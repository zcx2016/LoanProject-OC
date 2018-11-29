//
//  LoginVC.h
//  LoanProject
//
//  Created by 张晨曦 on 2018/11/29.
//  Copyright © 2018年 张晨曦. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoginVC : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *logoImgView;

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;

@property (weak, nonatomic) IBOutlet UITextField *verifyCodeTF;

@property (weak, nonatomic) IBOutlet UIButton *sendCodeBtn;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

NS_ASSUME_NONNULL_END
