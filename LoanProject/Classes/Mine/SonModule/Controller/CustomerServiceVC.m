//
//  CustomerServiceVC.m
//  LoanProject
//  客服
//  Created by 张晨曦 on 2018/12/10.
//  Copyright © 2018年 张晨曦. All rights reserved.
//

#import "CustomerServiceVC.h"
#import "CustomServerCell.h"

@interface CustomerServiceVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) NSArray *titleArr;

@end

@implementation CustomerServiceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"客服";
    self.view.backgroundColor = [UIColor whiteColor];
    
    _titleArr = @[@[@"weixin",@"复制"],@[@"phone",@"拨打"]];

    [self tableView];
}

#pragma mark - tableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

#pragma mark - tableView DataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CustomServerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomServerCell" forIndexPath:indexPath];
    //赋值
    [cell.imgView setImage:[UIImage imageNamed:_titleArr[indexPath.row][0]]];
    [cell.eventBtn setTitle:_titleArr[indexPath.row][1] forState:UIControlStateNormal];
    [cell.eventBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    if (indexPath.row == 0){
        cell.titleLb.text = self.weChat;
    }else{
        cell.titleLb.text = self.telephone;
    }
    return cell;
}

- (void)btnClick:(UIButton *)btn{
    CustomServerCell *cell = (CustomServerCell *)btn.superview.superview;
    if ([btn.titleLabel.text isEqualToString: @"复制"]){
        //复制到粘贴板
        UIPasteboard *pb = [UIPasteboard generalPasteboard];
        if (cell.titleLb.text != nil){
            pb.string = cell.titleLb.text;
        }
        [SVProgressHUD showSuccessWithStatus:@"微信号已复制到粘贴板!"];
    }
    if ([btn.titleLabel.text isEqualToString: @"拨打"]){
        //打电话
        NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",cell.titleLb.text];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}

#pragma mark - 设置高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

#pragma mark - 懒加载tableView
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.rowHeight = ZCXRowHeight;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //注册cell
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CustomServerCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CustomServerCell"];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

@end
