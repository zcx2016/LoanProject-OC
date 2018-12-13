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

@interface LPCertificationVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *chooseBtn;
@property (nonatomic, strong) UILabel *protocolLabel;

@property (nonatomic, strong) NSArray *imgArr;
@property (nonatomic, strong) NSArray *titleArr;

@property (nonatomic, strong) UIButton *submitBtn;

@end

@implementation LPCertificationVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    _imgArr = @[@"id_check",@"carrier_check",@"zfb_check",@"bankcard_check"];
    _titleArr = @[@"身份证认证",@"运营商认证",@"支付宝认证",@"银行卡认证"];
    
    [self setBotBtn];
    
    [self tableView];
    
    [self loadList];
}

- (void)loadList{
    [[LCHTTPSessionManager sharedInstance] GET:[kUrlReqHead stringByAppendingString:@"/API.asmx/getkey"] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ZcxUserDefauts setObject:responseObject[@"key"] forKey:@"key"];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"key----%@",error);
    }];
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
  
    NSString *key = [ZcxUserDefauts objectForKey:@"key"];
    NSString *uid = [ZcxUserDefauts objectForKey:@"uid"];
    
    NSDictionary *dict = @{@"key":key, @"uid": uid};
    
    [[LCHTTPSessionManager sharedInstance] GET:[kUrlReqHead stringByAppendingString:@"/API.asmx/SaveLoan"] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"提交贷款申请----%@",responseObject);
        
        NSString *stateCode = [NSString stringWithFormat:@"%@",responseObject[@"isSave"]];
        if ([stateCode isEqualToString:@"0"]){
            [SVProgressHUD showSuccessWithStatus:@"申请成功！"];
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
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0){
        IDCardCertificationVC *vc = [IDCardCertificationVC new];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 1){
        CarrierCertificationVC *vc = [CarrierCertificationVC new];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.row == 2){
        AlipayCertificationVC *vc = [AlipayCertificationVC new];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        BankCardCertificationVC *vc = [BankCardCertificationVC new];
        [self.navigationController pushViewController:vc animated:YES];
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

@end
