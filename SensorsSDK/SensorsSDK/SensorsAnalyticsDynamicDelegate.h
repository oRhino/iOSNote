//
//  SensorsAnalyticsDynamicDelegate.h
//  SensorsSDK
//
//  Created by hx on 2021/5/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SensorsAnalyticsDynamicDelegate : NSObject

+ (void)proxyWithTableViewDelegate:(id<UITableViewDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
