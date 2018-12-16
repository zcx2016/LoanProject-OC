//
//  HelpCenterVC.m
//  LoanProject
//
//  Created by 张晨曦 on 2018/11/29.
//  Copyright © 2018年 张晨曦. All rights reserved.
//

#import "HelpCenterVC.h"

@interface HelpCenterVC ()

@property (nonatomic, strong) UITextView *tv;

@end

@implementation HelpCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navigationItem.title = @"帮助中心";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tv = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth - 20, kScreenHeight - 20)];
    
    self.tv.font = [UIFont systemFontOfSize:16];
    self.tv.text = @"急用钱不用慌，容易借来帮你忙。\n【容易借】\n在这里你可以体验到专业高效的贷款服务，用户通过APP实现线上申请、即刻审核、极速贷款，全程贴心服务 \n【产品特色】\n\n 速度快：快速审核，极速放款 \n\n 门槛低：只需一张身份证，无需抵押，无需担保。 \n\n 易操作：全程只需手机操作，在线直接申请。 \n\n 超安全：严格遵守国家相关法律法规，对客户隐私信息进行保护。";
    
    [self.view addSubview:self.tv];
}



@end
