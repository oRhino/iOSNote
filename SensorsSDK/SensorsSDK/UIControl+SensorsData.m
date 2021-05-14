//
//  UIControl+SensorsData.m
//  SensorsSDK
//
//  Created by hx on 2021/5/12.
//

#import "UIControl+SensorsData.h"
#import "NSObject+SASwizzler.h"
#import "SensorsAnalyticsSDK.h"

@implementation UIControl (SensorsData)

+ (void)load{
    [UIControl sensorsdata_swizzleMethod:@selector(didMoveToSuperview) withMethod:@selector(sensorsdata_didMoveToSuperview)];
}

- (void)sensorsdata_didMoveToSuperview{
    //调用交换前的原始方法实现
    [self sensorsdata_didMoveToSuperview];
    
    
    if ([self isKindOfClass:[UISwitch class]] ||
        [self isKindOfClass:[UISegmentedControl class]] ||
        [self isKindOfClass:[UIStepper class]] ||
        [self isKindOfClass:[UISlider class]] ) {
        [self addTarget:self action:@selector(sensorsdata_valueChangedAction:event:) forControlEvents:UIControlEventValueChanged];
    }else{
        [self addTarget:self action:@selector(sensorsdata_touchDownAction:event:) forControlEvents:UIControlEventTouchDown];
    }
}

- (void)sensorsdata_valueChangedAction:(UIControl *)sender event:(UIEvent *)event{
    
    if ([sender isKindOfClass:[UISlider class]] && event.allTouches.anyObject.phase != UITouchPhaseEnded) {
        return;
    }
    if ([self sensorsdata_isAddMultipleTargetActionsWithDefaultControlEvent:UIControlEventValueChanged]) {
        [[SensorsAnalyticsSDK sharedInstance] tracckAppClickWithView:sender properties:nil];
    }
}

- (void)sensorsdata_touchDownAction:(UIControl *)sender event:(UIEvent *)event{
    
    if ([self sensorsdata_isAddMultipleTargetActionsWithDefaultControlEvent:UIControlEventTouchDown]) {
        [[SensorsAnalyticsSDK sharedInstance] tracckAppClickWithView:sender properties:nil];
    }
    
}

- (BOOL)sensorsdata_isAddMultipleTargetActionsWithDefaultControlEvent:(UIControlEvents)defaultControlEvent {
    // 如果有多个Target ，说明除了添加的Target，还有其他 // 那么返回YES，触发$AppClick事件
    if (self.allTargets.count >= 2) {
        return YES;
    }
    
    // 如果控件控件本身为Target，并且添加了不是UIControlEventTouchDown类型的Action
    // 说明开发者以控件本身为Target，并且已添加Action
    // 那么返回YES，触发$AppClick事件
    if ((self.allControlEvents & UIControlEventAllTouchEvents) != defaultControlEvent) {
        return YES;
        
    }
    
    // 如果控件本身为Target，并添加了两个以上的UIControlEventTouchDown类型的Action
    // 说明开发者自行添加了Action
    // 那么返回YES，触发$AppClick事件
    if ([self actionsForTarget:self forControlEvent:UIControlEventTouchDown].count >= 2) {
        return YES;
        
    }
    return NO;
}

@end
