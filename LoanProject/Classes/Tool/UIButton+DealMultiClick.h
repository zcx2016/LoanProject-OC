//
//  UIButton+DealMultiClick.h
//  LoanProject
//
//  Created by 张晨曦 on 2018/12/20.
//  Copyright © 2018年 张晨曦. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (DealMultiClick)

/*
 Category不能给类添加属性, 所以以上的cs_acceptEventInterval和cs_acceptEventTime只会有对应的getter和setter方法, 不会添加真正的成员变量.
 如果我们不在实现文件中添加其getter和setter方法, 则采用*** btn.cs_acceptEventInterval = 1; *** 这种方法尝试访问该属性会出错.
 
 */
@property (nonatomic, assign) NSTimeInterval zcx_acceptEventInterval; // 重复点击的间隔

@property (nonatomic, assign) NSTimeInterval zcx_acceptEventTime;

@end

NS_ASSUME_NONNULL_END
