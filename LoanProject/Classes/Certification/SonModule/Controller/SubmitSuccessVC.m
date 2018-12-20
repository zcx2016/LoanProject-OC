//
//  SubmitSuccessVC.m
//  LoanProject
//
//  Created by 张晨曦 on 2018/12/20.
//  Copyright © 2018年 张晨曦. All rights reserved.
//

#import "SubmitSuccessVC.h"

@interface SubmitSuccessVC ()

@end

@implementation SubmitSuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navigationItem.title = @"运营商认证";
    
    self.doneBtn.zcx_acceptEventInterval = 3;
    [self.doneBtn addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
}

- (void)done{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
