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

- (void)go {
    NSLog(@"go");
    CBUUID *myServiceUUID = [CBUUID UUIDWithString:@"244F0C5F-BD49-4EDC-8B3C-CC34AE509465"];
    CBMutableService *myService = [[CBMutableService alloc] initWithType:myServiceUUID primary:YES];
    myService.characteristics = @[];
    [_cbManager addService:myService];
    [_cbManager startAdvertising:@{ CBAdvertisementDataServiceUUIDsKey :
                                                 @[myService.UUID] }];
}

#pragma mark - CBPeripheralManagerDelegate

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    NSLog(@"centralManagerDidUpdateState state = %ld", (long)peripheral.state);
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
