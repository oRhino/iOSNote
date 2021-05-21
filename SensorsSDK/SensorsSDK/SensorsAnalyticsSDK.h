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


@interface SensorsAnalyticsSDK(Timer)



/// 系统启动时间
+ (double)systemUpTime;

/// 开始统计事件时长
/// 调用这个接口时,并不会真正触发一次事件,只是开始计时
/// @param event 事件名
- (void)trackTimerStart:(NSString *)event;



/// 结束事件时长统计,计算时长
/// trackTimerStart: - trackTimerEnd: 如果多次调用trackTimerStart:  按最后一次,如果没有调用trackTimerStart:  按普通事件处理
/// @param event 事件名
/// @param properties 事件属性
- (void)trackTimerEnd:(NSString *)event properties:(nullable NSDictionary *)properties;


/// 暂停统计事件时长
/// 如果该事件未开始,既没有调用-trackStart:方法,则不作任何操作
/// @param event 事件名
- (void)trackTimerPause:(NSString *)event;

/// 恢复统计事件时长
/// 如果该事件并没暂停,既没有调用-trackTimerPause:方法,则没有影响
/// @param event 事件名
- (void)trackTimerResume:(NSString *)event;


@end
NS_ASSUME_NONNULL_END
