//
//  SensorsAnalyticsDelegateProxy.h
//  SensorsSDK
//
//  Created by hx on 2021/5/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SensorsAnalyticsDelegateProxy : NSProxy<UITableViewDelegate,UICollectionViewDelegate>

+ (instancetype)proxyWithTableViewDelegate:(id<UITableViewDelegate>)delegate;

+ (instancetype)proxyWithCollectionViewDelegate:(id<UICollectionViewDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
