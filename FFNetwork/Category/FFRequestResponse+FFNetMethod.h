//
//  FFRequestResponse+FFNetMethod.h
//  FFMusic
//
//  Created by xiazer on 14/10/22.
//  Copyright (c) 2014年 xiazer. All rights reserved.
//

#import "FFRequestResponse.h"

@interface FFRequestResponse (FFNetMethod)

- (void)updateWithRTNetworkResponse:(FFRequestResponse *)response;
- (FFRequestResponse *)returnNetworkResponse;

@end
