//
//  LPCertificationCell.h
//  LoanProject
//
//  Created by 张晨曦 on 2018/11/28.
//  Copyright © 2018年 张晨曦. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LPCertificationCell : UITableViewCell

@property (strong, nonatomic) UIImageView *headImg;

@property (strong, nonatomic) UILabel *titleLb;

@property (strong, nonatomic) UILabel *checkLb;

@property (strong, nonatomic) UIImageView *indicatorView;

@property (strong, nonatomic) UIView *lineView;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
