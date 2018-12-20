//
//  PaymentCodePopView.m
//  LoanProject
//
//  Created by 张晨曦 on 2018/12/12.
//  Copyright © 2018年 张晨曦. All rights reserved.
//

#import "PaymentCodePopView.h"

@implementation PaymentCodePopView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _whiteContentView.layer.cornerRadius = 10;
    _whiteContentView.layer.masksToBounds = YES;
    
    //二维码长按事件
    _codeImgView.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(saveToAlbum:)];
    longPress.minimumPressDuration = 1; //定为1秒
    [_codeImgView addGestureRecognizer:longPress];
    
    //关闭按钮点击事件
    _closeBtn.zcx_acceptEventInterval = 3;
    [_closeBtn addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    
    self.describeLabel.text = @"1.请备注姓名与手机号码，否则影响审批进度 \n2.支付以后如有疑问请在客服中心联系人工客服";
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    //设置 金额 和 二维码
    if (self.money != nil){
        self.payMoneyLabel.text = [[@"支付" stringByAppendingString:self.money]  stringByAppendingString:@"元"];
    }
    
    if (self.feeAddress != nil){
        
        NSURL *imageUrl = [NSURL URLWithString:[[kUrlReqHead stringByAppendingString:@"/"] stringByAppendingString:self.feeAddress]];
        [self.codeImgView sd_setImageWithURL:imageUrl placeholderImage:kPlaceholderHeadImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            
        }];
    }
    
}

- (void)saveToAlbum:(UILongPressGestureRecognizer*)gestureRecognizer{
   
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        UIImageWriteToSavedPhotosAlbum(_codeImgView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }

}

-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if(error){
//        [SVProgressHUD showErrorWithStatus:error.description];
        [SVProgressHUD showErrorWithStatus:@"保存图片失败!"];
    }else{
        [SVProgressHUD showSuccessWithStatus:@"付款码已经保存至相册!"];
    }
}

//关闭弹出框
- (void)closeView{
    [self removeFromSuperview];
}

@end
