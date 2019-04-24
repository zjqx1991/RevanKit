//
//  RevanAppInfo.h
//  QMKit
//
//  Created by Revan on 2018/7/19.
//

#import <Foundation/Foundation.h>

@interface RevanAppInfo : NSObject
/**
 设备id
 */
+ (NSString *)revan_deviceId;

/**
 广告标识IDFA
 */
+ (NSString *)revan_idfa;
/**
 AppID
 */
+ (NSString *)revan_appId;

/**
 bundle
 */
+ (NSString *)revan_appBundle;
/**
 App名称
 */
+ (NSString *)revan_appName;
/**
 版本号
 */
+ (NSString *)revan_appVersion;
/**
 版本号(三位100)
 */
+ (NSInteger)revan_appVersionNumber;
/**
 build号
 */
+ (int)revan_buildVersion;
/**
 systemName
 */
+ (NSString *)revan_systemName;
/**
 systemVersion
 */
+ (NSString *)revan_systemVersion;
/**
 设备类型
 */
+ (int)revan_deviceType;
/**
 设备型号
 */
+ (NSString *)revan_modelName;

@end
