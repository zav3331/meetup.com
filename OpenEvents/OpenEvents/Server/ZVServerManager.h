//
//  ZVServerManager.h
//  OpenEvents
//
//  Created by Alexander Zakharin on 19/08/15.
//  Copyright (c) 2015 ZV. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CLLocation;

@interface ZVServerManager : NSObject

+ (ZVServerManager *)sharedManager;

- (void)getListCategoriesonSuccess:(void(^)(NSArray *categories))success
                         onFailure:(void(^)(NSError* error, NSInteger statusCode))failure;

- (void)getListOpenEventsWithCategoryID:(NSString *)categoryID
                            andLocation:(CLLocation *)location
                             andSuccess:(void(^)(NSArray *openEvents))success
                              onFailure:(void(^)(NSError* error, NSInteger statusCode))failure;

@end
