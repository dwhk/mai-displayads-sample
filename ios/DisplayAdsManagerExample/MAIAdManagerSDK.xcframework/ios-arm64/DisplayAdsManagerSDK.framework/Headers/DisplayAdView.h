//
//  DisplayAdView.h
//  DisplayAdsManagerSDK
//
//  Created by 王志忠 on 2024/2/26.
//
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
NS_ASSUME_NONNULL_BEGIN

typedef void (^DisplayAdRenderErrorHandler)(NSInteger errorType, NSError*  __nullable error);
typedef void (^DisplayAdRenderCompletionHandler)(NSString *targetAdId);
typedef void (^DisplayAdOnPressedAdView)(NSString *requestUrl);
typedef void (^DisplayAdOnPressedCloseMenu)(NSString *targetAdId);

@interface DisplayAdView : UIView<WKNavigationDelegate>

@property (nonatomic, copy) DisplayAdRenderErrorHandler adRenderErrorHandler;
@property (nonatomic, copy) DisplayAdRenderCompletionHandler adRenderCompletionHandler;
@property (nonatomic, copy) DisplayAdOnPressedAdView onAdViewPressed;
@property (nonatomic, copy) DisplayAdOnPressedCloseMenu onCloseMenuPressed;

- (instancetype)initWithAdSize: (CGSize)adSize;
- (void)loadAd: (NSString *)url;

@end

NS_ASSUME_NONNULL_END
