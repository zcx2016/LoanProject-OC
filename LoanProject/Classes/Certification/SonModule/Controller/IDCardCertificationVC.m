//
//  IDCardCertificationVC.m
//  LoanProject
//
//  Created by 张晨曦 on 2018/12/10.
//  Copyright © 2018年 张晨曦. All rights reserved.
//

#import "IDCardCertificationVC.h"
#import "IDCardCell.h"

#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface IDCardCertificationVC ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *submitBtn;

// 调用相机/相册
@property (nonatomic, strong) UIImagePickerController *imagePickerController;

//弱引用3个cell
@property (nonatomic, weak) IDCardCell *weak_firstCell;
@property (nonatomic, weak) IDCardCell *weak_secCell;
@property (nonatomic, weak) IDCardCell *weak_thirdCell;

//选择的哪个图片的index
@property (nonatomic, strong) NSIndexPath *selectIndex;

//图片url
@property (nonatomic, strong) NSString *pic1UrlStr;
@property (nonatomic, strong) NSString *pic2UrlStr;
@property (nonatomic, strong) NSString *pic3UrlStr;

@end

@implementation IDCardCertificationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"身份证认证";
    
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
    NSString *uid = [ZcxUserDefauts objectForKey:@"uid"];
 
    NSDictionary *dict = @{@"uid" : uid, @"key": kLpKey ,@"positive" : self.pic1UrlStr, @"back":self.pic2UrlStr,@"hold":self.pic3UrlStr};
    
    [[LCHTTPSessionManager sharedInstance] GET:[kUrlReqHead stringByAppendingString:@"/API.asmx/SaveIDCard"] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"上传身份证---%@",responseObject);
