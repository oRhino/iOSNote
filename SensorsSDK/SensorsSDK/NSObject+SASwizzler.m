//
//  NSObject+SASwizzler.m
//  SensorsSDK
//
//  Created by hx on 2021/5/11.
//

#import "NSObject+SASwizzler.h"
#import <objc/runtime.h>
#import <objc/message.h>


@implementation NSObject (SASwizzler)

/// 交换方法名为originalSEL 和方法名为alternateSEL两个方法的实现
/// @param originalSEL 原始方法名
/// @param alternateSEL 要交换的方法名
+ (BOOL)sensorsdata_swizzleMethod:(SEL)originalSEL withMethod:(SEL)alternateSEL{
    
    //获取原始方法
    Method originalMethod = class_getInstanceMethod(self, originalSEL);
    if (!originalMethod) {
        //方法不存在
        return NO;
    }
    
    Method alternateMethod = class_getInstanceMethod(self, alternateSEL);
    if (!alternateMethod) {
        return NO;
    }
    
    
    IMP originalIMP = method_getImplementation(originalMethod);
    const char *originalMethodType = method_getTypeEncoding(originalMethod);
    
    ///往类中添加originalSEL方法,如果已经存在,则添加失败,并返回NO
    if (class_addMethod(self, originalSEL, originalIMP, originalMethodType)) {
        //如果添加成功,重新获取originalSEL实例方法
        originalMethod = class_getInstanceMethod(self, originalSEL);
    }
    
    
    IMP alternateIMP = method_getImplementation(alternateMethod);
    const char *alternateMeethodType = method_getTypeEncoding(alternateMethod);
    if (class_addMethod(self, alternateSEL, alternateIMP, alternateMeethodType)) {
        alternateMethod = class_getInstanceMethod(self, alternateSEL);
    }
    
    
    method_exchangeImplementations(originalMethod, alternateMethod);
    return YES;
}


@end
