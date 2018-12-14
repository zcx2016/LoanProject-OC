//
//  UIImage+Compress.h
//  LoanProject
//
//  Created by 张晨曦 on 2018/12/14.
//  Copyright © 2018年 张晨曦. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Compress)

-(NSData *)compressWithMaxLength:(NSUInteger)maxLengt;

@end

NS_ASSUME_NONNULL_END
