//
//  GetAddressBookPopView.m
//  LoanProject
//
//  Created by 张晨曦 on 2018/12/12.
//  Copyright © 2018年 张晨曦. All rights reserved.
//

#import "GetAddressBookPopView.h"

@implementation GetAddressBookPopView

- (void)awakeFromNib {
    [super awakeFromNib];

    self.whitePopView.layer.cornerRadius = 10;
    self.whitePopView.layer.masksToBounds = YES;
    
    self.refuseBtn.layer.cornerRadius = 5;
    self.refuseBtn.layer.masksToBounds = YES;
    [self.refuseBtn addTarget:self action:@selector(refuse) forControlEvents:UIControlEventTouchUpInside];
    
    self.agreeBtn.layer.cornerRadius = 5;
    self.agreeBtn.layer.masksToBounds = YES;
    [self.agreeBtn addTarget:self action:@selector(agree) forControlEvents:UIControlEventTouchUpInside];
}

//拒绝
- (void)refuse{
    [self removeFromSuperview];
}

//同意
- (void)agree{
    [self removeFromSuperview];
}

@end
