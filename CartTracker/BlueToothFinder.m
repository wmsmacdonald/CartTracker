//
//  BlueToothFinder.m
//  CartTracker
//
//  Created by Mike Dokken on 10/24/15.
//  Copyright © 2015 Mike Dokken. All rights reserved.
//

@import CoreBluetooth;
#import "BlueToothFinder.h"
#import "NSObject+PerformBlock.h"

@interface BlueToothFinder () <CBCentralManagerDelegate>

@property (nonatomic, strong) CBCentralManager *cbManager;
@property (nonatomic, strong) NSDate *lastDate;

@end

@implementation BlueToothFinder

- (instancetype)init {
    NSLog(@"init");
    if (self = [super init]) {
        _cbManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    }
    return self;
}

- (void)sendUrlGetRssi:(int)rssi uuid:(NSString*)uuid {
    //NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    //[request setHTTPMethod:@"GET"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://quotacle.com:3000/api?beaconid=%d&uuid=%@&signalstrength=%d", 2, uuid, rssi]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSDate *now = [NSDate date];
    if (_lastDate != nil) {
        NSTimeInterval since = [now timeIntervalSinceDate:_lastDate];
        if (since < 1.0) return;
    }
    _lastDate = now;
    
    [self performBlockInBackground:^{
        NSError *error = nil;
        NSHTTPURLResponse *responseCode = nil;
        [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
        if([responseCode statusCode] != 200){
            NSLog(@"Error getting %@, HTTP status code %ld", url, (long)[responseCode statusCode]);
        }
    }];
}

#pragma mark - CBCentralManagerDelegate

- (void)centralManager:(CBCentralManager *)central
 didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary<NSString *,
                        id> *)advertisementData
                  RSSI:(NSNumber *)RSSI {
    if ([advertisementData[CBAdvertisementDataLocalNameKey] isEqualToString:@"cart_tracker"]) {
        NSLog(@"cart_tracker");
        NSLog(@"RSSI = %@, uuid = %@", RSSI, peripheral.identifier.UUIDString);
        
        [self sendUrlGetRssi:RSSI.intValue uuid:peripheral.identifier.UUIDString];
    }
    
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    NSLog(@"centralManagerDidUpdateState state = %ld", (long)central.state);
    
    if (central.state == CBCentralManagerStatePoweredOn) {
        NSLog(@"CBCentralManagerStatePoweredOn");
        //[_cbManager scanForPeripheralsWithServices:nil options:nil];
        [_cbManager scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @YES}];
    }
}

@end
