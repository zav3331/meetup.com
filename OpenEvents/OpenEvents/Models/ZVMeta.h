//
//  ZVMeta.h
//  OpenEvents
//
//  Created by Alexander Zakharin on 19/08/15.
//  Copyright (c) 2015 ZV. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZVServerObject.h"

@interface ZVMeta : ZVServerObject

@property (strong, nonatomic, readonly) NSString *title;
@property (strong, nonatomic, readonly) NSNumber *totalCount;
@property (strong, nonatomic, readonly) NSString *descr;

@end
