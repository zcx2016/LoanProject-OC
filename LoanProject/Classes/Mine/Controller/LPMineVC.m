//
//  LPMineVC.m
//  LoanProject
//
//  Created by 张晨曦 on 2018/11/28.
//  Copyright © 2018年 张晨曦. All rights reserved.
//

#import "LPMineVC.h"
#import "LPCertificationCell.h"
#import "MineHeadView.h"
#import "LoginVC.h"

//
#import "LoanProgressVC.h"
#import "MyLoanVC.h"
#import "CustomerServiceVC.h"
#import "CardManageVC.h"
#import "HelpCenterVC.h"

@interface LPMineVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *imgArr;
@property (nonatomic, strong) NSArray *titleArr;

@property (nonatomic, strong) UIButton *quitBtn;

@end

@implementation LPMineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _imgArr = @[@"loanProgress",@"myLoan",@"customServer",@"bankcard_check",@"helpCenter"];
    _titleArr = @[@"贷款进度",@"我的贷款",@"客服",@"银行卡管理",@"帮助中心"];
    
    [self setBotBtn];
    
    [self tableView];
}

- (void)setBotBtn{
    
    _quitBtn = [UIButton new];
    [_quitBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [_quitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _quitBtn.layer.cornerRadius = 6;
    _quitBtn.layer.borderWidth = 1;
    _quitBtn.layer.borderColor = ZCXColor(238, 147, 55).CGColor;
    [_quitBtn setBackgroundColor:ZCXColor(238, 147, 55)];
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
    
    //弹出 登录界面
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"LoginVC" bundle:[NSBundle mainBundle]];
    LoginVC *vc = [sb instantiateViewControllerWithIdentifier:
                   @"LoginVC"];
    [self.navigationController presentViewController:vc animated:YES completion:nil];
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
    [cell.headImg setImage:[UIImage imageNamed:_imgArr[indexPath.row]]];
    cell.titleLb.text = _titleArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0){
        LoanProgressVC *vc = [LoanProgressVC new];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 1){
        NSLog(@"111");
    }else if (indexPath.row == 2){
        NSLog(@"222");
    }else if (indexPath.row == 3){
        
    }else if (indexPath.row == 4){
        
    }else {
        NSLog(@"关于我们");
    }

}

#pragma mark - 设置高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 220;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MineHeadView *view = [MineHeadView viewWithTableView:tableView];
    return view;
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
        //注册headView
    
        //注册cell
//        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LPCertificationCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"LPCertificationCell"];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

//
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}


@end
