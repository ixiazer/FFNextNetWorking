//
//  FFApiManager.m
//  FFMusic
//
//  Created by xiazer on 14/10/19.
//  Copyright (c) 2014年 xiazer. All rights reserved.
//

#import "FFApiManager.h"
#import "FFRequestGenerator.h"
#import "FFNetDebug.h"
//#import "NSURLRequest+CTNetworkingMethods.h"
#import <AFNetworking/AFNetworking.h>

@interface FFApiManager ()
@property (nonatomic, strong) NSMutableDictionary *dispatchTable;
@property (nonatomic, strong) NSNumber *recordedRequestId;
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end

@implementation FFApiManager

+ (id)shareInstance{
    static dispatch_once_t pred;
    static FFApiManager *sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [[FFApiManager alloc] init];
    });
    return sharedInstance;
}

- (NSMutableDictionary *)dispatchTable
{
    if (_dispatchTable == nil) {
        _dispatchTable = [[NSMutableDictionary alloc] init];
    }
    return _dispatchTable;
}

- (AFHTTPSessionManager *)sessionManager
{
    if (_sessionManager == nil) {
        _sessionManager = [AFHTTPSessionManager manager];
        _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _sessionManager.securityPolicy.allowInvalidCertificates = YES;
        _sessionManager.securityPolicy.validatesDomainName = NO;
    }
    return _sessionManager;
}

- (FFRequestResponse *)callGETWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName{
    FFNetService *service = [[FFNetServiceFactory shareInstance] serviceWithIdentifier:servieIdentifier];
    
    if (service.isREST) {
        return nil;
    }
    
    NSURLRequest *request = [[FFRequestGenerator sharedInstance] generateGETRequestWithServiceIdentifier:servieIdentifier requestParams:params methodName:methodName];
    
    return [self callApiWithRequestSynchronously:request];
}

- (FFRequestResponse *)callPostWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName{
    FFNetService *service = [[FFNetServiceFactory shareInstance] serviceWithIdentifier:servieIdentifier];
    
    if (service.isREST) {
        return nil;
    }
    
    NSURLRequest *request = [[FFRequestGenerator sharedInstance] generatePostRequestWithServiceIdentifier:servieIdentifier requestParams:params methodName:methodName];
    
    return [self callApiWithRequestSynchronously:request];
}

#pragma mark - public methods
- (FFRequestResponse *)callApiWithRequestSynchronously:(NSURLRequest *)request
{
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    FFRequestResponse *FFResponse = [[FFRequestResponse alloc] initWithResponseString:nil
                                                                            requestId:@(-1)
                                                                              request:request
                                                                         responseData:data
                                                                                error:error];
    [FFNetDebug logDebugInfoWithResponse:(NSHTTPURLResponse *)response
                           resposeString:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]
                                 request:request
                                   error:error];
    return FFResponse;
}

- (NSInteger)callGETWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(FFCallback)success fail:(FFCallback)fail
{
    FFNetService *service = [[FFNetServiceFactory shareInstance] serviceWithIdentifier:servieIdentifier];
    
    if (service.isREST) {
        return 0;
    }
    
    NSURLRequest *request = [[FFRequestGenerator sharedInstance] generateGETRequestWithServiceIdentifier:servieIdentifier requestParams:params methodName:methodName];
    
    NSNumber *requestId = [self callApiWithRequest:request success:success fail:fail];
    return [requestId integerValue];
}


- (NSInteger)callPostWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(FFCallback)success fail:(FFCallback)fail
{
    FFNetService *service = [[FFNetServiceFactory shareInstance] serviceWithIdentifier:servieIdentifier];
    
    if (service.isREST) {
        return 0;
    }
    
    NSURLRequest *request = [[FFRequestGenerator sharedInstance] generatePostRequestWithServiceIdentifier:servieIdentifier requestParams:params methodName:methodName];
    
    NSNumber *requestId = [self callApiWithRequest:request success:success fail:fail];
    return [requestId integerValue];
}

- (NSInteger)callRestfulGETWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(FFCallback)success fail:(FFCallback)fail{
    NSURLRequest *request = [[FFRequestGenerator sharedInstance] generateRestfulGETRequestWithServiceIdentifier:servieIdentifier requestParams:params methodName:methodName];
    NSNumber *requestId = [self callApiWithRequest:request success:success fail:fail];
    
    return [requestId integerValue];
}

- (NSInteger)callRestfulPOSTWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(FFCallback)success fail:(FFCallback)fail{
    NSURLRequest *request = [[FFRequestGenerator sharedInstance] generateRestfulPOSTRequestWithServiceIdentifier:servieIdentifier requestParams:params methodName:methodName];
    NSNumber *requestId = [self callApiWithRequest:request success:success fail:fail];
    
    return [requestId integerValue];
}

