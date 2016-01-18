//
//  AcronymDataModel.h
//  sample
//
//  Created by Raghava on 1/14/16.
//  Copyright © 2016 Company. All rights reserved.
//


@interface AcronymDataModel : NSObject <NSCoding>

@property (nonatomic, strong) NSString *shortForm;
@property (nonatomic, strong) NSString *frequency;
@property (nonatomic, strong) NSString *since;
@property (nonatomic, strong) NSString *longForm;

+ (NSURLSessionDataTask *)requestAcronyms:(NSDictionary*) params andCompletionBlock:(void (^)(NSArray *posts, NSError *error))block;

@end