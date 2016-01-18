//
//  AcronymDataModel.m
//  sample
//
//  Created by Raghava on 1/14/16.
//  Copyright © 2016 Company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AcronymDataModel.h"
#import "AFNetworkConfigClient.h"

@implementation AcronymDataModel

- (instancetype)initWithAttributes:(NSDictionary *)attributes forShortForm:(NSString*)sf {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.shortForm = sf;
    self.longForm = [attributes valueForKeyPath:@"lf"];
    self.since = [attributes valueForKey:@"since"];
    self.frequency = [attributes valueForKey:@"freq"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.since forKey:@"ACRONYM.since"];
    [aCoder encodeObject:self.frequency forKey:@"ACRONYM.freq"];
    [aCoder encodeObject:self.shortForm forKey:@"ACRONYM.sf"];
    [aCoder encodeObject:self.longForm forKey:@"ACRONYM.lf"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.frequency = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"ACRONYM.freq"];
    self.since = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"ACRONYM.since"];
    self.shortForm = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"ACRONYM.sf"];
    self.longForm = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"ACRONYM.lf"];
    
    return self;
}

+ (NSURLSessionDataTask *) requestAcronyms:(NSDictionary*) params andCompletionBlock:(void (^)(NSArray *responseArray, NSError *error))block {
    [AFNetworkConfigClient sharedClient].responseSerializer = [AFHTTPResponseSerializer serializer];
    return [[AFNetworkConfigClient sharedClient] GET:@"software/acromine/dictionary.py" parameters:params progress:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
    
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:JSON options:0 error:nil];
        if([json count]){ //For Empty Data.
            NSArray* sf = [json valueForKey:@"sf"];
            NSArray* lfs = [json valueForKey:@"lfs"][0];
            NSMutableArray *mutablePosts = [[NSMutableArray alloc] init];
            for (NSDictionary *lf in lfs) {
                NSArray *vars = [lf valueForKey:@"vars"];
                for (NSDictionary *var in vars){
                    AcronymDataModel *acronymDataModel = [[AcronymDataModel alloc] initWithAttributes:var forShortForm:sf[0]];
                    [mutablePosts addObject:acronymDataModel];
                }
            }
        
            if (block) {
                block([NSArray arrayWithArray:mutablePosts], nil);
            }
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}


@end