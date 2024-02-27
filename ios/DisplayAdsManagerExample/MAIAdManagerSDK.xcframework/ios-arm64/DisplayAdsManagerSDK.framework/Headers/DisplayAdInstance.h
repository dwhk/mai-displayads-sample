//
//  DisplayAdInstance.h
//  DisplayAdsManagerSDK
//
//  Created by 王志忠 on 2024/2/26.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <DisplayAdsManagerSDK/DisplayAdError.h>
#import <DisplayAdsManagerSDK/DisplayAdsManager.h>
NS_ASSUME_NONNULL_BEGIN
@class DisplayAdInstance;
@protocol DisplayAdInstanceDelegate <NSObject>

@optional
///All ad error will be here
- (void)onAdLoadFailed:(DisplayAdError *)error instance: (DisplayAdInstance *)instance;
///Ad request finished
- (void)onAdRequestFinished: (DisplayAdInstance *)adInstance;
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

@interface DisplayAdInstance : NSObject
@property (nonatomic, strong) DisplayAdView *adView;
///banner  or splash
@property (nonatomic, strong) NSString *adType;
@property (nonatomic, strong) NSString *targetId;
@property (nonatomic, strong) NSString *adId;
@property (nonatomic) CGSize adSize;

@property(nonatomic, weak)id <DisplayAdInstanceDelegate> delegate;

- (instancetype)initAdInstanceWithAdManager:(DisplayAdsManager *)manager type: (NSString *)adType slot:(NSDictionary *)slot optionalParams:(NSDictionary *)optionalParams;
- (void)positionDetect;
- (void)fetchAd;
@end

NS_ASSUME_NONNULL_END
