//
//  ProtocolVC.m
//  LoanProject
//
//  Created by 张晨曦 on 2018/12/16.
//  Copyright © 2018年 张晨曦. All rights reserved.
//

#import "ProtocolVC.h"

@interface ProtocolVC ()

@property (nonatomic, strong) UITextView *tv;

@end

@implementation ProtocolVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navigationItem.title = @"《前风科技》贷款协议";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tv = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth - 20, kScreenHeight - 20)];
    
    self.tv.font = [UIFont systemFontOfSize:16];
    self.tv.editable = NO;
    self.tv.text = @"本人同意并不可撤销地授权西安前风科技电子有限公司在办理业务时，可根据需要从中国人民银行个人信用信息基础数据库、上海资信、鹏元、百融金服等其他经国家有权机关批准设立的第三方征信服务机构查询、打印、保存并使用本人运营商信息、借贷信息、消费信息、财务信息等个人信息和包括信贷信息在内的信用信息（包括可能对本人产生负面影响的不良信息），并授权前述第三方服务机构依据法律法规在授权范围内对上述本人信息进行采集、获取、存储、处理、提供、传输、披露。用途包括但不限于：\n 1、审核本人及本人作为担保人或共同还款人贷款及其他信贷业务申请；\n 2、对已发放的信贷业务进行贷中及贷后管理；\n 3、受理法人、其他组织（以下合称为“业务合作人”）的合作申请或在被授权人对业务合作人进行日常管理时，需要查询本人作为业务合作人的法定代表人、负责人、实际控制人、投资人、关键管理者、关联方以及其他关系人的信用状况的；\n 4、其他本人向重庆硕果金额有限公司申请或办理的业务。\n  \n本人同意本授权书以数据电文或其他书面形式订立；本人一旦在线确认本授权书，本授权书即生效。";
    
    [self.view addSubview:self.tv];
}


@end
