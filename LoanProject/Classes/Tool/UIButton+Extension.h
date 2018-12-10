//
//  UIButton+Extension.h
//  LoanProject
//
//  Created by 张晨曦 on 2018/12/10.
//  Copyright © 2018年 张晨曦. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (Extension)

+ (UIButton *)createYellowBgBtn:(NSString *)title;

- (void)setYellowBgBtn:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
