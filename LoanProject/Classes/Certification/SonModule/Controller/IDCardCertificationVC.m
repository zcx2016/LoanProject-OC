//
//  IDCardCertificationVC.m
//  LoanProject
//
//  Created by 张晨曦 on 2018/12/10.
//  Copyright © 2018年 张晨曦. All rights reserved.
//

#import "IDCardCertificationVC.h"
#import "IDCardCell.h"

@interface IDCardCertificationVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *submitBtn;

//弱引用3个cell
@property (nonatomic, weak) IDCardCell *weak_firstCell;
@property (nonatomic, weak) IDCardCell *weak_secCell;
@property (nonatomic, weak) IDCardCell *weak_thirdCell;

@end

@implementation IDCardCertificationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"身份证认证";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self tableView];
    
    [self setBotBtn];
}

- (void)setBotBtn{
    //确认按钮
    _submitBtn = [UIButton createYellowBgBtn:@"提交"];
    [_submitBtn addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_submitBtn];
    [_submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(-20);
        make.left.equalTo(self.view).with.offset(15);
        make.height.equalTo(@50);
    }];
}

- (void)submitClick{
    NSLog(@"2222");
}

#pragma mark - tableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

#pragma mark - tableView DataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    IDCardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IDCardCell" forIndexPath:indexPath];
    if (indexPath.row == 0){
        [cell.imgView setImage:[UIImage imageNamed:@"shenfen1"]];
    }else if (indexPath.row == 1){
        [cell.imgView setImage:[UIImage imageNamed:@"shenfen2"]];
    }else{
        [cell.imgView setImage:[UIImage imageNamed:@"shenfen3"]];
    }
    return cell;
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 -80) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.rowHeight = 180;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //注册cell
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([IDCardCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"IDCardCell"];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

@end
