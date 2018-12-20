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
//    Method before   = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
//    Method after    = class_getInstanceMethod(self, @selector(zcx_sendAction:to:forEvent:));
//    method_exchangeImplementations(before, after);
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        //分别获取
        SEL beforeSelector = @selector(sendAction:to:forEvent:);
        SEL afterSelector = @selector(zcx_sendAction:to:forEvent:);
        
        Method beforeMethod = class_getInstanceMethod(class, beforeSelector);
        Method afterMethod = class_getInstanceMethod(class, afterSelector);
        //先尝试给原来的方法添加实现，如果原来的方法不存在就可以添加成功。返回为YES，否则
        //返回为NO。
        //UIButton 真的没有sendAction方法的实现，这是继承了UIControl的而已，UIControl才真正的实现了。
        BOOL didAddMethod =
        class_addMethod(class,
                        beforeSelector,
                        method_getImplementation(afterMethod),
                        method_getTypeEncoding(afterMethod));
        NSLog(@"%d",didAddMethod);
        if (didAddMethod) {
            // 如果之前不存在，但是添加成功了，此时添加成功的是cs_sendAction方法的实现
            // 这里只需要方法替换
            class_replaceMethod(class,
                                afterSelector,
                                method_getImplementation(beforeMethod),
                                method_getTypeEncoding(beforeMethod));
        } else {
            //本来如果存在就进行交换
            method_exchangeImplementations(afterMethod, beforeMethod);
        }
    });

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
