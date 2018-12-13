//
//  LPUser.h
//  LoanProject
//
//  Created by 张晨曦 on 2018/12/13.
//  Copyright © 2018年 张晨曦. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LPUser : NSObject

+(instancetype) shareInstance;

//key值
@property (nonatomic, copy)  NSString *key;
//用户编号
@property (nonatomic, copy) NSString *uid;
//用户手机号
@property (nonatomic, copy) NSString  *phone;

@end

NS_ASSUME_NONNULL_END
