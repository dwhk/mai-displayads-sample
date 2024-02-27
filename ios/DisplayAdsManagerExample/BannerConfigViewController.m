//
//  BannerConfigViewController.m
//  DisplayAdsManagerExample
//
//  Created by 王志忠 on 2024/2/26.
//

#import "BannerConfigViewController.h"
#import <DisplayAdsManagerSDK/DisplayAdsManager.h>
#import <DisplayAdsManagerSDK/DisplayAdInstance.h>
#import "ToastView.h"
@interface BannerConfigViewController ()<UITextFieldDelegate, UITextViewDelegate, DisplayAdsManagerDelegate>
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) NSString *endpointStr;
@property (nonatomic, strong) NSString *trackingEndpointStr;
@property (nonatomic, strong) NSString *slotAfStr;
@property (nonatomic, strong) NSString *slotIdStr;
@property (nonatomic, strong) NSString *slotIuStr;
@property (nonatomic, strong) NSString *slotSzStr;
@property (nonatomic, strong) NSString *optionalParamsStr;
@property (nonatomic, strong) UITextView *optionalParamsTextView;

@property (nonatomic, strong) DisplayAdsManager *adManager;

//@property (nonatomic, strong) LoadingView *loadingView;
@property (nonatomic, strong) ToastView *toast;
@end

@implementation BannerConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.title = @"Banner Config";
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName: [UIColor whiteColor]}];
//    self.loadingView = [LoadingView new];
    self.toast = [ToastView new];
    
    
    self.adManager = [DisplayAdsManager shareInstance];
        
    UIEdgeInsets insets = [UIApplication sharedApplication].windows.firstObject.safeAreaInsets;
    
    CGFloat horizontalPadding = 20;
    CGFloat largeLabelHeight = 35;
    
    
    UIScreen *currentScreen = [UIScreen mainScreen];
    CGFloat screenWidth = currentScreen.bounds.size.width;
    CGFloat screenHeight = currentScreen.bounds.size.height;

    
    [self initDefaultValue];
    
    self.mainScrollView = [[UIScrollView alloc] initWithFrame: CGRectMake(0, 0, screenWidth, screenHeight)];
    self.mainScrollView.contentSize = CGSizeMake(screenWidth, screenHeight * 2);
    
    [self.view addSubview: self.mainScrollView];
    
    CGFloat contentWidth = screenWidth - horizontalPadding * 2;

    UILabel *endpointLabel = [self largeTitleLabelWithFrame: CGRectMake(horizontalPadding, 20, contentWidth, largeLabelHeight) title: @"Display Endpoint"];
    [self.mainScrollView addSubview: endpointLabel];
    
    UIView *endpointContainer = [self textfiledContainerWithFrame: CGRectMake(horizontalPadding, [self getBottomPosition: endpointLabel.frame], contentWidth, 46) Placeholder: @"enter Display Endpoint" defaultText: self.endpointStr tag: 1001];
    [self.mainScrollView addSubview: endpointContainer];
    
    UILabel *trackingEndpoingLabel = [self largeTitleLabelWithFrame: CGRectMake(horizontalPadding, [self getBottomPosition: endpointContainer.frame] + 10, contentWidth, largeLabelHeight) title: @"Tracking Endpoint"];

    [self.mainScrollView addSubview: trackingEndpoingLabel];
    
    UIView *trackingContainer = [self textfiledContainerWithFrame: CGRectMake(horizontalPadding, [self getBottomPosition: trackingEndpoingLabel.frame], contentWidth, 46) Placeholder: @"enter Tracking Endpoint" defaultText: self.trackingEndpointStr tag: 1000];

    [self.mainScrollView addSubview: trackingContainer];
    
    UILabel *solotsLabel = [self largeTitleLabelWithFrame: CGRectMake(horizontalPadding, [self getBottomPosition: trackingContainer.frame] + 10, contentWidth, largeLabelHeight) title: @"Slots"];
    [self.mainScrollView addSubview: solotsLabel];
    
    UIView *slotAf = [self textfiledContainerWithFrame: CGRectMake(horizontalPadding, [self getBottomPosition: solotsLabel.frame], contentWidth, 46) Title: @"af" placeholder: @"enter af" defaultText:self.slotAfStr tag: 1002];
    [self.mainScrollView addSubview: slotAf];
    
    UIView *slotId = [self textfiledContainerWithFrame: CGRectMake(horizontalPadding, [self getBottomPosition: slotAf.frame] + 10, contentWidth, 46) Title: @"id" placeholder: @"enter id" defaultText: self.slotIdStr tag: 1003];
    [self.mainScrollView addSubview: slotId];
    
    UIView *slotIu = [self textfiledContainerWithFrame: CGRectMake(horizontalPadding, [self getBottomPosition: slotId.frame] + 10, contentWidth, 46) Title: @"iu" placeholder: @"enter iu" defaultText: self.slotIuStr tag: 1004];
    [self.mainScrollView addSubview: slotIu];
    
    UIView *slotSz = [self textfiledContainerWithFrame: CGRectMake(horizontalPadding, [self getBottomPosition: slotIu.frame] + 10, contentWidth, 46) Title: @"sz" placeholder: @"enter sz" defaultText: self.slotSzStr tag: 1005];
    [self.mainScrollView addSubview: slotSz];
    
    

    UILabel *opLabel = [self largeTitleLabelWithFrame: CGRectMake(horizontalPadding, [self getBottomPosition: slotSz.frame] + 20, contentWidth, largeLabelHeight) title: @"Optionnal Param"];
    [self.mainScrollView addSubview: opLabel];
    
    
