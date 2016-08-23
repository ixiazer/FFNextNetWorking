//
//  FFNetServiceFactory.h
//  FFMusic
//
//  Created by xiazer on 14/10/21.
//  Copyright (c) 2014年 xiazer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FFNetService.h"

@interface FFNetServiceFactory : NSObject
+ (id)shareInstance;

- (FFNetService<FFNetServiceProtocal> *)serviceWithIdentifier:(NSString *)identifier;
- (FFNetService<FFNetServiceProtocal> *)newServiceWithIdentify:(NSString *)identify;

@end
