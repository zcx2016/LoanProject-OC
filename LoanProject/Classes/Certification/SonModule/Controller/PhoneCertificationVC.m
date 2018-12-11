//
//  PhoneCertificationVC.m
//  LoanProject
//
//  Created by 张晨曦 on 2018/12/10.
//  Copyright © 2018年 张晨曦. All rights reserved.
//

#import "PhoneCertificationVC.h"
#import "CarrierCell.h"

@interface PhoneCertificationVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *chooseBtn;
@property (nonatomic, strong) UILabel *protocolLabel;
@property (nonatomic, strong) UIButton *submitBtn;

//自定义 电话,银行卡 的inputAccessoryView
@property (nonatomic, strong) UIToolbar *customAccessoryView;

//弱引用3个cell
@property (nonatomic, weak) CarrierCell *weak_phoneCell;
@property (nonatomic, weak) CarrierCell *weak_serverPwdCell;
@property (nonatomic, weak) CarrierCell *weak_verifyCodeCell;

@end

@implementation PhoneCertificationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"手机认证";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setBotBtn];
    
    [self tableView];
}

- (void)setBotBtn{
    
    //同意协议 按钮
    _chooseBtn = [UIButton new];
    [_chooseBtn setImage:[UIImage imageNamed:@"choose_yes"] forState:UIControlStateNormal];
    [_chooseBtn addTarget:self action:@selector(chooseEvents:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_chooseBtn];
    [_chooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(200);
        make.left.equalTo(self.view).with.offset(15);
        make.width.height.equalTo(@30);
    }];
    
    //协议
    _protocolLabel = [UILabel new];
    _protocolLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickProtocol)];
    [_protocolLabel addGestureRecognizer:ges];
    
    //富文本
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:@"同意《用户使用协议》"];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, 2)];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(2, attributedStr.length - 2)];
    _protocolLabel .attributedText = attributedStr;
    
    [self.view addSubview:_protocolLabel];
    [_protocolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.chooseBtn);
        make.left.equalTo(self.chooseBtn.mas_right).with.offset(5);
    }];

    
    //确认按钮
    _submitBtn = [UIButton createYellowBgBtn:@"确认"];
    [_submitBtn addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_submitBtn];
    [_submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(250);
        make.left.equalTo(self.view).with.offset(15);
        make.height.equalTo(@50);
    }];
}

- (void)clickProtocol{
    NSLog(@"点击协议");
}

- (void)chooseEvents:(UIButton *)btn{
    if (btn.isSelected == NO){
        btn.selected = !btn.selected;
        [btn setImage:[UIImage imageNamed:@"choose_no"] forState:UIControlStateNormal];
        NSLog(@"不同意协议");
    }else{
        btn.selected = !btn.selected;
        [btn setImage:[UIImage imageNamed:@"choose_yes"] forState:UIControlStateNormal];
        NSLog(@"同意协议");
    }
    
}

- (void)submitClick{
    NSLog(@"手机信息-- %@,%@,%@",_weak_phoneCell.inputTF.text,_weak_serverPwdCell.inputTF.text,_weak_verifyCodeCell.inputTF.text);
    
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
    CarrierCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CarrierCell" forIndexPath:indexPath];
    cell.inputTF.inputAccessoryView = self.customAccessoryView;
    cell.inputTF.keyboardType = UIKeyboardTypeNumberPad;
    if (indexPath.row == 0){
        _weak_phoneCell = cell;
        cell.inputTF.placeholder = @"请输入手机号码";
    }
    if (indexPath.row == 1){
        _weak_serverPwdCell = cell;
        cell.inputTF.placeholder = @"请输入服务密码";
    }
    if (indexPath.row == 2){
        _weak_verifyCodeCell = cell;
        [cell.codeBtn setHidden:NO];
        cell.inputTF.placeholder = @"请输入验证码";
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 180) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.rowHeight = ZCXRowHeight;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //注册cell
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CarrierCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CarrierCell"];
        [self.view addSubview:_tableView];
    }
    return _tableView;
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
    [self.weak_phoneCell.inputTF resignFirstResponder];
    [self.weak_serverPwdCell.inputTF resignFirstResponder];
    [self.weak_verifyCodeCell.inputTF resignFirstResponder];
}

@end