//    UILabel *custParamLabel = [[UILabel alloc] initWithFrame: CGRectMake(horizontalPadding, [self getBottomPosition: opLabel.frame], contentWidth, 20)];
//    custParamLabel.text = @"cus_param";
//    custParamLabel.font = [UIFont systemFontOfSize: 13 weight: UIFontWeightMedium];
//    custParamLabel.textColor = [UIColor whiteColor];
//    [_mainScrollView addSubview: custParamLabel];
    
    self.optionalParamsTextView = [[UITextView alloc] initWithFrame: CGRectMake(20, [self getBottomPosition: opLabel.frame] + 10, contentWidth, 150)];
    
    self.optionalParamsTextView.layer.cornerRadius = 8;
    self.optionalParamsTextView.text = self.optionalParamsStr;
    self.optionalParamsTextView.font = [UIFont systemFontOfSize: 16 weight: UIFontWeightRegular];
    self.optionalParamsTextView.backgroundColor = [UIColor colorNamed: @"TFBackgroundColor"];
    self.optionalParamsTextView.delegate = self;
    self.optionalParamsTextView.textColor = [UIColor whiteColor];
    [_mainScrollView addSubview: self.optionalParamsTextView ];
    
    
    UIView *bottomContainer = [[UIView alloc] initWithFrame: CGRectMake(0, screenHeight - insets.bottom - 60, screenWidth, insets.bottom + 60)];
    bottomContainer.backgroundColor = [UIColor blackColor];
    [self.view addSubview: bottomContainer];

    
    UIButton *submitButton = [UIButton buttonWithType: UIButtonTypeCustom];
    submitButton.frame = CGRectMake(50, 5, screenWidth - 100, 50);
    submitButton.layer.cornerRadius = 50/2;
    submitButton.titleLabel.font = [UIFont systemFontOfSize: 18 weight: UIFontWeightBold];
    [submitButton setTitle: @"Submit" forState: UIControlStateNormal];
    submitButton.backgroundColor = [UIColor orangeColor];
    [submitButton setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
    [submitButton addTarget: self action:@selector(whenPressedSubmitButton:) forControlEvents: UIControlEventTouchUpInside];
    
    [bottomContainer addSubview: submitButton];

    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(whenTapBlankArea)];
    [self.view addGestureRecognizer: tapGes];
}

