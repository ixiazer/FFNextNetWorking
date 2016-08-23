//
//  UIDevice+FFIdentifierAddition.h
//  FFMusic
//
//  Created by xiazer on 14/10/21.
//  Copyright (c) 2014年 xiazer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (FFIdentifierAddition)

- (NSString *)FFNet_uuid;
- (NSString *)FFNet_udid;
- (NSString *)FFNet_macaddress;
- (NSString *)FFNet_macaddressMD5;
- (NSString *)FFNet_machineType;
- (NSString *)FFNet_ostype;//显示“ios6，ios5”，只显示大版本号
- (NSString *)FFNet_createUUID;


@end
