//
//  IDCardCell.m
//  LoanProject
//
//  Created by 张晨曦 on 2018/12/11.
//  Copyright © 2018年 张晨曦. All rights reserved.
//

#import "IDCardCell.h"

@implementation IDCardCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.imgView.userInteractionEnabled = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
