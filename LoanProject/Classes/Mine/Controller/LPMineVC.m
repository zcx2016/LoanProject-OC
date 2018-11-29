//
//  LPMineVC.m
//  LoanProject
//
//  Created by 张晨曦 on 2018/11/28.
//  Copyright © 2018年 张晨曦. All rights reserved.
//

#import "LPMineVC.h"
#import "LPCertificationCell.h"

@interface LPMineVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *titleArr;

@property (nonatomic, strong) UIButton *quitBtn;

@end

@implementation LPMineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"个人中心";
    
    _titleArr = @[@"贷款进度",@"我的贷款",@"客服",@"银行卡管理",@"帮助中心",@"关于我们"];
    
    [self setBotBtn];
    
    [self tableView];
}

- (void)setBotBtn{
    
    _quitBtn = [UIButton new];
    [_quitBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [_quitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _quitBtn.layer.cornerRadius = 6;
    _quitBtn.layer.borderWidth = 1;
    _quitBtn.layer.borderColor = [UIColor blackColor].CGColor;
    _quitBtn.layer.masksToBounds = YES;
    
    [_quitBtn addTarget:self action:@selector(quitClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_quitBtn];
    [_quitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(-80);
        make.left.equalTo(self.view).with.offset(20);
        make.height.equalTo(@50);
    }];
}

- (void)quitClick{
    NSLog(@"退出登录");
}

#pragma mark - tableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titleArr.count;
}

#pragma mark - tableView DataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LPCertificationCell *cell = [LPCertificationCell cellWithTableView:tableView];
    //    LPCertificationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LPCertificationCell" forIndexPath:indexPath];
    [cell.checkLb setHidden:YES];
    cell.titleLb.text = _titleArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0){
        NSLog(@"0000");
    }else if (indexPath.row == 1){
        NSLog(@"111");
    }else if (indexPath.row == 2){
        NSLog(@"222");
    }else if (indexPath.row == 3){
        
    }else if (indexPath.row == 4){
        
    }else {
        NSLog(@"关于我们");
    }
    //    LPAVipDetailVC *vc = [LPAVipDetailVC new];
    //    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 设置行高
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 100;
//}

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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 130) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.rowHeight = 50;
        _tableView.backgroundColor = [UIColor whiteColor];
        //注册cell
//        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LPCertificationCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"LPCertificationCell"];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}


@end
