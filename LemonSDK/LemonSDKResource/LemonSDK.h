//
//  LemonSDK.h
//  LemonSDK
//
//  Created by Skye on 16/3/7.
//  Copyright © 2016年 com.chuangkit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LemonResult.h"



#define LemonSDKPlatformWechat      @"LemonSDKPlatformWechatKey"
#define LemonSDKPlatformQQ          @"LemonSDKPlatformQQKey"
#define LemonSDKPlatformWeiBo       @"LemonSDKPlatformWeiBoKey"

typedef void(^LemonResultBlock)(LemonResult *result);

@class LemonShareObject;

@interface LemonSDK : NSObject

@property (nonatomic,copy) NSString *weiboRedirctURI;

@property (nonatomic,copy) NSString *qqAppKey;

+ (LemonSDK *)shareSDK;

/**
 *  注册第三方SDK
 *  @param appKeys value为APPKEY
 */
+ (void) registerApp:(NSDictionary *)appKeys;

/**
 *  在AppDelegate中注册
 */
+ (BOOL) handleOpenURL:(NSURL *)url withOptions:(NSDictionary *)options;

/**
 *  拉起第三方程序，进行登录 （如果没有安装会调用web登录）
 */
- (void) accessAuthorization:(NSString *)platForm result:(LemonResultBlock) loginBlock;

- (void) share:(LemonShareObject *) shareObject toPlatForm:(NSString *)platform result:(LemonResultBlock) shareBlock;

@end
