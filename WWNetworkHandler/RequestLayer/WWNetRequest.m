//
//  WWNetRequest.m
//  WWNetworkHelper
//
//  Created by swift on 2017/7/28.
//  Copyright © 2017年 王家伟. All rights reserved.
//

#import "WWNetRequest.h"
#import "WWInterfaceConst.h"
#import "WWNetworkHelper.h"

@implementation WWNetRequest

#pragma mark - 请求方法：可以在其它界面直接调用，解除其它界面复杂的网络解析操作。一行代码完成请求即可
//登录
+ (NSURLSessionTask *)getLoginWithParameters:(id)parameters success:(WWRequestSuccess)success failure:(WWRequestFailure)failure {
    // 将请求前缀与请求路径拼接成一个完整的URL
    NSString *url = [NSString stringWithFormat:@"%@%@",kApiPrefix,kLogin];
    return [self requestWithURL:url parameters:parameters success:success failure:failure];
}

/*
 配置好WWNetworkHelper各项请求参数,封装成一个公共方法,给以上方法调用,
 相比在项目中单个分散的使用WWNetworkHelper/其他网络框架请求,可大大降低耦合度,方便维护
 在项目的后期, 你可以在公共请求方法内任意更换其他的网络请求工具,切换成本小
 */

#pragma mark - 请求的公共方法

+ (NSURLSessionTask *)requestWithURL:(NSString *)URL parameters:(NSDictionary *)parameter success:(WWRequestSuccess)success failure:(WWRequestFailure)failure
{
    // 在请求之前你可以统一配置你请求的相关参数 ,设置请求头, 请求参数的格式, 返回数据的格式....这样你就不需要每次请求都要设置一遍相关参数
    
    // 发起请求
    return [WWNetworkHelper POST:URL parameters:parameter success:^(id responseObject) {
        
        // 在这里你可以根据项目自定义其他一些重复操作,比如加载页面时候的等待效果, 提醒弹窗....
        success(responseObject);
        
    } failure:^(NSError *error) {
        // 同上
        failure(error);
    }];
}

@end
