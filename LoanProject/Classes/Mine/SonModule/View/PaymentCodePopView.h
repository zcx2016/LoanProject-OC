//
//  PaymentCodePopView.h
//  LoanProject
//
//  Created by 张晨曦 on 2018/12/12.
//  Copyright © 2018年 张晨曦. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PaymentCodePopView : UIView

@property (weak, nonatomic) IBOutlet UIButton *closeBtn;

@property (weak, nonatomic) IBOutlet UIImageView *codeImgView;

@property (weak, nonatomic) IBOutlet UILabel *payMoneyLabel;

@property (weak, nonatomic) IBOutlet UIView *whiteContentView;

//二维码地址
@property (nonatomic, copy) NSString  *feeAddress;
//金额
@property (nonatomic, copy) NSString  *money;

@end

NS_ASSUME_NONNULL_END
