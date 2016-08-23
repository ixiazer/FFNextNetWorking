//
//  FFRequestGenerator.m
//  FFMusic
//
//  Created by xiazer on 14/10/19.
//  Copyright (c) 2014年 xiazer. All rights reserved.
//

#import "FFRequestGenerator.h"
#import "FFSignatureGenerator.h"
#import "FFNetCommonParamsGenerator.h"
#import "NSDictionary+FFNetMethod.h"
#import "FFSignatureGenerator.h"
#import "FFNetServiceFactory.h"
#import "FFNetCommonParamsGenerator.h"
#import "NSObject+FFNetMethod.h"
#import <AFNetworking/AFNetworking.h>
#import "FFNetService.h"
#import "AFURLRequestSerialization.h"
#import "NSURLRequest+FFNetMethod.h"
#import "FFNetServiceFactory.h"
#import "FFNetDebug.h"
#import "FFHomeFreshFresh.h"
#import "FFHomeNextService.h"

static NSString * const httpMethodRestfulGet = @"GET";
static NSString * const httpMethodRestfulPost = @"POST";
static NSString * const httpMethodRestfulPut = @"PUT";
static NSString * const httpMethodRestfulDelete = @"DELETE";

static NSTimeInterval kAIFNetworkingTimeoutSeconds = 20.0f;

@interface FFRequestGenerator ()
@property(nonatomic, strong) AFHTTPRequestSerializer *httpRequestSerializer;
@end

@implementation FFRequestGenerator

#pragma mark - public methods
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static FFRequestGenerator *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[FFRequestGenerator alloc] init];
    });
    return sharedInstance;
}


#pragma mark - getters and setters
- (AFHTTPRequestSerializer *)httpRequestSerializer{
    if (_httpRequestSerializer == nil) {
        _httpRequestSerializer = [AFHTTPRequestSerializer serializer];
        _httpRequestSerializer.timeoutInterval = kAIFNetworkingTimeoutSeconds;
        _httpRequestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    }
    return _httpRequestSerializer;
}

- (NSURLRequest *)generateGETRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName{
    FFNetService *service = [[FFNetServiceFactory shareInstance] serviceWithIdentifier:serviceIdentifier];
    
//    NSString *signature = @"";
    NSString *baseUrlStr = [NSString stringWithFormat:@"%@%@%@",service.apiBaseUrl, service.apiVersion, methodName];
    
    NSMutableDictionary *publicParams = [NSMutableDictionary dictionaryWithDictionary:[FFNetCommonParamsGenerator commonParamsDictionary]];
//    [publicParams setObject:service.publicKey forKey:@"api_key"];
//    [publicParams setObject:signature forKey:@"sig"];
    
    NSString *fullUrl;
    if ([requestParams allKeys].count > 0) {
        if ([service isKindOfClass:[FFHomeFreshFresh class]]) {
            // v2版本 需要单独处理参数
            NSString *paramsStr = [requestParams FFNet_urlParamsStringSignature:YES];
            fullUrl = [NSString stringWithFormat:@"%@?%@",baseUrlStr,paramsStr];
        } else if ([service isKindOfClass:[FFHomeNextService class]]) {
//            NSString *paramsStr = [requestParams FFNet_urlParamsString:YES];
            NSMutableArray *result = [[NSMutableArray alloc] init];
            
            [requestParams enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                if (![obj isKindOfClass:[NSString class]]) {
                    obj = [NSString stringWithFormat:@"%@", obj];
                }
                if ([obj length] > 0) {
                    [result addObject:[NSString stringWithFormat:@"%@=%@", key, [self encodeString:obj]]];
                } else {
                    [result addObject:[NSString stringWithFormat:@"%@=%@", key, [self encodeString:@""]]];
                }
            }];
            
            
            NSMutableString *paramString = [[NSMutableString alloc] init];
            
            NSArray *sortedParams = [result sortedArrayUsingSelector:@selector(compare:)];
            [sortedParams enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if ([paramString length] == 0) {
                    [paramString appendFormat:@"%@", obj];
                } else {
                    [paramString appendFormat:@"&%@", obj];
                }
            }];
            fullUrl = [NSString stringWithFormat:@"%@?%@",baseUrlStr,paramString];
        } else {
            NSString *paramsStr = [requestParams FFNet_urlParamsString:YES];
            fullUrl = [NSString stringWithFormat:@"%@?%@",baseUrlStr,paramsStr];
        }
    } else {
        fullUrl = [NSString stringWithFormat:@"%@",baseUrlStr];
    }
    NSMutableURLRequest *request = [self.httpRequestSerializer requestWithMethod:@"GET" URLString:fullUrl parameters:nil error:NULL];
