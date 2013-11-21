//
//  BTBandCentral.h
//  SmartBat
//
//  Created by kaka' on 13-6-15.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BTConstants.h"
#import "BTBandPeripheral.h"
#import "BTGlobals.h"
#import "BTBleList.h"
#import "BTAppDelegate.h"
#import "BTUtils.h"
#import "BTRawData.h"

@interface BTBandCentral : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate>{
    NSManagedObjectContext* _context;
    NSArray* _localBleLIst;
    
}

@property(strong, nonatomic) CBCentralManager* cm;
@property(strong, nonatomic) NSMutableDictionary* allPeripherals;
@property(strong, nonatomic) BTGlobals* globals;

@property(strong, nonatomic) NSMutableDictionary* connectedList;

@property(strong, nonatomic) NSTimer* scanTimer;
@property(strong, nonatomic) NSTimer* timeoutTimer;

@property(assign, nonatomic) Boolean syncLocker;

@property(strong, nonatomic) void(^timeoutBlock)(void);

+(BTBandCentral*)sharedBandCentral;

-(void)writeAll:(NSData*)value withUUID:(CBUUID*)cuuid;
-(void)readAll:(CBUUID*)cuuid withBlock:(void (^)(NSData* value, CBCharacteristic* characteristic, CBPeripheral* peripheral))block;

-(void)scan;

-(void)togglePeripheralByIndex:(NSUInteger)index;

-(void)connectPeripheralByName:(NSString*)name timeoutAndHappe:(void(^)(void))block;
-(void)removePeripheralByModel:(NSString*)model;

-(void)sync:(NSString*)model;
-(NSString*)getLastSyncDesc:(NSString*)model;

-(BTBandPeripheral*)getBpByName:(NSString*)name;
-(BTBandPeripheral*)getBpByModel:(NSString*)model;
-(BTBandPeripheral*)getBpByIndex:(NSInteger)row;

-(Boolean)isConnectedByModel:(NSString*)model;

-(void)restartScan;

@end
 