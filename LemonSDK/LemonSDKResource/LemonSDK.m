//
//  LemonSDK.m
//  LemonSDK
//
//  Created by Skye on 16/3/7.
//  Copyright © 2016年 com.chuangkit. All rights reserved.
//

#import "LemonSDK.h"
#import "LemonToolKit.h"
#import "LemonShareObject.h"
#import "WXApi.h"
#import "WeiboSDK.h"

#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

@interface LemonSDK ()<WXApiDelegate,WeiboSDKDelegate,TencentSessionDelegate,QQApiInterfaceDelegate>

@property (nonatomic, strong) TencentOAuth *tOAuth;

@property (nonatomic, copy) LemonResultBlock loginBlock;

@property (nonatomic, copy) LemonResultBlock shareBlock;

@end

@implementation LemonSDK

+ (LemonSDK *)shareSDK
{
    static dispatch_once_t onceToken;
    static LemonSDK *lemon ;
    dispatch_once(&onceToken, ^{
        if (lemon == nil) {
            lemon = [[LemonSDK alloc] init];
        }
    });
    return lemon;
}

+ (void) registerApp:(NSDictionary *)appKeys
{
    for (NSString *key in appKeys.allKeys) {
        if ([key isEqualToString:LemonSDKPlatformWechat]) {
            [WXApi registerApp:[appKeys objectForKey:key]];
        }
        if ([key isEqualToString:LemonSDKPlatformWeiBo]) {
            [WeiboSDK enableDebugMode:YES];
            [WeiboSDK registerApp:[appKeys objectForKey:key]];
        }
        if ([key isEqualToString:LemonSDKPlatformQQ]) {
            [LemonSDK shareSDK].tOAuth = [[TencentOAuth alloc] initWithAppId:[appKeys objectForKey:key] andDelegate:[LemonSDK shareSDK]];
        }
    }
    
}

+ (BOOL)handleOpenURL:(NSURL *)url withOptions:(NSDictionary *)options
{
    //    NSLog(@"url -- %@,options -- %@",url,options); com.tencent.mqq
    if ([[options objectForKey:UIApplicationOpenURLOptionsSourceApplicationKey] isEqualToString:@"com.tencent.xin"]) {
        //微信回调
        return [WXApi handleOpenURL:url delegate:[LemonSDK shareSDK]];
    }
    if([[options objectForKey:UIApplicationOpenURLOptionsSourceApplicationKey] isEqualToString:@"com.sina.weibo"])
    {
        return [WeiboSDK handleOpenURL:url delegate:[LemonSDK shareSDK]];
    }
    if([[options objectForKey:UIApplicationOpenURLOptionsSourceApplicationKey] isEqualToString:@"com.tencent.mqq"])
    {
        [QQApiInterface handleOpenURL:url delegate:[LemonSDK shareSDK]];
        return [TencentOAuth HandleOpenURL:url];
    }
    return YES;
}

- (void)accessAuthorization:(NSString *)platForm result:(LemonResultBlock) loginBlock
{
    self.loginBlock = loginBlock;
    //微信登录
    if ([platForm isEqualToString:LemonSDKPlatformWechat]) {
        //构造SendAuthReq结构体
        SendAuthReq* req = [[SendAuthReq alloc] init];
        req.scope = @"snsapi_userinfo" ;
        req.state = @"login";
        //第三方向微信终端发送一个SendAuthReq消息结构
        [WXApi sendReq:req];
    }
    //QQ登录
    if([platForm isEqualToString:LemonSDKPlatformQQ])
    {
        NSArray* permissions = [NSArray arrayWithObjects:
                                kOPEN_PERMISSION_GET_USER_INFO,
                                kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                                kOPEN_PERMISSION_ADD_SHARE,
                                nil];
        [self.tOAuth authorize:permissions inSafari:NO];
    }
    //微博登录
    if ([platForm isEqualToString:LemonSDKPlatformWeiBo])
    {
        WBAuthorizeRequest *request = [WBAuthorizeRequest request];
        request.scope = @"all";
        request.redirectURI = self.weiboRedirctURI;
        request.shouldShowWebViewForAuthIfCannotSSO = YES;
        [WeiboSDK sendRequest:request];
    }
}

