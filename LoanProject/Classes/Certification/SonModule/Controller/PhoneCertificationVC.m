//
//  PhoneCertificationVC.m
//  LoanProject
//
//  Created by 张晨曦 on 2018/12/10.
//  Copyright © 2018年 张晨曦. All rights reserved.
//

#import "PhoneCertificationVC.h"
#import "SubmitSuccessVC.h"
#import "PhoneCheckCell.h"
#import "CarrierProtocolVC.h"

@interface PhoneCertificationVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;

//控件
@property (nonatomic, strong) UIButton *submitBtn;
@property (nonatomic, strong) UIButton *safeProtectBtn;

//footview所含控件
@property (nonatomic, strong) UIButton *chooseBtn;
@property (nonatomic, strong) UILabel *protocolLabel;

//自定义 电话,银行卡 的inputAccessoryView
@property (nonatomic, strong) UIToolbar *customAccessoryView;

//弱引用4个cell
@property (nonatomic, weak) PhoneCheckCell *weak_phoneCell;
@property (nonatomic, weak) PhoneCheckCell *weak_serverPwdCell;
@property (nonatomic, weak) PhoneCheckCell *weak_idCardCell;
@property (nonatomic, weak) PhoneCheckCell *weak_nameCell;

//验证码
@property (nonatomic, copy) NSString *verifyCode;
//placeholder文字和图片
@property (nonatomic, strong) NSArray *imgArr;
@property (nonatomic, strong) NSArray *titleArr;
//是否同意协议
@property (nonatomic, assign) BOOL isAgreeProtocol;

@end

@implementation PhoneCertificationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"手机认证";
    self.view.backgroundColor = ZCXColor(240, 240, 240);
    
    //默认为同意
    self.isAgreeProtocol = true;
    
    self.imgArr = @[@"telephone",@"lock",@"idCard",@"person"];
    self.titleArr = @[@"请输入手机号码",@"请输入服务密码",@"本人身份证号码",@"姓名"];

    [self setBotBtn];
    
    [self tableView];
}

- (void)setBotBtn{

    //确认按钮
    _submitBtn = [UIButton createYellowBgBtn:@"下一步"];
    [_submitBtn setBackgroundImage:[UIImage imageNamed:@"blueRect"] forState:UIControlStateNormal];
    _submitBtn.zcx_acceptEventInterval = 3;
    [_submitBtn addTarget:self action:@selector(submitClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_submitBtn];
    [_submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(380);
        make.left.equalTo(self.view).with.offset(15);
        make.height.equalTo(@kBtnHeight);
    }];
    
    //信息安全保护按钮
    _safeProtectBtn = [UIButton new];
    _safeProtectBtn.userInteractionEnabled = false;
    [_safeProtectBtn setImage:[UIImage imageNamed:@"safeProtect"] forState:UIControlStateNormal];
    [_safeProtectBtn setTitle:@"  信息安全保护中.." forState:UIControlStateNormal];
    _safeProtectBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_safeProtectBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    [self.view addSubview:_safeProtectBtn];
    [_safeProtectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(-25);
    }];
}


- (void)submitClick:(UIButton *)btn{

    if ([_weak_phoneCell.inputTF.text isEqualToString:@""] || [_weak_serverPwdCell.inputTF.text isEqualToString:@""] || [_weak_idCardCell.inputTF.text isEqualToString:@""] || [_weak_nameCell.inputTF.text isEqualToString:@""]){
        
        [SVProgressHUD showErrorWithStatus:@"请先填写完信息！"];
        return;
    }
    
    if (![_weak_phoneCell.inputTF.text isEqualToString:[ZcxUserDefauts objectForKey:@"phone"]]){
        [SVProgressHUD showErrorWithStatus:@"手机号码需与登录手机号匹配！"];
        return;
    }
    
    if (self.isAgreeProtocol == false){
        [SVProgressHUD showErrorWithStatus:@"请先阅读并同意协议！"];
        return;
    }
    
    //发送通讯录给后台
    [[LCHTTPSessionManager sharedInstance] POST:[kUrlReqHead stringByAppendingPathComponent:@"/UploadDic.aspx"] parameters:self.addressBookDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"通讯录---%@",responseObject);
        
        NSString *stateCode = [NSString stringWithFormat:@"%@",responseObject[@"state"]];
        if ([stateCode isEqualToString:@"200"]){
            
            [SVProgressHUD showProgress:-1 status:@"提交中..."];

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

                [SVProgressHUD dismiss];
                
                SubmitSuccessVC *vc = [[UIStoryboard storyboardWithName:@"SubmitSuccessVC" bundle:nil] instantiateViewControllerWithIdentifier:@"SubmitSuccessVC"];
                [self.navigationController pushViewController:vc animated:YES];
                
            });
            
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
    return 4;
}

