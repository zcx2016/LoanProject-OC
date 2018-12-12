//
//  RepaySuccessVC.m
//  LoanProject
//
//  Created by 张晨曦 on 2018/12/12.
//  Copyright © 2018年 张晨曦. All rights reserved.
//

#import "RepaySuccessVC.h"

@interface RepaySuccessVC ()

@end

@implementation RepaySuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"贷款进度";
    
    self.applyMoneyBtn.layer.cornerRadius = 5;
    self.applyMoneyBtn.layer.masksToBounds = YES;
}



@end
