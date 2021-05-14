Xcode

* Derived data
* Caches
* Old archives
* Unavailable simulators
* Device support files


## Clearing Derived Data

构建项目时，Xcode会在derived data中存储该项目的构建文件。
~/Library/Developer/Xcode/DerivedData

ModuleCache.index存储Xcode之前编译的模块。 Xcode在项目和构建之间共享这些缓存的模块，以缩短构建时间。
同样，单个项目对应的文件夹也可以缩短构建时间。

DerivedData中的所有内容都可以安全删除,但下次构建时将花费更多时间.


## Clearing Archives

〜/ Library / Developer / Xcode / Archives

archives不会影响未来构建。它们是构建应用程序的最终产品，因此不会以任何方式加快编译速度。如果您需要重新发布旧的archives文件，则需要存储在archives文件夹中的.xcarchive。
另外，调试应用的指定版本需要archive文件中打包的dSYM的文件。

## Clearing Simulators

模拟器的应用程序/照片等
Device ▸ Erase All Content and Settings 模拟器擦除所有内容
xcrun simctl delete unavailable  删除不可用的模拟器


## Device Support

物理设备连接到Mac以安装或调试其中一个应用程序时，Xcode会创建device support文件。 Xcode使用这些文件来支持开发人员功能，例如查看崩溃日志。
设备支持device support文件特定于每个iOS版本，甚至是次要版本。 因此，如果您经常构建设备，则可能具有适用于iOS 14.1、14.2、14.2.1等的支持文件。

~/Library/Developer/Xcode/iOS DeviceSupport

## Caches
〜/ Library / Caches
〜/ Library / Caches / com.apple.dt.Xcode
〜/ Library / Caches / org.carthage.CarthageKit
pods : pod cache clean --all

```
#!/usr/bin/env bash

# 1
echo "Removing Derived Data..."
rm -rf ~/Library/Developer/Xcode/DerivedData/

# 2
echo "Removing Device Support..."
rm -rf ~/Library/Developer/Xcode/iOS\ DeviceSupport
rm -rf ~/Library/Developer/Xcode/watchOS\ DeviceSupport
rm -rf ~/Library/Developer/Xcode/tvOS\ DeviceSupport

# 3
echo "Removing old simulators..."
xcrun simctl delete unavailable

# 4
echo "Removing caches..."
rm -rf ~/Library/Caches/com.apple.dt.Xcode
rm -rf ~/Library/Caches/org.carthage.CarthageKit

# 5
if command -v pod  &> /dev/null
then
    # 6
    pod cache clean --all
fi

echo "Done!"
```
