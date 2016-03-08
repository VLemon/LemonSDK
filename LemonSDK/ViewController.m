//
//  ViewController.m
//  LemonSDK
//
//  Created by Skye on 16/3/7.
//  Copyright © 2016年 com.chuangkit. All rights reserved.
//

#import "ViewController.h"
#import "LemonSDK.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (IBAction)qqLogin:(id)sender {
    [[LemonSDK shareSDK] accessAuthorization:LemonSDKPlatformQQ result:^(LemonResult *result) {
        
    }];
}

- (IBAction)wechatLogin:(id)sender {
    [[LemonSDK shareSDK] accessAuthorization:LemonSDKPlatformWechat result:^(LemonResult *result) {
        NSLog(@"LemonResult   ----  %@",result.code);
    }];
}

- (IBAction)weiBoLogin:(id)sender {
    LemonSDK *lemon = [LemonSDK shareSDK];
    lemon.weiboRedirctURI = @"http://www.chuangkit.com/index2/loginFromSina.do";
    [lemon accessAuthorization:LemonSDKPlatformWeiBo result:^(LemonResult *result) {
        
    }];
}

@end
