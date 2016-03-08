//
//  LemonToolKit.m
//  LemonSDK
//
//  Created by Skye on 16/3/7.
//  Copyright © 2016年 com.chuangkit. All rights reserved.
//

#import "LemonToolKit.h"

@implementation LemonToolKit

+ (NSDictionary *)lemonQuaryToParams:(NSString *)quary
{
    NSArray *pars =  [quary componentsSeparatedByString:@"&"];
    NSMutableDictionary *parms = [NSMutableDictionary dictionary];
    for (NSString *par in pars) {
        NSArray *tempArray = [par componentsSeparatedByString:@"="];
        [parms setObject:tempArray.lastObject forKey:tempArray.firstObject];
    }
    return parms;
}

@end
