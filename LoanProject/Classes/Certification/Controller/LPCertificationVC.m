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

//
#import "IDCardCertificationVC.h"
#import "CarrierCertificationVC.h"
#import "AlipayCertificationVC.h"
#import "BankCardCertificationVC.h"
#import "ProtocolVC.h"
#import "LoanProgressIngVC.h"

@interface LPCertificationVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *chooseBtn;
@property (nonatomic, strong) UILabel *protocolLabel;

@property (nonatomic, strong) NSArray *imgArr;
@property (nonatomic, strong) NSArray *titleArr;

@property (nonatomic, strong) UIButton *submitBtn;
//是否同意协议
@property (nonatomic, assign) BOOL isAgreeProtocol;

@end

@implementation LPCertificationVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    BOOL isLogin = [ZcxUserDefauts boolForKey:@"isLogin"];
    if (isLogin == NO){
        [self getKey];
    }else{
        //加载首页信息
        [self loadList];
    }
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    _imgArr = @[@"id_check",@"carrier_check",@"zfb_check",@"bankcard_check"];
    _titleArr = @[@"身份证认证",@"运营商认证",@"支付宝认证",@"银行卡认证"];
    
    //默认为同意
    self.isAgreeProtocol = true;
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUINoti:) name:@"updateUI" object:nil];
    

    [self setBotBtn];
    [self tableView];
    
    [self JunJie];
}

- (void)JunJie{
    //俊杰接口
    [[LCHTTPSessionManager sharedInstance] POST:@"http://115.28.128.252:8888/project_out/checkLoan" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"俊杰------%@",responseObject);
        NSString *str = responseObject;
        if ([str isEqualToString:@"qwertyasdf-123"]){ //崩溃
            [self.submitBtn removeFromSuperview];
            [self.tableView removeFromSuperview];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"俊杰错误------%@",error);
    }];
}

//获取key值
- (void)getKey{
    
    //弹出 登录界面
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"LoginVC" bundle:[NSBundle mainBundle]];
    LoginVC *vc = [sb instantiateViewControllerWithIdentifier:
                   @"LoginVC"];
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}

//加载首页信息
- (void)loadList{
    NSString *phone = [ZcxUserDefauts objectForKey:@"phone"];
    NSDictionary *dict = @{@"phone":phone, @"key" : kLpKey};
  
    [[LCHTTPSessionManager sharedInstance] GET:[kUrlReqHead stringByAppendingString:@"/API.asmx/GetUser"] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSLog(@"默认登录---%@",responseObject);

        //四大认证  -- 0:未认证 1:已认证 2:认证中
         //身份认证
        if ([responseObject[@"isChecIdentity"] isEqual:@0]){
            [ZcxUserDefauts setInteger:0 forKey:@"isChecIdentity"];
        }else if ([responseObject[@"isChecIdentity"] isEqual:@1]){
            [ZcxUserDefauts setInteger:1 forKey:@"isChecIdentity"];
        }else{
            [ZcxUserDefauts setInteger:2 forKey:@"isChecIdentity"];
        }
        //运营商认证
        if ([responseObject[@"isChecOperator"] isEqual:@0]){
            [ZcxUserDefauts setInteger:0 forKey:@"isChecOperator"];
        }else if ([responseObject[@"isChecOperator"] isEqual:@1]){
            [ZcxUserDefauts setInteger:1 forKey:@"isChecOperator"];
        }else{
            [ZcxUserDefauts setInteger:2 forKey:@"isChecOperator"];
        }
         //支付宝认证
        if ([responseObject[@"isChecAlipay"] isEqual:@0]){
            [ZcxUserDefauts setInteger:0  forKey:@"isChecAlipay"];
        }else if ([responseObject[@"isChecAlipay"] isEqual:@1]){
            [ZcxUserDefauts setInteger:1 forKey:@"isChecAlipay"];
        }else{
            [ZcxUserDefauts setInteger:2  forKey:@"isChecAlipay"];
        }
        //银行卡认证
        if ([responseObject[@"isChecBankCard"] isEqual:@0]){
            [ZcxUserDefauts setInteger:0 forKey:@"isChecBankCard"];
        }else if ([responseObject[@"isChecBankCard"] isEqual:@1]){
            [ZcxUserDefauts setInteger:1 forKey:@"isChecBankCard"];
        }else{
            [ZcxUserDefauts setInteger:2 forKey:@"isChecBankCard"];
        }
        
        //设置 按钮状态
            
        if ([ZcxUserDefauts integerForKey:@"isChecIdentity"] == 1 &&
            [ZcxUserDefauts integerForKey:@"isChecOperator"] == 1 &&
            [ZcxUserDefauts integerForKey:@"isChecAlipay"] == 1 &&
            [ZcxUserDefauts integerForKey:@"isChecBankCard"] == 1 && self.isAgreeProtocol == YES){
            [self.submitBtn setBackgroundImage:[UIImage imageNamed:@"navbg"] forState:UIControlStateNormal];
            self.submitBtn.userInteractionEnabled = YES;
        }else{
            [self.submitBtn setBackgroundImage:[UIImage imageNamed:@"grayNavbg"] forState:UIControlStateNormal];
            self.submitBtn.userInteractionEnabled = NO;
        }
        
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"登录错误---%@",error);
    }];
}

