//
//  UIView+SensorsData.h
//  SensorsSDK
//
//  Created by hx on 2021/5/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - UIButton

@interface UIButton(SensorsData)

@end

@interface UILabel(SensorsData)

@end


@interface UISwitch(SensorsData)

@end


@interface UISlider(SensorsData)

@end


@interface UISegmentedControl(SensorsData)

@end


@interface UIStepper(SensorsData)

@end


@interface UIView (SensorsData)

@property(nonatomic, copy, readonly) NSString *sensorsdata_elementType;
@property(nonatomic, copy, readonly) NSString *sensorsdata_elementContent;
@property(nonatomic, readonly) UIViewController *sensorsdata_viewcontroller;

@end

NS_ASSUME_NONNULL_END


