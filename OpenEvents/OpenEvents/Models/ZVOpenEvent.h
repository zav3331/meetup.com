//
//  ZVOpenEvents.h
//  OpenEvents
//
//  Created by Alexander Zakharin on 19/08/15.
//  Copyright (c) 2015 ZV. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZVServerObject.h"

@interface ZVOpenEvent : ZVServerObject

@property (strong, nonatomic, readonly) NSDate *time;
@property (strong, nonatomic, readonly) NSNumber *duration;
@property (strong, nonatomic, readonly) NSString *name;
@property (strong, nonatomic, readonly) NSString *who;

@end
