//
//  RevanDevicePermission.h
//  AFNetworking
//
//  Created by RevanWang on 2018/10/26.
//

#import <Foundation/Foundation.h>

#define kRevanDevicePermission [RevanDevicePermission shareInstance]

NS_ASSUME_NONNULL_BEGIN

@interface RevanDevicePermission : NSObject

+ (instancetype)shareInstance;

/**
 设备相册权限
 
 @param photoAccess 回调
 */
+ (void)revan_photoAPPName:(NSString *)appName access:(void(^)(BOOL isAllow))photoAccess;

/**
 设备相机权限
 
 @param videoAccess 回调
 */
+ (void)revan_videoAPPName:(NSString *)appName access:(void(^)(BOOL isAllow))videoAccess;


/**
 设备麦克风权限
 
 @param audioAccess 回调
 */
+ (void)revan_audioAPPName:(NSString *)appName access:(void(^)(BOOL isAllow))audioAccess;

/**
 打电话

 @param phoneNumber 电话号码
 */
+ (void)revan_callPhoneNumber:(NSString *)phoneNumber;

@end

NS_ASSUME_NONNULL_END
