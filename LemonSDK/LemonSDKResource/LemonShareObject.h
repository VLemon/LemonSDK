//
//  LemonShareObject.h
//  LemonSDK
//
//  Created by Skye on 16/3/7.
//  Copyright © 2016年 com.chuangkit. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, LemonShareScene) {
    LemonShareSceneSession = 0,
    LemonShareSceneTimeLine,
};

@interface LemonShareObject : NSObject

/**
 *  默认分享到对话
 */
@property (nonatomic, assign) LemonShareScene scene;
/**
 *  分享标题
 */
@property (nonatomic, copy) NSString *title;

/**
 * 分享描述
 */
@property (nonatomic, copy) NSString *shareContent;

/**
 *  分享图片地址列表
 */
@property (nonatomic, strong) NSData *thumbImageData;

/**
 *  分享URI
 */
@property (nonatomic, copy) NSString *shareUrl;

@end
