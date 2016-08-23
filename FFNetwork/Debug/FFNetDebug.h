//
//  FFNetDebug.h
//  FFMusic
//
//  Created by xiazer on 14/11/3.
//  Copyright (c) 2014年 xiazer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FFNetService.h"
#import "FFRequestResponse.h"

@interface FFNetDebug : NSObject
+ (instancetype)sharedInstance;

@property (nonatomic, assign) BOOL showLogs;
@property (nonatomic, assign) BOOL showRequests;
@property (nonatomic, assign) BOOL showResponses;

+ (void)logDebugInfoWithRequest:(NSURLRequest *)request apiName:(NSString *)apiName service:(FFNetService *)service requestParams:(id)requestParams httpMethod:(NSString *)httpMethod;
+ (void)logDebugInfoWithResponse:(NSHTTPURLResponse *)response resposeString:(NSString *)responseString request:(NSURLRequest *)request error:(NSError *)error;
+ (void)logDebugInfoWithCachedResponse:(FFRequestResponse *)response methodName:(NSString *)methodName serviceIdentifier:(FFNetService *)service;

@end
