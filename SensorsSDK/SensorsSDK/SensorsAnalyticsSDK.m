//
//  SensorsAnalyticsSDK.m
//  SensorsSDK
//
//  Created by hx on 2021/2/7.
//

#import "SensorsAnalyticsSDK.h"
#include <sys/sysctl.h>
#import "UIView+SensorsData.h"

static NSString * const SensorsAnalyticsVersion = @"1.0.0";

@interface SensorsAnalyticsSDK()

/// 预置属性 SDK默认自动采集的事件属性
@property(nonatomic, strong) NSDictionary <NSString *,id>* automaticProperties;

/// 标记应用程序是否已收到UIApplicationWillResignActiveNotification本地通知
@property(nonatomic, assign) BOOL applicationWillResignActive;
/// 是否为被动启动
@property(nonatomic, getter=isLaunchedPassively) BOOL launchedPassively;

@end


@implementation SensorsAnalyticsSDK

+ (SensorsAnalyticsSDK *)sharedInstance{
    static dispatch_once_t once;
    static SensorsAnalyticsSDK *single = nil;
    dispatch_once(&once, ^{
        single = [[SensorsAnalyticsSDK alloc]init];
    });
    return single;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _automaticProperties = [self collectAutomaticProperties];
        
        //设置是否被动启动标记
        _launchedPassively = UIApplication.sharedApplication.backgroundTimeRemaining != UIApplicationBackgroundFetchIntervalNever;
        [self setupListeners];
    }
    return self;
}

- (NSDictionary<NSString *,id> *)collectAutomaticProperties{
    NSMutableDictionary *properties = [[NSMutableDictionary alloc]init];
    //操作系统类型
    properties[@"$os"] = @"iOS";
    //SDK平台类型
    properties[@"$lib"] = @"iOS";
    //设备制造商
    properties[@"$manufacturer"] = @"Apple";
    //SDK版本号
    properties[@"$lib_version"] = SensorsAnalyticsVersion;
    //手机型号
    properties[@"$model"] = [self deviceModel];
    //操作系统版本号
    properties[@"$os_version"] = UIDevice.currentDevice.systemVersion;
    //应用程序版本号
    properties[@"$app_version"] = NSBundle.mainBundle.infoDictionary[@"CFBundleShortVersionString"];
    
    return [properties copy];
}

//获取手机型号
- (NSString *)deviceModel{
    
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char answer[size];
    sysctlbyname("hw.machine", answer, &size, NULL, 0);
    NSString *results = @(answer);
    return results;
}
- (void)printEvent:(NSDictionary *)event {
#if DEBUG
    
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:event options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        return NSLog(@"JSON Serialized Error: %@",error);
    }
    NSString *json = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"[Event]: %@",json);
#endif
}


