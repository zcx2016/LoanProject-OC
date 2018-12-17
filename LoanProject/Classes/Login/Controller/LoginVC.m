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
    [self.sendCodeBtn addTarget:self action:@selector(sendCodeEvents) forControlEvents:UIControlEventTouchUpInside];
    
    self.loginBtn.layer.cornerRadius = 5;
    self.loginBtn.layer.masksToBounds = YES;
    [self.loginBtn addTarget:self action:@selector(loginEvents) forControlEvents:UIControlEventTouchUpInside];
}

- (void)sendCodeEvents{
    NSLog(@"发送验证码");
    
    if ([self.phoneTF.text isEqualToString:@""]){
        [SVProgressHUD showErrorWithStatus:@"手机号和服务密码不能为空！"];
        return;
    }

    NSDictionary *dict = @{@"phone" : self.phoneTF.text, @"key":kLpKey};
    
    [[LCHTTPSessionManager sharedInstance] POST:[kUrlReqHead stringByAppendingString:@"/API.asmx/SendSMS"] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//        NSLog(@"发送验证码-----%@",responseObject);
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
- (void)loginEvents{
    
    if ([_phoneTF.text isEqualToString:@""] || [_verifyCodeTF.text isEqualToString:@""]){
        [SVProgressHUD showErrorWithStatus:@"请先填写完信息！"];
        return;
    }
 
    NSDictionary *dict = @{@"phone":_phoneTF.text, @"key" : kLpKey};
    
    [[LCHTTPSessionManager sharedInstance] GET:[kUrlReqHead stringByAppendingString:@"/API.asmx/GetUser"] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
         [SVProgressHUD showProgress:-1 status:@"登录中..."];
        
//        NSLog(@"登录---%@",responseObject);
        //保存用户编号和手机
        [ZcxUserDefauts setObject:responseObject[@"id"] forKey:@"uid"];
        [ZcxUserDefauts setObject:responseObject[@"phone"] forKey:@"phone"];
        //保存额度
        [ZcxUserDefauts setObject:responseObject[@"limit"] forKey:@"limit"];
        //设置 已登录 属性
        [ZcxUserDefauts setBool:YES forKey:@"isLogin"];
        //四大认证
        if ([responseObject[@"isChecIdentity"] isEqual:@0]){ //身份认证
            [ZcxUserDefauts setBool:NO forKey:@"isChecIdentity"];
        }else{
            [ZcxUserDefauts setBool:YES forKey:@"isChecIdentity"];
        }
        if ([responseObject[@"isChecOperator"] isEqual:@0]){ //运营商认证
            [ZcxUserDefauts setBool:NO forKey:@"isChecOperator"];
        }else{
            [ZcxUserDefauts setBool:YES forKey:@"isChecOperator"];
        }
        if ([responseObject[@"isChecAlipay"] isEqual:@0]){ //支付宝认证
            [ZcxUserDefauts setBool:NO forKey:@"isChecAlipay"];
        }else{
            [ZcxUserDefauts setBool:YES forKey:@"isChecAlipay"];
        }
        if ([responseObject[@"isChecBankCard"] isEqual:@0]){ //银行卡认证
            [ZcxUserDefauts setBool:NO forKey:@"isChecBankCard"];
        }else{
            [ZcxUserDefauts setBool:YES forKey:@"isChecBankCard"];
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
