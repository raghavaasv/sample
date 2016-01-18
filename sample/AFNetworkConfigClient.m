//
//  AFNetworkConfig.m
//  sample
//
//  Created by Raghava on 1/14/16.
//  Copyright © 2016 Company. All rights reserved.
//

#import "AFNetworkConfigClient.h"

static NSString * const AFAPIBaseURLString = @"http://www.nactem.ac.uk/";

@implementation  AFNetworkConfigClient

+ (instancetype)sharedClient {
    static AFNetworkConfigClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[AFNetworkConfigClient alloc] initWithBaseURL:[NSURL URLWithString:AFAPIBaseURLString]];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    });
    
    return _sharedClient;
}

@end
