//
//  AlipayCertificationVC.m
//  LoanProject
//
//  Created by 张晨曦 on 2018/12/10.
//  Copyright © 2018年 张晨曦. All rights reserved.
//

#import "AlipayCertificationVC.h"
#import "CarrierCell.h"
#import "AliPayFooterView.h"

#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface AlipayCertificationVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *submitBtn;

//自定义 电话的inputAccessoryView
@property (nonatomic, strong) UIToolbar *customAccessoryView;

// 调用相机/相册
@property (nonatomic, strong) UIImagePickerController *imagePickerController;

//弱引用2个cell
@property (nonatomic, weak) CarrierCell *weak_numCell;
@property (nonatomic, weak) CarrierCell *weak_pwdCell;
//
@property (nonatomic, weak) AliPayFooterView *weak_zhimaView;

//上传图片 地址
@property (nonatomic, copy) NSString *zmImgStr;

@end

@implementation AlipayCertificationVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navigationItem.title = @"支付宝认证";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self tableView];
    
    [self setBotBtn];
    
    //照片选择器
    self.imagePickerController = [[UIImagePickerController alloc] init];
    self.imagePickerController.delegate = self;
    self.imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    self.imagePickerController.allowsEditing = YES;
}

- (void)setBotBtn{
    //确认按钮
    _submitBtn = [UIButton createYellowBgBtn:@"提交"];
    _submitBtn.zcx_acceptEventInterval = 3;
    [_submitBtn addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_submitBtn];
    [_submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(-20);
        make.left.equalTo(self.view).with.offset(15);
        make.height.equalTo(@kBtnHeight);
    }];
}

- (void)submitClick{
    
    if ([_weak_numCell.inputTF.text isEqualToString:@""] || [_weak_pwdCell.inputTF.text isEqualToString:@""] ){
        [SVProgressHUD showErrorWithStatus:@"请先填写完信息！"];
        return;
    }
    
    NSString *uid = [ZcxUserDefauts objectForKey:@"uid"];
    
    NSDictionary *dict = @{@"uid":uid, @"key":kLpKey,@"alipay":_weak_numCell.inputTF.text, @"alipaycipher" : _weak_pwdCell.inputTF.text , @"zmImg" : self.zmImgStr};
    
    [[LCHTTPSessionManager sharedInstance] GET:[kUrlReqHead stringByAppendingString:@"/API.asmx/SaveAlipay"] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"支付宝认证----%@",responseObject);
        
        NSString *stateCode = [NSString stringWithFormat:@"%@",responseObject[@"isSave"]];
        if ([stateCode isEqualToString:@"0"]){
            [SVProgressHUD showSuccessWithStatus:@"保存成功！"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //返回上个界面
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
            
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"支付宝认证错误----%@",error);
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
    cell.inputTF.keyboardType = UIKeyboardTypeDefault;
    cell.inputTF.returnKeyType = UIReturnKeyDone;
    cell.inputTF.delegate = self;
    
    if (indexPath.row == 0){
        cell.inputTF.placeholder = @"支付宝账号";
        _weak_numCell = cell;
    }
    if (indexPath.row == 1){
        cell.inputTF.placeholder = @"支付宝密码";
//        cell.inputTF.inputAccessoryView = self.customAccessoryView;
//        cell.inputTF.keyboardType = UIKeyboardTypeNumberPad;
        _weak_pwdCell = cell;
    }
    
    return cell;
}

#pragma mark - 设置高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 400;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    AliPayFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"AliPayFooterView"];
    //赋值
    _weak_zhimaView = view;
    //添加点击事件
    [view.uploadZhiMaImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(uploadImg:)]];
    return view;
}

#pragma mark - 懒加载tableView
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.rowHeight = ZCXRowHeight;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //注册footView
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AliPayFooterView class]) bundle:[NSBundle mainBundle]] forHeaderFooterViewReuseIdentifier:@"AliPayFooterView"];
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

//上传芝麻信用
- (void)uploadImg:(UITapGestureRecognizer *)recognize{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择照片" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"打开相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击调用相册
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        self.imagePickerController.allowsEditing = NO;
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
            self.imagePickerController.allowsEditing = NO;
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
    
    [SVProgressHUD showProgress:-1 status:@"上传中..."];
    [[LCHTTPSessionManager sharedInstance] upload:[kUrlReqHead stringByAppendingString:@"/UpLoadFiles.aspx"] parameters:nil name:@"imgarray0" fileName:@"zhima.jpg" data:imageData completion:^(id  _Nonnull result, BOOL isSuccess) {

        NSString *stateCode = [NSString stringWithFormat:@"%@",result[@"state"]];
        if ([stateCode isEqualToString:@"200"]){
            self.zmImgStr = result[@"img"];
            [SVProgressHUD dismiss];
        }else{
            [SVProgressHUD showErrorWithStatus:@"图片上传失败！"];
            [SVProgressHUD dismiss];
            return;
        }
        }];
    
    //判断数据源类型
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {    //相册
        //显示图片
        _weak_zhimaView.uploadZhiMaImgView.image = image;
        [self  dismissViewControllerAnimated:YES completion:nil];
    }
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {   //相机
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        //显示图片
        _weak_zhimaView.uploadZhiMaImgView.image = image;
        
        [self  dismissViewControllerAnimated:YES completion:nil];
    }
}

//当用户取消选取时调用
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
