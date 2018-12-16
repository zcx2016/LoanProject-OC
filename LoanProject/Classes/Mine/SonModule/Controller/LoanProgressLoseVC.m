//
//  LoanProgressLoseVC.m
//  LoanProject
//
//  Created by 张晨曦 on 2018/12/11.
//  Copyright © 2018年 张晨曦. All rights reserved.
//

#import "LoanProgressLoseVC.h"

@interface LoanProgressLoseVC ()

@end

@implementation LoanProgressLoseVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navigationItem.title = @"贷款进度";
    
    self.loseReasonLabel.text = [@"失败原因：" stringByAppendingString:self.loseInfo];
}


@end
