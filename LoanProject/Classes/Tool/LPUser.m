//
//  LPUser.m
//  LoanProject
//  用户单例
//  Created by 张晨曦 on 2018/12/13.
//  Copyright © 2018年 张晨曦. All rights reserved.
//

#import "LPUser.h"

@implementation LPUser

static LPUser* _instance = nil;

+(instancetype) shareInstance
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init] ;
    }) ;
    
    return _instance ;
}

+(id) allocWithZone:(struct _NSZone *)zone
{
    return [LPUser shareInstance] ;
}

-(id) copyWithZone:(struct _NSZone *)zone
{
    return [LPUser shareInstance] ;
}

@end
