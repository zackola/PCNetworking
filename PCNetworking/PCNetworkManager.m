//
//  PCNetworkManager.m
//  PCNetworking
//
//  Created by Paul Carpenter on 6/25/14.
//  Copyright (c) 2014 Paul Carpenter. All rights reserved.
//

#import "PCNetworkManager.h"
#import <AFNetworking/AFNetworking.h>
#import "PCNetworkRequest.h"
#import "NSObject+PCNetworking.h"
#import <BlocksKit/BlocksKit.h>

@interface PCNetworkManager ()

@property (nonatomic, strong) AFHTTPSessionManager* sessionManager;
@property (nonatomic, strong) NSString* baseURLString;

@end

@implementation PCNetworkManager

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.sessionManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        self.sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    return self;
}

- (instancetype)initWithBaseURL:(NSURL*)url
{
    self = [super init];
    if (self)
    {
        self.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:url sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        self.sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        self.baseURLString = [url absoluteString];
    }
    return self;
}

- (RACSignal*)loadObjectFromJSONNetworkRequest:(PCNetworkRequest*)request
{
    NSError* error;
    NSMutableURLRequest* serializedRequest = [[AFJSONRequestSerializer serializer] requestWithMethod:request.httpVerb URLString:[NSString stringWithFormat:@"%@%@", self.baseURLString, request.urlString] parameters:request.params error:&error];
    if (request.headerDict)
    {
        [request.headerDict bk_each:^(NSString* key, NSString* value) {
            [request setValue:value forKey:key];
        }];
    }
    
    RACSignal* signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber)
    {
        NSURLSessionTask* task = [self.sessionManager dataTaskWithRequest:serializedRequest completionHandler:^(NSURLResponse *response, id json, NSError *error) {
            if (!error)
            {
                id __block keyedJson = json;
                if (request.responseKeys)
                {
                    [request.responseKeys enumerateObjectsUsingBlock:^(NSString* key, NSUInteger idx, BOOL *stop) {
                        keyedJson = keyedJson[key];
                    }];
                }
                
                id obj;
                if ([keyedJson isKindOfClass:[NSArray class]])
                {
                    obj = [keyedJson bk_map:^(NSDictionary* elem) {
                        return [request.objectClass objectFromDictionary:elem];
                    }];
                }
                else
                {
                    obj = [request.objectClass objectFromDictionary:keyedJson];
                }
                if (obj)
                {
                    [subscriber sendNext:obj];
                }
                else
                {
                    [subscriber sendError:error];
                }
            }
            else
            {
                [subscriber sendError:error];
            }
        }];
        
        [task resume];
        
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
    
    // Start executing the request
    
    return signal;
}

@end