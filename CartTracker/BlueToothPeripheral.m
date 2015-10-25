//
//  BlueToothPeripheral.m
//  CartTracker
//
//  Created by Mike Dokken on 10/24/15.
//  Copyright © 2015 Mike Dokken. All rights reserved.
//

@import CoreBluetooth;
#import "BlueToothPeripheral.h"

@interface BlueToothPeripheral () <CBPeripheralManagerDelegate>

@property (nonatomic, strong) CBPeripheralManager *cbManager;

@end

@implementation BlueToothPeripheral

- (instancetype)init {
    NSLog(@"init");
    if (self = [super init]) {
        _cbManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
    }
    return self;
}

#pragma mark - CBPeripheralManagerDelegate

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    NSLog(@"centralManagerDidUpdateState state = %ld", (long)peripheral.state);
    
    if (peripheral.state == CBPeripheralManagerStatePoweredOn) {
        CBUUID *myServiceUUID = [CBUUID UUIDWithString:[[NSUUID UUID] UUIDString]];
        CBMutableService *myService = [[CBMutableService alloc] initWithType:myServiceUUID primary:YES];
        myService.characteristics = @[];
        [_cbManager addService:myService];
        [_cbManager startAdvertising:@{ CBAdvertisementDataServiceUUIDsKey :
                                            @[myService.UUID] }];
    }
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral
            didAddService:(CBService *)service
                    error:(NSError *)error {
    NSLog(@"peripheralManager didAddService");
    if (error) {
        NSLog(@"Error publishing service: %@", [error localizedDescription]);
    }
}

- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral
                                       error:(NSError *)error {
    NSLog(@"peripheralManagerDidStartAdvertising");
    if (error) {
        NSLog(@"Error advertising: %@", [error localizedDescription]);
    }
}

@end
