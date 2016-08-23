//
//  FFNetCommonParamsGenerator.h
//  FFMusic
//
//  Created by xiazer on 14/10/21.
//  Copyright (c) 2014年 xiazer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FFNetService.h"

@interface FFNetCommonParamsGenerator : NSObject
+ (NSDictionary *)commonParamsDictionary;
+ (NSDictionary *)commonParamsDictionaryForLog;

+ (NSDictionary *)sigCommParamsOldWithService:(FFNetService<FFNetServiceProtocal> *)service;
+ (NSDictionary *)outSigCommParamsOldWithService:(FFNetService<FFNetServiceProtocal> *)service;

@end
