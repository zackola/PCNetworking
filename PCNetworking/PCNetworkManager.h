//
//  PCNetworkManager.h
//  PCNetworking
//
//  Created by Paul Carpenter on 6/25/14.
//  Copyright (c) 2014 Paul Carpenter. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PCNetworkRequest, AFHTTPSessionManager;

@interface PCNetworkManager : NSObject

- (instancetype)initWithBaseURL:(NSURL*)url;
- (instancetype)initWithBaseURL:(NSURL*)url sessionConfiguration:(NSURLSessionConfiguration *)sessionConfiguration;
- (RACSignal*)loadObjectFromJSONNetworkRequest:(PCNetworkRequest*)request;
- (RACSignal*)loadObjectFromJSONNetworkRequest:(PCNetworkRequest*)request multipart:(NSDictionary*)multipart;
- (RACSignal*)loadObjectFromJSONNetworkRequest:(PCNetworkRequest*)request multipart:(NSDictionary*)multipart files:(nullable NSDictionary *)multipartFiles;


- (void)cancelAll;


@end
