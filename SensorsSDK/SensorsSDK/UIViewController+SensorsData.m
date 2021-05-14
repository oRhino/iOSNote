//
//  UIVewController+SensorsData.m
//  SensorsSDK
//
//  Created by hx on 2021/5/11.
//

#import "UIViewController+SensorsData.h"
#import "SensorsAnalyticsSDK.h"
#import "NSObject+SASwizzler.h"

static NSString * const kSensorsDataBlackListFileName = @"sensorsdata_black_list";

@implementation UIViewController (SensorsData)

//在类或者类别被加载到 Objective-C时执行的。如果在+load类方法中实现Method Swizzling，替换的 方法会在应用程序运行的整个生命周期中生效
+ (void)load{
    
    [UIViewController sensorsdata_swizzleMethod:@selector(viewDidAppear:) withMethod:@selector(sensorsdata_viewDidAppear:)];
}

- (void)sensorsdata_viewDidAppear:(BOOL)animated{
    
    //调用原始方法
    [self sensorsdata_viewDidAppear:animated];
    
    if ([self shouldTrackAppViewScreen]) {
        NSMutableDictionary *properties = [[NSMutableDictionary alloc]init];
        [properties setValue:NSStringFromClass([self class]) forKey:@"$screen_name"];
        NSString *title = [self contentFromView:self.navigationItem.titleView];
        if (title.length == 0) {
            title = self.navigationItem.title;
        }
        [properties setValue:title forKey:@"$title"];
        [[SensorsAnalyticsSDK sharedInstance] track:@"$AppViewScreen" properties:properties];
    }

}

- (BOOL)shouldTrackAppViewScreen{
    
    static NSSet *blackList = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        //获取黑名单文件路径
        NSString *path = [[NSBundle bundleForClass:SensorsAnalyticsSDK.class] pathForResource:kSensorsDataBlackListFileName ofType:@"plist"];
        //读取文件中黑名单类名数组
        NSArray *classNames = [NSArray arrayWithContentsOfFile:path];
        NSMutableSet *set = [NSMutableSet setWithCapacity:classNames.count];
        for (NSString *className in classNames) {
            [set addObject:NSClassFromString(className)];
        }
        blackList = [set copy];
    });
    
    for (Class cla in blackList) {
        if ([self isKindOfClass:cla]) {
            return NO;
        }
    }
    return YES;
}

- (NSString *)contentFromView:(UIView *)rootView{
    if (rootView.isHidden) {
        return nil;
    }
    NSMutableString *elementContent = [NSMutableString string];
    
    if ([rootView isKindOfClass:[UIButton class]]) {
        UIButton *button = (UIButton *)rootView;
        NSString *title = button.titleLabel.text;
        if (title.length > 0) {
            [elementContent appendString:title];
        }
    }else if ([rootView isKindOfClass:[UILabel class]]){
        UILabel *label = (UILabel *)rootView;
        NSString *title = label.text;
        if (title.length > 0) {
            [elementContent appendString:title];
        }
    }else if ([rootView isKindOfClass:[UITextView class]]){
        UITextView *textView = (UITextView *)rootView;
        NSString *title = textView.text;
        if (title.length > 0) {
            [elementContent appendString:title];
        }
    }else{
        NSMutableArray<NSString *> *elementContentArray = [NSMutableArray array];
        for (UIView *subview in rootView.subviews) {
            NSString *temp = [self contentFromView:subview];
            if (temp.length > 0) {
                [elementContentArray addObject:temp];
            }
        }
        
        if (elementContentArray.count > 0) {
            [elementContent appendString:[elementContentArray componentsJoinedByString:@"-"]];
        }
        
    }
    
    return [elementContent copy];
}


@end
