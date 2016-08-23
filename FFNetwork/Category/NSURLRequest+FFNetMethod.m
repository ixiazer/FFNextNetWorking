//
//  NSURLRequest+FFNetMethod.m
//  FFMusic
//
//  Created by xiazer on 14/10/21.
//  Copyright (c) 2014年 xiazer. All rights reserved.
//

#import "NSURLRequest+FFNetMethod.h"
#import <objc/runtime.h>

static void *FFNetworkingRequestParams;

@implementation NSURLRequest (FFNetMethod)
- (void)setRequestParams:(NSDictionary *)requestParams{
    objc_setAssociatedObject(self, &FFNetworkingRequestParams, requestParams, OBJC_ASSOCIATION_COPY);
}

- (NSDictionary *)requestParams{
    return objc_getAssociatedObject(self, &FFNetworkingRequestParams);
}
@end
