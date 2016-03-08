//
//  LemonResult.h
//  LemonSDK
//
//  Created by Skye on 16/3/8.
//  Copyright © 2016年 com.chuangkit. All rights reserved.
//
// 当前需求是微信第三方登陆获取到Code 然后交给服务器处理

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, LemonResultType) {
    LemonResultTypeLogin = 0,
    LemonResultTypeShare,
};

@interface LemonResult : NSObject

@property (nonatomic, assign) BOOL result;

@property (nonatomic, assign) LemonResultType resultType;

/**
 *  微信登陆获取Code
 */
@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *access_token;

/**
 *  用户唯一标示
 */
@property (nonatomic, copy) NSString *uId;
@end
