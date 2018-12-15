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
    [self.changeCardBtn addTarget:self action:@selector(changeCard) forControlEvents:UIControlEventTouchUpInside];
    
    [self loadCardInfo];
}

- (void)loadCardInfo{
    NSString *uid = [ZcxUserDefauts objectForKey:@"uid"];
    NSString *key = [ZcxUserDefauts objectForKey:@"key"];
    
    NSDictionary *dict = @{@"uid" : uid, @"key" : key};
    
    [[LCHTTPSessionManager sharedInstance] GET:[kUrlReqHead stringByAppendingString:@"/API.asmx/GetBank"] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"银行卡信息-----%@",responseObject);
        
        self.nameLabel.text = responseObject[@"bankcard"];
        self.cardNumLabel.text = responseObject[@"savingscard"];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"银行卡信息错误-----%@",error);
    }];
}

- (void)changeCard{
    BankCardCertificationVC *vc = [BankCardCertificationVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
