//
//  LPCertificationVC.m
//  LoanProject
//
//  Created by 张晨曦 on 2018/11/28.
//  Copyright © 2018年 张晨曦. All rights reserved.
//

#import "LPCertificationVC.h"
#import "LPCertificationCell.h"
#import "LoginVC.h"

@interface LPCertificationVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *titleArr;

@property (nonatomic, strong) UIButton *submitBtn;

@end

@implementation LPCertificationVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    _titleArr = @[@"身份认证",@"运营商认证",@"支付宝认证",@"银行卡认证"];
    
    [self setBotBtn];
    
    [self tableView];
}

- (void)setBotBtn{
    
    _submitBtn = [UIButton new];
    [_submitBtn setTitle:@"提交贷款申请" forState:UIControlStateNormal];
    [_submitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _submitBtn.layer.cornerRadius = 6;
    _submitBtn.layer.borderWidth = 1;
    _submitBtn.layer.borderColor = [UIColor blackColor].CGColor;
    _submitBtn.layer.masksToBounds = YES;
    
    [_submitBtn addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_submitBtn];
    [_submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(-80);
        make.left.equalTo(self.view).with.offset(20);
        make.height.equalTo(@50);
    }];
}

- (void)submitClick{
    NSLog(@"提交贷款申请");
    
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
    cell.titleLb.text = _titleArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0){
        
    }else if (indexPath.row == 1){
        
    }else if (indexPath.row == 2){
        
    }else{
        
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
//        _tableView registerClass:<#(nullable Class)#> forCellReuseIdentifier:<#(nonnull NSString *)#>
//        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LPCertificationCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"LPCertificationCell"];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}


@end
