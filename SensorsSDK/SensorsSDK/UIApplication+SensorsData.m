//
//  UIApplication+SensorsData.m
//  SensorsSDK
//
//  Created by hx on 2021/5/11.
//

#import "UIApplication+SensorsData.h"
#import "SensorsAnalyticsSDK.h"
#import "NSObject+SASwizzler.h"

@implementation UIApplication (SensorsData)

//+ (void)load{
//    [UIApplication sensorsdata_swizzleMethod:@selector(sendAction:to:from:forEvent:) withMethod:@selector(sensorsdata_sendAction:to:from:forEvent:)];
//}


- (BOOL)sensorsdata_sendAction:(SEL)action to:(nullable id)target from:(nullable id)sender forEvent:(UIEvent *)event{
    
    //fix:UISlider会触发多次
    //uiswitch 只会触发began
    if ([sender isKindOfClass:[UISwitch class]] ||
        [sender isKindOfClass:[UISegmentedControl class]] ||
        [sender isKindOfClass:[UIStepper class]] ||
        event.allTouches.anyObject.phase == UITouchPhaseEnded) {
        [[SensorsAnalyticsSDK sharedInstance] tracckAppClickWithView:sender properties:nil];
    }
    
    //调用原有实现，即- sendAction:to:from:forEvent: 方法
    return [self sensorsdata_sendAction:action to:target from:sender forEvent:event];
}



@end
