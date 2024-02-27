//
//  BannerTestListViewController.m
//  DisplayAdsManagerExample
//
//  Created by 王志忠 on 2024/2/26.
//

#import "BannerTestListViewController.h"
#import <DisplayAdsManagerSDK/DisplayAdsManager.h>
#import <DisplayAdsManagerSDK/DisplayAdInstance.h>
#import "ToastView.h"
@interface BannerTestListViewController ()<DisplayAdsManagerDelegate>

@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) DisplayAdsManager *adManager;
@property (nonatomic, strong) ToastView *toast;

@end

@implementation BannerTestListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.title = @"Banner List";
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    CGFloat largeLabelHeight = 35;
    
    
    UIScreen *currentScreen = [UIScreen mainScreen];
    CGFloat screenWidth = currentScreen.bounds.size.width;
    CGFloat screenHeight = currentScreen.bounds.size.height;
    
    self.mainScrollView = [[UIScrollView alloc] initWithFrame: CGRectMake(0, 0, screenWidth, screenHeight)];
    self.mainScrollView.contentSize = CGSizeMake(screenWidth, screenHeight * 2);
    [self.view addSubview: self.mainScrollView];
    
    NSLog(@"check current display end point::%@", [[DisplayAdsManager shareInstance] displayEndpoint]);
    
    NSString * slotAfStr = @"1";
    NSString * slotIdStr = @"frame1";
    //FIXME: need replace with your own iu
    NSString * slotIuStr = @"/123456/a.pc.uat/home/bn";
    NSString * slotSzStr = @"320x100";

    
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
    
    NSString *optionalParamsStr = [[NSString alloc] initWithData: [NSJSONSerialization dataWithJSONObject: optionalParams options: 0 error: nil] encoding:NSUTF8StringEncoding];
    
    NSArray *sizeItemArray = [slotSzStr componentsSeparatedByString: @"x"];
    CGSize size = CGSizeMake([sizeItemArray.firstObject floatValue], [sizeItemArray.lastObject floatValue]);
    
    NSDictionary *slot = @{
        @"iu": slotIuStr,
        @"id": slotIdStr,
        @"sz": @[@(size.width), @(size.height)],
        @"af": slotAfStr
    };
    
    //optionParams json string 转 dictionary
    NSDictionary *optionParams = [NSJSONSerialization JSONObjectWithData: [optionalParamsStr dataUsingEncoding: NSUTF8StringEncoding] options: kNilOptions error: nil];
    NSMutableDictionary *optionParamsNew = [NSMutableDictionary new];
    //将cust_params 进行URLEncode
    for (NSString *key in optionParams) {
        if ([key isEqualToString: @"cust_params"]) {
            [optionParamsNew setValue: [self urlEncode: optionParams[key]] forKey: key];
        } else {
            [optionParamsNew setValue: optionParams[key]  forKey: key];
        }
    }
    
    
//    NSString * optionalParamsStr = [[NSString alloc] initWithData: [NSJSONSerialization dataWithJSONObject: optionalParams options: 0 error: nil] encoding:NSUTF8StringEncoding];
//
    self.toast = [ToastView new];
    
    self.adManager = [DisplayAdsManager shareInstance];
    self.adManager.delegate = self;
    
  DisplayAdInstance *banner1 = [self.adManager getAdBannerWithSlot: slot optionalParams: optionParamsNew];
    banner1.adView.frame = CGRectMake(20, 0, 320, 100);;
    banner1.adId = @"banner1";
    [self.mainScrollView addSubview: banner1.adView];
    
  DisplayAdInstance *banner2 = [self.adManager getAdBannerWithSlot: slot optionalParams: optionParamsNew];
    banner2.adView.frame = CGRectMake(20, 350, 320, 100);
    banner2.adId = @"banner2";
    [self.mainScrollView addSubview: banner2.adView];
    
  DisplayAdInstance *banner3 = [self.adManager getAdBannerWithSlot: slot optionalParams: optionParamsNew];
    banner3.adView.frame = CGRectMake(20, 650, 320, 100);
    banner3.adId = @"banner3";
    [self.mainScrollView addSubview: banner3.adView];
    
  DisplayAdInstance *banner4 = [self.adManager getAdBannerWithSlot: slot optionalParams: optionParamsNew];
    banner4.adView.frame = CGRectMake(20, 1050, 320, 100);
    banner4.adId = @"banner4";
    [self.mainScrollView addSubview: banner4.adView];
    
  DisplayAdInstance *banner5 = [self.adManager getAdBannerWithSlot: slot optionalParams: optionParamsNew];
    banner5.adView.frame = CGRectMake(20, 1400, 320, 100);
    banner5.adId = @"banner5";
    [self.mainScrollView addSubview: banner5.adView];
    
    
}


- (NSString *)urlEncode:(NSString *)from {
    NSCharacterSet *encodeSet = [NSCharacterSet characterSetWithCharactersInString:@"!*'();:@&=+$,/?%#[]"];
    NSString *encode = [from stringByAddingPercentEncodingWithAllowedCharacters:encodeSet];//编码
    return encode;
}

- (void)onAdLoadFinished:(DisplayAdInstance *)adInstance {
    
}

- (void)onRecordImpression:(DisplayAdInstance *)adInstance {
    [self.toast showMessage: [NSString stringWithFormat: @"%@ record impression finished", adInstance.adId]];
}

- (void)onRecordImpressionFailed:(DisplayAdError *)error instance:(DisplayAdInstance *)instance {
    [self.toast showMessage: @"ad record impression failed"];
}


@end
