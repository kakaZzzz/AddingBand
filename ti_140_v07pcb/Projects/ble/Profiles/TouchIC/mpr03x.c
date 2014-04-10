/******************** (C) COPYRIGHT 2012 Freescale Semiconductor, Inc. *************
 *
 * File Name		: mpr03x.c
 * Authors		: Rick Zhang(rick.zhang@freescale.com)
 			  Rick is willing to be considered the contact and update points 
 			  for the driver
 * Version		: V.1.0.0
 * Date			: 2012/Apr/1
 * Description		: Touchkey driver for Freescale MPR03x (MPR031 MPR032) Capacitive Touch Sensor Controllor.
 *
 ******************************************************************************
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 *
 * THE PRESENT SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES
 * OR CONDITIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED, FOR THE SOLE
 * PURPOSE TO SUPPORT YOUR APPLICATION DEVELOPMENT.
 * AS A RESULT, FREESCALE SHALL NOT BE HELD LIABLE FOR ANY DIRECT,
 * INDIRECT OR CONSEQUENTIAL DAMAGES WITH RESPECT TO ANY CLAIMS ARISING FROM THE
 * CONTENT OF SUCH SOFTWARE AND/OR THE USE MADE BY CUSTOMERS OF THE CODING
 * INFORMATION CONTAINED HEREIN IN CONNECTION WITH THEIR PRODUCTS.
 *
 * THIS SOFTWARE IS SPECIFICALLY DESIGNED FOR EXCLUSIVE USE WITH FREESCALE PARTS.

 ******************************************************************************
 * Revision 1.0.0 2/1/2012 First Release;
 ******************************************************************************/

#include <linux/module.h>
#include <linux/init.h>
#include <linux/i2c.h>
#include <linux/interrupt.h>
#include <linux/input.h>
#include <linux/irq.h>
#include <linux/slab.h>
#include <linux/delay.h>
#include <linux/bitops.h>
#include "mpr03x.h"
#define AUTO_CONFIG
//#define DEBUG
struct mpr03x_touchkey_data {
	struct i2c_client	*client;
	struct input_dev	*input_dev;
	struct mpr03x_platform_data * pdata;
#ifdef DEBUG
	struct input_dev	*th_dev;   // use to report baseline and fiter data to calculate threshold 
#endif
	struct delayed_work  work;
    u8 			CDC;
	u8 			CDT;
	u8		 	key_status;
	int			statusbits;
	int			keycount;
	u16			keycodes[MPR03X_MAX_KEY_COUNT];
};

static void mpr03x_soft_reset(struct i2c_client *client)
{
    i2c_smbus_write_byte_data(client,0x5f,0x55);  
}

static void  mpr03x_stop(struct i2c_client *client)
{
 	u8 data;
  	data = i2c_smbus_read_byte_data(client , MPR03X_EC_REG);
  	i2c_smbus_write_byte_data(client ,MPR03X_EC_REG, (data & 0x40));    

}
static void  mpr03x_start(struct i2c_client *client)
{
	//set mpr031 run mode with Run1 mode, 2 pad with INT 
	u8 data;
  	data = i2c_smbus_read_byte_data(client , MPR03X_EC_REG);
	data &= ~0x0f;
	i2c_smbus_write_byte_data(client ,MPR03X_EC_REG, (data | MPR03X_E1_E2_IRQ));    
} 