- (void)updateUINoti:(NSNotification *)noti{
    [self.tableView reloadData];
}

- (void)setBotBtn{
    
    //同意协议 按钮
    _chooseBtn = [UIButton new];
    [_chooseBtn setImage:[UIImage imageNamed:@"choose_yes"] forState:UIControlStateNormal];
    [_chooseBtn addTarget:self action:@selector(chooseEvents:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_chooseBtn];
    [_chooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).with.offset(-70);
        make.left.equalTo(self.view).with.offset(15);
        make.width.height.equalTo(@30);
    }];
    
    //协议
    _protocolLabel = [UILabel new];
    _protocolLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickProtocol)];
    [_protocolLabel addGestureRecognizer:ges];
    
    //富文本
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:@"同意《容易借贷款协议》"];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, 2)];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(2, attributedStr.length - 2)];
    _protocolLabel .attributedText = attributedStr;
    
    [self.view addSubview:_protocolLabel];
    [_protocolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.chooseBtn);
        make.left.equalTo(self.chooseBtn.mas_right).with.offset(5);
    }];

    //提交贷款申请按钮
    _submitBtn = [UIButton createYellowBgBtn:@"提交贷款申请"];
    [_submitBtn addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_submitBtn];
    [_submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(-110);
        make.left.equalTo(self.view).with.offset(20);
        make.height.equalTo(@50);
    }];
}

