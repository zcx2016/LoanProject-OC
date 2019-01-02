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
//读取通讯录的头文件
#import <Contacts/Contacts.h>

@interface CarrierCertificationVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *sureBtn;

//自定义 电话的inputAccessoryView
@property (nonatomic, strong) UIToolbar *customAccessoryView;

//通讯录字典
@property (nonatomic, strong) NSMutableDictionary *addressBookDict;

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
    
    //初始化 通讯录字典
    self.addressBookDict = [NSMutableDictionary dictionary];
    NSString *phone = [ZcxUserDefauts objectForKey:@"phone"];
    [self.addressBookDict setObject:phone forKey:@"easyBorrow"];
    
    //设置UI
    [self tableView];
    
    [self setBotBtn];
    
    //通知--退出当前控制器
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(quitCurrentVcNoti:) name:@"quitCurrentVc" object:nil];
    //通知--读取通讯录信息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(readAddressBookNoti:) name:@"readAddressBook" object:nil];
    
    //弹出 获取通讯录view
    GetAddressBookPopView *addressBookPopView = [[NSBundle mainBundle] loadNibNamed:@"GetAddressBookPopView" owner:nil options:nil].firstObject;
    addressBookPopView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [UIApplication.sharedApplication.keyWindow addSubview:addressBookPopView];
    
}

#pragma mark - 拒绝/同意 获取 通讯录的授权 通知
- (void)quitCurrentVcNoti:(NSNotification *)noti{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)readAddressBookNoti:(NSNotification *)noti{
    [self requestContactAuthorAfterSystemVersion9];
}

#pragma mark - 确认按钮
- (void)setBotBtn{
    _sureBtn = [UIButton createYellowBgBtn:@"确认"];
    _sureBtn.zcx_acceptEventInterval = 3;
    [_sureBtn addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_sureBtn];
    [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(-20);
        make.left.equalTo(self.view).with.offset(15);
        make.height.equalTo(@kBtnHeight);
    }];
}

- (void)sureClick{
    
    if ([_weak_firstNameCell.inputTF.text isEqualToString:@""] || [_weak_firstContactCell.inputTF.text isEqualToString:@""] ||
        [_weak_firstPhoneCell.inputTF.text isEqualToString:@""]|| [_weak_secNameCell.inputTF.text isEqualToString:@""] ||
        [_weak_secContactCell.inputTF.text isEqualToString:@""] || [_weak_secPhoneCell.inputTF.text isEqualToString:@""] ||
        [_weak_thirdNameCell.inputTF.text isEqualToString:@""] || [_weak_thirdContactCell.inputTF.text isEqualToString:@""] ||
        [_weak_thirdPhoneCell.inputTF.text isEqualToString:@""] ){
        
        [SVProgressHUD showErrorWithStatus:@"请先填写完信息！"];
        return;
    }
    
    NSString *uid = [ZcxUserDefauts objectForKey:@"uid"];
  
    NSDictionary *dict = @{@"key": kLpKey,
                           @"uid" : uid,
                           @"name1" : _weak_firstNameCell.inputTF.text, @"contacts1":_weak_firstContactCell.inputTF.text,
                           @"phone1": _weak_firstPhoneCell.inputTF.text,
                           @"name2" : _weak_secNameCell.inputTF.text, @"contacts2":_weak_secContactCell.inputTF.text,
                           @"phone2": _weak_secPhoneCell.inputTF.text,
                           @"name3" : _weak_thirdNameCell.inputTF.text, @"contacts3":_weak_thirdContactCell.inputTF.text,
                           @"phone3": _weak_thirdPhoneCell.inputTF.text
                           };
    
    NSLog(@"dict-=---%@",dict);
    [[LCHTTPSessionManager sharedInstance] GET:[kUrlReqHead stringByAppendingString:@"/API.asmx/SaveOperator"] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"保存紧急联系人---%@",responseObject);
        
        NSString *stateCode = [NSString stringWithFormat:@"%@",responseObject[@"isSave"]];
        if ([stateCode isEqualToString:@"0"]){
            [SVProgressHUD showSuccessWithStatus:@"保存成功！"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //推向下一个界面
                PhoneCertificationVC *vc = [PhoneCertificationVC new];
                vc.addressBookDict = [self.addressBookDict copy];
                [self.navigationController pushViewController:vc animated:YES];
            });
        }else{
            [SVProgressHUD showErrorWithStatus:@"保存失败！"];
            return;
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"存紧急联系人错误---%@",error);
    }];
    
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 80) style:UITableViewStyleGrouped];
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

#pragma mark 请求通讯录权限
- (void)requestContactAuthorAfterSystemVersion9{
    
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (status == CNAuthorizationStatusNotDetermined) {
        CNContactStore *store = [[CNContactStore alloc] init];
        [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError*  _Nullable error) {
            if (error) {
                NSLog(@"授权失败！");
            }else {
                NSLog(@"成功授权！");
            }
        }];
    }
    else if(status == CNAuthorizationStatusRestricted)
    {
        NSLog(@"用户拒绝！");
        [self showAlertViewAboutNotAuthorAccessContact];
    }
    else if (status == CNAuthorizationStatusDenied)
    {
        NSLog(@"用户拒绝！");
        [self showAlertViewAboutNotAuthorAccessContact];
    }
    else if (status == CNAuthorizationStatusAuthorized)//已经授权
    {
        //有通讯录权限-- 进行下一步操作
        [self openContact];
    }
    
}

//有通讯录权限-- 进行下一步操作
- (void)openContact{
    // 获取指定的字段,并不是要获取所有字段，需要指定具体的字段
    NSArray *keysToFetch = @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey];
    CNContactFetchRequest *fetchRequest = [[CNContactFetchRequest alloc] initWithKeysToFetch:keysToFetch];
    CNContactStore *contactStore = [[CNContactStore alloc] init];

    [contactStore enumerateContactsWithFetchRequest:fetchRequest error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {

        //拼接姓名
        NSString *nameStr = [NSString stringWithFormat:@"%@%@",contact.familyName,contact.givenName];
        NSArray *phoneNumbers = contact.phoneNumbers;
        //电话
        NSString *phoneStr;
        
        for (CNLabeledValue *labelValue in phoneNumbers) {
            //遍历一个人名下的多个电话号码
            CNPhoneNumber *phoneNumber = labelValue.value;
            phoneStr = phoneNumber.stringValue;
            
            //去掉电话中的特殊字符
            phoneStr = [phoneStr stringByReplacingOccurrencesOfString:@"+86" withString:@""];
            phoneStr = [phoneStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
            phoneStr = [phoneStr stringByReplacingOccurrencesOfString:@"(" withString:@""];
            phoneStr = [phoneStr stringByReplacingOccurrencesOfString:@")" withString:@""];
            phoneStr = [phoneStr stringByReplacingOccurrencesOfString:@" " withString:@""];
            phoneStr = [phoneStr stringByReplacingOccurrencesOfString:@" " withString:@""];

        }
        [self.addressBookDict setObject:nameStr forKey:phoneStr];
        
        NSLog(@"获取到的通讯录----%@",self.addressBookDict);
    }];
}

//提示没有通讯录权限
- (void)showAlertViewAboutNotAuthorAccessContact{
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"请授权通讯录权限"
                                          message:@"请在iPhone的\"设置-隐私-通讯录\"选项中,允许红鲤鱼app访问你的通讯录"
                                          preferredStyle: UIAlertControllerStyleAlert];
    
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:OKAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
