//
//  AFNetworkConfig.h
//  sample
//
//  Created by Raghava on 1/14/16.
//  Copyright © 2016 Company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface AFNetworkConfigClient : AFHTTPSessionManager

+ (instancetype)sharedClient;

@end
