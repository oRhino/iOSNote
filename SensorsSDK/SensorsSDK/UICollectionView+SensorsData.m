//
//  UICollectionView+SensorsData.m
//  SensorsSDK
//
//  Created by hx on 2021/5/13.
//

#import "UICollectionView+SensorsData.h"
#import "NSObject+SASwizzler.h"
#import "SensorsAnalyticsDelegateProxy.h"
#import "UIScrollView+SensorsData.h"

@implementation UICollectionView (SensorsData)


+ (void)load{
    [UICollectionView sensorsdata_swizzleMethod:@selector(setDelegate:) withMethod:@selector(sensorsdata_setDelegate:)];
}

- (void)sensorsdata_setDelegate:(id<UICollectionViewDelegate>)delegate{
    SensorsAnalyticsDelegateProxy *proxy = [SensorsAnalyticsDelegateProxy proxyWithCollectionViewDelegate:delegate];
    self.sensorsdata_delegateProxy = proxy;
    [self sensorsdata_setDelegate:proxy];
}

    
@end
