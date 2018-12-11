//
//  CardManageVC.m
//  LoanProject
//
//  Created by 张晨曦 on 2018/12/10.
//  Copyright © 2018年 张晨曦. All rights reserved.
//

#import "CardManageVC.h"

@interface CardManageVC ()

@end

@implementation CardManageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"银行卡管理";
    
    [self setUpView];
}

- (void)setUpView{
    
    self.changeCardBtn.layer.cornerRadius = 5;
    self.changeCardBtn.layer.masksToBounds = YES;
    
}

@end
