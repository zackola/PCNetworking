//
//  NSObject+PCNetworking.h
//  PCNetworking
//
//  Created by Paul Carpenter on 5/16/14.
//  Copyright (c) 2014 Paul Carpenter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (PCNetworking)

+ (instancetype)objectFromDictionary:(NSDictionary*)dictionary;

+ (NSString*)propertyNameFromNetworkName:(NSString *)networkName; // Deprecated
+ (NSDictionary*)networkNameMappings; // Takes precedence over values from propertyNameFromNetworkName

@end
