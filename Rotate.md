1.App支持哪些方向?
 info.plist勾选的方向?APP会默认读取info.plist中的方向,其实本质是通过AppDelegate中的方法去控制.
 - (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
 
 2.三个方法
 优先级:AppDelegate > 容器视图控制器(UINavigationController,UITabBarController) > UIViewController
 // 是否支持自动转屏
 - (BOOL)shouldAutorotate {
     return [[self.viewControllers lastObject] shouldAutorotate];
 }

 // 支持哪些屏幕方向
 - (UIInterfaceOrientationMask)supportedInterfaceOrientations {
     return [[self.viewControllers lastObject] supportedInterfaceOrientations];
 }

 // 默认的屏幕方向（当前ViewController必须是通过模态出来的UIViewController（模态带导航的无效）方式展现出来的，才会调用这个方法）
 - (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
     return [[self.viewControllers lastObject] preferredInterfaceOrientationForPresentation];
 }
 3.强制转屏<通过变量去控制AppDelegate中的方法返回的值,然后后通过kvc赋值改变orientation>
 //强制横屏
 - (void)forceOrientationLandscape{
     
     AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
     appdelegate.isForceLandscape = YES;
     appdelegate.isForcePortrait = NO;
     [appdelegate application:[UIApplication sharedApplication] supportedInterfaceOrientationsForWindow:self.view.window];
     //强制翻转屏幕，Home键在右边。
     [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
         [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
         [[UIDevice currentDevice] setValue:@(UIInterfaceOrientationLandscapeRight) forKey:@"orientation"];
         //刷新
         [UIViewController attemptRotationToDeviceOrientation];
     }];
     
 }

 //强制竖屏
 - (void)forceOrientationPortrait {

     AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
     appdelegate.isForcePortrait = YES;
     appdelegate.isForceLandscape = NO;
     //调用APPdelegate中的方法
     [appdelegate application:[UIApplication sharedApplication] supportedInterfaceOrientationsForWindow:self.view.window];

     [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
          [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
          //设置屏幕的转向为竖屏
          [[UIDevice currentDevice] setValue:@(UIDeviceOrientationPortrait) forKey:@"orientation"];
          //刷新
          [UIViewController attemptRotationToDeviceOrientation];
     }];
 }

 4.监听屏幕的旋转
 [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeOrientation) name:UIDeviceOrientationDidChangeNotification object:nil];

- (void)changeOrientation{
 UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
}
 
