//
//  SensorsAnalyticsKeychainItem.h
//  SensorsSDK
//
//  Created by hx on 2021/5/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SensorsAnalyticsKeychainItem : NSObject

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithService:(NSString *)service key:(NSString *)key;
- (instancetype)initWithService:(NSString *)service accessGroup:(nullable NSString *)accessGroup key:(NSString *)key;


- (nullable NSString *)value;
- (void)update:(NSString *)value;
- (void)remove;

@end

NS_ASSUME_NONNULL_END
