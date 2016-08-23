//
//  NSString+FFNetMethod.h
//  FFMusic
//
//  Created by xiazer on 14/10/21.
//  Copyright (c) 2014年 xiazer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (FFNetMethod)
- (NSString *)STR_md5;

+ (NSString *) jsonStringWithArray:(NSArray *)array;
+ (NSString *) jsonStringWithDictionary:(NSDictionary *)dictionary;
+ (NSString *) jsonStringWithObject:(id) object;
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
+ (NSString *) jsonStringWithString:(NSString *) string;
+ (NSString *)replaceUnicode:(NSString *)unicodeStr;
@end
