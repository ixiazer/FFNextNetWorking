//
//  FFFresh2014HomeService.m
//  FFNetworking
//
//  Created by xiazer on 15/9/7.
//  Copyright (c) 2015年 freshfresh. All rights reserved.
//

#import "FFFresh2014HomeService.h"
#import "FFAppContext.h"

@implementation FFFresh2014HomeService

- (BOOL)isOnline
{
    return [[FFAppContext sharedInstance] isApiOnline];
}

- (NSString *)onlineApiBaseUrl
{
    return @"http://www.freshfresh.com/";
}

- (NSString *)onlineApiVersion
{
    return @"";
}

- (NSString *)onlinePrivateKey
{
    return @"";
}

- (NSString *)onlinePublicKey
{
    return @"";;
}

- (NSString *)offlineApiBaseUrl
{
    return @"http://test1.freshfresh.com/";
}

- (NSString *)offlineApiVersion
{
    return @"";
}

- (NSString *)offlinePrivateKey
{
    return @"";
}

- (NSString *)offlinePublicKey
{
    return @"";
}

@end