//    request.requestParams = requestParams;
    request.timeoutInterval = kAIFNetworkingTimeoutSeconds;
    
    for (NSString *key in publicParams) {
        NSString *headerStr = publicParams[key];
        if (headerStr && headerStr.length > 0) {
            [request setValue:headerStr ? headerStr : @"" forHTTPHeaderField:key];
        }
    }
    
    [FFNetDebug logDebugInfoWithRequest:request apiName:methodName service:service requestParams:requestParams httpMethod:@"GET"];
    return request;
}

- (NSString *)encodeString:(NSString*)unencodedString{
    
    // CharactersToBeEscaped = @":/?&=;+!@#$()~',*";
    // CharactersToLeaveUnescaped = @"[].";
    
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)unencodedString,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    
    return encodedString;
}

- (NSURLRequest *)generatePostRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName{
    FFNetService *service = [[FFNetServiceFactory shareInstance] serviceWithIdentifier:serviceIdentifier];
    
//    NSString *signature = @"";
    NSString *baseUrlStr = [NSString stringWithFormat:@"%@%@%@",service.apiBaseUrl, service.apiVersion, methodName];
    
    NSMutableDictionary *publicParams = [NSMutableDictionary dictionaryWithDictionary:[FFNetCommonParamsGenerator commonParamsDictionary]];
//    [publicParams setObject:service.publicKey forKey:@"api_key"];
//    [publicParams setObject:signature forKey:@"sig"];
    
    NSDictionary *requestedParams = [[NSDictionary alloc] init];
    
    if ([requestParams allKeys].count > 0) {
        if ([service isKindOfClass:[FFHomeFreshFresh class]]) {
            // v2版本 需要单独处理参数
            requestedParams = [requestParams FFNet_urlParamsDicSignature:YES];
        } else {
            requestedParams = requestParams;
        }
    }

    NSMutableURLRequest *request = [self.httpRequestSerializer requestWithMethod:@"POST" URLString:baseUrlStr parameters:requestedParams error:NULL];
    if ([service isKindOfClass:[FFHomeFreshFresh class]]) {
        // v2版本 需要单独处理参数
        request.requestParams = requestedParams;
    } else {
        request.requestParams = requestedParams;
    }
    for (NSString *key in publicParams) {
        NSString *headerStr = publicParams[key];
        if (headerStr && headerStr.length > 0) {
            [request setValue:headerStr ? headerStr : @"" forHTTPHeaderField:key];
        }
    }
    
    [FFNetDebug logDebugInfoWithRequest:request apiName:methodName service:service requestParams:requestedParams httpMethod:@"POST"];
    return request;
}

- (NSURLRequest *)generateRestfulGETRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName httpMethod:(NSString *)httpMethod
{
    NSMutableDictionary *allParams = [NSMutableDictionary dictionaryWithDictionary:[FFNetCommonParamsGenerator commonParamsDictionary]];
    [allParams addEntriesFromDictionary:requestParams];
    
    FFNetService *service = [[FFNetServiceFactory shareInstance] serviceWithIdentifier:serviceIdentifier];
    NSString *signature = [FFSignatureGenerator signRestfulGetWithAllParams:requestParams methodName:methodName apiVersion:service.apiVersion privateKey:service.privateKey];
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%@?%@", service.apiBaseUrl, service.apiVersion, methodName, [allParams FFNet_urlParamsStringSignature:NO]];
    
    NSDictionary *restfulHeader = [self commRESTHeadersWithService:service signature:signature];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:kAIFNetworkingTimeoutSeconds];
    request.HTTPMethod = httpMethod;
    [restfulHeader enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [request setValue:obj forHTTPHeaderField:key];
    }];
    request.requestParams = requestParams;
    
    [FFNetDebug logDebugInfoWithRequest:request apiName:methodName service:service requestParams:requestParams httpMethod:[NSString stringWithFormat:@"Restful %@",httpMethod]];
    return request;
}

