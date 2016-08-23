//
//  FFRequestResponse.h
//  FFMusic
//
//  Created by xiazer on 14/10/19.
//  Copyright (c) 2014年 xiazer. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, FFNetWorkingResponseStatus){
    FFNetWorkingResponseStatusSuccess,
    FFNetWorkingResponseStatusTimeOut,
    FFNetWorkingResponseStatusTokenInvalid,
    FFNetWorkingResponseStatusNetError,
    FFNetWorkingResponseStatusError
};

typedef unsigned int FFRequestID;

@interface FFRequestResponse : NSObject
@property (nonatomic, copy, readwrite) NSString *contentString;
@property(nonatomic, assign) FFRequestID requestID;
@property(nonatomic, assign) FFNetWorkingResponseStatus status;
@property (nonatomic, copy) NSDictionary *requestParams;
@property (nonatomic, copy, readwrite) id content;


- (instancetype)initWithResponseString:(NSString *)responseString requestId:(NSNumber *)requestId request:(NSURLRequest *)request responseData:(NSData *)responseData status:(enum FFNetWorkingResponseStatus)status;

- (instancetype)initWithResponseString:(NSString *)responseString requestId:(NSNumber *)requestId request:(NSURLRequest *)request responseData:(NSData *)responseData error:(NSError *)error;
- (void)updateWithContent:(id)content requestId:(NSInteger)requestId status:(enum FFNetWorkingResponseStatus)status;
@property (nonatomic, assign, readwrite) NSInteger requestId;

@end
