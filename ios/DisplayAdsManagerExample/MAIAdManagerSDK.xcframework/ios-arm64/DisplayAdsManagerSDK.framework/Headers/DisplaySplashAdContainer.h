//
//  DsiplaySplashAdContainer.h
//  DisplayAdsManagerSDK
//
//  Created by 王志忠 on 2024/2/26.
//

#import <UIKit/UIKit.h>
#import <DisplayAdsManagerSDK/DisplayAdView.h>
NS_ASSUME_NONNULL_BEGIN

@interface DisplaySplashAdContainer : UIView

@property (nonatomic, strong) UIView *adView;
- (instancetype)initWithSplashAdView: (UIView *)adView;
- (void)hideView;
- (void)showView;

@end

NS_ASSUME_NONNULL_END
