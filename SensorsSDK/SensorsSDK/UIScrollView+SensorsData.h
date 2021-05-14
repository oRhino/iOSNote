//
//  UIScrollView+SensorsData.h
//  SensorsSDK
//
//  Created by hx on 2021/5/13.
//

#import <UIKit/UIKit.h>
#import "SensorsAnalyticsDelegateProxy.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (SensorsData)

@property(nonatomic, strong, nullable) SensorsAnalyticsDelegateProxy *sensorsdata_delegateProxy;


@end

NS_ASSUME_NONNULL_END
