//
//  TargetProxy.h
//  Demo
//
//  Created by hx on 2021/5/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TargetProxy : NSProxy

- (instancetype)initWithObject1:(id)object1 object2:(id)object2;

@end

NS_ASSUME_NONNULL_END