#pragma mark - tableView DataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PhoneCheckCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PhoneCheckCell" forIndexPath:indexPath];
    [cell.iconView setImage:[UIImage imageNamed:_imgArr[indexPath.row]]];
    cell.inputTF.placeholder = _titleArr[indexPath.row];
    
    if (indexPath.row == 0){
        _weak_phoneCell = cell;
        cell.iconW.constant = 13;
        cell.iconH.constant = 20;
        cell.inputTF.inputAccessoryView = self.customAccessoryView;
        cell.inputTF.keyboardType = UIKeyboardTypePhonePad;
    }
    if (indexPath.row == 1){
        _weak_serverPwdCell = cell;
        cell.iconW.constant = 16;
        cell.iconH.constant = 18;
        cell.inputTF.inputAccessoryView = self.customAccessoryView;
        cell.inputTF.keyboardType = UIKeyboardTypeNumberPad;
    }
    if (indexPath.row == 2){
        _weak_idCardCell = cell;
        cell.iconW.constant = 19;
        cell.iconH.constant = 14;
        cell.inputTF.keyboardType = UIKeyboardTypeDefault;
        cell.inputTF.returnKeyType = UIReturnKeyDone;
        cell.inputTF.delegate = self;
    }
    if (indexPath.row == 3){
        _weak_nameCell = cell;
        cell.iconW.constant = 19;
        cell.iconH.constant = 19;
        cell.inputTF.keyboardType = UIKeyboardTypeDefault;
        cell.inputTF.returnKeyType = UIReturnKeyDone;
        cell.inputTF.delegate = self;
    }
    
    return cell;
}

#pragma mark - 设置高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 80)];
    UIButton *btn = [UIButton new];
    btn.userInteractionEnabled = false;
    [btn setImage:[UIImage imageNamed:@"safeIcon"] forState:UIControlStateNormal];
    [btn setTitle:@"  GlobalSign 国际安全认证" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    [bgView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(bgView);
    }];
    
    return  bgView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    tableView.tableFooterView = bgView;
    
    //同意协议 按钮
    _chooseBtn = [UIButton new];
    [_chooseBtn setImage:[UIImage imageNamed:@"bluePick"] forState:UIControlStateNormal];
    [_chooseBtn addTarget:self action:@selector(chooseEvents:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:_chooseBtn];
    [_chooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bgView.mas_centerY);
        make.left.equalTo(bgView).with.offset(12);
        make.width.height.equalTo(@30);
    }];
    
    //协议
    _protocolLabel = [UILabel new];
    _protocolLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickProtocol)];
    [_protocolLabel addGestureRecognizer:ges];
    
    //富文本
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:@"同意《认证服务协议》"];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, 2)];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:ZCXColor(35, 131, 255) range:NSMakeRange(2, attributedStr.length - 2)];
    _protocolLabel .attributedText = attributedStr;
    
    [bgView addSubview:_protocolLabel];
    [_protocolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.chooseBtn);
        make.left.equalTo(self.chooseBtn.mas_right).with.offset(5);
    }];

    return bgView;
}

- (void)clickProtocol{
    CarrierProtocolVC *vc = [CarrierProtocolVC new];
    [self.navigationController pushViewController:vc animated:true];
}

- (void)chooseEvents:(UIButton *)btn{
    
    if (btn.isSelected == NO){
        btn.selected = !btn.selected;
        [btn setImage:[UIImage imageNamed:@"grayPick"] forState:UIControlStateNormal];
        self.isAgreeProtocol = false;
        
    }else{
        btn.selected = !btn.selected;
        [btn setImage:[UIImage imageNamed:@"bluePick"] forState:UIControlStateNormal];
        self.isAgreeProtocol = true;
    }
    
}

#pragma mark - 懒加载tableView
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 350) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.rowHeight = ZCXRowHeight;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //注册cell
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([PhoneCheckCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PhoneCheckCell"];
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

//实现UITextField代理方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];//取消第一响应者
    return YES;
}

@end
