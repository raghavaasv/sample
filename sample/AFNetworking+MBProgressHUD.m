//
//  AFNetworking+MBProgressHUD.m
//  sample
//
//  Created by Raghava on 1/14/16.
//  Copyright © 2016 Company. All rights reserved.
//

#import "AFNetworking+MBProgressHUD.h"
#import <objc/runtime.h>
#import "AFURLSessionManager.h"

@interface AFMBProgressHUDNotificationObserver : NSObject
@property (readonly, nonatomic, weak) MBProgressHUD *mbProgressHUD;
- (instancetype)initWithMBProgressHUD:(MBProgressHUD *)mbProgressHUD;

- (void)setRefreshingWithStateOfTask:(NSURLSessionTask *)task withAnimation:(BOOL) animate;

@end

@implementation MBProgressHUD (AFNetworking)

- (AFMBProgressHUDNotificationObserver *)af_notificationObserver {
    AFMBProgressHUDNotificationObserver *notificationObserver = objc_getAssociatedObject(self, @selector(af_notificationObserver));
    if (notificationObserver == nil) {
        notificationObserver = [[AFMBProgressHUDNotificationObserver alloc] initWithMBProgressHUD:self];
        objc_setAssociatedObject(self, @selector(af_notificationObserver), notificationObserver, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return notificationObserver;
}

- (void)startAnimation:(BOOL) animate forTask:(NSURLSessionTask *)task {
    [[self af_notificationObserver] setRefreshingWithStateOfTask:task withAnimation:animate];
}

@end

@implementation AFMBProgressHUDNotificationObserver{
    BOOL animateHUD;
}

- (instancetype)initWithMBProgressHUD:(MBProgressHUD *)mbProgressHUD
{
    self = [super init];
    if (self) {
        _mbProgressHUD = mbProgressHUD;
    }
    return self;
}

- (void)setRefreshingWithStateOfTask:(NSURLSessionTask *)task withAnimation:(BOOL) animate {
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter removeObserver:self name:AFNetworkingTaskDidResumeNotification object:nil];
    [notificationCenter removeObserver:self name:AFNetworkingTaskDidSuspendNotification object:nil];
    [notificationCenter removeObserver:self name:AFNetworkingTaskDidCompleteNotification object:nil];
    animateHUD = animate;
    if (task) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wreceiver-is-weak"
#pragma clang diagnostic ignored "-Warc-repeated-use-of-weak"
        if (task.state == NSURLSessionTaskStateRunning) {
            [self.mbProgressHUD show:animate];
            
            [notificationCenter addObserver:self selector:@selector(af_beginRefreshing) name:AFNetworkingTaskDidResumeNotification object:task];
            [notificationCenter addObserver:self selector:@selector(af_endRefreshing) name:AFNetworkingTaskDidCompleteNotification object:task];
            [notificationCenter addObserver:self selector:@selector(af_endRefreshing) name:AFNetworkingTaskDidSuspendNotification object:task];
        } else {
            [self.mbProgressHUD hide:animate afterDelay:3];
        }
#pragma clang diagnostic pop
    }
}

#pragma mark -

- (void)af_beginRefreshing {
    dispatch_async(dispatch_get_main_queue(), ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wreceiver-is-weak"
        [self.mbProgressHUD show:animateHUD];
#pragma clang diagnostic pop
    });
}

- (void)af_endRefreshing {
    dispatch_async(dispatch_get_main_queue(), ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wreceiver-is-weak"
        [self.mbProgressHUD hide:animateHUD afterDelay:3];
#pragma clang diagnostic pop
    });
}

#pragma mark -

- (void)dealloc {
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter removeObserver:self name:AFNetworkingTaskDidCompleteNotification object:nil];
    [notificationCenter removeObserver:self name:AFNetworkingTaskDidResumeNotification object:nil];
    [notificationCenter removeObserver:self name:AFNetworkingTaskDidSuspendNotification object:nil];
}

@end

