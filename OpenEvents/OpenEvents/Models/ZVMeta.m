//
//  ZVMeta.m
//  OpenEvents
//
//  Created by Alexander Zakharin on 19/08/15.
//  Copyright (c) 2015 ZV. All rights reserved.
//

#import "ZVMeta.h"

static NSString * const kTitleField = @"title";
static NSString * const kTotalCountField = @"total_count";
static NSString * const kDescriptionnameField = @"description";

@interface ZVMeta ()

@property (strong, nonatomic, readwrite) NSString *title;
@property (strong, nonatomic, readwrite) NSNumber *totalCount;
@property (strong, nonatomic, readwrite) NSString *descr;

@end

@implementation ZVMeta

- (id)initWithServerResponse:(id)responseObject {
    
    self = [super initWithServerResponse:responseObject];
    if (self) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            self.title = [responseObject valueForKey:kTitleField];
            self.totalCount = [responseObject valueForKey:kTotalCountField];
            self.descr = [responseObject valueForKey:kDescriptionnameField];
        }
    }
    return self;
}

@end