- (NSURLRequest *)generateRestfulPOSTRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName httpMethod:(NSString *)httpMethod{
    FFNetService *service = [[FFNetServiceFactory shareInstance] serviceWithIdentifier:serviceIdentifier];
    NSDictionary *commonParams = [FFNetCommonParamsGenerator commonParamsDictionary];
    NSString *signature = [FFSignatureGenerator signRestfulPOSTWithApiParams:requestParams commonParams:commonParams methodName:methodName apiVersion:service.apiVersion privateKey:service.privateKey];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%@?%@", service.apiBaseUrl, service.apiVersion, methodName, [commonParams FFNet_urlParamsStringSignature:NO]];
    
    NSDictionary *restfulHeader = [self commRESTHeadersWithService:service signature:signature];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:kAIFNetworkingTimeoutSeconds];
    request.HTTPMethod = httpMethod;
    [restfulHeader enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [request setValue:obj forHTTPHeaderField:key];
    }];
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:requestParams options:NSJSONWritingPrettyPrinted error:NULL];
    request.requestParams = requestParams;
    
    [FFNetDebug logDebugInfoWithRequest:request apiName:methodName service:service requestParams:requestParams httpMethod:[NSString stringWithFormat:@"Restful %@",httpMethod]];
    
    return request;
}

- (NSURLRequest *)generateRestfulGETRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName
{
    return [self generateRestfulGETRequestWithServiceIdentifier:serviceIdentifier requestParams:requestParams methodName:methodName httpMethod:httpMethodRestfulGet];
}

- (NSURLRequest *)generateRestfulPOSTRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName
{
    return [self generateRestfulPOSTRequestWithServiceIdentifier:serviceIdentifier requestParams:requestParams methodName:methodName httpMethod:httpMethodRestfulGet];
}

#pragma mark - private methods
- (NSDictionary *)commRESTHeadersWithService:(FFNetService *)service signature:(NSString *)signature
{
    NSMutableDictionary *headerDic = [NSMutableDictionary dictionary];
    [headerDic setValue:signature forKey:@"sig"];
    [headerDic setValue:service.publicKey forKey:@"key"];
    [headerDic setValue:@"application/json" forKey:@"Accept"];
    [headerDic setValue:@"application/json" forKey:@"Content-Type"];
    
    //    NSString *token = @"OxXjntKz8Hv+G5b2Qts8L6AIlMaQz/FCT/LX1f+A61Hrx36tysEvFtoV7DV64sKB2+2garTXQBIeoHl0rfsuOi1fyoEIPrA5ynNfDk5gGoR8YTRSQiXkVFFpVmuzwDD7Um/BVbq2UK693Wr3/vbI/uzpHY61Gv6bp9j6oOO3zEgoo4kZJa2tgCEUxgm2MOBoDRe7F9ZmOQAXlGkqwZBtFcHTOEeLGVZBSQplNAxrHunHz5bkTwfQnrxdn50nCcbhWCtfulRYC+/jkLObSbPHmA==";
    //    if (token) {
    //        [headerDic setValue:token forKey:@"AuthToken"];
    //    }
    //    NSDictionary *loginResult = [[NSUserDefaults standardUserDefaults] objectForKey:@"anjuke_chat_login_info"];
    //    if (loginResult[@"auth_token"]) {
    //        [headerDic setValue:loginResult[@"auth_token"] forKey:@"AuthToken"];
    //    }
    return headerDic;
}


@end
