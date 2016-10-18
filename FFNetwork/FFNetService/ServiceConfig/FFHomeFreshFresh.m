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

- (FFAppApiConfigType)apiConfigType
{
    return [FFAppContext sharedInstance].apiConfigType;
}

- (NSString *)apiPreUrl {
    if (self.apiConfigType == FFAppApiConfigTypeForDev) {
        return @"http://test1.freshfresh.com/";
    } else if (self.apiConfigType == FFAppApiConfigTypeForTest) {
        return @"http://114.55.218.27/testfresh/";
    } else if (self.apiConfigType == FFAppApiConfigTypeForPreOnline) {
        return @"http://114.55.218.27/";
    } else if (self.apiConfigType == FFAppApiConfigTypeForOnline) {
        return @"http://www.freshfresh.com/";
    }
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
