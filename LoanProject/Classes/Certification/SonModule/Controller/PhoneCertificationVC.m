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

//验证码
@property (nonatomic, copy) NSString *verifyCode;

//是否同意协议
//@property (nonatomic, assign) BOOL isAgreeProtocol;

@end

@implementation PhoneCertificationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"手机认证";
    self.view.backgroundColor = [UIColor whiteColor];
    
    //默认为同意
//    self.isAgreeProtocol = true;
    
    [self setBotBtn];
    
    [self tableView];
}

- (void)setBotBtn{
    
//    //同意协议 按钮
//    _chooseBtn = [UIButton new];
//    [_chooseBtn setImage:[UIImage imageNamed:@"choose_yes"] forState:UIControlStateNormal];
//    [_chooseBtn addTarget:self action:@selector(chooseEvents:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_chooseBtn];
//    [_chooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view).with.offset(200);
//        make.left.equalTo(self.view).with.offset(15);
//        make.width.height.equalTo(@30);
//    }];
//
//    //协议
//    _protocolLabel = [UILabel new];
//    _protocolLabel.userInteractionEnabled = YES;
//    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickProtocol)];
//    [_protocolLabel addGestureRecognizer:ges];
//
//    //富文本
//    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:@"同意《用户使用协议》"];
//    [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, 2)];
//    [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(2, attributedStr.length - 2)];
//    _protocolLabel .attributedText = attributedStr;
//
//    [self.view addSubview:_protocolLabel];
//    [_protocolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.chooseBtn);
//        make.left.equalTo(self.chooseBtn.mas_right).with.offset(5);
//    }];
//
//
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

//- (void)clickProtocol{
//    NSLog(@"点击协议");
//}

//- (void)chooseEvents:(UIButton *)btn{
//    if (btn.isSelected == NO){
//        btn.selected = !btn.selected;
//        [btn setImage:[UIImage imageNamed:@"choose_no"] forState:UIControlStateNormal];
//        self.isAgreeProtocol = false;
//    }else{
//        btn.selected = !btn.selected;
//        [btn setImage:[UIImage imageNamed:@"choose_yes"] forState:UIControlStateNormal];
//        self.isAgreeProtocol = true;
//    }
//}

- (void)submitClick{
    NSLog(@"手机信息-- %@,%@,%@",_weak_phoneCell.inputTF.text,_weak_serverPwdCell.inputTF.text,_weak_verifyCodeCell.inputTF.text);
//
//    if (self.isAgreeProtocol == false){
//        [SVProgressHUD showErrorWithStatus:@"请先同意《容易借贷款协议》!"];
//        return;
//    }
    
    if ([_weak_phoneCell.inputTF.text isEqualToString:@""] || [_weak_serverPwdCell.inputTF.text isEqualToString:@""] || [_weak_verifyCodeCell.inputTF.text isEqualToString:@""]){
        
        [SVProgressHUD showErrorWithStatus:@"请先填写完信息！"];
        return;
    }
    
    if (![_weak_verifyCodeCell.inputTF.text isEqualToString:self.verifyCode]){
        [SVProgressHUD showErrorWithStatus:@"验证码输入错误！"];
        return;
    }
    
    //发送通讯录给后台
    [[LCHTTPSessionManager sharedInstance] POST:[kUrlReqHead stringByAppendingPathComponent:@"/UploadDic.aspx"] parameters:self.addressBookDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"通讯录---%@",responseObject);
        
        NSString *stateCode = [NSString stringWithFormat:@"%@",responseObject[@"state"]];
        if ([stateCode isEqualToString:@"200"]){
            [SVProgressHUD showSuccessWithStatus:@"提交成功!"];
            [self.navigationController popToRootViewControllerAnimated:YES];
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
        [cell.codeBtn addTarget:self action:@selector(sendVerifyCode) forControlEvents:UIControlEventTouchUpInside];
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

#pragma mark - 发送验证码
- (void)sendVerifyCode{
    
    if ([self.weak_phoneCell.inputTF.text isEqualToString:@""] || [self.weak_serverPwdCell.inputTF.text isEqualToString:@""]){
        [SVProgressHUD showErrorWithStatus:@"手机号和服务密码不能为空！"];
        return;
    }

//    NSString *key = [ZcxUserDefauts objectForKey:@"key"];
    NSDictionary *dict = @{@"phone" : self.weak_phoneCell.inputTF.text, @"key":kLpKey};
    
    [[LCHTTPSessionManager sharedInstance] POST:[kUrlReqHead stringByAppendingString:@"/API.asmx/SendSMS"] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"发送验证码-----%@",responseObject);
        NSString *stateCode = [NSString stringWithFormat:@"%@",responseObject[@"state"]];
        if ([stateCode isEqualToString:@"0"]){
            // 开启倒计时效果
            [self showCountDown];
            //保存验证码
            self.verifyCode = responseObject[@"key"];
        }else{
            [SVProgressHUD showErrorWithStatus:@"获取验证码失败！"];
            return;
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"发送验证码错误-----%@",error);
    }];
}

// 开启倒计时效果
- (void)showCountDown{
    __block NSInteger time = 59; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮的样式
                [self.weak_verifyCodeCell.codeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
                [self.weak_verifyCodeCell.codeBtn setTitleColor:ZCXColor(253, 141, 38) forState:UIControlStateNormal];
                self.weak_verifyCodeCell.codeBtn.layer.borderColor = ZCXColor(253, 141, 38).CGColor;
                self.weak_verifyCodeCell.codeBtn.userInteractionEnabled = YES;
            });
            
        }else{ //倒计时开始
            
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮显示读秒效果
                [self.weak_verifyCodeCell.codeBtn setTitle:[NSString stringWithFormat:@"%ds后重发", seconds] forState:UIControlStateNormal];
                [self.weak_verifyCodeCell.codeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                self.weak_verifyCodeCell.codeBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
                self.weak_verifyCodeCell.codeBtn.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}

@end
