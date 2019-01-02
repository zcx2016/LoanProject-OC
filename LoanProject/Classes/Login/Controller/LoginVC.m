//
//  LoginVC.m
//  LoanProject
//
//  Created by 张晨曦 on 2018/11/29.
//  Copyright © 2018年 张晨曦. All rights reserved.
//

#import "LoginVC.h"

@interface LoginVC ()

//自定义 电话 的inputAccessoryView
@property (nonatomic, strong) UIToolbar *customAccessoryView;

//验证码
@property (nonatomic, copy) NSString *verifyCode;

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.phoneTF.inputAccessoryView = self.customAccessoryView;

    self.verifyCodeTF.inputAccessoryView = self.customAccessoryView;
    
    self.sendCodeBtn.layer.cornerRadius = 5;
    self.sendCodeBtn.layer.borderWidth = 1;
    self.sendCodeBtn.layer.borderColor = ZCXColor(238, 142, 33).CGColor;
    [self.sendCodeBtn addTarget:self action:@selector(sendCodeEvents:) forControlEvents:UIControlEventTouchUpInside];
    //设置 按钮3秒内点击效果 只能实现一次
    self.sendCodeBtn.zcx_acceptEventInterval = 3;
    
    self.loginBtn.layer.cornerRadius = 5;
    self.loginBtn.layer.masksToBounds = YES;
    self.loginBtn.zcx_acceptEventInterval = 3;
    [self.loginBtn addTarget:self action:@selector(loginEvents:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)sendCodeEvents:(UIButton *)btn{
  
    if ([self.phoneTF.text isEqualToString:@""]){
        [SVProgressHUD showErrorWithStatus:@"手机号和服务密码不能为空！"];
        return;
    }
    
    [self.verifyCodeTF becomeFirstResponder];
    
    NSDictionary *dict = @{@"phone" : self.phoneTF.text, @"key":kLpKey};
    
    [[LCHTTPSessionManager sharedInstance] POST:[kUrlReqHead stringByAppendingString:@"/API.asmx/SendSMS"] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"发送验证码-----%@",responseObject);
        NSString *stateCode = [NSString stringWithFormat:@"%@",responseObject[@"state"]];
        if ([stateCode isEqualToString:@"0"]){
            // 开启倒计时效果
            [self showCountDown];
            //保存验证码
            self.verifyCode = responseObject[@"key"];
        }else{
            [SVProgressHUD showErrorWithStatus:@"获取验证码失败！"];
            return;
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"发送验证码错误-----%@",error);
    }];

}

