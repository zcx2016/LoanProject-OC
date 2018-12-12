//
//  LoanProgressVC.h
//  LoanProject
//
//  Created by 张晨曦 on 2018/12/10.
//  Copyright © 2018年 张晨曦. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoanProgressVC : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *canBorrowMoneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *backMoneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *serverMoneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *wechatLabel;

@property (weak, nonatomic) IBOutlet UIButton *copiBtn;

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIButton *callBtn;

@end

NS_ASSUME_NONNULL_END