#pragma mark - Application LifeCycle
- (void)setupListeners{
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    //监听应用进入后台
    [center addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    //监听应用启动<下拉显示通知栏,上滑关闭显示通知栏,显示控制中心关闭之后,也会调用>
    [center addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [center addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification
                 object:nil];
    [center addObserver:self selector:@selector(applicationDidFinishLaunching:) name:UIApplicationDidFinishLaunchingNotification object:nil];
}

- (void)applicationDidEnterBackground:(NSNotification *)notification{
    NSLog(@"applicationDidEnterBackground");
    
    [self track:@"$APPEnd" properties:nil];
}

// 下拉通知栏并上滑，会触发$AppStart事件。
// 上滑控制中心并下拉，会触发$AppStart事件。
// 双击Home键进入切换应用程序页面，最后又选择当前应用程序，会触发$AppStart事件。

- (void)applicationDidBecomeActive:(NSNotification *)notification{
    NSLog(@"applicationDidBecomeActive");

    ///还原标记位
    if (self.applicationWillResignActive) {
        self.applicationWillResignActive = NO;
        return;
    }
    
    //将被动启动标记设置为NO,正常记录事件
    self.launchedPassively = NO;
    
    //触发$AppStart事件
    [self track:@"$APPStart" properties:nil];
}

- (void)applicationWillResignActive:(NSNotification *)notification{
    self.applicationWillResignActive = YES;
}

///正常启动的冷启动也会执行
/// @property(nonatomic,readonly) NSTimeInterval backgroundTimeRemaining API_AVAILABLE(ios(4.0));
/// 表示 APP被系统强杀之前,还能继续在后台运行的时间
/// 当APP进入前台运行时,backgroundTimeRemaining会被设置为UIApplicationBackgroundFetchIntervalNever
/// 当APP启动时backgroundTimeRemaining != UIApplicationBackgroundFetchIntervalNever 就意味着APP是被动启动的
- (void)applicationDidFinishLaunching:(NSNotification *)notification{
    NSLog(@"applicationDidFinishLaunching");
    
    ///当app在后台运行时,触发被动启动事件
    if (self.isLaunchedPassively) {
        //触发被动启动事件
        [self track:@"$AppStartPassively" properties:nil];
    }
    
}
/// 模拟系统自启动
/// 1. target的capabilities开启Background Modes ,勾选Background Fetch
/// 2. scheme->run ->options -> 勾选Background Fetch
/// 3. command + r 运行,可以看到图标闪了一下

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


@end



@implementation SensorsAnalyticsSDK(Track)

/// 触发事件
/// @param eventName 事件名称
/// @param properties 事件属性 key是属性的名称,value则是事件的内容
- (void)track:(NSString *)eventName properties:(nullable NSDictionary<NSString *,id> *)properties{
    NSMutableDictionary *event = [NSMutableDictionary dictionary];
    //设置事件名称
    event[@"event"] = eventName;
    //设置事件发生的时间戳,单位为毫秒
    event[@"time"] = [NSNumber numberWithLong:NSDate.date.timeIntervalSince1970 * 1000];
    
    
    NSMutableDictionary *eventProperties = [NSMutableDictionary dictionary];
    //添加预置属性
    [eventProperties addEntriesFromDictionary:self.automaticProperties];
    //添加自定义属性
    [eventProperties addEntriesFromDictionary:properties];
    
    //判断是否为被动启动状态
    if (self.isLaunchedPassively) {
        ///添加应用程序状态属性
        eventProperties[@"$app_state"] = @"backgroound";
    }
    
    //设置事件属性
    event[@"properties"] = eventProperties;
    //打印日志
    [self printEvent:event];
}



/// 触发点击事件
/// @param view 控件
/// @param properties 自定义事件属性
- (void)tracckAppClickWithView:(UIView *)view properties:(nullable NSDictionary<NSString *,id> *)properties{
    
    NSMutableDictionary *eventProperties = [NSMutableDictionary dictionary];
    
    //获取控件类型
    eventProperties[@"$element_type"] = view.sensorsdata_elementType;
    //获取控件显示文本
    eventProperties[@"$element_content"] = view.sensorsdata_elementContent;
    
    UIViewController *vc = view.sensorsdata_viewcontroller;
    eventProperties[@"$screen_name"] = NSStringFromClass([vc class]);
    
    //添加自定义属性
    [eventProperties addEntriesFromDictionary:properties];
   
    //触发事件
    [[SensorsAnalyticsSDK sharedInstance] track:@"$AppClick" properties:eventProperties];
    
}


/// UITablview触发$APPClick事件
/// @param tableview -
/// @param indexPath -
/// @param properties 自定义事件属性
- (void)trackAppClickWithTableView:(UITableView *)tableview
           didSelectRowAtIndexPath:(NSIndexPath *)indexPath
                        properties:(nullable NSDictionary<NSString *,id> *)properties{
    NSMutableDictionary *eventProperties = [NSMutableDictionary dictionary];
    
    
    UITableViewCell *cell = [tableview cellForRowAtIndexPath:indexPath];
    eventProperties[@"$element_content"] = cell.sensorsdata_elementContent;
    eventProperties[@"$element_position"] = [NSString stringWithFormat:@"%ld:%ld",(long)indexPath.section,(long)indexPath.row];
    
    [eventProperties addEntriesFromDictionary:properties];
    [[SensorsAnalyticsSDK sharedInstance] tracckAppClickWithView:tableview properties:eventProperties];
}

/// UICollectionView触发$APPClick事件
/// @param collectionView  -
/// @param indexPath -
/// @param properties 自定义事件属性
- (void)trackAppClickWithCollectionView:(UICollectionView *)collectionView
               didSelectItemAtIndexPath:(NSIndexPath *)indexPath
                             properties:(nullable NSDictionary<NSString *,id> *)properties{
    
    NSMutableDictionary *eventProperties = [NSMutableDictionary dictionary];
    
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    eventProperties[@"$element_content"] = cell.sensorsdata_elementContent;
    eventProperties[@"$element_position"] = [NSString stringWithFormat:@"%ld:%ld",(long)indexPath.section,(long)indexPath.row];
    
    [eventProperties addEntriesFromDictionary:properties];
    [[SensorsAnalyticsSDK sharedInstance] tracckAppClickWithView:collectionView properties:eventProperties];
    
}

@end













