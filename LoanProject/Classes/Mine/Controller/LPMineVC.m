//
//  LPMineVC.m
//  LoanProject
//
//  Created by 张晨曦 on 2018/11/28.
//  Copyright © 2018年 张晨曦. All rights reserved.
//

#import "LPMineVC.h"
#import "LPCertificationCell.h"
#import "MineHeadView.h"
#import "LoginVC.h"

//
#import "LoanProgressVC.h"
#import "LoanProgressIngVC.h"
#import "LoanProgressLoseVC.h"
#import "RepaySuccessVC.h"
#import "MyLoanVC.h"
#import "CustomerServiceVC.h"
#import "CardManageVC.h"
#import "HelpCenterVC.h"

#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface LPMineVC ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *imgArr;
@property (nonatomic, strong) NSArray *titleArr;

@property (nonatomic, strong) UIButton *quitBtn;

// 调用相机/相册
@property (nonatomic, strong) UIImagePickerController *imagePickerController;

@property (nonatomic, weak) MineHeadView *weak_headView;

//参数
//贷款金额
@property (nonatomic, copy) NSString  *loanAmount;
//贷款时间（时间戳）
@property (nonatomic, copy) NSString  *loanTime;
//服务费
@property (nonatomic, copy) NSString  *serviceCharge;
//贷款审核备注
@property (nonatomic, copy) NSString  *resultInfo;
//还款时间（时间戳）
@property (nonatomic, copy) NSString  *repaymentTime;
//是否支付
@property (nonatomic, copy) NSString *isPayCost;
//是否还款
@property (nonatomic, copy) NSString *isPayLoan;
//是否已发放贷款(0:未发放 1:已发放)
@property (nonatomic, copy) NSString *mloan;
//是否申请了贷款（0：未申请 1：已申请）
@property (nonatomic, copy) NSString *isNew;
//审核状态（0：未审核 1：已审核未通过 2：已审核已通过）
@property (nonatomic, copy) NSString *isPass;

//客服微信
@property (nonatomic, copy) NSString *CSWeChat;
//客服电话
@property (nonatomic, copy) NSString *CSTelephone;
//还款二维码地址
@property (nonatomic, copy) NSString *receiptAddress;
//额度1 支付服务费地址
@property (nonatomic, copy) NSString *feeAddress1;
//额度2 支付服务费地址
@property (nonatomic, copy) NSString *feeAddress2;
//额度3 支付服务费地址
@property (nonatomic, copy) NSString *feeAddress3;

@end

@implementation LPMineVC

//隐藏和显示导航栏
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

//开始
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _imgArr = @[@"loanProgress",@"myLoan",@"customServer",@"bankcard_check",@"helpCenter"];
    _titleArr = @[@"贷款进度",@"我的贷款",@"客服",@"银行卡管理",@"帮助中心"];
    
    [self setBotBtn];
    
    [self tableView];
    
    //照片选择器
    self.imagePickerController = [[UIImagePickerController alloc] init];
    self.imagePickerController.delegate = self;
    self.imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    self.imagePickerController.allowsEditing = YES;
    
    [self loadList];
}

- (void)loadList{
    NSString *key = [ZcxUserDefauts objectForKey:@"key"];
    NSString *uid = [ZcxUserDefauts objectForKey:@"uid"];
    
    NSDictionary *dict = @{@"key":key,@"uid":uid};
    [[LCHTTPSessionManager sharedInstance] GET:[kUrlReqHead stringByAppendingString:@"/API.asmx/GetLoan"] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"贷款信息----%@",responseObject);
        self.isNew = responseObject[@"isNew"];
        self.isPass = responseObject[@"isPass"];
        self.isPayCost = responseObject[@"isPayCost"];
        self.isPayLoan = responseObject[@"isPayLoan"];
        self.mloan = responseObject[@"mloan"];

        self.loanAmount = responseObject[@"loanAmount"];
        self.loanTime = responseObject[@"loanTime"];
        self.serviceCharge = responseObject[@"serviceCharge"];
        self.repaymentTime = responseObject[@"repaymentTime"];
        self.resultInfo = responseObject[@"resultInfo"];

        self.CSWeChat = responseObject[@"CSWeChat"];
        self.CSTelephone = responseObject[@"CSTelephone"];
        self.receiptAddress = responseObject[@"receiptAddress"];
        self.feeAddress1 = responseObject[@"feeAddress1"];
        self.feeAddress2 = responseObject[@"feeAddress2"];
        self.feeAddress3 = responseObject[@"feeAddress3"];
        
        //刷新
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"贷款信息错误----%@",error);
    }];
}

- (void)setBotBtn{
    
    _quitBtn = [UIButton createYellowBgBtn:@"退出登录"];
    [_quitBtn addTarget:self action:@selector(quitClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_quitBtn];
    [_quitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(-80);
        make.left.equalTo(self.view).with.offset(20);
        make.height.equalTo(@50);
    }];
}

