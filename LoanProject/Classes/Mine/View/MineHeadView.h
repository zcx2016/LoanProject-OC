//
//  MineHeadView.h
//  LoanProject
//
//  Created by 张晨曦 on 2018/12/10.
//  Copyright © 2018年 张晨曦. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MineHeadView : UITableViewHeaderFooterView

@property (strong, nonatomic) UIImageView *bgImgView;

@property (strong, nonatomic) UIImageView *headImgView;

@property (strong, nonatomic) UILabel *phoneLabel;

@property (strong, nonatomic) UIButton *renzhenBtn;

+ (instancetype)viewWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
