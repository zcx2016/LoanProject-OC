//
//  MineHeadView.m
//  LoanProject
//
//  Created by 张晨曦 on 2018/12/10.
//  Copyright © 2018年 张晨曦. All rights reserved.
//

#import "MineHeadView.h"

@implementation MineHeadView

+ (instancetype)viewWithTableView:(UITableView *)tableView{
    static NSString *ID = @"headViewID";
    MineHeadView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (!view){
        view = [[MineHeadView alloc] initWithReuseIdentifier:ID];
    }
    return view;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self){
        [self initView];
    }
    return self;
}

- (void)initView{
    
    _bgImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"banner2"]];
    _bgImgView.userInteractionEnabled = YES;
    
    _headImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"touxiang"]];
    _headImgView.userInteractionEnabled = YES;
    _headImgView.layer.cornerRadius = 40;
    _headImgView.layer.masksToBounds = YES;
    
    _phoneLabel = [UILabel new];
    _phoneLabel.textColor = [UIColor whiteColor];
    _phoneLabel.font = [UIFont boldSystemFontOfSize:20];
    _phoneLabel.text = @"18000023323";
    
    _renzhenBtn = [UIButton new];
    [_renzhenBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_renzhenBtn setTitle:@"未认证" forState:UIControlStateNormal];
    [_renzhenBtn setBackgroundImage:[UIImage imageNamed:@"weirenzheng"] forState:UIControlStateNormal];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self addSubview:_bgImgView];
    [_bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.equalTo(@220);
    }];
    
    [_bgImgView addSubview:_headImgView];
    [_headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.mas_top).with.offset(40);
        make.width.height.equalTo(@80);
    }];
    
    [_bgImgView addSubview:_phoneLabel];
    [_phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.headImgView.mas_bottom).with.offset(13);
    }];
    
    [_bgImgView addSubview:_renzhenBtn];
    [_renzhenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.phoneLabel.mas_bottom).with.offset(12);
        make.width.equalTo(@95);
        make.height.equalTo(@33);
    }];
}

@end