#pragma mark - 登录
- (void)loginEvents:(UIButton *)btn{
    
    if ([_phoneTF.text isEqualToString:@""] || [_verifyCodeTF.text isEqualToString:@""]){
        [SVProgressHUD showErrorWithStatus:@"请先填写完信息！"];
        return;
    }
 
    NSDictionary *dict = @{@"phone":_phoneTF.text, @"key" : kLpKey};
    
    [SVProgressHUD showProgress:-1 status:@"登录中..."];
    
    [[LCHTTPSessionManager sharedInstance] GET:[kUrlReqHead stringByAppendingString:@"/API.asmx/GetUser"] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"登录---%@",responseObject);
        
        if (responseObject == nil){
            [SVProgressHUD showErrorWithStatus:@"网络不畅，登录失败!"];
            return;
        }
        
        if ([responseObject[@"isillegal"] isEqualToString:@"1"]){
            [SVProgressHUD showErrorWithStatus:@"您已被加入黑名单，暂时禁止使用该app，请联系工作人员!"];
            return;
        }
        
        //保存用户编号和手机
        [ZcxUserDefauts setObject:responseObject[@"id"] forKey:@"uid"];
        [ZcxUserDefauts setObject:self.phoneTF.text forKey:@"phone"];
        //保存额度
        [ZcxUserDefauts setObject:responseObject[@"limit"] forKey:@"limit"];
        //设置 已登录 属性
        [ZcxUserDefauts setBool:YES forKey:@"isLogin"];
        //四大认证
        //身份认证
        if ([responseObject[@"isChecIdentity"] isEqual:@0]){
            [ZcxUserDefauts setInteger:0 forKey:@"isChecIdentity"];
        }else if ([responseObject[@"isChecIdentity"] isEqual:@1]){
            [ZcxUserDefauts setInteger:1 forKey:@"isChecIdentity"];
        }else{
            [ZcxUserDefauts setInteger:2 forKey:@"isChecIdentity"];
        }
        //运营商认证
        if ([responseObject[@"isChecOperator"] isEqual:@0]){
            [ZcxUserDefauts setInteger:0 forKey:@"isChecOperator"];
        }else if ([responseObject[@"isChecOperator"] isEqual:@1]){
            [ZcxUserDefauts setInteger:1 forKey:@"isChecOperator"];
        }else{
            [ZcxUserDefauts setInteger:2 forKey:@"isChecOperator"];
        }
        //支付宝认证
        if ([responseObject[@"isChecAlipay"] isEqual:@0]){
            [ZcxUserDefauts setInteger:0  forKey:@"isChecAlipay"];
        }else if ([responseObject[@"isChecAlipay"] isEqual:@1]){
            [ZcxUserDefauts setInteger:1 forKey:@"isChecAlipay"];
        }else{
            [ZcxUserDefauts setInteger:2  forKey:@"isChecAlipay"];
        }
        //银行卡认证
        if ([responseObject[@"isChecBankCard"] isEqual:@0]){
            [ZcxUserDefauts setInteger:0 forKey:@"isChecBankCard"];
        }else if ([responseObject[@"isChecBankCard"] isEqual:@1]){
            [ZcxUserDefauts setInteger:1 forKey:@"isChecBankCard"];
        }else{
            [ZcxUserDefauts setInteger:2 forKey:@"isChecBankCard"];
        }
        
        [ZcxUserDefauts synchronize];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [SVProgressHUD dismiss];
            [self dismissViewControllerAnimated:YES completion:^{
                //发送通知,给主界面，刷新 认证信息
                [[NSNotificationCenter defaultCenter] postNotificationName:@"updateUI" object:nil];
            }];
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"登录错误---%@",error);
    }];
    
}

//自定义 电话 和 qq 的inputAccessoryView
- (UIToolbar *)customAccessoryView{
    if (!_customAccessoryView) {
        _customAccessoryView = [[UIToolbar alloc]initWithFrame:(CGRect){0,0,kScreenWidth,45}];
        _customAccessoryView.barTintColor = [UIColor lightGrayColor];
        UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *done = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
        [_customAccessoryView setItems:@[space,done]];
    }
    return _customAccessoryView;
}

- (void)done{
    [self.phoneTF resignFirstResponder];
    [self.verifyCodeTF resignFirstResponder];
}

/* 注意：
 在创建Button时, 要设置Button的样式:
 当type为: UIButtonTypeCustom时 , 是普通读秒的效果.
 当type为: 其他时, 是一闪一闪的效果.
 */
// 开启倒计时效果
-(void)showCountDown{
    
    __block NSInteger time = 59; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮的样式
                [self.sendCodeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
                [self.sendCodeBtn setTitleColor:ZCXColor(253, 141, 38) forState:UIControlStateNormal];
                self.sendCodeBtn.layer.borderColor = ZCXColor(253, 141, 38).CGColor;
                self.sendCodeBtn.userInteractionEnabled = YES;
            });
            
        }else{ //倒计时开始
            
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮显示读秒效果
                [self.sendCodeBtn setTitle:[NSString stringWithFormat:@"%ds后重发", seconds] forState:UIControlStateNormal];
                [self.sendCodeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                self.sendCodeBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
                self.sendCodeBtn.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}

@end
