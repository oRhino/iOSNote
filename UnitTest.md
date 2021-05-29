UnitTest:

1.单元测试同样需要运行APP,执行didFinishLaunchingWithOptions的方法,其中有些逻辑对于单元测试是不需要的,那么如何避免无效的代码执行路径呢? 
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
2. 如何在项目中集成XCTest?
 在xcode的安装目录是可以看到XCTest.framework,运行的XCTest工程应该也是通过链接framework的方式运行的,可以借鉴这个思路,在主工程中建立xcconfig文件来指定链接器参数.
 
 ```
 ///这里链接的模拟器的
HEADER_SEARCH_PATHS = $(inherited) "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/Library/Frameworks/XCTest.framework/Headers"

OTHER_LDFLAGS = $(inherited) -F"/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/Library/Frameworks" -framework "XCTest"

LD_RUNPATH_SEARCH_PATHS = $(inherited) "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/Library/Frameworks"
 ```

XCTestSuite允许你动态创建测试用例

```
    XCTestSuite *suite = [XCTestSuite testSuiteWithName:@"My tests"];
    [suite addTest:[MathTest testCaseWithSelector:@selector(testAdd)]];
     for (XCTest *test in suite.tests) {
        [test runTest];
    }
    
```
