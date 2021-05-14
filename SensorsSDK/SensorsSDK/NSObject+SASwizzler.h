//
//  NSObject+SASwizzler.h
//  SensorsSDK
//
//  Created by hx on 2021/5/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (SASwizzler)


/// 交换方法名为originalSEL 和方法名为alternateSEL两个方法的实现
/// @param originalSEL 原始方法名
/// @param alternateSEL 要交换的方法名
+ (BOOL)sensorsdata_swizzleMethod:(SEL)originalSEL withMethod:(SEL)alternateSEL;


@end

NS_ASSUME_NONNULL_END
