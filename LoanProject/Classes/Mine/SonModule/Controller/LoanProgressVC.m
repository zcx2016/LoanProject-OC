//
//  LoanProgressVC.m
//  LoanProject
//
//  Created by 张晨曦 on 2018/12/10.
//  Copyright © 2018年 张晨曦. All rights reserved.
//

#import "LoanProgressVC.h"
#import "PaymentCodePopView.h"
#import "PayVipFeeSuccessVC.h"

@interface LoanProgressVC ()

//支付按钮
@property (nonatomic, strong) UIButton *payMoneyBtn;
//我已完成支付按钮
@property (nonatomic, strong) UIButton *donePayBtn;

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
        make.bottom.equalTo(self.view).with.offset(-70);
        make.left.equalTo(self.view).with.offset(20);
        make.height.equalTo(@kBtnHeight);
    }];
    
    _donePayBtn = [UIButton createYellowBgBtn:@"我已完成支付"];
    [_donePayBtn setBackgroundImage:[UIImage imageNamed:@"redBtn"] forState:UIControlStateNormal];
    _donePayBtn.zcx_acceptEventInterval = 3;
    [_donePayBtn addTarget:self action:@selector(compeletPayClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_payMoneyBtn];
    [_donePayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(-20);
        make.left.equalTo(self.view).with.offset(20);
        make.height.equalTo(@kBtnHeight);
    }];
}


- (void)compeletPayClick{
    //我已完成支付
    NSString *uid = [ZcxUserDefauts objectForKey:@""];
    NSString *key = [ZcxUserDefauts objectForKey:@""];
    NSDictionary *dict = @{@"uid" : uid , @"key" :key};
    [[LCHTTPSessionManager sharedInstance] GET:[kUrlReqHead stringByAppendingString:@"UpdateIsPayCost"] parameters:dict  progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"我已支付费用responseObject------%@",responseObject);
        
        PayVipFeeSuccessVC *vc = [[UIStoryboard storyboardWithName:@"PayVipFeeSuccessVC" bundle:nil] instantiateViewControllerWithIdentifier:@"PayVipFeeSuccessVC"];
        [self.navigationController pushViewController:vc animated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"我已支付费用error------%@",error);
    }];
    
}

- (void)returnMoneyClick{

    //弹出 支付view
    PaymentCodePopView *popView = [[NSBundle mainBundle] loadNibNamed:@"PaymentCodePopView" owner:nil options:nil].firstObject;
    popView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    popView.feeAddress = self.feeAddress;
    popView.money = self.serverMoney;
    popView.fromVc = @"贷款进度";
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