- (void)whenTapBlankArea {
    [self.view endEditing: YES];
}

- (CGFloat)getBottomPosition: (CGRect)frame {
    return  frame.origin.y + frame.size.height;
}

- (void)initDefaultValue {
    NSLog(@"check current display end point::%@", [[DisplayAdsManager shareInstance] displayEndpoint]);
    self.endpointStr = [[DisplayAdsManager shareInstance] displayEndpoint];
    self.trackingEndpointStr = [[DisplayAdsManager shareInstance] trackingEndpoint];
    self.slotAfStr = @"1";
    self.slotIdStr = @"frame1";
    //FIXME: need replace with your own iu
    self.slotIuStr = @"/123456/a.pc.uat/home/bn";
    self.slotSzStr = @"320x100";

    
    NSMutableDictionary *custParams = [NSMutableDictionary new];
    [custParams setObject: @"ios" forKey: @"platform"];
    [custParams setObject: @"phone" forKey: @"dtype"];
    [custParams setObject: @"f7ec8346a9d678a6e4e2115d5b6ff4b29c3cbd4b1928ea2e3d11c9ac92636c32" forKey: @"hdid"];
    
    //将custParams dictionary 转为 query string
    NSString *custParamsQueryStr = @"";
    for (NSString *key in custParams.allKeys) {
        custParamsQueryStr = [NSString stringWithFormat: @"%@&%@=%@", custParamsQueryStr, key, custParams[key]];
    }
    if (custParamsQueryStr.length > 0) {
        custParamsQueryStr = [custParamsQueryStr substringFromIndex: 1];
    }
    
    NSMutableDictionary *optionalParams = [NSMutableDictionary new];
    [optionalParams setObject: @"2d321288-4a78-4be7-aa87-876d16df241a" forKey: @"ppid"];
    [optionalParams setObject: @"banner" forKey: @"adFormat"];
    [optionalParams setObject: custParamsQueryStr forKey: @"cust_params"];
    
    self.optionalParamsStr = [[NSString alloc] initWithData: [NSJSONSerialization dataWithJSONObject: optionalParams options: 0 error: nil] encoding:NSUTF8StringEncoding];
}

#pragma mark Custom UI
- (UILabel *)largeTitleLabelWithFrame: (CGRect)frame title: (NSString *)text {
    UILabel *label = [[UILabel alloc] initWithFrame: frame];
    label.font = [UIFont systemFontOfSize: 18 weight: UIFontWeightBold];
    label.text = text;
    label.textColor = [UIColor whiteColor];
    return  label;
}

- (UILabel *)commonTitleLabelWithFrame: (CGRect)frame Text: (NSString *)title {
    UILabel *label = [[UILabel alloc] initWithFrame: frame];
    label.font = [UIFont systemFontOfSize: 16 weight: UIFontWeightBold];
    label.text = title;
    label.textColor = [UIColor whiteColor];
    return  label;
}

- (UIView *)textfiledContainerWithFrame: (CGRect)frame Placeholder: (NSString *)placeholder defaultText: (NSString *)defaultText tag: (NSInteger)tag {
    UIView *container = [[UIView alloc] initWithFrame: frame];
    container.backgroundColor = [UIColor colorNamed: @"TFBackgroundColor"];
    container.layer.cornerRadius = 8;
    
    UITextField *tf = [[UITextField alloc] initWithFrame: CGRectMake(8, 0, frame.size.width - 16, frame.size.height)];
    tf.text = defaultText;
    tf.placeholder = placeholder;
    tf.textColor = [UIColor whiteColor];
    tf.tag = tag;
    tf.returnKeyType = UIReturnKeyDone;
    tf.delegate = self;
    [container addSubview: tf];
    
    if (tag == -1) {
        tf.userInteractionEnabled = false;
    }

    return container;
}


