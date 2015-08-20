//
//  ZVLocationManager.h
//  OpenEvents
//
//  Created by Alexander Zakharin on 19/08/15.
//  Copyright (c) 2015 ZV. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CLLocation;

@interface ZVLocationManager : NSObject

+ (ZVLocationManager *)sharedManager;

- (void)findCurrentUserLocationSuccess:(void(^)(CLLocation *location))success;

@end
