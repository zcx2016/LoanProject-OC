//
//  LPCertificationCell.m
//  LoanProject
//
//  Created by 张晨曦 on 2018/11/28.
//  Copyright © 2018年 张晨曦. All rights reserved.
//

#import "LPCertificationCell.h"

@interface LPCertificationCell()


@end

@implementation LPCertificationCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"cellID";
    LPCertificationCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell){
        cell = [[LPCertificationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        [self initView];
    }
    return self;
}

- (void)initView{
    _headImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"identity"]];
 
    _titleLb = [UILabel new];
    _titleLb.text = @"身份认证";

    _checkLb = [UILabel new];
    _checkLb.text = @"未认证";
    _checkLb.textColor = [UIColor lightGrayColor];

    _indicatorView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rightArrow"]];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self addSubview:_headImg];
    [_headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.mas_left).with.offset(10);
        make.width.equalTo(@28);
        make.height.equalTo(@28);
    }];

    [self addSubview:_titleLb];
    [_titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.headImg.mas_right).with.offset(10);
    }];
    
    [self addSubview:_indicatorView];
    [_indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.mas_right).with.offset(-10);
        make.width.equalTo(@12);
        make.height.equalTo(@15);
    }];
    
    [self addSubview:_checkLb];
    [_checkLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.indicatorView.mas_left).with.offset(-10);
    }];
    
}

@end
