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

- (FFAppApiConfigType)apiConfigType
{
    return [FFAppContext sharedInstance].apiConfigType;
}

- (NSString *)apiPreUrl {
    if (self.apiConfigType == FFAppApiConfigTypeForDev) {
        return @"https://test2.freshfresh.com/";
    } else if (self.apiConfigType == FFAppApiConfigTypeForTest) {
        return @"https://test2.freshfresh.com/";
    } else if (self.apiConfigType == FFAppApiConfigTypeForPreOnline) {
        return @"https://test2.freshfresh.com/";
    } else if (self.apiConfigType == FFAppApiConfigTypeForOnline) {
        return @"https://wx.freshfresh.com/";
    }
}

- (NSString *)onlineApiBaseUrl
{
    return @"";
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
    return @"";
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
