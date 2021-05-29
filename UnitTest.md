UnitTest:

单元测试同样需要运行APP,执行didFinishLaunchingWithOptions的方法,其中有些逻辑对于单元测试是不需要的,那么如何避免无效的代码执行路径呢? 
其实可以通过runtime,在main函数中,通过NSClassFromString(@"XCTest"),判断是否加载XCTest.framework,来新生成一个无业务入侵的AppDelegate.

```
int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        id cls = NSClassFromString(@"XCTest");
        appDelegateClassName = cls ?  @"UnitTestAppDelgate" : NSStringFromClass([AppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
```
