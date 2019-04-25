//
//  RevanHttpManager.h
//  QMKit
//
//  Created by Revan on 2018/7/19.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "RevanHttpResponse.h"


@interface RevanHttpManager : NSObject
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

- (instancetype)initWithBaseUrl:(NSString *)url;
- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                 taskResponse:(void (^)(NSURLSessionDataTask *task, RevanHttpResponse *response))aTaskResponse;

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                  taskResponse:(void (^)(NSURLSessionDataTask *task, RevanHttpResponse *response))aTaskResponse;

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
     constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                  taskResponse:(void (^)(NSURLSessionDataTask *task, RevanHttpResponse *response))aTaskResponse;



/**
 *  下载文件
 *
 *  @param urlString     url
 *  @param folderName    下载到的文件夹名字 默认在 document目录下
 *  @param parameters    参数
 *  @param aTaskResponse 结束之后，成功了，返回有path ，否则没有path
 *
 *  @return 下载任务
 */
- (NSURLSessionDownloadTask *)download:(NSString *)urlString toFolder:(NSString *)folderName parameters:(id)parameters
                          taskResponse:(void (^)(NSString * filePath,RevanHttpResponse *response))aTaskResponse;

/**
 *  下载文件
 *
 *  @param urlString     url
 *  @param folderName    下载到的文件夹名字 默认在 document目录下
 *  @param parameters    参数
 *  @param aTaskResponse 结束之后，成功了，返回有path ，否则没有path
 *  @param progressBlock 进度回调
 *
 *  @return 下载任务
 */
- (NSURLSessionDownloadTask *)download:(NSString *)urlString toFolder:(NSString *)folderName parameters:(id)parameters
                          taskResponse:(void (^)(NSString * filePath,RevanHttpResponse *response))aTaskResponse
                       progressChanged:(void (^)(NSProgress * downloadProgress))progressBlock
                       replaceFilePath:(NSString *)replaceFilePath;

@end
