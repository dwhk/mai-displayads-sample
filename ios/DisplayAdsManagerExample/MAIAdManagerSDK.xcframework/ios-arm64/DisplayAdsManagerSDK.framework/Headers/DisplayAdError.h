//
//  DisplayAdError.h
//  DisplayAdsManagerSDK
//
//  Created by 王志忠 on 2024/2/26.
//
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DisplayAdError : NSObject

@property (nonatomic) NSInteger errorCode;
@property (nonatomic, strong) NSString *errorMessage;

+ (DisplayAdError *)initWithCode: (NSInteger)code message: (NSString *)message;

@end

NS_ASSUME_NONNULL_END
