//
//  SensorsAnalyticsSDK.h
//  SensorsSDK
//
//  Created by hx on 2021/2/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SensorsAnalyticsSDK : NSObject

+ (SensorsAnalyticsSDK *)sharedInstance;

@end


@interface SensorsAnalyticsSDK(Track)


/// 触发事件
/// @param eventName 事件名称
/// @param properties 事件属性 key是属性的名称,value则是事件的内容
- (void)track:(NSString *)eventName properties:(nullable NSDictionary<NSString *,id> *)properties;


/// 触发点击事件
/// @param view 控件
/// @param properties 自定义事件属性
- (void)tracckAppClickWithView:(UIView *)view properties:(nullable NSDictionary<NSString *,id> *)properties;



/// UITablview触发$APPClick事件
/// @param tableview -
/// @param indexPath -
/// @param properties 自定义事件属性
- (void)trackAppClickWithTableView:(UITableView *)tableview
           didSelectRowAtIndexPath:(NSIndexPath *)indexPath
                        properties:(nullable NSDictionary<NSString *,id> *)properties;

/// UICollectionView触发$APPClick事件
/// @param collectionView  -
/// @param indexPath -
/// @param properties 自定义事件属性
- (void)trackAppClickWithCollectionView:(UICollectionView *)collectionView
               didSelectItemAtIndexPath:(NSIndexPath *)indexPath
                             properties:(nullable NSDictionary<NSString *,id> *)properties;

@end
NS_ASSUME_NONNULL_END
