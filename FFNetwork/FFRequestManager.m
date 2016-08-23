//
//  FFRequestManager.m
//  FFMusic
//
//  Created by xiazer on 14/10/19.
//  Copyright (c) 2014年 xiazer. All rights reserved.
//

#import "FFRequestManager.h"
#import "FFApiManager.h"
#import "FFRequestResponse+FFNetMethod.h"
#import "AFNetworkReachabilityManager.h"

@implementation FFRequestManager

+ (id)shareInstance{
    static dispatch_once_t pred;
    static FFRequestManager *sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [[FFRequestManager alloc] init];
    });
    return sharedInstance;
}

+ (void)initServieId
{
}

+ (BOOL)isNetWorkReachable{
    
    
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable){
        return NO;
    }
    return YES;
}


#pragma mark --Normal request
- (FFRequestID)asyncGetWithServiceID:(NSString *)serviceID methodName:(NSString *)methodName params:(NSDictionary *)params target:(id)target action:(SEL)action
{
    NSInteger requestId = [[FFApiManager shareInstance] callGETWithParams:params
                                                        serviceIdentifier:serviceID
                                                               methodName:methodName
                                                                  success:^(FFRequestResponse *response)
                           {
                               if ([target respondsToSelector:action]) {
                                   [target performSelector:action withObject:[response returnNetworkResponse] afterDelay:0.0];
                               }
                           } fail:^(FFRequestResponse *response) {
                               if ([target respondsToSelector:action]) {
                                   [target performSelector:action withObject:[response returnNetworkResponse] afterDelay:0.0];
                               }
                           }];
    
    return (FFRequestID)requestId;
}


- (FFRequestID)asyncPostWithServiceID:(NSString *)serviceID methodName:(NSString *)methodName params:(NSDictionary *)params target:(id)target action:(SEL)action{
    NSInteger requestId = [[FFApiManager shareInstance] callPostWithParams:params
                                                         serviceIdentifier:serviceID
                                                                methodName:methodName
                                                                   success:^(FFRequestResponse *response)
                           {
                               if ([target respondsToSelector:action]) {
                                   [target performSelector:action withObject:[response returnNetworkResponse] afterDelay:0.0];
                               }
                           } fail:^(FFRequestResponse *response) {
                               if ([target respondsToSelector:action]) {
                                   [target performSelector:action withObject:[response returnNetworkResponse] afterDelay:0.0];
                               }
                           }];
    
    return (FFRequestID)requestId;
}

- (FFRequestResponse *)syncGetWithServiceID:(NSString *)serviceID methodName:(NSString *)methodName params:(NSDictionary *)params{
    if ([self isRest:serviceID]) {
        return [self syncRESTGetWithServiceID:serviceID methodName:methodName params:params];
    }
    
    return [[FFApiManager shareInstance] callGETWithParams:params serviceIdentifier:serviceID methodName:methodName];
}
- (FFRequestResponse *)syncPostWithServiceID:(NSString *)serviceID methodName:(NSString *)methodName params:(NSDictionary *)params{
    if ([self isRest:serviceID]) {
        return [self syncRESTGetWithServiceID:serviceID methodName:methodName params:params];
    }
    
    return [[FFApiManager shareInstance] callPostWithParams:params
                                          serviceIdentifier:serviceID
                                                 methodName:methodName];
    
}

#pragma mark - REST
- (FFRequestID)asyncRESTGetWithServiceID:(NSString *)serviceID methodName:(NSString *)methodName params:(NSDictionary *)params target:(id)target action:(SEL)action{
    NSInteger requestId = [[FFApiManager shareInstance] callRestfulGETWithParams:params
                                                               serviceIdentifier:serviceID methodName:methodName
                                                                         success:
                           ^(FFRequestResponse *response)
                           {
                               if ([target respondsToSelector:action]) {
                                   [target performSelector:action withObject:[response returnNetworkResponse] afterDelay:0.0];
                               }
                           }fail:^(FFRequestResponse *response)
                           {
                               if ([target respondsToSelector:action]) {
                                   [target performSelector:action withObject:[response returnNetworkResponse] afterDelay:0.0];
                               }
                           }];
    
    
    return (FFRequestID)requestId;
}

- (FFRequestID)asyncRESTPostWithServiceID:(NSString *)serviceID methodName:(NSString *)methodName params:(NSDictionary *)params target:(id)target action:(SEL)action{
    NSInteger requestId = [[FFApiManager shareInstance] callRestfulPOSTWithParams:params
                                                                serviceIdentifier:serviceID
                                                                       methodName:methodName
                                                                          success:^(FFRequestResponse *response)
                           {
                               if ([target respondsToSelector:action]) {
                                   [target performSelector:action withObject:[response returnNetworkResponse] afterDelay:0.0];
                               }
                           }
                                                                             fail:^(FFRequestResponse *response)
                           {
                               if ([target respondsToSelector:action]) {
                                   [target performSelector:action withObject:[response returnNetworkResponse] afterDelay:0.0];
                               }
                           }];
    
    return (FFRequestID)requestId;
}
- (FFRequestResponse *)syncRESTPostWithServiceID:(NSString *)serviceID methodName:(NSString *)methodName params:(NSDictionary *)params{
    return [[FFApiManager shareInstance] callRestfulPOSTWithParams:params serviceIdentifier:serviceID methodName:methodName];
}

- (FFRequestResponse *)syncRESTGetWithServiceID:(NSString *)serviceID methodName:(NSString *)methodName params:(NSDictionary *)params{
    return [[FFApiManager shareInstance] callRestfulGETWithParams:params serviceIdentifier:serviceID methodName:methodName];
}

#pragma mark - Cancel requests
- (void)cancelRequest:(FFRequestID)requestID
{
    [[FFApiManager shareInstance] cancelRequestWithRequestID:@(requestID)];
}

- (void)cancelRequestsWithTarget:(id)target
{
    
}

- (BOOL)isRest:(NSString *)serviceID{
    if ([serviceID isEqualToString:FFNetworkingRestfulGetServiceIDForFreshFresh] || [serviceID isEqualToString:FFNetworkingRestfulPostServiceIDForFreshFresh]) {
        return YES;
    }
    
    return NO;
}


@end
