//
//  ShareViewController.m
//  LemonSDK
//
//  Created by Skye on 16/3/7.
//  Copyright © 2016年 com.chuangkit. All rights reserved.
//

#import "ShareViewController.h"
#import "LemonSDK.h"
#import "LemonShareObject.h"

@implementation ShareViewController

- (IBAction)shareToQQ:(id)sender {
    LemonShareObject *shareObj = [[LemonShareObject alloc] init];
    shareObj.title = @"我只是个测试";
    shareObj.shareContent = @"测试内容哈~~~";
    shareObj.shareUrl = @"http://www.chuangkit.com";
    shareObj.thumbImageData = UIImagePNGRepresentation([UIImage imageNamed:@"icon_60"]);
    shareObj.scene = LemonShareSceneTimeLine;
    [[LemonSDK shareSDK] share:shareObj toPlatForm:LemonSDKPlatformQQ result:^(LemonResult *result) {
        
    }];
    
}

- (IBAction)shareToWechat:(id)sender {
    
    LemonShareObject *shareObj = [[LemonShareObject alloc] init];
    shareObj.title = @"我只是个测试";
    shareObj.shareContent = @"测试内容哈~~~";
    shareObj.shareUrl = @"http://www.chuangkit.com";
    shareObj.thumbImageData = UIImagePNGRepresentation([UIImage imageNamed:@"icon_60"]);
    shareObj.scene = LemonShareSceneTimeLine;
    [[LemonSDK shareSDK] share:shareObj toPlatForm:LemonSDKPlatformWechat result:^(LemonResult *result) {
        
    }];
}

- (IBAction)shareToWeibo:(id)sender {
    LemonShareObject *shareObj = [[LemonShareObject alloc] init];
    shareObj.title = @"我只是个测试";
    shareObj.shareContent = @"测试内容哈~~~";
    shareObj.shareUrl = @"http://www.chuangkit.com";
    shareObj.thumbImageData = UIImagePNGRepresentation([UIImage imageNamed:@"icon_60"]);
    shareObj.scene = LemonShareSceneTimeLine;
    [[LemonSDK shareSDK] share:shareObj toPlatForm:LemonSDKPlatformWeiBo result:^(LemonResult *result) {
        
    }];
}

- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