#pragma mark share
- (void)share:(LemonShareObject *)shareObject toPlatForm:(NSString *)platform result:(LemonResultBlock) shareBlock
{
    self.shareBlock = shareBlock;
    if ([platform isEqualToString:LemonSDKPlatformWechat])
    {
        //分享到微信
        WXMediaMessage *mediaMessage = [WXMediaMessage message];
        mediaMessage.title = shareObject.title;
        mediaMessage.description = shareObject.shareContent;
        mediaMessage.thumbData = shareObject.thumbImageData;
        WXWebpageObject *wObject = [WXWebpageObject object];
        wObject.webpageUrl = shareObject.shareUrl;
        mediaMessage.mediaObject = wObject;
        SendMessageToWXReq *testReq = [[SendMessageToWXReq alloc] init];
        testReq.message = mediaMessage;
        testReq.bText = NO;
        testReq.scene = shareObject.scene;
        [WXApi sendReq:testReq];
    }
    if([platform isEqualToString:LemonSDKPlatformQQ])
    {
        
        //分享到QQ
        QQApiURLObject *urlObject = [QQApiURLObject objectWithURL:[NSURL URLWithString:shareObject.shareUrl]
                                                            title:shareObject.title
                                                      description:shareObject.shareContent
                                                 previewImageData:shareObject.thumbImageData
                                                targetContentType:QQApiURLTargetTypeNews];
        switch (shareObject.scene) {
            case LemonShareSceneSession:
            {
                urlObject.cflag = kQQAPICtrlFlagQQShare;
                break;
            }
            case LemonShareSceneTimeLine:
            {
                urlObject.cflag = kQQAPICtrlFlagQZoneShareOnStart;
                break;
            }
            default:
                break;
        }
        SendMessageToQQReq *request = [SendMessageToQQReq reqWithContent:urlObject];
        [QQApiInterface sendReq:request];
    }
    if([platform isEqualToString:LemonSDKPlatformWeiBo])
    {
        //分享到微博
        WBMessageObject *message = [WBMessageObject message];
        message.text = shareObject.shareContent;
        
        WBWebpageObject *webpage = [WBWebpageObject object];
        webpage.objectID = @"";
        webpage.title = shareObject.title;
        webpage.description = shareObject.shareContent;
        webpage.thumbnailData = shareObject.thumbImageData;
        webpage.webpageUrl =   shareObject.shareUrl;
        message.mediaObject = webpage;
        
        switch (shareObject.scene) {
            case LemonShareSceneSession:
            {
                WBShareMessageToContactRequest *request = [WBShareMessageToContactRequest requestWithMessage:message];
                [WeiboSDK sendRequest:request];
                break;
            }
            case LemonShareSceneTimeLine:
            {
                WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message];
                [WeiboSDK sendRequest:request];
                break;
            }
            default:
                break;
        }
    }
}

#pragma mark wechatDelegate

- (void)onReq:(BaseReq *)req
{
    
}
/**
 *  返回时调用
 */
- (void)onResp:(BaseResp *)resp
{
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *sResp = (SendAuthResp *)resp;
        LemonResult *resultObj = [[LemonResult alloc] init];
        if (sResp.code) {
            resultObj.resultType = LemonResultTypeLogin;
            resultObj.code = sResp.code;
            resultObj.result = YES;
        }
        else
        {
            resultObj.result = NO;
            resultObj.resultType = LemonResultTypeLogin;
        }
        self.loginBlock(resultObj);
    }
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        SendMessageToWXResp *mResponse = (SendMessageToWXResp *)resp;
        LemonResult *resultObj = [[LemonResult alloc] init];
        resultObj.resultType = LemonResultTypeShare;
        if (mResponse.errCode == 0) {
            //分享成功
            resultObj.result = YES;
        }
        else
        {
            resultObj.result = NO;
        }
        self.shareBlock(resultObj);
    }
    if ([resp isKindOfClass:[SendMessageToQQResp class]]) {
        SendMessageToQQResp *qResp = (SendMessageToQQResp *)resp;
        LemonResult *result = [[LemonResult alloc] init];
        result.resultType = LemonResultTypeShare;
        if([qResp.result isEqualToString:@"0"])
        {
            //分享成功
            result.result = YES;
        }
        else
        {
            //分享失败
            result.result = NO;
        }
        self.shareBlock(result);
    }
}

#pragma mark qqdelegate

- (void)isOnlineResponse:(NSDictionary *)response
{
    NSLog(@"isOnlineResponse -- %@",response);
}

- (void)tencentDidLogin
{
    //登陆成功
    LemonResult *resultObj = [[LemonResult alloc] init];
    resultObj.resultType = LemonResultTypeLogin;
    resultObj.result = YES;
    resultObj.access_token = self.tOAuth.accessToken;
    resultObj.uId = self.tOAuth.openId;
    self.loginBlock(resultObj);
}

- (void)tencentDidNotLogin:(BOOL)cancelled
{
    //用户取消
    LemonResult *resultObj = [[LemonResult alloc] init];
    resultObj.resultType = LemonResultTypeLogin;
    resultObj.result = NO;
    self.loginBlock(resultObj);
}

- (void)tencentDidNotNetWork
{
    NSLog(@"tencentDidNotNetWork");
}

#pragma mark weiboDelegate
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    //新浪微博跳转到当前APP
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if([response isKindOfClass:[WBAuthorizeResponse class]])
    {
        WBAuthorizeResponse *aResp = (WBAuthorizeResponse *)response;
        LemonResult *resultObj = [[LemonResult alloc] init];
        resultObj.resultType = LemonResultTypeLogin;
        if(aResp.accessToken)
        {
            resultObj.result = YES;
            resultObj.access_token = aResp.accessToken;
            resultObj.uId = aResp.userID;
        }
        else
        {
            resultObj.result = NO;
        }
        self.loginBlock(resultObj);
    }
    if ([response isKindOfClass:[WBSendMessageToWeiboResponse class]]) {
        WBSendMessageToWeiboResponse *wResponse = (WBSendMessageToWeiboResponse *)response;
        LemonResult *resultObj = [[LemonResult alloc] init];
        resultObj.resultType = LemonResultTypeShare;
        if (wResponse.statusCode == 0) {
            //分享成功
            resultObj.result = YES;
        }
        else
        {
            //分享失败
            resultObj.result = NO;
        }
        self.shareBlock(resultObj);
    }
}
@end
