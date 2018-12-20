//
//  RepaySuccessVC.m
//  LoanProject
//
//  Created by 张晨曦 on 2018/12/12.
//  Copyright © 2018年 张晨曦. All rights reserved.
//

#import "RepaySuccessVC.h"

@interface RepaySuccessVC ()

@end

@implementation RepaySuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"贷款进度";
    
    self.applyMoneyBtn.layer.cornerRadius = 5;
    self.applyMoneyBtn.layer.masksToBounds = YES;
    self.applyMoneyBtn.zcx_acceptEventInterval = 3;
    [self.applyMoneyBtn addTarget:self action:@selector(applyLoan) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)applyLoan{
    NSString *uid = [ZcxUserDefauts objectForKey:@"uid"];
    
    NSDictionary *dict = @{@"key":kLpKey, @"uid": uid};
    
    //先调接口，看申请了贷款没有
    [[LCHTTPSessionManager sharedInstance] GET:[kUrlReqHead stringByAppendingString:@"/API.asmx/GetLoan"] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *isNew = responseObject[@"isNew"];
        if ([isNew isEqualToString:@"1"]){ //已申请贷款
            [self popDoneView];
        }else{ //未申请贷款
            [self createNewApply];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

//已申请，弹出框提示
- (void)popDoneView{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"您的贷款申请已提交，系统人工正在审核中，请去“我的”—“贷款进度”进行查看" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertC addAction:okAction];
    [self.navigationController presentViewController:alertC animated:YES completion:nil];
}


//未申请，开始申请
- (void)createNewApply{
    NSString *uid = [ZcxUserDefauts objectForKey:@"uid"];
    
    NSDictionary *dict = @{@"key":kLpKey, @"uid": uid};
    [[LCHTTPSessionManager sharedInstance] GET:[kUrlReqHead stringByAppendingString:@"/API.asmx/SaveLoan"] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"提交贷款申请----%@",responseObject);
        
        NSString *stateCode = [NSString stringWithFormat:@"%@",responseObject[@"isSave"]];
        if ([stateCode isEqualToString:@"0"]){
            
            [self popDoneView];
        }else{
            [SVProgressHUD showErrorWithStatus:@"申请失败！"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"提交贷款申请失败----%@",error);
    }];
}
@end