- (UIView *)textfiledContainerWithFrame: (CGRect)frame Title: (NSString *)title placeholder: (NSString *)placeholder defaultText: (NSString *)defaultText tag: (NSInteger)tag{
    UIView *container = [[UIView alloc] initWithFrame: frame];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, 45, frame.size.height)];
    titleLabel.text = title;
    titleLabel.font = [UIFont systemFontOfSize: 13 weight: UIFontWeightMedium];
    titleLabel.textColor = [UIColor whiteColor];
    
    [container addSubview: titleLabel];
    
    
    UIView *tfBgView = [[UIView alloc] initWithFrame: CGRectMake( titleLabel.frame.size.width + titleLabel.frame.origin.y + 10, 0, container.frame.size.width - titleLabel.frame.size.width - 10, container.frame.size.height)];
    tfBgView.backgroundColor = [UIColor colorNamed: @"TFBackgroundColor"];
    tfBgView.layer.cornerRadius = 8;
    
    [container addSubview: tfBgView];
    
    UITextField *tf = [[UITextField alloc] initWithFrame: CGRectMake(8, 0, tfBgView.frame.size.width - 16, tfBgView.frame.size.height)];
    tf.text = defaultText;
    tf.placeholder = placeholder;
    tf.textColor = [UIColor whiteColor];
    tf.tag = tag;
    tf.returnKeyType = UIReturnKeyDone;
    tf.delegate = self;
    tf.userInteractionEnabled = true;
    
    NSMutableDictionary *dicm = [NSMutableDictionary dictionary];
    dicm[NSForegroundColorAttributeName] = [UIColor grayColor];
    NSAttributedString *attribute = [[NSAttributedString alloc] initWithString: placeholder attributes: dicm];
    [tf setAttributedPlaceholder: attribute];

    [tfBgView addSubview: tf];
    
    return container;
}
#pragma mark Action

- (void)whenPressedSubmitButton: (UIButton *)sender {
    [self parseStringAndSubmit];
}

- (BOOL)formatVerify{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle: @"Something Wrong" message: @"" preferredStyle: UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle: @"OK" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alertVC dismissViewControllerAnimated: YES  completion: nil];
    }];
    [alertVC addAction: confirmAction];
    BOOL isOK = YES;
    if ([self.endpointStr isEqualToString: @""]) {
        alertVC.message = @"Endpoint should not be empty.";
        isOK = NO;
    }
    if ([self.slotAfStr isEqualToString: @""]) {
        alertVC.message = @"Slot af should not be empty.";
        isOK = NO;
    }
    if ([self.slotIdStr isEqual: @""]) {
        alertVC.message = @"Slot id should not be empty.";
        isOK = NO;
    }
    if ([self.slotIuStr isEqualToString: @""]) {
        alertVC.message = @"Slot iu should not be empty.";
        isOK = NO;
    }
    if ([self.slotSzStr isEqualToString: @""]) {
        alertVC.message = @"Slot sz should not be empty.";
        isOK = NO;
    }
    if ([self.optionalParamsStr isEqualToString: @""]) {
        alertVC.message = @"cus_params should not be empty.";
        isOK = NO;
    }
    
    if (!isOK) {
        [self presentViewController: alertVC animated: YES completion: nil];
    }
    
    return isOK;
}

