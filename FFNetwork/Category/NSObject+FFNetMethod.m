//
//  NSObject+FFNetMethod.m
//  FFMusic
//
//  Created by xiazer on 14/10/21.
//  Copyright (c) 2014年 xiazer. All rights reserved.
//

#import "NSObject+FFNetMethod.h"

@implementation NSObject (FFNetMethod)

- (id)FFNet_defaultValue:(id)defaultData
{
    if (![defaultData isKindOfClass:[self class]]) {
        return defaultData;
    }
    
    if ([self FFNet_isEmptyObject]) {
        return defaultData;
    }
    
    return self;
}

- (NSString *)replaceAllCurrentString:(NSString *)fullString {
    if ([fullString FFNet_isEmptyObject]) {
        return @"";
    }

    if ([fullString isKindOfClass:[NSString class]]) {
        NSRange range1 = [fullString rangeOfString:@"<null>"];
        NSRange range2 = [fullString rangeOfString:@"(null)"];
        NSRange range3 = [fullString rangeOfString:@"null"];
        
        NSString *returnString = [fullString copy];
        if (range1.length > 0) {
            returnString = [returnString stringByReplacingOccurrencesOfString:@"<null>" withString:@"\"\""];
        }
        
        if (range2.length > 0) {
            returnString = [returnString stringByReplacingOccurrencesOfString:@"(null)" withString:@"\"\""];
        }

        if (range3.length > 0) {
            returnString = [returnString stringByReplacingOccurrencesOfString:@"null" withString:@"\"\""];
        }
        
        return returnString;
    }
    
    return @"";
}


- (BOOL)FFNet_isEmptyObject
{
    if ([self isEqual:[NSNull null]]) {
        return YES;
    }
    
    if ([self isKindOfClass:[NSString class]]) {
        if ([(NSString *)self length] == 0) {
            return YES;
        }
    }
    
    if ([self isKindOfClass:[NSArray class]]) {
        if ([(NSArray *)self count] == 0) {
            return YES;
        }
    }
    
    if ([self isKindOfClass:[NSDictionary class]]) {
        if ([(NSDictionary *)self count] == 0) {
            return YES;
        }
    }
    
    return NO;
}

@end
