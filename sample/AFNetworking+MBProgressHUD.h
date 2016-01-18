//
//  AFNetworking+MBProgressHUD.h
//  sample
//
//  Created by Raghava on 1/14/16.
//  Copyright © 2016 Company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "MBProgressHUD.h"

//Category of MBProgressHUD class to integrate the progress sequences for request made by AFNetworking.

@interface MBProgressHUD (AFNetworking)

- (void)startAnimation:(BOOL) animate forTask:(NSURLSessionTask *)task;

@end