- (void)parseStringAndSubmit {
//    [self.loadingView showLoading];
    NSArray *sizeItemArray = [self.slotSzStr componentsSeparatedByString: @"x"];
    CGSize size = CGSizeMake([sizeItemArray.firstObject floatValue], [sizeItemArray.lastObject floatValue]);
    
    NSDictionary *slot = @{
        @"iu": self.slotIuStr,
        @"id": self.slotIdStr,
        @"sz": @[@(size.width), @(size.height)],
        @"af": self.slotAfStr
    };

    //optionParams json string 转 dictionary
    NSDictionary *optionParams = [NSJSONSerialization JSONObjectWithData: [self.optionalParamsStr dataUsingEncoding: NSUTF8StringEncoding] options: kNilOptions error: nil];
    NSMutableDictionary *optionParamsNew = [NSMutableDictionary new];
    //将cust_params 进行URLEncode
    for (NSString *key in optionParams) {
        if ([key isEqualToString: @"cust_params"]) {
            [optionParamsNew setValue: [self urlEncode: optionParams[key]] forKey: key];
        } else {
            [optionParamsNew setValue: optionParams[key]  forKey: key];
        }
    }
    self.adManager.delegate = self;
    
    DisplayAdInstance *bannerInstance = [self.adManager getAdBannerWithSlot: slot optionalParams: optionParams];
    bannerInstance.adView.frame = CGRectMake( 20, [self getBottomPosition: self.optionalParamsTextView.frame] + 20, bannerInstance.adView.frame.size.width, bannerInstance.adView.frame.size.height);
   
    [self.mainScrollView addSubview: bannerInstance.adView];
}


- (NSString *)urlEncode:(NSString *)from {
    NSCharacterSet *encodeSet = [NSCharacterSet characterSetWithCharactersInString:@"!*'();:@&=+$,/?%#[]"];
    NSString *encode = [from stringByAddingPercentEncodingWithAllowedCharacters:encodeSet];//编码
    return encode;
}

#pragma mark TF Delegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == 1001) {
        self.endpointStr = textField.text;
        [[DisplayAdsManager shareInstance] setDisplayEndpoint: textField.text trackingEndpoint: self.trackingEndpointStr];
        NSLog(@"check endpoint string...:%@", [[DisplayAdsManager shareInstance] displayEndpoint]);
    }
    if (textField.tag == 1002) {
        self.slotAfStr = textField.text;
    }
    if (textField.tag == 1003) {
        self.slotIdStr = textField.text;
    }
    if (textField.tag == 1004) {
        self.slotIuStr = textField.text;
    }
    if (textField.tag == 1005) {
        self.slotSzStr = textField.text;
    }
    if (textField.tag == 1000) {
        self.trackingEndpointStr = textField.text;
        [[DisplayAdsManager shareInstance] setDisplayEndpoint: self.endpointStr  trackingEndpoint: textField.text];
    }
    NSLog(@"check current textfile text:::%@", textField.text);
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField endEditing: false];
    return  YES;
}
- (void)textViewDidChange:(UITextView *)textView {
    NSLog(@"check textview text:::%@", textView.text);
}
-(void)textViewDidEndEditing:(UITextView *)textView {
    self.optionalParamsStr = textView.text;
}

#pragma mark AdManager Delegate
- (void)onAdLoadFinished:(DisplayAdInstance *)adInstance {
//    [self.loadingView hideLoading];
}
- (void)onAdRenderFinished:(DisplayAdInstance *)adInstance {
    [self.toast showMessage: @"ad render finished"];
}
- (void)onRecordImpression:(DisplayAdInstance *)adInstance {
    [self.toast showMessage: @"ad record impression finished"];
}

- (void)onRecordImpressionFailed:(DisplayAdError *)error instance:(DisplayAdInstance *)instance {
    [self.toast showMessage: @"ad record impression failed"];
}
-(void)onAdLoadFailed:(DisplayAdError *)error instance:(DisplayAdInstance *)instance {
//    [self.loadingView hideLoading];
    
    UIAlertController *alertCtl = [UIAlertController alertControllerWithTitle:@"Error" message: [NSString stringWithFormat:@"code:%ld \n message: %@", error.errorCode,error.errorMessage] preferredStyle: UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"OK" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alertCtl dismissViewControllerAnimated: YES completion: nil];
    }];
    [alertCtl addAction: alertAction];
  dispatch_async(dispatch_get_main_queue(), ^{
    [self presentViewController: alertCtl animated: YES completion: nil];
  });
    
}
-(void)onAdClosed:(UIView *)adView targetAdId:(NSString *)targetAdId {
    
    
}

@end

