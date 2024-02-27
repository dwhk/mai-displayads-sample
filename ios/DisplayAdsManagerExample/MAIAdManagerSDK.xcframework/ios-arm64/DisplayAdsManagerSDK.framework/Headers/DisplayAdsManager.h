//
//  DisplayAdsManager.h
//  DisplayAdsManagerSDK
//
//  Created by 王志忠 on 2024/2/26.
//

#import <Foundation/Foundation.h>
#import <DisplayAdsManagerSDK/DisplayAdView.h>
#import <DisplayAdsManagerSDK/DisplayAdError.h>
NS_ASSUME_NONNULL_BEGIN

@class DisplayAdInstance;
@protocol DisplayAdsManagerDelegate <NSObject>

@optional
///All ad error will be here
- (void)onAdLoadFailed:(DisplayAdError *)error instance: (DisplayAdInstance *)instance;
///Ad request finished
- (void)onAdLoadFinished: (DisplayAdInstance *)adInstance;
///Ad view render finished
- (void)onAdRenderFinished: (DisplayAdInstance *)adInstance;
///Ad view on call impression
- (void)onRecordImpression: (DisplayAdInstance *)adInstance;
///
- (void)onRecordImpressionFailed: (DisplayAdError *)error instance: (DisplayAdInstance *)instance;
///Ad view pressed
- (void)onAdPressed: (UIView *)adView targetAdId: (NSString *)targetAdId requestUrl: (NSString *)requestUrl;
///If Ad contains close button & pressed
- (void)onAdClosed: (UIView *)adView targetAdId: (NSString *)targetAdId;
///When slot ad size not equal with Ad request response size call back
- (void)onAdSizeChanged: (DisplayAdInstance *)adInstance;

@end

@interface DisplayAdsManager : NSObject
@property (nonatomic, strong) NSString *displayEndpoint;
@property (nonatomic, strong) NSString *trackingEndpoint;
@property (nonatomic, weak) id<DisplayAdsManagerDelegate> delegate;
//@property (nonatomic) NSInteger splashTimeOut;

+ (id)shareInstance;
- (void)setDisplayEndpoint: (NSString *)displayEndpoint trackingEndpoint: (NSString *)trackingEndpoint;

- (void )initSpalshAdWithSlot: (NSDictionary *)slot optionalParams: (NSDictionary *)optionalParams;

- (DisplayAdInstance *)getAdBannerWithSlot: (NSDictionary *)slot optionalParams: (NSDictionary *)optionalParams;

- (void)showSplash;
- (void)hideSplash;

@end

NS_ASSUME_NONNULL_END
