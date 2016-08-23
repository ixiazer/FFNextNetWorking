//
//  FFRequestManager.h
//  FFMusic
//
//  Created by xiazer on 14/10/19.
//  Copyright (c) 2014年 xiazer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FFRequestResponse.h"
#import "FFNetWorkingHeader.h"


@interface FFRequestManager : NSObject

+ (id)shareInstance;
+ (void)initServieId;
+ (BOOL)isNetWorkReachable;

#pragma mark --Normal request
- (FFRequestID)asyncGetWithServiceID:(NSString *)serviceID methodName:(NSString *)methodName params:(NSDictionary *)params target:(id)target action:(SEL)action;
- (FFRequestID)asyncPostWithServiceID:(NSString *)serviceID methodName:(NSString *)methodName params:(NSDictionary *)params target:(id)target action:(SEL)action;
- (FFRequestResponse *)syncGetWithServiceID:(NSString *)serviceID methodName:(NSString *)methodName params:(NSDictionary *)params;
- (FFRequestResponse *)syncPostWithServiceID:(NSString *)serviceID methodName:(NSString *)methodName params:(NSDictionary *)params;

#pragma mark - REST
- (FFRequestID)asyncRESTGetWithServiceID:(NSString *)serviceID methodName:(NSString *)methodName params:(NSDictionary *)params target:(id)target action:(SEL)action;
- (FFRequestID)asyncRESTPostWithServiceID:(NSString *)serviceID methodName:(NSString *)methodName params:(NSDictionary *)params target:(id)target action:(SEL)action;
- (FFRequestResponse *)syncRESTPostWithServiceID:(NSString *)serviceID methodName:(NSString *)methodName params:(NSDictionary *)params;
- (FFRequestResponse *)syncRESTGetWithServiceID:(NSString *)serviceID methodName:(NSString *)methodName params:(NSDictionary *)params;

#pragma mark - Cancel request
- (void)cancelRequest:(FFRequestID)requestID;
- (void)cancelRequestsWithTarget:(id)target;



@end
