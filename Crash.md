Crash收集

1.  可以获取到设备

Xcode -> window -> Devices and Simulators -> View Device Logs
选择对应的APP查看Crash

直接在设备上查看log
iOS 8 开始，设置 -> 隐私 -> 分析与改进 ->分析数据



2. 测试/Testflight

Xcode -> Window -> Organizer ->APP -> Crashes



3. 第三方服务

Bugly ,Google Analytics等



上传符号表

Xcode -> Window -> Organizer -> Archives -> Downlooad Debug Symbols
无法获取时, 选择对应的Archive -> Show in Finder ->显示包内容 -> dSYMs 

符号表解析:

工具路径:
/Applications/Xcode.app/Contents/SharedFrameworks/DVTFoundation.framework/Versions/A/Resources/symbolicatecrash

./symbolicatecrash crash_path  dsym_path > log.crash
如:./symbolicatecrash /Users/example/Desktop/Crash/123.crash /Users/example/Desktop/Crash/xxx.app.dSYM > log.crash （这里面一共有四个部分：第一个部分固定是./symbolicatecrash，第二个部分可以直接crash文件到上面，第三个直接拖动dsym到上面，第四个生成的文件名字


如果终端报错：Error: "DEVELOPER_DIR" is not defined at ./symbolicatecrash line 69.
那么在终端输入：export DEVELOPER_DIR="/Applications/XCode.app/Contents/Developer"，
然后在运行上面的方法


