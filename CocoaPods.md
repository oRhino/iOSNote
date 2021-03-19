#  CocoaPods 依赖库管理工具

用户痛点:依赖库循环依赖,依赖库版本冲突等.
依赖库管理工具:Carthage,Swift Package Manager,Git Submodules,Cocoapods等

Cocoapods
特点:
- 成熟稳定,简单易用
- 自动整合Xcode项目,其它成员无须额外操作
- 支持的开源库丰富

##语义化版本管理(Semantic Versioning)
版本号规范:包括四部分,MAJOR,MINOR,PATCH,BUILD.如1.2.1.3,按顺序分别对应各部分
MAJOR主版本号:重大更新
MINOR副版本号:小功能的改善
PATCH补丁版本号:bug fix以及修复安全性问题
BUILD构建版本号:一般用于内部测试


##Pod版本管理
###podfile
配置文件，主要是用来描述Xcode项目里各个target的依赖库
source用于指向 PodSpec（Pod 规范）文件的 Repo，从而使得 CocoaPods 能查询到相应的 PodSpec 文件。
使用公共依赖库的时候，source需要指向 CocoaPods Master Repo，这个主仓库集中存放所有公共依赖库的 PodSpec 文件。 由于 CocoaPods 经常被开发者吐槽 Pod 下载很慢，因此 CocoaPods 使用了 CDN （Content Delivery Network，内容分发网络）来缓存整个 CocoaPods Master Repo， 方便开发者快速下载。具体的配置方法就是使source指向 CND 的地址

platform s用于指定操作系统以及所支持系统的最低版本号
use_frameworks!把所有第三方依赖库打包生成一个动态加载库，而不是静态库。因为动态库,它能有效地加快编译和链接的速度。

```
//通过def定义可以复用同一类依赖库方式
def dev_pods

  pod 'SwiftLint', '0.40.3', configurations: ['Debug']

  pod 'SwiftGen', '6.4.0', configurations: ['Debug']

end
```
configurations: ['Debug']用于指定该依赖库只是使用到Debug构建目标（target）里面，而不在其他（如Release）构建目标里面，这样做能有效减少 App Store 发布版本的体积。

```
target 'Moments' do

  dev_pods

  core_pods

  # other pods...

end

```
###依赖库版本
pod 'RxSwift', '= 5.1.1'来配置依赖库的版本号

> 0.1表示大于 0.1 的任何版本，这样可以包含 0.2 或者 1.0；
>= 0.1表示大于或等于 0.1 的任何版本；

< 0.1表示少于 0.1 的任何版本；

<= 0.1表示少于或等于 0.1 的任何版本；

~> 0.1.2表示大于 0.1.2 而且最高支持 0.1.* 的版本，但不包含 0.2 版本


引入本地依赖库,需要使用:path来指定该内部库的路径。
pod 'DesignKit', :path => './Frameworks/DesignKit', :inhibit_warnings => false


###workspace

Workspace是Xcode管理子项目的方式。通过 Workspace，我们可以把相关联的多个 Xcode 子项目组合起来方便开发。
执行pod install的时候，CocoaPods 会自动创建或者更新一个叫作 Pods 的项目文档（Pods.xcodeproj ）以及一个 Workspace 文档（在我们项目中叫作 Moments.xcworkspace）。

执行pod install
1.CocoaPods会自动创建或者更新一个叫作Pods的项目文档（Pods.xcodeproj )以及一个 Workspace
2.Pods 项目负责统一管理各个依赖库,在Podfile里面指定构建成动态库的时候，该项目会自动生成一个名叫Pods_<项目名称>.framework的动态库供我们项目使用,Workspace则统一管理了我们原有的主项目以及那个Pods项目。
3.CocoaPods 还会修改 Xcode 项目中的 Build Phases  以此来检测 Podfile.lock 和 Manifest.lock 文件的一致性，并把Pods_<项目名称>.framework动态库嵌入我们的主项目中去


以上所有操作都是由 CocoaPods 自动帮我们完成.

###podfile.lock
podfile.lock 文件是由 CocoaPods 自动生成和更新的，该文件会详细列举所有依赖库具体的版本号
PODFILE CHECKSUM 用于记录 Podfile 的验证码，任何库的版本号的更改，都会改变该验证码。这样能帮助我们在不同的机器上，快速检测依赖库的版本号是否一致。



##Pod版本更新
pod outdated命令，可以用它一次查看所有Pod的最新版本，而无须到GitHub 上逐一寻找
pod update会自动更新所有 Pod 的版本

