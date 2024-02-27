//
//  ViewController.m
//  DisplayAdsManagerExample
//
//  Created by 王志忠 on 2024/2/26.
//

#import "ViewController.h"
#import <DisplayAdsManagerSDK/DisplayAdsManager.h>
#import "BannerConfigViewController.h"
#import "BannerTestListViewController.h"
#import "SplashConfigViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [[DisplayAdsManager shareInstance] setDisplayEndpoint: @"abc.hkai.io/display/v2" trackingEndpoint: @"abc-t.hkai.io/tracking/api/v1"];
}
- (IBAction)onPressedSplashConfig:(id)sender {
  [self.navigationController pushViewController: [SplashConfigViewController new] animated: YES];
}
- (IBAction)onPressedBannerConfig:(id)sender {
  [self.navigationController pushViewController: [BannerConfigViewController new] animated: YES];
}
- (IBAction)onPressedBannerList:(id)sender {
  [self.navigationController pushViewController: [BannerTestListViewController new] animated: YES];
}

@end