- (FFRequestResponse *)callRestfulPOSTWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName
{
    NSURLRequest *request = [[FFRequestGenerator sharedInstance] generateRestfulPOSTRequestWithServiceIdentifier:servieIdentifier
                                                                                                   requestParams:params
                                                                                                      methodName:methodName];
    return [self callApiWithRequestSynchronously:request];
}

- (FFRequestResponse *)callRestfulGETWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName
{
    NSURLRequest *request = [[FFRequestGenerator sharedInstance] generateRestfulGETRequestWithServiceIdentifier:servieIdentifier
                                                                                                  requestParams:params
                                                                                                     methodName:methodName];
    return [self callApiWithRequestSynchronously:request];
}

#pragma mark - private methods
/** AFNetworking 核心功能 */
- (NSNumber *)callApiWithRequest:(NSURLRequest *)request success:(FFCallback)success fail:(FFCallback)fail
{
    // 跑到这里的block的时候，就已经是主线程了。
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [self.sessionManager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSNumber *requestID = @([dataTask taskIdentifier]);
        [self.dispatchTable removeObjectForKey:requestID];
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSData *responseData = responseObject;
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        if (error) {
            [FFNetDebug logDebugInfoWithResponse:httpResponse
                                   resposeString:responseString
                                         request:request
                                           error:error];

            FFRequestResponse *response = [[FFRequestResponse alloc]
                                           initWithResponseString:responseString
                                           requestId:requestID
                                           request:request
                                           responseData:responseData
                                           error:error];
            fail?fail(response):nil;
        } else {
            // 检查http response是否成立。
            [FFNetDebug logDebugInfoWithResponse:httpResponse
                                   resposeString:responseString
                                         request:request
                                           error:NULL];

            FFRequestResponse *response = [[FFRequestResponse alloc]
                                           initWithResponseString:responseString
                                           requestId:requestID
                                           request:request
                                           responseData:responseData
                                           status:FFNetWorkingResponseStatusSuccess];

            success?success(response):nil;

//            if (operation.response.statusCode >= 200  && operation.response.statusCode < 300) {
//                success?success(response):nil;
//            } else {
//                fail?fail(response):nil;
//            }
        }
    }];
    
    NSNumber *requestId = @([dataTask taskIdentifier]);
    
    self.dispatchTable[requestId] = dataTask;
    [dataTask resume];
    
    return requestId;
}

//- (void)performanceWithResponse:(AIFURLResponse *)response totalTime:(double)time responseCode:(NSUInteger)code
//{
//    if (![AIFPerformanceConfig shared].config.performance.api) {
//        return;
//    }
//    
//    double serverTime = 0;
//    NSDictionary *responseDic = response.content;
//    if ([responseDic isKindOfClass:[NSDictionary class]] &&
//        responseDic[@"requestTime"]) {
//        serverTime = [responseDic[@"requestTime"] doubleValue];
//    }
//    
//    AIFPerformanceModel *model = [AIFPerformanceModel apiPerformanceModelWithTime:time * 1000
//                                                                              url:[[response.request URL] absoluteString]
//                                                               serverResponseTime:serverTime * 1000
//                                                                     responseCode:code];
//    [AIFPerformanceReporter reportWithModel:model];
//}

#pragma mark - Cancel requests
- (void)cancelRequest:(FFRequestID)requestID
{
    [[FFApiManager shareInstance] cancelRequestWithRequestID:@(requestID)];
}

- (void)cancelRequestsWithTarget:(id)target
{
    
}

- (void)cancelRequestWithRequestID:(NSNumber *)requestID
{
    NSOperation *requestOperation = self.dispatchTable[requestID];
    [requestOperation cancel];
    [self.dispatchTable removeObjectForKey:requestID];
}

- (void)cancelRequestWithRequestIDList:(NSArray *)requestIDList
{
    for (NSNumber *requestId in requestIDList) {
        [self cancelRequestWithRequestID:requestId];
    }
}

- (void)cancelAllRequest
{
    if (self.dispatchTable.allKeys.count > 0) {
        for (NSNumber *requestId in self.dispatchTable.allKeys) {
            [self cancelRequestWithRequestID:requestId];
        }
    }
}

- (NSNumber *)generateRequestId
{
    if (_recordedRequestId == nil) {
        _recordedRequestId = @(1);
    } else {
        if ([_recordedRequestId integerValue] == NSIntegerMax) {
            _recordedRequestId = @(1);
        } else {
            _recordedRequestId = @([_recordedRequestId integerValue] + 1);
        }
    }
    return _recordedRequestId;
}

@end
