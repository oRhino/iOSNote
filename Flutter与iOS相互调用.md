# Flutter混合开发

## 混编方案

- Flutter嵌套原生即原生作为Flutter 的子工程,由Flutter统一管理,**统一管理模式**.
- 原生嵌套Flutter即Flutter作为原生的子工程,维持原有的原生工程管理方式,**三端分离模式**.

![下载](/Users/Alen/Documents/manager.png)

**统一管理模式**:  三端代码耦合严重,相关工具链耗时增长,开发效率低.

**三端分离模式**:  轻量级接入,Flutter功能支持'热插拔',降低原生工程的改造成本,**Flutter工程可以抽离,将不同平台的构建产物依照标准组件化的形式进行管理. (Android使用aar,iOS 使用Pod)**.

## 集成 Flutter

创建Flutter Moudle

```
Flutter create -t module Flutter_library
```



## Flutter和iOS的相互调用

- MethodChannel
- 

### MethodChannel 一次通信

1. 建立通信的管道

```
//flutter端
///创建一个channel
final MethodChannel _channel = MethodChannel("mine_page");
  
///iOS
- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
  FlutterViewController *rootVC = (FlutterViewController *)self.window.rootViewController;
  self.channel = [FlutterMethodChannel methodChannelWithName:@"mine_page" binaryMessenger:rootVC.binaryMessenger];
  
  [GeneratedPluginRegistrant registerWithRegistry:self];
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

```

2. 相互调用和监听

   ```
   //======flutter 调用原生
   _channel.invokeMethod('call_ios','I can call you!');
   //监听原生的调用
   _channel.setMethodCallHandler((call){
         if(call.method == 'getImagePath'){
           print(call.arguments);
         }
         return Future.value(null);
      });
      
   //=========ios  
   ///调用flutter
   [self.channel invokeMethod:@"getImagePath" arguments:@"1111"];
   
   /// 监听Flutter消息
       [self.channel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
           if ([call.method isEqualToString:@"call_ios"]) {
               NSLog(@"参数:%@",call.arguments);
           }
       }];
    
   ```
   

### Msg