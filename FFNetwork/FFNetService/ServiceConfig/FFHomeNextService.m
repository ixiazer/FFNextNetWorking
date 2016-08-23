//
//  FFHomeNextService.m
//  Pods
//
//  Created by ixiazer on 16/4/8.
//
//

#import "FFHomeNextService.h"
#import "FFAppContext.h"

@implementation FFHomeNextService

- (BOOL)isOnline
{
    return [[FFAppContext sharedInstance] isApiOnline];
}

- (NSString *)onlineApiBaseUrl
{
    return [NSString stringWithFormat:@"http://wx.freshfresh.com/"];
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
    return [NSString stringWithFormat:@"http://test2.freshfresh.com/"];
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
