//
//  ZVCategory.m
//  OpenEvents
//
//  Created by Alexander Zakharin on 19/08/15.
//  Copyright (c) 2015 ZV. All rights reserved.
//

#import "ZVCategory.h"

static NSString * const kNameField = @"name";
static NSString * const kIDField = @"id";
static NSString * const kShortnameField = @"shortname";
static NSString * const kShortNameForTech = @"Tech";

@interface ZVCategory ()

@property (strong, nonatomic, readwrite) NSString *name;
@property (strong, nonatomic, readwrite) NSString *shortname;
@property (strong, nonatomic, readwrite) NSNumber *identifier;

@end

@implementation ZVCategory

- (id)initWithServerResponse:(id)responseObject {
    
    self = [super initWithServerResponse:responseObject];
    if (self) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            self.name = [responseObject valueForKey:kNameField];
            self.shortname = [responseObject valueForKey:kShortnameField];
            self.identifier = [responseObject valueForKey:kShortnameField];
        }
    }
    
    return self;
}

+ (ZVCategory *)findTechCategoryInArray:(NSArray *)categoriesArray {
    
    for (ZVCategory *object in categoriesArray) {
        if ([object.shortname isEqualToString:kShortNameForTech]) {
            return object;
        }
    }
    return nil;
}

@end
