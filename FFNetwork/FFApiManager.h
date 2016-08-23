//
//  FFApiManager.h
//  FFMusic
//
//  Created by xiazer on 14/10/19.
//  Copyright (c) 2014年 xiazer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FFRequestResponse.h"
#import "FFNetService.h"
#import "FFNetServiceFactory.h"

typedef void(^FFCallback)(FFRequestResponse *response);

typedef NS_ENUM(NSUInteger, FFNetworkDetailStatus)
{
    FFNetworkDetailStatusNone,
    FFNetworkDetailStatus2G,
    FFNetworkDetailStatus3G,
    FFNetworkDetailStatus4G,
    FFNetworkDetailStatusLTE,
    FFNetworkDetailStatusWIFI,
    FFNetworkDetailStatusUnknown
};

@interface FFApiManager : NSObject
+ (id)shareInstance;

#pragma mark - General equest
- (NSInteger)callGETWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(FFCallback)success fail:(FFCallback)fail;
- (NSInteger)callPostWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(FFCallback)success fail:(FFCallback)fail;
- (FFRequestResponse *)callGETWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName;
- (FFRequestResponse *)callPostWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName;

#pragma mark - Rest request
- (NSInteger)callRestfulGETWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(FFCallback)success fail:(FFCallback)fail;
- (NSInteger)callRestfulPOSTWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(FFCallback)success fail:(FFCallback)fail;
- (FFRequestResponse *)callRestfulPOSTWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName;
- (FFRequestResponse *)callRestfulGETWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName;

#pragma mark - Cancel request
- (void)cancelRequest:(FFRequestID)requestID;
- (void)cancelRequestsWithTarget:(id)target;
- (void)cancelRequestWithRequestID:(NSNumber *)requestID;
- (void)cancelAllRequest;
@end
