//
//  BTMeshDriver.m
//  Gigma
//
//  Created by Jake Chong on 06/06/2023.
//

#import "BTMeshDriver.h"

@interface BTMeshDriver () {
    NSMutableDictionary * currentlyAvailableDevices;
    CBPeripheral * discoveredPeripheral;
    NSArray * kServices;
}

@property CBCentralManager * centralManager;
@property CBPeripheralManager * peripheralManager;

@end

@implementation BTMeshDriver

@synthesize centralManager;
@synthesize peripheralManager;

- (instancetype) init {
    self = [super init];
    kServices = @[
        [[NSUUID UUID] initWithUUIDString: kLocationServiceUUID]
    ];
    [self setupBluetooth];
    return self;
}

- (void) centralManagerDidUpdateState:(CBCentralManager *) central
{
    NSString *stateString = nil;
    switch (centralManager.state) {
        case CBManagerStateResetting:
            NSLog(@"resetting");
            break;
        case CBManagerStateUnsupported:
            NSLog(@"unsupported");
            break;
        case CBManagerStateUnauthorized:
            NSLog(@"unauthorised");
            break;
        case CBManagerStatePoweredOff:
            stateString = @"Bluetooth is currently powered off.";
            NSLog(@"off");
            break;
        case CBManagerStatePoweredOn:
            stateString = @"Bluetooth is currently powered on and available to use.";
            NSLog(@"on");
            //[self.centralManager scanForPeripheralsWithServices: kServices options: nil];
            break;
        default:
            stateString = @"State unknown, update imminent.";
            break;
    }

    NSLog(@"Bluetooth State %@", stateString);
}

- (void) centralManager:(CBCentralManager *) central didDiscoverPeripheral:(CBPeripheral *) peripheral advertisementData:(NSDictionary <NSString *, id> *) advertisementData RSSI:(NSNumber *) RSSI {
    [currentlyAvailableDevices setObject: advertisementData[@"CBAdvertisementDataLocalNameKey"] forKey: peripheral.identifier];
    NSLog(@"%@", peripheral.identifier);
}

- (void) retrievePeripheral {
    NSArray * connectedPeripherals = [centralManager retrieveConnectedPeripheralsWithServices: kServices];
    NSLog(@"Found connected peripherals with transfer service: %@", connectedPeripherals);
    
    CBPeripheral * lastPeripheral = connectedPeripherals.lastObject;
    
    if (lastPeripheral != nil) {
        NSLog(@"Connecting to peripheral: %@", lastPeripheral);
        discoveredPeripheral = lastPeripheral;
        [centralManager connectPeripheral: lastPeripheral options: nil];
    } else {
        [centralManager scanForPeripheralsWithServices: kServices options: @{
            CBCentralManagerScanOptionAllowDuplicatesKey: @YES
        }];
    }
}

- (void) setupBluetooth {
    if (!self.centralManager) {
        self.centralManager = [[CBCentralManager alloc] initWithDelegate: self queue: dispatch_get_main_queue() options: @{
            CBCentralManagerOptionShowPowerAlertKey : @YES
        }];
    }
    if (!self.peripheralManager) {
        self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate: self queue: dispatch_get_main_queue()];
    }
    NSDictionary * advertisementData = @{
        CBAdvertisementDataLocalNameKey : [[UIDevice currentDevice] name],
        CBAdvertisementDataServiceUUIDsKey : kServices
    };
    [self.peripheralManager startAdvertising: advertisementData];
    
}

- (CodableCoordinate * _Nonnull) getLocationWithUuid:(NSUUID * _Nonnull) uuid {
    Bluetoother * bt = [[Bluetoother alloc] init];
    return [bt getLocationWithUuid: uuid];
}

- (NSDictionary <NSUUID *, NSString *> * _Nonnull) nearbyBluetoothDevices {
    return currentlyAvailableDevices;
}

- (void) peripheralManagerDidUpdateState:(nonnull CBPeripheralManager *) peripheral {
    if (peripheral.state == CBManagerStatePoweredOn) {
        NSLog(@"Peripheral Manager state: Powered On");
    } else {
        NSLog(@"Peripheral Manager state: Unavailable");
    }
    
}

@end
