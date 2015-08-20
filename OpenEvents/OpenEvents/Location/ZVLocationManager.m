//
//  ZVLocationManager.m
//  OpenEvents
//
//  Created by Alexander Zakharin on 19/08/15.
//  Copyright (c) 2015 ZV. All rights reserved.
//

#import "ZVLocationManager.h"
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

@interface ZVLocationManager () <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic, copy) void (^successBlock)(CLLocation *location);
@end

@implementation ZVLocationManager

+ (ZVLocationManager *)sharedManager {
    
    static ZVLocationManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ZVLocationManager alloc] init];
    });
    
    return manager;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    }
    
    return self;
}

- (void)findCurrentUserLocationSuccess:(void(^)(CLLocation *location))success {
    self.successBlock = success;
    self.locationManager.delegate = self;

    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [self.locationManager requestAlwaysAuthorization];
    
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    CLLocation *location = [locations lastObject];
    
    if (self.successBlock) {
        self.successBlock(location);
    }
    
    [manager stopUpdatingLocation];
}

@end
