//
//  CardManageVC.m
//  LoanProject
//
//  Created by 张晨曦 on 2018/12/10.
//  Copyright © 2018年 张晨曦. All rights reserved.
//

#import "CardManageVC.h"
#import "BankCardCertificationVC.h"

@interface CardManageVC ()

@end

@implementation CardManageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"银行卡管理";
    
    self.changeCardBtn.layer.cornerRadius = 5;
    self.changeCardBtn.layer.masksToBounds = YES;
    self.changeCardBtn.zcx_acceptEventInterval = 3;
    [self.changeCardBtn addTarget:self action:@selector(changeCard) forControlEvents:UIControlEventTouchUpInside];
    
    self.nameLabel.text = self.name;
    self.cardNumLabel.text = self.card;

}

- (void)changeCard{
    BankCardCertificationVC *vc = [BankCardCertificationVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
