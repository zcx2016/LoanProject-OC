//
//  LPMainNavC.m
//
//  Created by 张晨曦 on 11/28/18.
//  Copyright © 2018 张晨曦. All rights reserved.
//

#import "LPMainNavC.h"

#define CurrentSystemVersion ([[[UIDevice currentDevice] systemVersion] floatValue])

@interface LPMainNavC () <UIGestureRecognizerDelegate>

@end

@implementation LPMainNavC

+ (void)initialize {
    
    if (self == [LPMainNavC class]) {
        // 设置导航栏
        // 系统适配
        UINavigationBar *navBar = nil;
        if (CurrentSystemVersion < 9.0) {
            // 9.0 前支持的方法
            navBar = [UINavigationBar appearanceWhenContainedIn:[LPMainNavC class], nil];
        } else {
            // 9.0 后支持的方法
            navBar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[[LPMainNavC class]]];
        }

        //设置导航栏背景颜色为白色不透明
//        navBar.barStyle = UIBarStyleDefault;
//        navBar.translucent = NO;
//        navBar.tintColor = [UIColor blackColor];
        [navBar setBackgroundImage:[UIImage imageNamed:@"navbg"] forBarMetrics:UIBarMetricsDefault];

        // 设置导航栏的标题字体
        [navBar setTitleTextAttributes:@{
                                         NSFontAttributeName: [UIFont boldSystemFontOfSize:19],
                                         NSForegroundColorAttributeName: [UIColor whiteColor]
                                         }];
        // 设置 item 的显示属性
        UIBarButtonItem *item = [UIBarButtonItem appearance];
        
        NSDictionary *itemAttrs = @{
                                    NSForegroundColorAttributeName: [UIColor blackColor],
                                    NSFontAttributeName: [UIFont systemFontOfSize:17]
                                    };
        [item setTitleTextAttributes:itemAttrs forState:UIControlStateNormal];
        // UIControlStateDisabled
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]} forState:UIControlStateDisabled];
    }
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // 如果自定定制了左边的返回按钮, 就没有系统自带的左划返回功能了!!!
    //    self.interactivePopGestureRecognizer.delegate = nil;
    // 这样会造成界面卡住!!!   所以不行!!!
    
    //全屏 pop 手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self.interactivePopGestureRecognizer.delegate action:NSSelectorFromString(@"handleNavigationTransition:")];
    
    //增加全屏POP手势
//    [self.view addGestureRecognizer:pan];
    
    // 这样写同样存在界面卡住现象, 当我们在根控制器拖拽时,
    // 即想移除一个导航控制器的根控制器时, 同样会存在卡死现象
    // bug解决思路: 通过手势代理, 让其在根控制器中不响应手势操作即可!!!

    pan.delegate = self;
}

#pragma mark UIGestureRecognizerDelegate

// 手势开始时调用, 返回值代表手势是否允许执行
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    // 当 当前控制器不是根控制器时, 我们允许手势执行
    return (self.viewControllers.count > 1);
}

#pragma mark - 修改 状态栏
- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return [self.topViewController preferredStatusBarStyle];
}

#pragma mark -  监听导航控制器的 push 动作
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    // 如果childViewControllers的个数大于0, 代表根控制器已经push了
    if (self.childViewControllers.count > 0) { // 非根控制器
        // 这样定制了左边按钮在控制器的view加载之前, 我们可以在控制器的loadView中进行重新定制左边按钮
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:({
            // 这里定制左边的按钮, 让其成为返回按钮
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:@" " forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
            [btn setImage:[UIImage imageNamed:@"backIcon"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
            [btn sizeToFit];
            btn;
        })];
        
        // 如果自定定制了左边的返回按钮, 就没有系统自带的左划返回功能了!!!
        
        // 隐藏tabBar
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    // 这句话放在后面和放在前面是有区别的
    // 前面: 在子控制器中不可再次定制返回按钮
    // 后面: 在子控制器中可以再次定制返回按钮
    [super pushViewController:viewController animated:animated];
}

/** 返回按钮点击了 */
- (void)back {
    // 导航控制器 pop 动作
    [self popViewControllerAnimated:YES];
}
@end