//Auto config CDC CDT with Run1 mode, 2 pad with INT
//For other senario, set the MPR03X_EC_REG accordingly, and use Exdata accordingly
//reture CDC and CDT with optimized value  
static int  mpr03x_autoconfig(struct mpr03x_touchkey_data  *pdata) 
{
  u8 i;                                                             
  u16 result, e1data, e2data;
  u8 CDC = 30;  		
  u8 CDT = 0x00;
  struct i2c_client * client = pdata->client;
  i2c_smbus_write_byte_data(client,MPR03X_EC_REG, 0x00);
  
  for( i=0; i<3; i++ ) 
  {
    CDT = CDT | (1<<(3-1-i));
    i2c_smbus_write_byte_data(client,MPR03X_AFEC_REG,MPR03X_FFI_6| CDC); 
    i2c_smbus_write_byte_data(client,MPR03X_FC_REG,CDT<<5 | MPR03X_SFI_4 | MPR03X_ESI_1MS);
    i2c_smbus_write_byte_data(client,MPR03X_EC_REG, MPR03X_E1_E2_IRQ);
    msleep(10);
	i2c_smbus_write_byte_data(client,MPR03X_EC_REG, 0x00);
    e1data=((u16)i2c_smbus_read_byte_data(client,MPR03X_E0FDL_REG)) | 
					(((u16)i2c_smbus_read_byte_data(client,MPR03X_E0FDH_REG))<<8);
	e2data=((u16)i2c_smbus_read_byte_data(client,MPR03X_E1FDL_REG)) | 
					(((u16)i2c_smbus_read_byte_data(client,MPR03X_E1FDH_REG))<<8);				
    //not used for Run1 mode, 2 pad with INT
	if (e1data > e2data) 
	   result=e1data;
	else 
	   result=e2data;
	
	if(result > MPR03X_AC_USL_CT)
	   CDT = CDT ^ (1<<(3-1-i));	
  } 
  if(CDT== 0) CDT = 1;
	   CDC = 0x00;
  for( i=0; i < 6; i++ ) 
  {
    CDC = CDC | (1 << (6 - 1 - i));
    i2c_smbus_write_byte_data(client,MPR03X_AFEC_REG,MPR03X_FFI_6| CDC); 
    i2c_smbus_write_byte_data(client,MPR03X_FC_REG,CDT << 5 | MPR03X_SFI_4 | MPR03X_ESI_1MS);
    i2c_smbus_write_byte_data(client,MPR03X_EC_REG, MPR03X_E1_E2_IRQ);
    msleep(10);
	i2c_smbus_write_byte_data(client,MPR03X_EC_REG, 0x00);
	e1data=((u16)i2c_smbus_read_byte_data(client,MPR03X_E0FDL_REG)) | 
					(((u16)i2c_smbus_read_byte_data(client,MPR03X_E0FDH_REG))<<8);
	e2data=((u16)i2c_smbus_read_byte_data(client,MPR03X_E1FDL_REG)) | 
					(((u16)i2c_smbus_read_byte_data(client,MPR03X_E1FDH_REG))<<8);	
	//not used 
	//e3data=((u16)i2c_smbus_read_byte_data(client,MPR03X_E2FDL_REG)) | 
	//				(((u16)i2c_smbus_read_byte_data(client,MPR03X_E2FDH_REG))<<8);
	
	if (e1data > e2data) 
		result = e1data;
	else 
		result = e2data;

	if ( result > MPR03X_AC_LSL_CS ) 
		  CDC = CDC ^(1 << (6 - 1 - i)) ;
   } 
		
	if (result > MPR03X_AC_USL_CT || result < MPR03X_AC_LSL_CT ) 
	  return 0;
	else
	{
	  pdata->CDC = CDC;
	  pdata->CDT = CDT;
	  return 1;
	}
}

static int mpr03x_phys_init(struct mpr03x_platform_data *platdata,
			    struct mpr03x_touchkey_data *pdata,
			    struct i2c_client *client)
{
	u8 CDC , CDT , data ,data1,data2;   
	//Reset if has not reset properly
	mpr03x_soft_reset(client);
	if(i2c_smbus_read_byte_data(client,MPR03X_AFEC_REG)!=0x10 
			&& i2c_smbus_read_byte_data(client,MPR03X_EC_REG)!=0x00)
		dev_info(&client->dev,"mpr03x reset fail\n");
  	pdata->CDC = 0x24;
   	pdata->CDT = 1;
#ifdef AUTO_CONFIG
		//Auto search CDC, CDT
	if (mpr03x_autoconfig(pdata))
	   dev_info(&client->dev, "mpr03x auto Config Success\r\n"); 
	else
	   dev_info(&client->dev, "mpr03x auto Config Fail\r\n");
#endif
    CDC =  pdata->CDC;
  	CDT =  pdata->CDT ;
	//Configure AFE,then set into Run1 mode, 2 pad with INT
	mpr03x_stop(client);	
	i2c_smbus_write_byte_data(client,MPR03X_AFEC_REG,MPR03X_FFI_6| CDC); 
	i2c_smbus_write_byte_data(client,MPR03X_FC_REG,CDT<<5 | MPR03X_SFI_4 | MPR03X_ESI_1MS);
	mpr03x_start(client);
	  
