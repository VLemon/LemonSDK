//
//  AppDelegate.m
//  LemonSDK
//
//  Created by Skye on 16/3/7.
//  Copyright © 2016年 com.chuangkit. All rights reserved.
//

#import "AppDelegate.h"

#import "LemonSDK.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [LemonSDK registerApp:@{LemonSDKPlatformWechat:@"wx09aec10f9bf423f5",LemonSDKPlatformWeiBo:@"4055128011",LemonSDKPlatformQQ:@"1105139853"}];
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    return [LemonSDK handleOpenURL:url withOptions:options];
}

@end
