//
//  RevanHttpENV.h
//  QMKit
//
//  Created by Revan on 2018/7/19.
//

#import <Foundation/Foundation.h>

/**
 RevanApp
 */
typedef NS_ENUM(NSUInteger, RevanApp) {
    RevanAppMY
};

/**
 app当前的环境
 
 - RevanAppEnvPre: 预发布
 - RevanAppEnvRelease: 正式
 */
typedef NS_ENUM(NSUInteger, RevanAppEnv) {
    RevanAppEnvPre,
    RevanAppEnvRelease,
};

@interface RevanHttpENV : NSObject
/** APP平台 */
@property (nonatomic, assign) RevanApp app;
/** APP环境 */
@property (nonatomic, assign) RevanAppEnv networkEnv;

/** 测试环境 HTTPS or HTTP */
@property (nonatomic, copy) NSString *debugHTTPS;
/** 测试环境域名 */
@property (nonatomic, copy) NSString *debugDomain;

/** 正式环境 HTTPS or HTTP */
@property (nonatomic, copy) NSString *releaseHTTPS;
/** 正式环境域名 */
@property (nonatomic, copy) NSString *releaseDomain;


+ (RevanHttpENV *)sharedHttpEnv;
- (NSString *)baseAPIUrl;
@end
