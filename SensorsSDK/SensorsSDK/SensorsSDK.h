//
//  SensorsSDK.h
//  SensorsSDK
//
//  Created by hx on 2021/2/7.
//

#import <Foundation/Foundation.h>
#import <SensorsSDK/SensorsAnalyticsSDK.h>

//! Project version number for SensorsSDK.
FOUNDATION_EXPORT double SensorsSDKVersionNumber;

//! Project version string for SensorsSDK.
FOUNDATION_EXPORT const unsigned char SensorsSDKVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <SensorsSDK/PublicHeader.h>


/*
UDID(Unique Device Identifier，设备唯一标识符)的名称可以猜到，UDID是和设备相关且只跟设备相关的。它是一个由40位16进制组成的 序列。
在iOS 5之前，我们可以通过如下代码片段获 取当前设备的UDID:
   NSString *udid = [[UIDevice currentDevice] uniqueIdentifier];
 
返回的UDID示例如下:
fc8c9322aeb3b4042c85fda3bc12953896da88f6

 但从iOS 5开始，苹果公司为了保护用户隐私，就不再支持通过以上方式获取UDID。
 不过，我们仍然可以通过其他方式来获取iOS设备的UDID。
 
 1.Xcode，依次点击Windows→Devices and Simulators，然后就可以看到当前你连接到电脑上的所有iOS设备，其中显示的Identifier就是设备的UDID
 2. 蒲公英提供了一个可以用来获取iOS设备 UDID的网址:https://www.pgyer.com/udid
 */

/*
 UUID(Universally Unique Identifier，通用唯一标识符)是一个由32位十六进制组成的序列，使用短横线来连接，格式为:8-4-4-4-12(数字代表 位数，加上4个短横线，总共是36位)，
 示例如下所示:
 D8E4354E-C18A-44BB-BC75-548BD67C56E5
 
 UUID能在任何时刻、不借助任何服务器的情况下生成，且在某一特定的时空下是全球唯一的。
 从iOS 6开始，iOS应用程序可以通过NSUUID类来获取UUID，代码片 段如下。
 NSString *uuid = [NSUUID UUID].UUIDString;
 生成的UUID，系统不会做持久化存储，因此每次调用的时候都会获得 一个全新的UUID。
 */

/*
 MAC地址是用来标识互联网上的每一个站点，它是一个由12位十六进 制组成的序列，示例如下所示:
 C4:B3:01:BD:42:B1
 凡是接入网络的设备都会有一个MAC地址，用来区分每个设备的唯一 性。一个iOS设备(一般指iPhone手机)可能会有多个MAC地址，这是因 为它可能会有多个设备接入网络，比如Wi-Fi、SIM卡等。一般情况下，我 们只需要获取Wi-Fi的MAC地址即可，即en0的地址。
 但从iOS 7开始，苹果公司禁止iOS应用程序获取MAC地址。如果iOS 应用程序继续获取MAC地址，系统将会返回一个固定的MAC地址 02:00:00:00:00:00，这是因为MAC地址和UDID一样，都属于隐私信息。
 */


/*
 IDFA
 IDFA(Identifier For Advertising，广告标识符)主要用于广告推广、 换量等跨应用的设备追踪。它也是一个由32位十六进制组成的序列，格式 与UUID一致。在同一个iOS设备上，同一时刻，所有的应用程序获取到 的IDFA都是相同的。
 从iOS 6开始，我们可以利用AdSupport.framework库提供的方法来获 取IDFA，代码片段示例如下。
 #import <AdSupport/AdSupport.h>
 NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
 返回的IDFA示例:
 FB584D10-FFC4-40D8-A3AF-DDC77B60462B
 但是，IDFA的值并不是固定不变的。
 
 目前，以下操作均会改变IDFA的值。
 ·通过设置 → 通用 → 还原  →抹掉所有内容和设置
 ·通过iTunes还原设备。
 ·通过设置→隐私→广告→限制广告追踪
 
 一旦用户限制了广告追踪，我们获取到的IDFA将是一个固定的
 IDFA，即一连串零:00000000-0000-0000-0000-000000000000。
 因此，在获取IDFA之前，我们可以利用AdSupport.framework库提供 的接口来判断用户是否限制了广告追踪。代码片段示例如下。
 BOOL isLimitAdTracking = [[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled];
 ·通过设置→隐私→广告→还原广告标识符。
 用户一旦还原了广告标识符，系统将会生成一个全新的IDFA。
 
 IDFA的使用有一些限制条件，但对于上述操作，只有在特定的情况下才会发生，或者只有专业人士才有可能执行这些操作。同时， IDFA能解决应用程序卸载重装唯一标识设备的问题。因此，IDFA目前来 说比较适合作为iOS设备ID属性。
 */


/*
 IDFV
 IDFV(Identifier For Vendor，应用开发商标识符)是为了 便于应用开发商(Vendor)标识用户，适用于分析用户在应用 内的行为等。它也是一个由32位十六进制组成的序列，格式 与UUID一致。
 每一个iOS设备在所属同一个Vendor的应用里，获取到的 IDFV是相同的。Vendor是通过反转后的BundleID的前两部分 进行匹配的，如果相同就属于同一个Vendor。比如，对于 com.apple.example1和com.apple.example2这两个BundleID来 说，它们就属于同一个Vendor，将共享同一个IDFV。和IDFA 相比，IDFV不会出现获取不到的场景。
 但IDFV也有一个很大的缺点:如果用户将属于此Vendor 的所有应用程序都卸载，IDFV的值也会被系统重置。即使重 装该Vendor的应用程序，获取到的也是一个全新的IDFV。
 另外，以下操作也会重置IDFV。
 ·通过设置→通用→还原→抹掉所有内容和设置。
 ·通过iTunes还原设备。
 ·卸载设备上某个开发者账号下的所有应用程序。
 在iOS应用程序内，可以通过UIDevice类来获取IDFV，代码片段示例如下:

 NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
 18B4587A-0A6F-44A0-AD3C-3BB1C490C177
 */



/*
 IMEI(International Mobile Equipment Identity，国际移动设备身份码)是由15位纯数字 组成的串，并且是全球唯一的。任何一部手机， 在其生产并组装完成之后，都会被写入一个全球 唯一的IMEI。我们可以通过设置→通用→关于本 机，查看本机IMEI，如图7-11所示。
 从iOS 2开始，苹果公司提供了相应的接 口来获取IMEI。但后来为了保护用户隐私，从 iOS 5开始，苹果公司就不再允许应用程序获取 IMEI。因此，IMEI也不适合作为iOS设备ID。
 */

/*
 对于设备ID，不管是使用IDFA还是IDFV，用户限制广告追踪或应用
 程序卸载重装都有可能导致其发生变化。那我们是否还有更好的方案呢? 答案是肯定的，那就是Keychain。

 Keychain是OS X和iOS都提供的一种安全存储敏感 信息工具。比如，我们可以在Keychain中存储用户名、密码等信息。 Keychain的安全机制从系统层面保证了存储的敏感信息不会被非法读取或 者窃取。
 Keychain的特点如下。 ·保存在Keychain中的数据，即使应用程序被卸载，数据仍然存在;重
 新安装应用程序，我们也可以从Keychain中读取这些数据。 ·Keychain中的数据可以通过Group的方式实现应用程序之间共享，只
 要应用程序具有相同的TeamID即可。
 ·保存在Keychain中的数据都是经过加密的，因此非常安全。

 */






