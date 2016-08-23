//
//  FFSignatureGenerator.m
//  FFMusic
//
//  Created by xiazer on 14/10/21.
//  Copyright (c) 2014年 xiazer. All rights reserved.
//

#import "FFSignatureGenerator.h"
#import "NSString+FFNetMethod.h"
#import "NSDictionary+FFNetMethod.h"
#import "NSArray+FFNetMethod.h"

@implementation FFSignatureGenerator

+ (NSString *)signGetWithSigParams:(NSDictionary *)allParams methodName:(NSString *)methodName apiVersion:(NSString *)apiVersion privateKey:(NSString *)privateKey publicKey:(NSString *)publicKey{
    NSString *sigString = [allParams FFNet_urlParamsStringSignature:YES];
    NSString *sigWithKeyString = [NSString stringWithFormat:@"%@%@", sigString, privateKey ? privateKey : @""];
    return [sigWithKeyString STR_md5];
}

+ (NSString *)signPostWithApiParams:(NSDictionary *)apiParams privateKey:(NSString *)privateKey publicKey:(NSString *)publicKey{
    NSMutableDictionary *signParams = [NSMutableDictionary dictionaryWithDictionary:apiParams];
    if (publicKey && publicKey.length > 0) {
        signParams[@"api_key"] = publicKey;
    }
    NSString *signString = [signParams FFNet_urlParamsStringSignature:YES];
    
    return [[NSString stringWithFormat:@"%@%@",signString,privateKey ? signParams : @""] STR_md5];
}

+ (NSString *)signRestfulGetWithAllParams:(NSDictionary *)allParams methodName:(NSString *)methodName apiVersion:(NSString *)apiVersion privateKey:(NSString *)privateKey
{
    NSString *part1 = [NSString stringWithFormat:@"%@/%@", apiVersion, methodName];
    NSString *part2 = [allParams FFNet_urlParamsStringSignature:YES];
    NSString *part3 = privateKey;
    
    NSString *beforeSign = [NSString stringWithFormat:@"%@%@%@", part1, part2, part3];
    return [beforeSign STR_md5];
}

+ (NSString *)signRestfulPOSTWithApiParams:(id)apiParams commonParams:(NSDictionary *)commonParams methodName:(NSString *)methodName apiVersion:(NSString *)apiVersion privateKey:(NSString *)privateKey
{
    NSString *part1 = [NSString stringWithFormat:@"%@/%@", apiVersion, methodName];
    NSString *part2 = [commonParams FFNet_urlParamsStringSignature:YES];
    NSString *part3 = nil;
    if ([apiParams isKindOfClass:[NSDictionary class]]) {
        part3 = [(NSDictionary *)apiParams FFNet_jsonString];
    } else if ([apiParams isKindOfClass:[NSArray class]]) {
        part3 = [(NSArray *)apiParams FFNet_ArrTojsonString];
    } else {
        return @"";
    }
    
    NSString *part4 = privateKey;
    
    NSString *beforeSign = [NSString stringWithFormat:@"%@%@%@%@", part1, part2, part3, part4];
    
    return [beforeSign STR_md5];
}


@end
