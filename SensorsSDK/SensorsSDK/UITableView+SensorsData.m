//
//  UITableView+SensorsData.m
//  SensorsSDK
//
//  Created by hx on 2021/5/12.
//

#import "UITableView+SensorsData.h"
#import "NSObject+SASwizzler.h"
#import <objc/message.h>
#import "SensorsAnalyticsSDK.h"
#import "SensorsAnalyticsDynamicDelegate.h"
#import "SensorsAnalyticsDelegateProxy.h"
#import "UIScrollView+SensorsData.h"


static void sensorsdata_tableViewDidSelecctRow(id object,SEL selector,UITableView *tableView,NSIndexPath *indexPath){
    
    SEL destinationSelector = NSSelectorFromString(@"sensorsdata_tableView:didSelectRowAtIndexPath:");
    ((void(*)(id,SEL,id,id))objc_msgSend)(object,destinationSelector,tableView,indexPath);
    
    [[SensorsAnalyticsSDK sharedInstance] trackAppClickWithTableView:tableView didSelectRowAtIndexPath:indexPath properties:nil];
}


@implementation UITableView (SensorsData)

+ (void)load{
    [UITableView sensorsdata_swizzleMethod:@selector(setDelegate:) withMethod:@selector(sensorsdata_setDelegate:)];
}

- (void)sensorsdata_setDelegate:(id<UITableViewDelegate>)delegate{
    
//    [self sensorsdata_setDelegate:delegate];
    
//    //方法交换 ---- 方案一
//    //交换delegate对象中的tableView:didSelectedRowAtIndexPath:方法
//    [self sensorsdata_swizzleDidSelectRowAtIndexPathMethodWithDelegate:delegate];
//    1.简单、易理解;Method Swizzling属于成熟技术，性能相对来说较高。
//    2.对原始类有入侵，容易造成冲突。
    
//    ///方案二 生成动态子类
//    [SensorsAnalyticsDynamicDelegate proxyWithTableViewDelegate:delegate];
//    1.没有对原始类入侵，不会修改原始类的方法，不会和第三方库冲突，是一种比较稳定的方案。
//    2.动态创建子类对性能和内存有比较大的消耗。
    
    ///方案三: 消息转发
    /// NSProxy类不是继承自NSObject类或者NSObject子类，而是一 个实现了NSObject协议的抽象基类。
    /// 作为一个委托代理对 象，将消息转发给一个真实的对象或者自己加载的对象。模拟多继承
//    优点:充分利用消息转发机制，对消息进行 拦截，性能较好。
//    缺点:容易与一些同样使用消息转发进行拦 截的第三方库冲突，例如ReactiveCocoa。
    
    //销毁保存的委托对象
    self.sensorsdata_delegateProxy = nil;
    if (delegate) {
        //保存委托对象
        SensorsAnalyticsDelegateProxy *proxy = [SensorsAnalyticsDelegateProxy proxyWithTableViewDelegate:delegate];
        self.sensorsdata_delegateProxy = proxy;
        //调用原始方法,将代理设置为委托对象
        [self sensorsdata_setDelegate:proxy];
    }else{
        //调用原始方法,将代理设置为nil
        [self sensorsdata_setDelegate:nil];
    }
}


- (void)sensorsdata_swizzleDidSelectRowAtIndexPathMethodWithDelegate:(id)delegate{
   
    //获取delegate对象的类
    Class delegateClass = [delegate class];
    
    //方法名
    SEL sourceSelector = @selector(tableView:didSelectRowAtIndexPath:);
    //代理没有实现tableView:didSelectRowAtIndexPath: 直接返回
    if (![delegate respondsToSelector:sourceSelector]) {
        return;
    }
    
    SEL destinationSelector = NSSelectorFromString(@"sensorsdata_tableView:didSelectRowAtIndexPath:");
   //当对象已经存在了sensorsdata_tableView:didSelectRowAtIndexPath:方法,直接返回
    if ([delegate respondsToSelector:destinationSelector]) {
        return;
    }
    
    Method sourceMethod = class_getInstanceMethod(delegateClass, sourceSelector);
    const char *encoding = method_getTypeEncoding(sourceMethod);
    //当该类中已经存在相同的方法,则添加方法失败.但是前面已经判断过是否存在,因此,此处一定会添加成功
    if (!class_addMethod([delegate class], destinationSelector, (IMP)sensorsdata_tableViewDidSelecctRow, encoding)) {
        NSLog(@"ADD %@ to %@ error",NSStringFromSelector(sourceSelector),[delegate class]);
        return;
    }
    
    //方法添加成功之后,进行方法交换
    [delegateClass sensorsdata_swizzleMethod:sourceSelector withMethod:destinationSelector];
}



@end
