//
//  FFFlashBuyService.m
//  FFNetworking
//
//  Created by xiazer on 15/7/29.
//  Copyright (c) 2015年 freshfresh. All rights reserved.
//

#import "FFFlashBuyService.h"
#import "FFAppContext.h"

@implementation FFFlashBuyService

- (BOOL)isOnline
{
    return [[FFAppContext sharedInstance] isApiOnline];
}

- (NSString *)onlineApiBaseUrl
{
    return @"http://wx.freshfresh.com/";
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
    return @"http://test2.freshfresh.com/";
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
