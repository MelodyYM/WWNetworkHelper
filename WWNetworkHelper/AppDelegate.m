//
//  AppDelegate.m
//  WWNetworkHelper
//
//  Created by swift on 2017/7/28.
//  Copyright © 2017年 王家伟. All rights reserved.
//

#import "AppDelegate.h"
#import "WWNetworkHelper.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
- (void)wwNetworkConfig {
    //一次设置全程有效
    [WWNetworkHelper setRequestSerializer:WWRequestSerializerHTTP];
    [WWNetworkHelper setResponseSerializer:WWResponseSerializerJSON];
    [WWNetworkHelper openLog];
    NSLog(@"网络缓存大小cache = %fKB", [WWNetworkCache getAllHttpCacheSize]/1024.f);
    // 清理缓存
    [WWNetworkCache removeAllHttpCache];
    // 实时监测网络状态
    [self monitorNetworkStatus];
    
    /*
     * 一次性获取当前网络状态
     这里延时0.1s再执行是因为程序刚刚启动,可能相关的网络服务还没有初始化完成(也有可能是AFN的BUG),
     导致此demo检测的网络状态不正确,这仅仅只是为了演示demo的功能性, 在实际使用中可直接使用一次性网络判断,不用延时
     */
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self getCurrentNetworkStatus];
    });
}

#pragma mark - 实时监测网络状态
- (void)monitorNetworkStatus
{
    // 网络状态改变一次, networkStatusWithBlock就会响应一次
    [WWNetworkHelper networkStatusWithBlock:^(WWNetworkStatusType networkStatus) {
        
        switch (networkStatus) {
                // 未知网络
            case WWNetworkStatusUnknown:
                // 无网络
            case WWNetworkStatusNotReachable:
                NSLog(@"无网络,加载缓存数据");
                break;
                // 手机网络
            case WWNetworkStatusReachableViaWWAN:
                // 无线网络
            case WWNetworkStatusReachableViaWiFi:
                NSLog(@"有网络,请求网络数据");
                break;
        }
        
    }];
    
}

#pragma mark - 一次性获取当前最新网络状态
- (void)getCurrentNetworkStatus
{
    if (kIsNetwork) {
        NSLog(@"有网络");
        if (kIsWWANNetwork) {
            NSLog(@"手机网络");
        }else if (kIsWiFiNetwork){
            NSLog(@"WiFi网络");
        }
    } else {
        NSLog(@"无网络");
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self wwNetworkConfig];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[ViewController alloc] init];
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