	//Wait for enough time (10ms example here) to get stable electrode data
	msleep(10);		  
	
	mpr03x_stop(client);
	//load 5MSB to set E1 baseline, baseline<=signal level
	data1 = (i2c_smbus_read_byte_data(client,MPR03X_E0FDH_REG)<<6);
	data2 = (i2c_smbus_read_byte_data(client,MPR03X_E0FDL_REG)>>2) & 0xF8;  
	data = data1 | data2;
	i2c_smbus_write_byte_data(client,MPR03X_E0BV_REG,data); 
	  
	//load 5MSB to set E2 baseline, baseline<=signal level
	data1 = (i2c_smbus_read_byte_data(client,MPR03X_E1FDH_REG)<<6);
	data2 = (i2c_smbus_read_byte_data(client,MPR03X_E1FDL_REG)>>2) & 0xF8;
	data = data1 | data2;
	i2c_smbus_write_byte_data(client,MPR03X_E1BV_REG,data); 
	  
	//load 5MSB to set E3 baseline, baseline<=signal level
	//data= (i2c_smbus_read_byte_data(client,MPR03X_E2FDH_REG)<<6)|(i2c_smbus_read_byte_data(client,MPR03X_E2FDL_REG)>>2) & 0xF8;;  
	//i2c_smbus_write_byte_data(client,MPR03X_E2BV_REG,data); 
	  
	//Set baseline filtering
	i2c_smbus_write_byte_data(client,MPR03X_MHD_REG,0x01); 
	i2c_smbus_write_byte_data(client,MPR03X_NHD_REG,0x01); 
	i2c_smbus_write_byte_data(client,MPR03X_NCL_REG,0x0f); 	
	  
	//Set touch/release threshold
	i2c_smbus_write_byte_data(client,MPR03X_E0TTH_REG,MPR03X_TOUCH_THRESHOLD); 
	i2c_smbus_write_byte_data(client,MPR03X_E0RTH_REG,MPR03X_RELEASE_THRESHOLD);
	i2c_smbus_write_byte_data(client,MPR03X_E1TTH_REG,MPR03X_TOUCH_THRESHOLD); 
	i2c_smbus_write_byte_data(client,MPR03X_E1RTH_REG,MPR03X_RELEASE_THRESHOLD);
	//i2c_smbus_write_byte_data(client,MPR03X_E2TTH_REG,MPR03X_TOUCH_THRESHOLD); 
	//i2c_smbus_write_byte_data(client,MPR03X_E2RTH_REG,MPR03X_RELEASE_THRESHOLD);
	
	//Set AFE  
	i2c_smbus_write_byte_data(client,MPR03X_AFEC_REG,MPR03X_FFI_6| CDC); 
	i2c_smbus_write_byte_data(client,MPR03X_FC_REG,CDT<<5 | MPR03X_SFI_4 | MPR03X_ESI_4MS);
	
	return 0;
		 
}

