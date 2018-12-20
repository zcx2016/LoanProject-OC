//
//  UIButton+DealMultiClick.m
//  LoanProject
//
//  Created by 张晨曦 on 2018/12/20.
//  Copyright © 2018年 张晨曦. All rights reserved.
//

#import "UIButton+DealMultiClick.h"
#import <objc/runtime.h>

@implementation UIButton (DealMultiClick)

// 因category不能添加属性，只能通过关联对象的方式。
static const char *UIControl_acceptEventInterval = "UIControl_acceptEventInterval";

- (NSTimeInterval)zcx_acceptEventInterval {
    return  [objc_getAssociatedObject(self, UIControl_acceptEventInterval) doubleValue];
}

- (void)setZcx_acceptEventInterval:(NSTimeInterval)zcx_acceptEventInterval {
    objc_setAssociatedObject(self, UIControl_acceptEventInterval, @(zcx_acceptEventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static const char *UIControl_acceptEventTime = "UIControl_acceptEventTime";

- (NSTimeInterval)zcx_acceptEventTime {
    return  [objc_getAssociatedObject(self, UIControl_acceptEventTime) doubleValue];
}

- (void)setZcx_acceptEventTime:(NSTimeInterval)zcx_acceptEventTime {
    objc_setAssociatedObject(self, UIControl_acceptEventTime, @(zcx_acceptEventTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


// 在load时执行hook
+ (void)load {
    Method before   = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
    Method after    = class_getInstanceMethod(self, @selector(zcx_sendAction:to:forEvent:));
    method_exchangeImplementations(before, after);
}

- (void)zcx_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    if ([NSDate date].timeIntervalSince1970 - self.zcx_acceptEventTime < self.zcx_acceptEventInterval) {
        return;
    }
    
    if (self.zcx_acceptEventInterval > 0) {
        self.zcx_acceptEventTime = [NSDate date].timeIntervalSince1970;
    }
    
    [self zcx_sendAction:action to:target forEvent:event];
}


@end
