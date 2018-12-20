//
//  LoanProgressVC.m
//  LoanProject
//
//  Created by 张晨曦 on 2018/12/10.
//  Copyright © 2018年 张晨曦. All rights reserved.
//

#import "LoanProgressVC.h"
#import "PaymentCodePopView.h"

@interface LoanProgressVC ()

@property (nonatomic, strong) UIButton *payMoneyBtn;

@end

@implementation LoanProgressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"贷款进度";
    
    _backMoneyLabel.textColor = [UIColor whiteColor];
    _backMoneyLabel.backgroundColor = ZCXColor(246, 202, 121);
    _backMoneyLabel.layer.cornerRadius = 20;
    _backMoneyLabel.layer.masksToBounds = YES;
    
    //按钮点击事件
    [_copiBtn addTarget:self action:@selector(copyWeixin) forControlEvents:UIControlEventTouchUpInside];
    [_callBtn addTarget:self action:@selector(callPhone) forControlEvents:UIControlEventTouchUpInside];
    
    //赋值
    _canBorrowMoneyLabel.text = self.loanMoney;
    _serverMoneyLabel.text = [[@"会员服务费:" stringByAppendingString:self.serverMoney] stringByAppendingString:@"元"];
    _wechatLabel.text = self.weChat;
    _phoneLabel.text = self.telephone;
    
    //底部button
    [self setBotBtn];
}

- (void)setBotBtn{
    
    _payMoneyBtn = [UIButton createYellowBgBtn:@"支 付"];
    _payMoneyBtn.zcx_acceptEventInterval = 3;
    [_payMoneyBtn addTarget:self action:@selector(returnMoneyClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_payMoneyBtn];
    [_payMoneyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(-20);
        make.left.equalTo(self.view).with.offset(20);
        make.height.equalTo(@kBtnHeight);
    }];
}


- (void)returnMoneyClick{

    //弹出 支付view
    PaymentCodePopView *popView = [[NSBundle mainBundle] loadNibNamed:@"PaymentCodePopView" owner:nil options:nil].firstObject;
    popView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    popView.feeAddress = self.feeAddress;
    popView.money = self.serverMoney;
    [UIApplication.sharedApplication.keyWindow addSubview:popView];
}

- (void)copyWeixin{
    //复制到粘贴板
    UIPasteboard *pb = [UIPasteboard generalPasteboard];
    pb.string = _wechatLabel.text;
    [SVProgressHUD showSuccessWithStatus:@"微信号已复制到粘贴板!"];
}

- (void)callPhone{
    //打电话
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",_phoneLabel.text];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}


@end