#ifdef DEBUG
static int mpr03x_report_filter_data(struct mpr03x_touchkey_data *touch)
{
	struct i2c_client *client = touch->client;
	struct input_dev * idev = touch->th_dev;
	int ret;
	int i;
	u8 efdlh[6],ebvh[3];
	short efd[3];
	short ebv[3];
	short edelta[3];
	ret = i2c_smbus_read_i2c_block_data(client,MPR03X_E0FDL_REG,6,efdlh);
	if(ret < 6){
		dev_info(&client->dev, "mpr03x read filter data error,ret %d\n",ret);
		return -EIO;
	}
	ret = i2c_smbus_read_i2c_block_data(client,MPR03X_E0BV_REG,3,ebvh);
	if(ret < 3){
		dev_info(&client->dev, "mpr03x read baseline data error ret %d\n",ret);
		return -EIO;
	}
	for(i = 0; i < 3 ;i++){
		efd[i] = ((short)efdlh[2*i] | (((short)efdlh[2*i + 1] & 0x03) << 8));
		ebv[i] = ((short)ebvh[i] << 2); 
		edelta[i] = efd[i] - ebv[i];
	}
	input_report_rel(idev, REL_X,  efd[0]);
	input_report_rel(idev, REL_Y,  ebv[0]);
	input_report_rel(idev, REL_Z,  edelta[0]);
	input_report_rel(idev, REL_RX, efd[1]);
	input_report_rel(idev, REL_RY, ebv[1]);
	input_report_rel(idev, REL_RZ, edelta[1]);
	input_sync(idev);
	return 0;
	
}
#endif


static void mpr03x_touch_key_work(struct work_struct *work)
{
	struct mpr03x_touchkey_data *touch =
		container_of(work, struct mpr03x_touchkey_data, work.work);
	struct mpr03x_platform_data * pdata = touch->pdata;
	struct input_dev * input = touch->input_dev;
	 u8 status = i2c_smbus_read_byte_data(touch->client, MPR03X_TS_REG);	
	 if(status != touch->key_status){
	 	 if(((status & 0x01)!= (touch->key_status & 0x01)) && pdata->keycount > 0){
		 	input_report_key(input,pdata->matrix[0],status & 0x01);		
			input_sync(input);	
		 }		
		 if(((status & 0x02)!= (touch->key_status & 0x02)) && pdata->keycount > 1) {		
		 	input_report_key(input,pdata->matrix[1],status & 0x02);			
			input_sync(input);	 	
		}		
		 touch->key_status = status;	 
	}
#ifdef DEBUG
        mpr03x_report_filter_data(touch);
		schedule_delayed_work(&touch->work, msecs_to_jiffies(10));
#endif
}

#ifdef DEBUG
static int mpr03x_register_threshold_input(struct mpr03x_touchkey_data * touch)
{
    struct input_dev *idev;
	struct i2c_client *client;
	int ret;
	if(!touch)
		return -ENOMEM;
	client =  touch->client;
	idev = input_allocate_device();
	if(idev) {
	    idev->name = "mpr03x_th_dev";
		idev->id.bustype = BUS_I2C;
		touch->th_dev = idev;
		input_set_capability(idev, EV_REL, REL_X);
		input_set_capability(idev, EV_REL, REL_Y);
		input_set_capability(idev, EV_REL, REL_Z);
		input_set_capability(idev, EV_REL, REL_RX);
		input_set_capability(idev, EV_REL, REL_RY);
		input_set_capability(idev, EV_REL, REL_RZ);		
		ret = input_register_device(idev);
		if (ret)
			dev_err(&client->dev, "register mpr03x touch  device failed!\n");			
	}
	return ret;
}

static int mpr03x_unregister_threshold_input(struct mpr03x_touchkey_data * data)
{
	if(data && data->th_dev){
		input_unregister_device(data->th_dev);
		input_free_device(data->th_dev);
	}
	return 0;
}

#endif

static irqreturn_t mpr03x_touchkey_interrupt(int irq, void *dev_id)
{
	struct mpr03x_touchkey_data *data = dev_id;
	schedule_delayed_work(&data->work, msecs_to_jiffies(0));
	return IRQ_HANDLED;
}

static ssize_t mpr03x_status_show(struct device *dev,
				   struct device_attribute *attr, char *buf)
{
    struct input_dev *input = to_input_dev(dev);
	struct mpr03x_touchkey_data *touch = input_get_drvdata(input);
	struct i2c_client *client = touch->client;
	u8 data[9]; int i;
	u8 ts_status;
	ts_status = i2c_smbus_read_byte_data(client, MPR03X_TS_REG);
	i2c_smbus_read_i2c_block_data(client,MPR03X_E0FDL_REG,6,data);
    i2c_smbus_read_i2c_block_data(client,MPR03X_E0BV_REG,3,&data[6]);
	for(i = 0; i<9 ; i++)
		printk("the data %d ,0x%x\n",i,data[i]);
	return sprintf(buf, "0x%x\n", ts_status);
}

