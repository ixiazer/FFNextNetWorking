//
//  FFAppContext.m
//  FFMusic
//
//  Created by xiazer on 14/10/21.
//  Copyright (c) 2014年 xiazer. All rights reserved.
//

#import "FFAppContext.h"
#import "NSObject+FFNetMethod.h"
#import "UIDevice+FFIdentifierAddition.h"
#import "AFNetworkReachabilityManager.h"
//#import "FFNetLocationManager.h"

#import "FFDeviceInfo.h"
#import <ifaddrs.h>
#import <arpa/inet.h>

@interface FFAppContext ()
@property (nonatomic, strong) UIDevice *device;
@property (nonatomic, copy, readwrite) NSString *m;
@property (nonatomic, copy, readwrite) NSString *guid;
@property (nonatomic, copy, readwrite) NSString *net;
@property (nonatomic, copy, readwrite) NSString *ip;
@property (nonatomic, copy, readwrite) NSString *o;
@property (nonatomic, copy, readwrite) NSString *v;
@property (nonatomic, copy, readwrite) NSString *cv;
@property (nonatomic, copy, readwrite) NSString *macid;
@property (nonatomic, copy, readwrite) NSString *uuid;
@property (nonatomic, copy, readwrite) NSString *udid2;
@property (nonatomic, copy, readwrite) NSString *from;
@property (nonatomic, copy, readwrite) NSString *ostype2;
@property (nonatomic, copy, readwrite) NSString *uuid2;
@property (nonatomic, copy, readwrite) NSString *bp;
@property (nonatomic, copy, readwrite) NSString *p;
@property (nonatomic, copy, readwrite) NSString *ct;
@property (nonatomic, copy, readwrite) NSString *pmodel;
@property (nonatomic, copy, readwrite) NSString *bundleId;
@end

@implementation FFAppContext

#pragma mark - getters and setters
- (UIDevice *)device
{
    if (_device == nil) {
        _device = [UIDevice currentDevice];
    }
    return _device;
}

- (NSString *)m
{
    if (_m == nil) {
        _m = [[self.device.model stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] FFNet_defaultValue:@""];
    }
    return _m;
}

- (NSString *)o
{
    if (_o == nil) {
        _o = [[self.device.systemName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] FFNet_defaultValue:@""];
    }
    return _o;
}
- (NSString *)v
{
    if (_v == nil) {
        _v = [self.device systemVersion];
    }
    return _v;
}

- (NSString *)i
{
    return self.uuid;
}

- (NSString *)cv
{
    if (_cv == nil) {
        _cv = [[FFDeviceInfo appVersion] FFNet_defaultValue:@""];
    }
    return _cv;
}

- (NSString *)pm
{
    return self.channelID;
}

- (NSString *)macid
{
    if (_macid == nil) {
        _macid = [[self.device FFNet_macaddressMD5] FFNet_defaultValue:@""];
    }
    return _macid;
}

- (NSString *)uuid
{
    if (_uuid == nil) {
        _uuid = [[self.device FFNet_uuid] FFNet_defaultValue:@""];
    }
    return _uuid;
}

- (NSString *)from
{
    if (_from == nil) {
        _from = @"mobile";
    }
    return _from;
}

- (NSString *)ostype2
{
    if (_ostype2 == nil) {
        _ostype2 = [self.device.FFNet_ostype FFNet_defaultValue:@""];
    }
    return _ostype2;
}

- (NSString *)uuid2
{
    if (_uuid2 == nil) {
        _uuid2 = [self.device.FFNet_uuid FFNet_defaultValue:@""];
    }
    return _uuid2;
}

- (NSString *)udid2
{
    if (_udid2 == nil) {
        _udid2 = [self.device.FFNet_udid FFNet_defaultValue:@""];
    }
    return _udid2;
}

- (NSString *)qtime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:NSLocalizedString(@"yyyyMMddHHmmss", nil)];
    return [formatter stringFromDate:[NSDate date]];
}

//- (NSString *)cid
//{
//    return [[FFNetLocationManager sharedInstance] currentCityId];
//}

- (void)setCurrentPageNumber:(NSString *)currentPageNumber
{
    self.bp = _currentPageNumber;
    _currentPageNumber = [currentPageNumber copy];
}

