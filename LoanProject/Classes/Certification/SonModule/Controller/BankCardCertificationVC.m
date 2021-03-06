//
//  BankCardCertificationVC.m
//  LoanProject
//
//  Created by 张晨曦 on 2018/12/10.
//  Copyright © 2018年 张晨曦. All rights reserved.
//

#import "BankCardCertificationVC.h"
#import "BankCardCell.h"

@interface BankCardCertificationVC()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *titleArr;

@property (nonatomic, strong) UIButton *submitBtn;

//自定义 电话,银行卡 的inputAccessoryView
@property (nonatomic, strong) UIToolbar *customAccessoryView;

//弱引用4个cell
@property (nonatomic, weak) BankCardCell *weak_nameCell;
@property (nonatomic, weak) BankCardCell *weak_idCardCell;
@property (nonatomic, weak) BankCardCell *weak_cardCell;
@property (nonatomic, weak) BankCardCell *weak_phoneCell;

@end

@implementation BankCardCertificationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _titleArr = @[@"姓名",@"身份证",@"储蓄卡",@"预留手机号"];
   
    self.navigationItem.title = @"银行卡认证";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setBotBtn];
    
    [self tableView];
}

- (void)setBotBtn{
    
    _submitBtn = [UIButton new];
    _submitBtn.zcx_acceptEventInterval = 3;
    [_submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _submitBtn.layer.cornerRadius = 6;
    [_submitBtn setBackgroundImage:[UIImage imageNamed:@"navbg"] forState:UIControlStateNormal];
    _submitBtn.layer.masksToBounds = YES;
    
    [_submitBtn addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_submitBtn];
    [_submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(-50);
        make.left.equalTo(self.view).with.offset(20);
        make.height.equalTo(@kBtnHeight);
    }];
}

- (void)submitClick{
    
    if ([_weak_nameCell.inputTF.text isEqualToString:@""] || [_weak_idCardCell.inputTF.text isEqualToString:@""] || [_weak_cardCell.inputTF.text isEqualToString:@""] || [_weak_phoneCell.inputTF.text isEqualToString:@""]){
        
        [SVProgressHUD showErrorWithStatus:@"请先填写完信息！"];
        return;
    }
    
    NSString *uid = [ZcxUserDefauts objectForKey:@"uid"];
  
    NSDictionary *dict = @{@"uid" : uid, @"key" :kLpKey, @"bankcard" : _weak_nameCell.inputTF.text,@"idnumber" : _weak_idCardCell.inputTF.text, @"savingscard": _weak_cardCell.inputTF.text, @"phone" :_weak_phoneCell.inputTF.text};
    
    [[LCHTTPSessionManager sharedInstance] GET:[kUrlReqHead stringByAppendingString:@"/API.asmx/SaveBank"] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"银行卡-----%@",responseObject);
        
        NSString *stateCode = [NSString stringWithFormat:@"%@",responseObject[@"isSave"]];
        if ([stateCode isEqualToString:@"0"]){
            [SVProgressHUD showSuccessWithStatus:@"保存成功！"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //返回上个界面
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"银行卡错误-----%@",error);
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
    BankCardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BankCardCell" forIndexPath:indexPath];
    cell.titleLabel.text = _titleArr[indexPath.row];
    if (indexPath.row == 0){
        _weak_nameCell = cell;
        cell.inputTF.delegate = self;
        cell.inputTF.placeholder = @"请输入姓名";
        cell.inputTF.returnKeyType = UIReturnKeyDone;
    }
    if (indexPath.row == 1){
        _weak_idCardCell = cell;
        cell.inputTF.delegate = self;
        cell.inputTF.placeholder = @"请输入身份证号";
        cell.inputTF.returnKeyType = UIReturnKeyDone;
        cell.inputTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    }
    if (indexPath.row == 2){
        _weak_cardCell = cell;
        cell.inputTF.placeholder = @"请输入储蓄卡号";
        cell.inputTF.keyboardType = UIKeyboardTypeNumberPad;
        cell.inputTF.inputAccessoryView = self.customAccessoryView;
    }
    if (indexPath.row == 3){
        _weak_phoneCell = cell;
        cell.inputTF.placeholder = @"请输入预留手机号";
        cell.inputTF.keyboardType = UIKeyboardTypePhonePad;
        cell.inputTF.inputAccessoryView = self.customAccessoryView;
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 130) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.rowHeight = ZCXRowHeight;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //注册cell
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BankCardCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"BankCardCell"];
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
    [self.weak_phoneCell.inputTF resignFirstResponder];
    [self.weak_cardCell.inputTF resignFirstResponder];
}

@end
