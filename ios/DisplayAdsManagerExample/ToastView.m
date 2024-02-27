//
//  ToastView.m
//  DisplayAdsManagerExample
//
//  Created by 王志忠 on 2024/2/26.
//


#import "ToastView.h"
#import <UIKit/UIKit.h>
@interface ToastView()
@property (nonatomic, strong) UIView *toastView;
@property (nonatomic, strong) UILabel *messageLabel;
@end

@implementation ToastView

- (void)showMessage: (NSString *)message {
    UIView *toastView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 270, 120)];
    toastView.backgroundColor = [UIColor whiteColor];
    toastView.layer.cornerRadius = 15;
    toastView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    toastView.layer.borderWidth = 2;
    
    UILabel *messageLabel = [[UILabel alloc] initWithFrame: CGRectMake(20, 20, toastView.bounds.size.width - 40, toastView.bounds.size.height - 40)];
    messageLabel.font = [UIFont systemFontOfSize: 15 weight: UIFontWeightBold];
    messageLabel.text = message;
    messageLabel.numberOfLines = 3;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.textColor = [UIColor blackColor];
    
    [toastView addSubview: messageLabel];
    
    UIWindow *currentWindow = [UIApplication sharedApplication].windows.firstObject;
    toastView.center = currentWindow.center;
    [currentWindow addSubview: toastView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [toastView removeFromSuperview];
    });
}
@end
