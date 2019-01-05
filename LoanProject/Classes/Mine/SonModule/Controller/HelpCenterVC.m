//
//  HelpCenterVC.m
//  LoanProject
//
//  Created by 张晨曦 on 2018/11/29.
//  Copyright © 2018年 张晨曦. All rights reserved.
//

#import "HelpCenterVC.h"

@interface HelpCenterVC ()

@property (nonatomic, strong) UITextView *tv;

@end

@implementation HelpCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navigationItem.title = @"帮助中心";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tv = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth - 20, kScreenHeight - 20)];
    self.tv.editable = NO;
    self.tv.font = [UIFont systemFontOfSize:16];
    self.tv.text = @"Q1.借款额度和期限是多少？\n目前额度为800到5000元。期限为7天，现金将发放到您的绑定银行卡内。\n\nQ2.具备什么样子的条件才能申请借款？\n本产品并未对您职业收入等条件进行具体限制。年满18到50周岁。手机号码连续使用满6个月即可尝试。\n\nQ3.审核和放款时间需要多久？\n本产品会人工审核致电本人，请注意接听来电电话。放款最快情况下30分钟。最慢48小时之内。 \n\nQ4.为什么收取会员服务会？不可以到账扣除？\n公司规定不支持到账扣除，会员费充当贷款利息，不予退还。请知悉。\n\nQ5.还款日如何计算？如何查询我的还款?\n还款日是按照借款的实际发放日，顺延7天。请点击（我的）菜单里我的借款，即可查询详细借款信息。\n\nQ6.如未按时还款会有什么后果？\n在红鲤鱼逾期的客户。我们会采取合法的催收手段，对您以及您的联系人进行定时的电话和短信催收。";
    
    [self.view addSubview:self.tv];
}



@end