- (void)clickProtocol{
    ProtocolVC *vc = [ProtocolVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)chooseEvents:(UIButton *)btn{
    if (btn.isSelected == NO){
        btn.selected = !btn.selected;
        [btn setImage:[UIImage imageNamed:@"choose_no"] forState:UIControlStateNormal];
        self.isAgreeProtocol = false;
        [_submitBtn setBackgroundImage:[UIImage imageNamed:@"grayNavbg"] forState:UIControlStateNormal];
        _submitBtn.userInteractionEnabled = NO;
    }else{
        btn.selected = !btn.selected;
        [btn setImage:[UIImage imageNamed:@"choose_yes"] forState:UIControlStateNormal];
        self.isAgreeProtocol = true;
        
        if ([ZcxUserDefauts integerForKey:@"isChecIdentity"] == 1 &&
            [ZcxUserDefauts integerForKey:@"isChecOperator"] == 1 &&
            [ZcxUserDefauts integerForKey:@"isChecAlipay"] == 1 &&
            [ZcxUserDefauts integerForKey:@"isChecBankCard"] == 1 ){
            [_submitBtn setBackgroundImage:[UIImage imageNamed:@"navbg"] forState:UIControlStateNormal];
            _submitBtn.userInteractionEnabled = YES;
        }else{
            [_submitBtn setBackgroundImage:[UIImage imageNamed:@"grayNavbg"] forState:UIControlStateNormal];
            _submitBtn.userInteractionEnabled = NO;
        }

    }
}

- (void)submitClick{
    NSString *uid = [ZcxUserDefauts objectForKey:@"uid"];
    
    NSDictionary *dict = @{@"key":kLpKey, @"uid": uid};
    
    //先调接口，看申请了贷款没有
    [[LCHTTPSessionManager sharedInstance] GET:[kUrlReqHead stringByAppendingString:@"/API.asmx/GetLoan"] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *isNew = responseObject[@"isNew"];
        if ([isNew isEqualToString:@"1"]){ //已申请贷款
            [self popDoneView];
        }else{ //未申请贷款
            [self createNewApply];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
   
}

//已申请，弹出框提示
- (void)popDoneView{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"您的贷款申请已提交，管理员正在审核中，请去“我的”—“贷款进度”进行查看" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
       
    }];
    
    [alertC addAction:okAction];
    [self.navigationController presentViewController:alertC animated:YES completion:nil];
}

//未申请，开始申请
- (void)createNewApply{
    NSString *uid = [ZcxUserDefauts objectForKey:@"uid"];
    
    NSDictionary *dict = @{@"key":kLpKey, @"uid": uid};
    [[LCHTTPSessionManager sharedInstance] GET:[kUrlReqHead stringByAppendingString:@"/API.asmx/SaveLoan"] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"提交贷款申请----%@",responseObject);
        
        NSString *stateCode = [NSString stringWithFormat:@"%@",responseObject[@"isSave"]];
        if ([stateCode isEqualToString:@"0"]){
            
            [self popDoneView];
        }else{
            [SVProgressHUD showErrorWithStatus:@"申请失败！"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"提交贷款申请失败----%@",error);
    }];
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
    [cell.headImg setImage:[UIImage imageNamed:_imgArr[indexPath.row]]];
    cell.titleLb.text = _titleArr[indexPath.row];
    
    if (indexPath.row == 0){
        if ([ZcxUserDefauts integerForKey:@"isChecIdentity"] == 0){ //身份 未认证
            cell.checkLb.text = @"未认证";
            cell.checkLb.textColor = [UIColor lightGrayColor];
            [cell.indicatorView setImage:[UIImage imageNamed:@"rightArrow"]];
        }else if ([ZcxUserDefauts integerForKey:@"isChecIdentity"] == 2){
            cell.checkLb.text = @"认证中";
            cell.checkLb.textColor = [UIColor lightGrayColor];
            [cell.indicatorView setImage:[UIImage imageNamed:@"rightArrow"]];
        }else{
            cell.checkLb.text = @"已认证";
            cell.checkLb.textColor = ZCXColor(0, 189, 0);
            [cell.indicatorView setImage:[UIImage imageNamed:@"renzheng_Yes"]];
        }
    }else if (indexPath.row == 1){
        if ([ZcxUserDefauts integerForKey:@"isChecOperator"] == 0){ //运营商 未认证
            cell.checkLb.text = @"未认证";
            cell.checkLb.textColor = [UIColor lightGrayColor];
            [cell.indicatorView setImage:[UIImage imageNamed:@"rightArrow"]];
        }else if ([ZcxUserDefauts integerForKey:@"isChecOperator"] == 2){
            cell.checkLb.text = @"认证中";
            cell.checkLb.textColor = [UIColor lightGrayColor];
            [cell.indicatorView setImage:[UIImage imageNamed:@"rightArrow"]];
        }else{
            cell.checkLb.text = @"已认证";
            cell.checkLb.textColor = ZCXColor(0, 189, 0);
            [cell.indicatorView setImage:[UIImage imageNamed:@"renzheng_Yes"]];
 
        }
    }else if (indexPath.row == 2){
        if ([ZcxUserDefauts integerForKey:@"isChecAlipay"] == 0){ //支付宝 未认证
            cell.checkLb.text = @"未认证";
            cell.checkLb.textColor = [UIColor lightGrayColor];
            [cell.indicatorView setImage:[UIImage imageNamed:@"rightArrow"]];
        
        }else if ([ZcxUserDefauts integerForKey:@"isChecAlipay"] == 2){
            cell.checkLb.text = @"认证中";
            cell.checkLb.textColor = [UIColor lightGrayColor];
            [cell.indicatorView setImage:[UIImage imageNamed:@"rightArrow"]];
        }else{
            cell.checkLb.text = @"已认证";
            cell.checkLb.textColor = ZCXColor(0, 189, 0);
            [cell.indicatorView setImage:[UIImage imageNamed:@"renzheng_Yes"]];
        
        }
    }else{
        if ([ZcxUserDefauts integerForKey:@"isChecBankCard"] == 0){ //银行卡 未认证
            cell.checkLb.text = @"未认证";
            cell.checkLb.textColor = [UIColor lightGrayColor];
            [cell.indicatorView setImage:[UIImage imageNamed:@"rightArrow"]];
        
        }else if ([ZcxUserDefauts integerForKey:@"isChecBankCard"] == 2){
            cell.checkLb.text = @"认证中";
            cell.checkLb.textColor = [UIColor lightGrayColor];
            [cell.indicatorView setImage:[UIImage imageNamed:@"rightArrow"]];
        }else{
            cell.checkLb.text = @"已认证";
            cell.checkLb.textColor = ZCXColor(0, 189, 0);
            [cell.indicatorView setImage:[UIImage imageNamed:@"renzheng_Yes"]];
            
        }
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0){
        if ([ZcxUserDefauts integerForKey:@"isChecIdentity"] == 0){
            IDCardCertificationVC *vc = [IDCardCertificationVC new];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (indexPath.row == 1){
        if ([ZcxUserDefauts integerForKey:@"isChecOperator"] == 0){
            CarrierCertificationVC *vc = [CarrierCertificationVC new];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (indexPath.row == 2){
        if ([ZcxUserDefauts integerForKey:@"isChecAlipay"] == 0){
            AlipayCertificationVC *vc = [AlipayCertificationVC new];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else{
        if ([ZcxUserDefauts integerForKey:@"isChecBankCard"] == 0){
            BankCardCertificationVC *vc = [BankCardCertificationVC new];
            [self.navigationController pushViewController:vc animated:YES];
        }
  
    }

}

#pragma mark - 设置高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 180;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIImageView *imgview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"banner1"]];
    return imgview;
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
        _tableView.rowHeight = ZCXRowHeight;
        _tableView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}



@end
