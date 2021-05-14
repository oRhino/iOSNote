//
//  TargetProxy.m
//  Demo
//
//  Created by hx on 2021/5/13.
//

#import "TargetProxy.h"

@interface TargetProxy()

@end

@implementation TargetProxy{
    id _realObject1;
    id _realObject2;
}

- (instancetype)initWithObject1:(id)object1 object2:(id)object2{
    _realObject1 = object1;
    _realObject2 = object2;
    return self;
}


- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel{
    
    //获取1的方法签名
    NSMethodSignature *signature = [_realObject1 methodSignatureForSelector:sel];
    //没有查看2
    if (signature) {
        return signature;
    }
    //获取_realObject2中sel的方法签名
    signature = [_realObject2 methodSignatureForSelector:sel];
    return signature;
}


- (void)forwardInvocation:(NSInvocation *)invocation{
    //获取拥有该方法的真实对象
    id target = [_realObject1 methodSignatureForSelector:[invocation selector]] ? _realObject1 : _realObject2;
    //执行方法
    [invocation invokeWithTarget:target];
}

@end
