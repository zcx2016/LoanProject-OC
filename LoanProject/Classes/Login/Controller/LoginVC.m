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
    self.loginBtn.layer.borderWidth = 1;
    self.loginBtn.layer.borderColor = ZCXColor(238, 142, 33).CGColor;
    [self.loginBtn addTarget:self action:@selector(loginEvents) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)sendCodeEvents{
    NSLog(@"发送验证码");
}

- (void)loginEvents{
    [self dismissViewControllerAnimated:YES completion:nil];
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

@end
