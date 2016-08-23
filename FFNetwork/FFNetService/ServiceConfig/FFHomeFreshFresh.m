//
//  FFMusicForBaidu.m
//  FFMusic
//
//  Created by xiazer on 14/10/19.
//  Copyright (c) 2014年 xiazer. All rights reserved.
//

#import "FFHomeFreshFresh.h"
#import "FFAppContext.h"

@implementation FFHomeFreshFresh

- (BOOL)isOnline
{
    return [[FFAppContext sharedInstance] isApiOnline];
}

- (NSString *)onlineApiBaseUrl
{
    return [NSString stringWithFormat:@"http://www.freshfresh.com/"];
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
    return [NSString stringWithFormat:@"http://test1.freshfresh.com/"];
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
