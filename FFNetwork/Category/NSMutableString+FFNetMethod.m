//
//  NSMutableString+FFNetMethod.m
//  FFMusic
//
//  Created by xiazer on 14/11/3.
//  Copyright (c) 2014年 xiazer. All rights reserved.
//

#import "NSMutableString+FFNetMethod.h"
#import "NSObject+FFNetMethod.h"

@implementation NSMutableString (FFNetMethod)

- (void)appendURLRequest:(NSURLRequest *)request{
    [self appendFormat:@"\n\nHTTP URL:\n\t%@", request.URL];
    [self appendFormat:@"\n\nHTTP Header:\n%@", request.allHTTPHeaderFields ? request.allHTTPHeaderFields : @"\t\t\t\t\tN/A"];
    [self appendFormat:@"\n\nHTTP Body:\n\t%@", [[[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding] FFNet_defaultValue:@"\t\t\t\tN/A"]];
}


@end
