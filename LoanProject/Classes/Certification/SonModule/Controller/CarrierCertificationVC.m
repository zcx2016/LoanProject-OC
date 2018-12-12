//
//  CarrierCertificationVC.m
//  LoanProject
//
//  Created by 张晨曦 on 2018/12/10.
//  Copyright © 2018年 张晨曦. All rights reserved.
//

#import "CarrierCertificationVC.h"
#import "CarrierCell.h"
#import "EmergencyContactHeadView.h"

#import "PhoneCertificationVC.h"
#import "GetAddressBookPopView.h"

@interface CarrierCertificationVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *submitBtn;

//自定义 电话的inputAccessoryView
@property (nonatomic, strong) UIToolbar *customAccessoryView;

//弱引用9个cell
@property (nonatomic, weak) CarrierCell *weak_firstPhoneCell;
@property (nonatomic, weak) CarrierCell *weak_firstNameCell;
@property (nonatomic, weak) CarrierCell *weak_firstContactCell;

@property (nonatomic, weak) CarrierCell *weak_secPhoneCell;
@property (nonatomic, weak) CarrierCell *weak_secNameCell;
@property (nonatomic, weak) CarrierCell *weak_secContactCell;

@property (nonatomic, weak) CarrierCell *weak_thirdPhoneCell;
@property (nonatomic, weak) CarrierCell *weak_thirdNameCell;
@property (nonatomic, weak) CarrierCell *weak_thirdContactCell;

@end

@implementation CarrierCertificationVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navigationItem.title = @"紧急联系人";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self tableView];
    
    [self setBotBtn];
    
    //弹出 获取通讯录view
    GetAddressBookPopView *addressBookPopView = [[NSBundle mainBundle] loadNibNamed:@"GetAddressBookPopView" owner:nil options:nil].firstObject;
    addressBookPopView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [UIApplication.sharedApplication.keyWindow addSubview:addressBookPopView];
}

- (void)setBotBtn{
    //确认按钮
    _submitBtn = [UIButton createYellowBgBtn:@"确认"];
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
    NSLog(@"紧急联系人信息-- %@,%@,%@ /n %@,%@,%@ /n %@,%@,%@",_weak_firstNameCell.inputTF.text,_weak_firstContactCell.inputTF.text,_weak_firstPhoneCell.inputTF.text, _weak_secNameCell.inputTF.text, _weak_secContactCell.inputTF.text, _weak_secPhoneCell.inputTF.text, _weak_thirdNameCell.inputTF.text, _weak_thirdContactCell.inputTF.text , _weak_thirdPhoneCell.inputTF.text);
    
    PhoneCertificationVC *vc = [PhoneCertificationVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - tableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

#pragma mark - tableView DataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CarrierCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CarrierCell" forIndexPath:indexPath];
    if (indexPath.row == 0){
        cell.inputTF.placeholder = @"姓名";
        cell.inputTF.keyboardType = UIKeyboardTypeDefault;
        cell.inputTF.returnKeyType = UIReturnKeyDone;
        cell.inputTF.delegate = self;
    }
    if (indexPath.row == 1){
        cell.inputTF.placeholder = @"关系";
        cell.inputTF.keyboardType = UIKeyboardTypeDefault;
        cell.inputTF.returnKeyType = UIReturnKeyDone;
        cell.inputTF.delegate = self;
    }
    if (indexPath.row == 2){
        cell.inputTF.inputAccessoryView = self.customAccessoryView;
        cell.inputTF.keyboardType = UIKeyboardTypePhonePad;
        cell.inputTF.placeholder = @"电话号码";
    }
    
    if (indexPath.section == 0){
        if (indexPath.row == 0){
            _weak_firstNameCell = cell;
        }else if (indexPath.row == 1){
            _weak_firstContactCell = cell;
        }else{
            _weak_firstPhoneCell = cell;
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0){
            _weak_secNameCell = cell;
        }else if (indexPath.row == 1){
            _weak_secContactCell = cell;
        }else{
            _weak_secPhoneCell = cell;
        }
    }else{
        if (indexPath.row == 0){
            _weak_thirdNameCell = cell;
        }else if (indexPath.row == 1){
            _weak_thirdContactCell = cell;
        }else{
            _weak_thirdPhoneCell = cell;
        }
    }
    
    return cell;
}

#pragma mark - 设置高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    EmergencyContactHeadView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"EmergencyContactHeadView"];
    if (section == 0){
        view.titleLabel.text = @"紧急联系人1";
    }else if (section == 1){
        view.titleLabel.text = @"紧急联系人2";
    }else{
        view.titleLabel.text = @"紧急联系人3";
    }
    return view;
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
        _tableView.rowHeight = ZCXRowHeight;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //注册headView
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([EmergencyContactHeadView class]) bundle:[NSBundle mainBundle]] forHeaderFooterViewReuseIdentifier:@"EmergencyContactHeadView"];
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
    [self.weak_firstPhoneCell.inputTF resignFirstResponder];
    [self.weak_secPhoneCell.inputTF resignFirstResponder];
    [self.weak_thirdPhoneCell.inputTF resignFirstResponder];
}

@end
