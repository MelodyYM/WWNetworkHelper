//
//  WWInterfaceConst.m
//  WWNetworkHelper
//
//  Created by swift on 2017/7/28.
//  Copyright © 2017年 王家伟. All rights reserved.
//

#import "WWInterfaceConst.h"

/* ---  服务器使用判断  --- */
#if DevelopSever
/** 接口前缀-开发服务器*/
NSString *const kApiPrefix = @"接口服务器的请求前缀 例: http://192.168.0.1:8080";
#elif UATSever
/** 接口前缀-测试服务器*/
NSString *const kApiPrefix = @"https://www.baidu.com";
#elif ProductSever
/** 接口前缀-生产服务器*/
NSString *const kApiPrefix = @"https://www.baidu.com";
#endif


/* ---  二级接口定义  --- */
/** 登录*/
NSString *const kLogin = @"/login";

