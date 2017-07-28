//
//  ViewController.m
//  WWNetworkHelper
//
//  Created by swift on 2017/7/28.
//  Copyright © 2017年 王家伟. All rights reserved.
//

#import "ViewController.h"
#import "WWNetRequest.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [WWNetRequest getLoginWithParameters:@{} success:^(id response) {
        NSLog(@"成功");
    } failure:^(NSError *error) {
        NSLog(@"失败");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
