//
//  ZVOpenEvents.m
//  OpenEvents
//
//  Created by Alexander Zakharin on 19/08/15.
//  Copyright (c) 2015 ZV. All rights reserved.
//

#import "ZVOpenEvent.h"

static NSString * const kTimeField = @"time";
static NSString * const kNameField = @"name";
static NSString * const kGroupField = @"group";
static NSString * const kWhoField = @"who";
static NSString * const kDurationField = @"duration";

@interface ZVOpenEvent ()

@property (strong, nonatomic, readwrite) NSDate *time;
@property (strong, nonatomic, readwrite) NSNumber *duration;
@property (strong, nonatomic, readwrite) NSString *name;
@property (strong, nonatomic, readwrite) NSString *who;

@end

@implementation ZVOpenEvent

- (id)initWithServerResponse:(id)responseObject {
    
    self = [super initWithServerResponse:responseObject];
    if (self) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSTimeInterval interval = [[responseObject valueForKey:kTimeField] doubleValue] / 1000;
            
            self.time = [NSDate dateWithTimeIntervalSince1970:interval];
            self.name = [responseObject valueForKey:kNameField];
            self.duration = [responseObject valueForKey:kDurationField];
            
            if ([[responseObject valueForKey:kGroupField] isKindOfClass:[NSDictionary class]]) {
                self.who = [[responseObject valueForKey:kGroupField] valueForKey:kWhoField];
            }
        }
    }
    
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@\n %@\n %@\n ------------- ", self.time, self.who, self.name];
}

@end
