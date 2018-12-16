//
//  CardManageVC.h
//  LoanProject
//
//  Created by 张晨曦 on 2018/12/10.
//  Copyright © 2018年 张晨曦. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CardManageVC : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardNumLabel;

@property (weak, nonatomic) IBOutlet UIButton *changeCardBtn;


@property (nonatomic, copy) NSString  *name;
@property (nonatomic, copy) NSString  *card;

@end

NS_ASSUME_NONNULL_END