//        [SVProgressHUD setMaximumDismissTimeInterval:3];
        [SVProgressHUD showProgress:-1 status:@"身份证正在系统扫描中，等待系统认证中"];
        
        NSString *stateCode = [NSString stringWithFormat:@"%@",responseObject[@"isSave"]];
        if ([stateCode isEqualToString:@"0"]){
            [SVProgressHUD showSuccessWithStatus:@"上传成功！"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //推回上一个界面
                [SVProgressHUD dismiss];
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
             [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:@"上传失败，请重新上传！"];

            return;
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"上传身份证---%@",error);
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
    IDCardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IDCardCell" forIndexPath:indexPath];
    
    //图片添加 点击效果
    [cell.imgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImg:)]];
    
    if (indexPath.row == 0){
        [cell.imgView setImage:[UIImage imageNamed:@"shenfen1"]];
        _weak_firstCell = cell;
    }else if (indexPath.row == 1){
        [cell.imgView setImage:[UIImage imageNamed:@"shenfen2"]];
        _weak_secCell = cell;
    }else{
        [cell.imgView setImage:[UIImage imageNamed:@"shenfen3"]];
        _weak_thirdCell = cell;
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 -80) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.rowHeight = 190;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //注册cell
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([IDCardCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"IDCardCell"];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark - 调用相机或相册
- (void)tapImg:(UITapGestureRecognizer *)recognize{
    
    UIImageView *imgView = (UIImageView *)((UITapGestureRecognizer *)recognize).view;
    IDCardCell *cell = imgView.superview.superview;

    _selectIndex = [_tableView indexPathForCell:cell];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择照片" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"打开相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击调用相册
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //设为yes,再加上其他语句，就可以编辑了
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
    
    NSString *imageName = [NSString stringWithFormat:@"%@.jpg",[self getCurrentTime]];

  //判断数据源类型
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {    //相册
        if (_selectIndex.row == 0){
            
            _weak_firstCell.imgView.image = image;
            [SVProgressHUD showProgress:-1 status:@"上传中..."];
            [[LCHTTPSessionManager sharedInstance] upload:[kUrlReqHead stringByAppendingString:@"/UpLoadFiles.aspx"] parameters:nil name:@"img0" fileName:imageName data:imageData completion:^(id  _Nonnull result, BOOL isSuccess) {
                
                
                NSLog(@"相册1------%@,%d",result,isSuccess);
                NSString *stateCode = [NSString stringWithFormat:@"%@",result[@"state"]];
                if ([stateCode isEqualToString:@"200"]){
                    self.pic1UrlStr = result[@"img"];
                    [SVProgressHUD dismiss];
                }else{
                    [SVProgressHUD showErrorWithStatus:@"身份证人像面上传失败！"];
                     [SVProgressHUD dismiss];
                    return;
                }
            }];
        }else if (_selectIndex.row == 1){
            
            _weak_secCell.imgView.image = image;
            [SVProgressHUD showProgress:-1 status:@"上传中..."];
            [[LCHTTPSessionManager sharedInstance] upload:[kUrlReqHead stringByAppendingString:@"/UpLoadFiles.aspx"] parameters:nil name:@"img0" fileName:imageName data:imageData completion:^(id  _Nonnull result, BOOL isSuccess) {
                
                
                NSLog(@"相册2------%@,%d",result,isSuccess);
                NSString *stateCode = [NSString stringWithFormat:@"%@",result[@"state"]];
                if ([stateCode isEqualToString:@"200"]){
                    self.pic2UrlStr = result[@"img"];
                    [SVProgressHUD dismiss];
                }else{
                    [SVProgressHUD showErrorWithStatus:@"身份证国徽面上传失败！"];
                    [SVProgressHUD dismiss];
                    return;
                }
            }];
        }else{
            _weak_thirdCell.imgView.image = image;
            [SVProgressHUD showProgress:-1 status:@"上传中..."];
            [[LCHTTPSessionManager sharedInstance] upload:[kUrlReqHead stringByAppendingString:@"/UpLoadFiles.aspx"] parameters:nil name:@"img0" fileName:imageName data:imageData completion:^(id  _Nonnull result, BOOL isSuccess) {
                
                NSLog(@"相册3-------%@,%d",result,isSuccess);
                NSString *stateCode = [NSString stringWithFormat:@"%@",result[@"state"]];
                if ([stateCode isEqualToString:@"200"]){
                    self.pic3UrlStr = result[@"img"];
                    [SVProgressHUD dismiss];
                }else{
                    [SVProgressHUD showErrorWithStatus:@"手持身份证照片上传失败！"];
                    [SVProgressHUD dismiss];
                    return;
                }
            }];
        }
        
        [self  dismissViewControllerAnimated:YES completion:nil];
    }
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {   //相机
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);

        if (_selectIndex.row == 0){
            _weak_firstCell.imgView.image = image;
            [SVProgressHUD showProgress:-1 status:@"上传中..."];
            [[LCHTTPSessionManager sharedInstance] upload:[kUrlReqHead stringByAppendingString:@"/UpLoadFiles.aspx"] parameters:nil name:@"img0" fileName:imageName data:imageData completion:^(id  _Nonnull result, BOOL isSuccess) {
                
    
                NSLog(@"相机1-------%@,%d",result,isSuccess);
                NSString *stateCode = [NSString stringWithFormat:@"%@",result[@"state"]];
                if ([stateCode isEqualToString:@"200"]){
                    self.pic1UrlStr = result[@"img"];
                    [SVProgressHUD dismiss];
                }else{
                    [SVProgressHUD showErrorWithStatus:@"身份证人像面上传失败！"];
                    [SVProgressHUD dismiss];
                    return;
                }
            }];
        }else if (_selectIndex.row == 1){
            _weak_secCell.imgView.image = image;
            [SVProgressHUD showProgress:-1 status:@"上传中..."];
            [[LCHTTPSessionManager sharedInstance] upload:[kUrlReqHead stringByAppendingString:@"/UpLoadFiles.aspx"] parameters:nil name:@"img0" fileName:imageName data:imageData completion:^(id  _Nonnull result, BOOL isSuccess) {
        
                NSLog(@"相机2------%@,%d",result,isSuccess);
                NSString *stateCode = [NSString stringWithFormat:@"%@",result[@"state"]];
                if ([stateCode isEqualToString:@"200"]){
                    self.pic2UrlStr = result[@"img"];
                    [SVProgressHUD dismiss];
                }else{
                    [SVProgressHUD showErrorWithStatus:@"身份证国徽面上传失败！"];
                    [SVProgressHUD dismiss];
                    return;
                }
            }];
        }else{
            _weak_thirdCell.imgView.image = image;
            [SVProgressHUD showProgress:-1 status:@"上传中..."];
            [[LCHTTPSessionManager sharedInstance] upload:[kUrlReqHead stringByAppendingString:@"/UpLoadFiles.aspx"] parameters:nil name:@"img0" fileName:imageName data:imageData completion:^(id  _Nonnull result, BOOL isSuccess) {
                
                NSLog(@"相机3-------%@,%d",result,isSuccess);
                NSString *stateCode = [NSString stringWithFormat:@"%@",result[@"state"]];
                if ([stateCode isEqualToString:@"200"]){
                    self.pic3UrlStr = result[@"img"];
                    [SVProgressHUD dismiss];
                }else{
                    [SVProgressHUD showErrorWithStatus:@"手持身份证照片上传失败！"];
                    [SVProgressHUD dismiss];
                    return;
                }
            }];
        }
        
        [self  dismissViewControllerAnimated:YES completion:nil];
    }
}

//当用户取消选取时调用
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//获取当前时间
- (NSString *)getCurrentTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}

@end
