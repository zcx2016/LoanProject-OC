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
        LoanProgressIngVC *vc = [[UIStoryboard storyboardWithName:@"LoanProgressIngVC" bundle:nil] instantiateViewControllerWithIdentifier:@"LoanProgressIngVC"];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 1){
        MyLoanVC *vc = [[UIStoryboard storyboardWithName:@"MyLoanVC" bundle:nil] instantiateViewControllerWithIdentifier:@"MyLoanVC"];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 2){
        CustomerServiceVC *vc = [CustomerServiceVC new];
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
    _weak_headView = view;
    //添加点击事件
    [view.headImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeIcon:)]];
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
    
    //    NSString *imageName = [NSString stringWithFormat:@"%@.jpg",[self getCurrentTime]];
    //
    //    //将图片上传到服务器
    //    NSDictionary *dict = @{@"registerId" : self.registerId , @"employeeId" : self.employeeId};
    //
    //    [[LCHTTPSessionManager sharedInstance] upload:[kUrlReqHead stringByAppendingString:@"/app/users/updatePhoto.do"] parameters:dict name:@"imgarray0" fileName:imageName data:imageData completion:^(id  _Nonnull result, BOOL isSuccess) {
    //
    //        //存头像
    //        [UserDefautsLhm setObject:result[@"data"] forKey:KeyUserHeadImg];
    //    }];
    //
    
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
