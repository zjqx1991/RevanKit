//
//  RevanHttpTask.h
//  QMKit
//
//  Created by Revan on 2018/7/19.
//

#import <Foundation/Foundation.h>
#import "RevanHttpResponse.h"
#import "RevanAppInfo.h"
#import "RevanUserParameters.h"
#import "AFURLRequestSerialization.h"
#import "RevanHttpManager.h"
#import "AFNetworking.h"

#define KRevan_APPTokenPastDue @"KRevan_APPTokenPastDue"

@interface RevanHttpTask : NSObject

/**
 网络请求初始化

 @param debugHttps 测试环境协议名 eg:@"http://"
 @param debugDomain 测试环境域名
 @param releaseHttps 正式环境协议名 eg:@"https://"
 @param releaseDomain 正式环境域名
 */
+ (void)revan_InitDebugHTTPSEnv:(NSString *)debugHttps debugDomainEnv:(NSString *)debugDomain releaseHTTPSEnv:(NSString *)releaseHttps releaseDomainEnv:(NSString *)releaseDomain;

/**
 销毁单例
 */
+ (void)destroyInstance;


/**
 请求参数需要外部传入

 @param userParameters 构造一个RevanUserParameters对象传入
 */
+ (void)revan_httpTaseWithUserParamets:(RevanUserParameters *)userParameters;

/**
 GET请求

 @param URLString URL
 @param parameters 参数
 @param aTaskResponse 回调
 */
+ (void)GET:(NSString *)URLString
 parameters:(NSDictionary *)parameters
taskResponse:(void (^)(RevanHttpResponse *response))aTaskResponse;

/**
 POST请求

 @param URLString URL
 @param parameters 参数
 @param aTaskResponse 回调
 */
+ (void)POST:(NSString *)URLString
  parameters:(NSDictionary *)parameters
taskResponse:(void (^)(RevanHttpResponse *response))aTaskResponse;

/**
 POST请求，带协议

 @param URLString URL
 @param parameters 参数
 @param block AFMultipartFormData协议
 @param aTaskResponse 回调
 */
+ (void)POST:(NSString *)URLString
  parameters:(NSDictionary *)parameters
constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
taskResponse:(void (^)(RevanHttpResponse *response))aTaskResponse;

#pragma mark - 下载文件
/**
 *  下载文件
 *
 *  @param folderName    下载到的文件夹名字 默认在 document目录下
 *  @param parameters    参数
 *  @param aTaskResponse 结束之后，成功了，返回有path ，否则没有path
 */
+ (void)download:(NSString *)URLString toFolder:(NSString *)folderName parameters:(id)parameters
    taskResponse:(void (^)(NSString * filePath,RevanHttpResponse *response))aTaskResponse;

/**
 *  下载文件
 *
 *  @param folderName    下载到的文件夹名字 默认在 document目录下
 *  @param parameters    参数
 *  @param aTaskResponse 结束之后，成功了，返回有path ，否则没有path
 *  @param progressBlock 进度回调
 */
+ (void)download:(NSString *)URLString toFolder:(NSString *)folderName parameters:(id)parameters
    taskResponse:(void (^)(NSString * filePath,RevanHttpResponse *response))aTaskResponse
   progressBlock:(void (^)(NSProgress * downloadProgress))progressBlock
 replaceFileName:(NSString *)replaceName;

@end