static ssize_t mpr03x_thresholds_show(struct device *dev,
				   struct device_attribute *attr, char *buf)
{
    struct input_dev *input = to_input_dev(dev);
	struct mpr03x_touchkey_data *touch = input_get_drvdata(input);
	struct i2c_client *client = touch->client;
	u8 touchthreshold , releasethreshold;
	touchthreshold = i2c_smbus_read_byte_data(client, MPR03X_E0TTH_REG);
	releasethreshold = i2c_smbus_read_byte_data(client, MPR03X_E0RTH_REG);
	return sprintf(buf, "0x%x,0x%x", touchthreshold,releasethreshold);
}
static ssize_t mpr03x_thresholds_store(struct device *dev,
				    struct device_attribute *attr,
				    const char *buf, size_t count)
{
	struct input_dev *input = to_input_dev(dev);
	struct mpr03x_touchkey_data *touch = input_get_drvdata(input);
	struct i2c_client *client = touch->client;
	int touchthreshold , releasethreshold;
	sscanf(buf,"0x%x,0x%x",&touchthreshold,&releasethreshold);
	mpr03x_stop(client);
	if(touchthreshold >=0 && touchthreshold <= 0xff && releasethreshold > 0 && releasethreshold <= 0xff){
		i2c_smbus_write_byte_data(client, MPR03X_E0TTH_REG,touchthreshold);
		i2c_smbus_write_byte_data(client, MPR03X_E0RTH_REG,releasethreshold);
		i2c_smbus_write_byte_data(client, MPR03X_E1TTH_REG,touchthreshold);
		i2c_smbus_write_byte_data(client, MPR03X_E1RTH_REG,releasethreshold);
	}
	mpr03x_start(client);
	return count;
}

static DEVICE_ATTR(status, 0666,mpr03x_status_show, NULL);

static DEVICE_ATTR(thresholds, 0666,
		   mpr03x_thresholds_show, mpr03x_thresholds_store);

static struct attribute *mpr03x_attributes[] = {
	&dev_attr_status.attr,
	&dev_attr_thresholds.attr,
	NULL
};
static const struct attribute_group mpr03x_attr_group = {
	.attrs = mpr03x_attributes,
};


static u16 mpr03x_touchkey_martix_default[] = {
	KEY_HOME,KEY_BACK
};

static struct mpr03x_platform_data mpr03x_platform_data_default = {
	.keycount = ARRAY_SIZE(mpr03x_touchkey_martix_default),
	.matrix = mpr03x_touchkey_martix_default,
};

