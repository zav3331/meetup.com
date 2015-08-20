//
//  ZVServerManager.m
//  OpenEvents
//
//  Created by Alexander Zakharin on 19/08/15.
//  Copyright (c) 2015 ZV. All rights reserved.
//

#import "ZVServerManager.h"
#import <AFNetworking.h>
#import "ZVMeta.h"
#import "ZVCategory.h"
#import "ZVOpenEvent.h"
#import <Reachability+P34Utils.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

static NSString * const kBaseServerURL = @"https://api.meetup.com/2/";
static NSString * const kMeetupAPIKey = @"3c72695f61204b653b192d4d45206364";
static NSString * const kResultsKey = @"results";
static NSString * const kMetaKey = @"meta";
static NSString * const kRequestCategoriesKey = @"categories.json";
static NSString * const kRequestOpenEventsKey = @"open_events.json";
static NSString * const kMeetupAPIField = @"key";

@interface ZVServerManager ()

@property (strong, nonatomic) AFHTTPRequestOperationManager *requestOperationManager;

@end

@implementation ZVServerManager

+ (ZVServerManager *)sharedManager {
    
    static ZVServerManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ZVServerManager alloc] init];
    });
    
    return manager;
}

- (id)init
{
    self = [super init];
    if (self) {
        NSURL *url = [NSURL URLWithString:kBaseServerURL];
        self.requestOperationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    }
    
    return self;
}

- (void)getListCategoriesonSuccess:(void(^)(NSArray *categories))success
                         onFailure:(void(^)(NSError* error, NSInteger statusCode))failure {
    
    [self baseRequestWithName:kRequestCategoriesKey andParameters:nil onSuccess:^(NSArray *results, ZVMeta *meta) {
        
        NSMutableArray *categoriesArray = [NSMutableArray new];
        
        for (NSDictionary *object in results) {
            ZVCategory *category = [[ZVCategory alloc] initWithServerResponse:object];
            [categoriesArray addObject:category];
        }
        
        if (success) {
            success(categoriesArray);
        }
    } onFailure:^(NSError *error, NSInteger statusCode) {
        if (failure) {
            failure(error, statusCode);
        }
    }];
}

- (void)getListOpenEventsWithCategoryID:(NSString *)categoryID
                            andLocation:(CLLocation *)location
                             andSuccess:(void(^)(NSArray *openEvents))success
                              onFailure:(void(^)(NSError* error, NSInteger statusCode))failure {
    
    NSDictionary *parameters = @{
                                 @"category"    : categoryID,
                                 @"status"      : @"upcoming",
                                 @"time"        : @",1w",
                                 @"lat"         : [NSNumber numberWithDouble:location.coordinate.latitude],
                                 @"lon"         : [NSNumber numberWithDouble:location.coordinate.longitude]
                                 };

    [self baseRequestWithName:kRequestOpenEventsKey andParameters:parameters onSuccess:^(NSArray *results, ZVMeta *meta) {
        
        NSMutableArray *categoriesArray = [NSMutableArray new];
        
        for (NSDictionary *object in results) {
            ZVOpenEvent *category = [[ZVOpenEvent alloc] initWithServerResponse:object];
            [categoriesArray addObject:category];
        }
        
        if (success) {
            success(categoriesArray);
        }
    } onFailure:^(NSError *error, NSInteger statusCode) {
        if (failure) {
            failure(error, statusCode);
        }
    }];
}

- (void)baseRequestWithName:(NSString *)requestName
              andParameters:(NSDictionary *)parameters
                  onSuccess:(void(^)(NSArray *results, ZVMeta *meta))success
                  onFailure:(void(^)(NSError *error, NSInteger statusCode))failure {
    
    if ([Reachability isInternetReachable]) {
        
        NSMutableDictionary *parametersWithKey = nil;
        if (parameters) {
            parametersWithKey = [[NSMutableDictionary alloc] initWithDictionary:parameters];
        } else {
            parametersWithKey = [NSMutableDictionary new];
        }
        
        [parametersWithKey setValue:kMeetupAPIKey forKey:kMeetupAPIField];

        [self.requestOperationManager
         GET:requestName
         parameters:parametersWithKey
         success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
       
             if ([responseObject valueForKey:kMetaKey] && [responseObject valueForKey:kResultsKey]) {
                 
                 NSArray *results = [responseObject valueForKey:kResultsKey];
                 ZVMeta *meta = [[ZVMeta alloc] initWithServerResponse:[responseObject valueForKey:kMetaKey]];
                 
                 if (success) {
                     success(results, meta);
                 }
             } else {
                 if (failure) {
                     failure ([self errorConnection], 404);
                 }
             }
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             if (failure) {
                 failure(error, operation.response.statusCode);
             }
         }];
        
    } else {
        if (failure) {
            failure ([self errorConnection], 404);
        }
    }
}

- (NSError *)errorConnection {
   NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:kCFURLErrorNetworkConnectionLost userInfo:nil];
    return error;
}

@end
