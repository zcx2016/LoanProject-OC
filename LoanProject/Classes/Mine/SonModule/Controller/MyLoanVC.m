//
//  MyLoanVC.m
//  LoanProject
//
//  Created by 张晨曦 on 2018/12/10.
//  Copyright © 2018年 张晨曦. All rights reserved.
//

#import "MyLoanVC.h"

@interface MyLoanVC ()

@property (nonatomic, strong) UIButton *returnMoneyBtn;

@end

@implementation MyLoanVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的贷款";
    
    _backMoneyLabel.textColor = [UIColor whiteColor];
    _backMoneyLabel.backgroundColor = ZCXColor(246, 202, 121);
    _backMoneyLabel.layer.cornerRadius = 20;
    _backMoneyLabel.layer.masksToBounds = YES;
    
    //按钮点击事件
    [_copiBtn addTarget:self action:@selector(copyWeixin) forControlEvents:UIControlEventTouchUpInside];
    [_callBtn addTarget:self action:@selector(callPhone) forControlEvents:UIControlEventTouchUpInside];
    
    [self setBotBtn];
}

- (void)setBotBtn{
    
    _returnMoneyBtn = [UIButton createYellowBgBtn:@"我要还款"];
    [_returnMoneyBtn addTarget:self action:@selector(returnMoneyClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_returnMoneyBtn];
    [_returnMoneyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(-20);
        make.left.equalTo(self.view).with.offset(20);
        make.height.equalTo(@50);
    }];
}


- (void)returnMoneyClick{
    NSLog(@"111");
}

- (void)copyWeixin{
    
}

- (void)callPhone{
    
}

@end
