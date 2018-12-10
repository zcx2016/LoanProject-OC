//
//  AlipayCertificationVC.m
//  LoanProject
//
//  Created by 张晨曦 on 2018/12/10.
//  Copyright © 2018年 张晨曦. All rights reserved.
//

#import "AlipayCertificationVC.h"
#import "CarrierCell.h"

@interface AlipayCertificationVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *submitBtn;

//自定义 电话的inputAccessoryView
@property (nonatomic, strong) UIToolbar *customAccessoryView;

//弱引用9个cell
@property (nonatomic, weak) CarrierCell *weak_numCell;
@property (nonatomic, weak) CarrierCell *weak_pwdCell;

@end

@implementation AlipayCertificationVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navigationItem.title = @"支付宝认证";
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
    NSLog(@"支付宝认证-- %@,%@",_weak_numCell.inputTF.text,_weak_pwdCell.inputTF.text);
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
    CarrierCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CarrierCell" forIndexPath:indexPath];
    if (indexPath.row == 0){
        cell.inputTF.placeholder = @"支付宝账号";
        cell.inputTF.keyboardType = UIKeyboardTypeNamePhonePad;
        cell.inputTF.returnKeyType = UIReturnKeyDone;
        cell.inputTF.delegate = self;
        _weak_numCell = cell;
    }
    if (indexPath.row == 1){
        cell.inputTF.placeholder = @"支付宝密码";
        cell.inputTF.inputAccessoryView = self.customAccessoryView;
        cell.inputTF.keyboardType = UIKeyboardTypeNumberPad;
        _weak_pwdCell = cell;
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
        _tableView.rowHeight = 60;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //注册cell
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CarrierCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CarrierCell"];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

//实现UITextField代理方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];//取消第一响应者
    return YES;
}

//自定义 电话 和 qq 的inputAccessoryView
- (UIToolbar *)customAccessoryView{
    if (!_customAccessoryView) {
        _customAccessoryView = [[UIToolbar alloc]initWithFrame:(CGRect){0,0,kScreenWidth,45}];
        _customAccessoryView.barTintColor = [UIColor lightGrayColor];
        UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *done = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
        [_customAccessoryView setItems:@[space,done]];
    }
    return _customAccessoryView;
}

- (void)done{
    [self.weak_pwdCell.inputTF resignFirstResponder];
}




@end