static int __devinit mpr03x_touchkey_probe(struct i2c_client *client,
					const struct i2c_device_id *id)
{
	struct mpr03x_platform_data *pdata;
	struct mpr03x_touchkey_data *data;
	struct input_dev *input_dev;
	int error;
	int i;

	pdata = client->dev.platform_data;
	if (!pdata) {
		dev_err(&client->dev, "no platform data defined\n");
		pdata = &mpr03x_platform_data_default;
	}

	data = kzalloc(sizeof(struct mpr03x_touchkey_data), GFP_KERNEL);
	input_dev = input_allocate_device();
	if (!data || !input_dev) {
		dev_err(&client->dev, "mpr03x falied to allocate memory\n");
		error = -ENOMEM;
		goto err_free_mem;
	}
	data->client = client;
	data->input_dev = input_dev;
	data->keycount = pdata->keycount;
	data->pdata = pdata;
	INIT_DELAYED_WORK(&data->work, mpr03x_touch_key_work);
	if (data->keycount > MPR03X_MAX_KEY_COUNT) {
		dev_err(&client->dev, "mpr03x too many key defined\n");
		error = -EINVAL;
		goto err_free_mem;
	}
	

	error = mpr03x_phys_init(pdata, data, client);
	if (error < 0) {
		dev_err(&client->dev, "mpr03x failed to init register\n");
		goto err_free_mem;
	}

	i2c_set_clientdata(client, data);
	input_dev->name = "FSL MPR03X Touchkey";
	input_dev->id.bustype = BUS_I2C;
	input_dev->dev.parent = &client->dev;
	input_dev->keycode = pdata->matrix;
	input_dev->keycodesize = sizeof(pdata->matrix[0]);
	input_dev->keycodemax = data->keycount;
    
	for (i = 0; i < input_dev->keycodemax; i++) {
		__set_bit(pdata->matrix[i], input_dev->keybit);
		data->keycodes[i] = pdata->matrix[i];
	}

	input_set_capability(input_dev, EV_KEY, MSC_SCAN);
	input_set_drvdata(input_dev, data);

	error = request_threaded_irq(client->irq, NULL,
				     mpr03x_touchkey_interrupt,
				     IRQF_TRIGGER_FALLING,
				     client->dev.driver->name, data);
	if (error) {
		dev_err(&client->dev, "mpr03x failed to register interrupt\n");
		goto err_free_mem;
	}

	error = input_register_device(input_dev);
	if (error)
		goto err_free_irq;
	//device_init_wakeup(&client->dev, pdata->wakeup);
	error = sysfs_create_group(&input_dev->dev.kobj, &mpr03x_attr_group);
	if(error){
		dev_err(&client->dev, "mpr03x register sysfs error\n");
		goto err_sysfs;
	}
	mpr03x_start(client);
#ifdef DEBUG
    /*use to report baseline and filter data*/
    error = mpr03x_register_threshold_input(data);
    if(error)
		goto error_unregister_thdev;
	schedule_delayed_work(&data->work, 0);
#endif
	dev_info(&client->dev, "mpr03x touch keyboard init success.\n");
	return 0;
	
#ifdef DEBUG
error_unregister_thdev:
	mpr03x_unregister_threshold_input(data);
#endif
err_sysfs:
    input_unregister_device(input_dev);
err_free_irq:
	free_irq(client->irq, data);
err_free_mem:
	input_free_device(input_dev);
	kfree(data);
	return error;
}

static int __devexit mpr03x_touchkey_remove(struct i2c_client *client)
{
	struct mpr03x_touchkey_data *touch = i2c_get_clientdata(client);
    struct input_dev * idev = touch->input_dev;
	sysfs_remove_group(&idev->dev.kobj,&mpr03x_attr_group);
	free_irq(client->irq, touch);
#ifdef DEBUG
	cancel_delayed_work_sync(&touch->work);
#endif    
	input_unregister_device(idev);
    kfree(idev);
	kfree(touch);

	return 0;
}

#ifdef CONFIG_PM
static int mpr03x_suspend(struct i2c_client *client, pm_message_t mesg)
{
    mpr03x_stop(client);
	return 0;
}

static int mpr03x_resume(struct i2c_client *client)
{
   mpr03x_start(client);
	return 0;
}
#else
static int mpr03x_suspend(struct i2c_client *client, pm_message_t mesg) {}
static int mpr03x_resume(struct i2c_client *client) {}
#endif

static const struct i2c_device_id mpr03x_id[] = {
	{"mpr03x", 0},
	{ }
};

static struct i2c_driver mpr03x_touchkey_driver = {
	.driver = {
		.name = "mpr03x",
		.owner = THIS_MODULE,
	},
	.id_table = mpr03x_id,
	.probe	= mpr03x_touchkey_probe,
	.remove = __devexit_p(mpr03x_touchkey_remove),
	.suspend = mpr03x_suspend,
	.resume = mpr03x_resume,
};

static int __init mpr03x_touchkey_init(void)
{
	return i2c_add_driver(&mpr03x_touchkey_driver);
}

static void __exit mpr03x_touchkey_exit(void)
{
	i2c_del_driver(&mpr03x_touchkey_driver);
}

module_init(mpr03x_touchkey_init);
module_exit(mpr03x_touchkey_exit);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Freescale Semiconductor, Inc.");
MODULE_DESCRIPTION("Touch Key driver for FSL MPR03X Chip");