- (void)quitClick{

    //弹出 登录界面
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
    [cell.checkLb setHidden:YES];
    [cell.headImg setImage:[UIImage imageNamed:_imgArr[indexPath.row]]];
    cell.titleLb.text = _titleArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0){
        //此处分3种情况，分别是 审核中/审核失败/审核通过
        if ([self.isNew isEqualToString:@"0"]){
            [SVProgressHUD showErrorWithStatus:@"您暂未申请贷款!"];
            return;
        }else{
            if ([self.isPass isEqualToString:@"0"]){ //审核中
                LoanProgressIngVC *vc = [[UIStoryboard storyboardWithName:@"LoanProgressIngVC" bundle:nil] instantiateViewControllerWithIdentifier:@"LoanProgressIngVC"];
                [self.navigationController pushViewController:vc animated:YES];
            }
            if ([self.isPass isEqualToString:@"1"]){ //审核未通过
                LoanProgressLoseVC *vc = [[UIStoryboard storyboardWithName:@"LoanProgressLoseVC" bundle:nil] instantiateViewControllerWithIdentifier:@"LoanProgressLoseVC"];
                vc.loseInfo = self.resultInfo;
                [self.navigationController pushViewController:vc animated:YES];
            }
            if ([self.isPass isEqualToString:@"2"]){ //审核已通过
                LoanProgressVC *vc = [[UIStoryboard storyboardWithName:@"LoanProgressVC" bundle:nil] instantiateViewControllerWithIdentifier:@"LoanProgressVC"];
                vc.loanMoney = self.loanAmount;
                vc.serverMoney = self.serviceCharge;
                vc.weChat = self.CSWeChat;
                vc.telephone = self.CSTelephone;
                NSNumber *limit = [ZcxUserDefauts objectForKey:@"limit"];
                if ([limit isEqualToNumber:@1]){
                    vc.feeAddress = self.feeAddress1;
                }else if ([limit isEqualToNumber:@2]){
                    vc.feeAddress = self.feeAddress2;
                }else{
                    vc.feeAddress = self.feeAddress3;
                }
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
        
    }else if (indexPath.row == 1){
        
        if ([self.isNew isEqualToString:@"0"]){
            [SVProgressHUD showErrorWithStatus:@"您暂未申请贷款!"];
            return;
        }else{
            if ([self.mloan isEqualToString:@"1"]){
                MyLoanVC *vc = [[UIStoryboard storyboardWithName:@"MyLoanVC" bundle:nil] instantiateViewControllerWithIdentifier:@"MyLoanVC"];
                vc.loanMoney = self.loanAmount;
                vc.feeAddress = self.receiptAddress;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [SVProgressHUD showErrorWithStatus:@"您的贷款暂未发放!"];
                return;
            }
        }
    
    }else if (indexPath.row == 2){
        CustomerServiceVC *vc = [CustomerServiceVC new];
        vc.weChat = self.CSWeChat;
        vc.telephone = self.CSTelephone;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 3){
        CardManageVC *vc = [[UIStoryboard storyboardWithName:@"CardManageVC" bundle:nil] instantiateViewControllerWithIdentifier:@"CardManageVC"];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        HelpCenterVC *vc = [HelpCenterVC new];
        [self.navigationController pushViewController:vc animated:YES];
    }

}

#pragma mark - 设置高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 220;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MineHeadView *view = [MineHeadView viewWithTableView:tableView];
//    _weak_headView = view;
//    //添加点击事件
//    [view.headImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeIcon:)]];
    
    if ([ZcxUserDefauts boolForKey:@"isChecIdentity"] == YES && [ZcxUserDefauts boolForKey:@"isChecOperator"] == YES &&[ZcxUserDefauts boolForKey:@"isChecAlipay"] == YES &&[ZcxUserDefauts boolForKey:@"isChecBankCard"] == YES ){
        [view.renzhenBtn setBackgroundImage:[UIImage imageNamed:@"agree"] forState:UIControlStateNormal];
        [view.renzhenBtn setTitle:@"已认证" forState:UIControlStateNormal];
        
        view.phoneLabel.text = [NSString stringWithFormat:@"%@",[ZcxUserDefauts objectForKey:@"phone"]];
    }else{
        [view.renzhenBtn setBackgroundImage:[UIImage imageNamed:@"weirenzheng"] forState:UIControlStateNormal];
         [view.renzhenBtn setTitle:@"未认证" forState:UIControlStateNormal];
    }
        
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

#pragma mark - 懒加载tableView
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 80) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.rowHeight = ZCXRowHeight;
        _tableView.backgroundColor = [UIColor whiteColor];
      
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark - 换头像
- (void)changeIcon:(UITapGestureRecognizer *)recognize{

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"更换头像" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"打开相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击调用相册
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        self.imagePickerController.allowsEditing = YES;
        //相册权限
        ALAuthorizationStatus authStatus = [ALAssetsLibrary authorizationStatus];
        if (authStatus == ALAuthorizationStatusRestricted || authStatus ==ALAuthorizationStatusDenied){
            //无权限 引导去开启
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        }
        [self presentViewController:self.imagePickerController animated:YES completion:nil];
    }]];
    
    //判断设备是否有具有摄像头(相机)功能
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [alert addAction:[UIAlertAction actionWithTitle:@"打开照相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //点击调用照相机
            self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            self.imagePickerController.allowsEditing = YES;
            //相机权限
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            if (authStatus ==AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied ){
                // 无权限 引导去开启
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication]canOpenURL:url]) {
                    [[UIApplication sharedApplication]openURL:url];
                }
            }
            [self presentViewController:self.imagePickerController animated:YES completion:nil];
        }]];
    }
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self  presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 相机／相册 代理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //通过key值获取到图片
    UIImage * image =info[UIImagePickerControllerOriginalImage];
    //转换成jpg格式，并压缩，0.5比例最好
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);

    //    //判断数据源类型
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {    //相册

        _weak_headView.headImgView.image = image;
        
        [self  dismissViewControllerAnimated:YES completion:nil];
    }
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {   //相机
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        
        _weak_headView.headImgView.image = image;
        
        [self  dismissViewControllerAnimated:YES completion:nil];
    }
}

//当用户取消选取时调用
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
