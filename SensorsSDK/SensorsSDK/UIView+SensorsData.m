//
//  UIView+SensorsData.m
//  SensorsSDK
//
//  Created by hx on 2021/5/12.
//

#import "UIView+SensorsData.h"

@implementation UIButton(SensorsData)

- (NSString *)sensorsdata_elementContent{
    return self.currentTitle ?: [super sensorsdata_elementContent];
}

@end

@implementation UILabel(SensorsData)

- (NSString *)sensorsdata_elementContent{
    return self.text ?: [super sensorsdata_elementContent];
}

@end

@implementation UISwitch(SensorsData)

- (NSString *)sensorsdata_elementContent{
    return self.on ? @"checked": @"unchecked";
}


@end


@implementation UISlider(SensorsData)

- (NSString *)sensorsdata_elementContent{
    return [NSString stringWithFormat:@"%.2f",self.value];
}

@end


@implementation UISegmentedControl(SensorsData)

- (NSString *)sensorsdata_elementContent{
    return [self titleForSegmentAtIndex:self.selectedSegmentIndex];
}

@end


@implementation UIStepper(SensorsData)

- (NSString *)sensorsdata_elementContent{
    return [NSString stringWithFormat:@"%.2f",self.value];
}

@end



@implementation UIView (SensorsData)


- (NSString *)sensorsdata_elementType{
    return NSStringFromClass([self class]);
}

- (NSString *)sensorsdata_elementContent{
    //隐藏控件 不获取控件内容
    if (self.isHidden || self.alpha == 0) {
        return nil;
    }
    
    //
    NSMutableArray *contents = [NSMutableArray array];
    for (UIView *view in self.subviews) {
        NSString *content = view.sensorsdata_elementContent;
        if (content.length > 0) {
            [contents addObject:content];
        }
    }
    return contents.count == 0 ? nil : [contents componentsJoinedByString:@"-"];
}

- (UIViewController *)sensorsdata_viewcontroller{
    UIResponder *responder = self;
    while ((responder = [responder nextResponder])) {
        if ([responder isKindOfClass:[UIViewController class]]) {
            return  (UIViewController *)responder;
        }
    }
    return nil;
}

@end