- (NSString *)bp
{
    if (_bp == nil) {
        _bp = @"-1";
    }
    return _bp;
}

- (NSString *)channelID
{
    if (_channelID == nil) {
        _channelID = @"A01";
    }
    return _channelID;
}

- (NSString *)appName
{
    if (_appName == nil) {
        _appName = @"FreshFreshiOSApp";
    }
    return _appName;
}

- (NSString *)guid
{
    if (_guid == nil) {
        NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"RTGuid.string"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            _guid = [[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil] copy];
        }
        else {
            CFUUIDRef uuid = CFUUIDCreate(NULL);
            CFStringRef uuidStr = CFUUIDCreateString(NULL, uuid);
            
            _guid = [[NSString alloc] initWithFormat:@"%@",uuidStr];
            
            CFRelease(uuidStr);
            CFRelease(uuid);
            
            [_guid writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
        }
    }
    return _guid;
}

- (NSString *)dvid
{
    return self.udid2;
}

- (NSString *)net
{
    if (_net == nil) {
        _net = @"";
        if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWWAN) {
            _net = @"2G3G";
        }
        if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWiFi) {
            _net = @"WiFi";
        }
    }
    return _net;
}

- (NSString *)ver
{
    return @"1.0";
}

- (NSString *)ip
{
    if (_ip == nil) {
        _ip = @"Error";
        struct ifaddrs *interfaces = NULL;
        struct ifaddrs *temp_addr = NULL;
        int success = 0;
        // retrieve the current interfaces - returns 0 on success
        success = getifaddrs(&interfaces);
        if (success == 0) {
            // Loop through linked list of interfaces
            temp_addr = interfaces;
            while(temp_addr != NULL) {
                if(temp_addr->ifa_addr->sa_family == AF_INET) {
                    // Check if interface is en0 which is the wifi connection on the iPhone
                    if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                        // Get NSString from C String
                        _ip = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    }
                }
                temp_addr = temp_addr->ifa_next;
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return _ip;
}

- (NSString *)mac
{
    return self.macid;
}

//- (NSString *)geo
//{
//    CLLocationCoordinate2D coordinate = [[FFNetLocationManager sharedInstance].locatedCityLocation coordinate];
//    return [NSString stringWithFormat:@"%f, %f", coordinate.latitude, coordinate.longitude];
//}

//- (NSString *)gcid
//{
//    return [FFNetLocationManager sharedInstance].locatedCityId;
//}

- (NSString *)p
{
    if (_p == nil) {
        _p = @"ios";
    }
    return _p;
}

- (NSString *)os
{
    return self.v;
}

- (NSString *)app
{
    return self.appName;
}

- (NSString *)ch
{
    return self.channelID;
}

- (NSString *)ct
{
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    dateFormater.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
    return [dateFormater stringFromDate:[NSDate date]];
}

- (NSString *)pmodel
{
    if (_pmodel == nil) {
        _pmodel = [[UIDevice currentDevice] FFNet_machineType];
    }
    return _pmodel;
}

- (BOOL)isReachable
{
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusUnknown) {
        return YES;
    } else {
        return [[AFNetworkReachabilityManager sharedManager] isReachable];
    }
}

- (NSString *)bundleId
{
    if (!_bundleId) {
        _bundleId = [[[NSBundle mainBundle] bundleIdentifier] FFNet_defaultValue:@""];
    }
    return _bundleId;
}

#pragma mark - public methods
+ (instancetype)sharedInstance
{
    static FFAppContext *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[FFAppContext alloc] init];
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    });
    return sharedInstance;
}

- (void)configWithChannelID:(NSString *)channelID appName:(NSString *)appName ccid:(NSString *)ccid
{
    self.channelID = channelID;
    self.appName = appName;
//    self.appType = appType;
    self.ccid = ccid;
}

#pragma mark - overrided methods
- (instancetype)init
{
    self = [super init];
    if (self) {
        _currentPageNumber = @"-1";
        _isLonglinkOnline = YES;
        _apiConfigType = FFAppApiConfigTypeForOnline;
    }
    return self;
}
@end
