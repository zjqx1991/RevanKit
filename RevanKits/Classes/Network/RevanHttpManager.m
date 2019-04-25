//
//  RevanHttpManager.m
//  QMKit
//
//  Created by Revan on 2018/7/19.
//

#import "RevanHttpManager.h"
#import "NSString+RevanHttp.h"

@interface RevanHttpManager ()
/** baseUrl */
@property (nonatomic, strong) NSURL *baseUrl;
@end

@implementation RevanHttpManager

- (AFHTTPSessionManager *)sessionManager {
    static AFHTTPSessionManager *_sessionManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // configuration
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        [configuration setHTTPCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
        
        _sessionManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
        _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [_sessionManager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
        
        _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/plain", @"text/xml", @"text/json", @"application/octet-stream",nil];
        _sessionManager.securityPolicy.allowInvalidCertificates = YES;
        _sessionManager.securityPolicy.validatesDomainName = NO;
        _sessionManager.operationQueue.maxConcurrentOperationCount = 5;
        [_sessionManager.requestSerializer setTimeoutInterval:40];
    });
    return _sessionManager;
}

#pragma mark - 初始化
- (instancetype)initWithBaseUrl:(NSString *)url {
    self = [super init];
    if (self)
    {
        // base url
        NSURL *baseUrl = [NSURL URLWithString:url];
        self.baseUrl = baseUrl;
    }
    return self;
}

#pragma mark - public Method
- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                 taskResponse:(void (^)(NSURLSessionDataTask *task, RevanHttpResponse *response))aTaskResponse {
    if (![self checkUrlAndNetwork:URLString taskResponse:aTaskResponse]) {
        return nil;
    }
   
    //拼接URL
    if (URLString.length > 1) {
        NSString *urlstring = [URLString substringFromIndex:1];
        URLString = [NSString stringWithFormat:@"%@%@", self.baseUrl, urlstring];
    }
    NSURLSessionDataTask *dataTask = [self.sessionManager GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (aTaskResponse)
        {
            aTaskResponse (task, [RevanHttpResponse responseOfResponseObject:responseObject]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (aTaskResponse)
        {
            aTaskResponse (task, [RevanHttpResponse responseOfError:error]);
        }
    }];
    return dataTask;
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                  taskResponse:(void (^)(NSURLSessionDataTask *task, RevanHttpResponse *response))aTaskResponse {
    if (![self checkUrlAndNetwork:URLString taskResponse:aTaskResponse]) {
        return nil;
    }
    //拼接URL
    if (URLString.length > 1) {
        NSString *urlstring = [URLString substringFromIndex:1];
        URLString = [NSString stringWithFormat:@"%@%@", self.baseUrl, urlstring];
    }
    NSURLSessionDataTask *dataTask = [self.sessionManager POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (aTaskResponse)
        {
            aTaskResponse (task, [RevanHttpResponse responseOfResponseObject:responseObject]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (aTaskResponse)
        {
            //            NSLog(@"response error: %@", error);
            aTaskResponse (task, [RevanHttpResponse responseOfError:error]);
        }
    }];
    return dataTask;
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
     constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                  taskResponse:(void (^)(NSURLSessionDataTask *task, RevanHttpResponse *response))aTaskResponse
{
    if (![self checkUrlAndNetwork:URLString taskResponse:aTaskResponse]) {
        return nil;
    }
    //拼接URL
    if (URLString.length > 1) {
        NSString *urlstring = [URLString substringFromIndex:1];
        URLString = [NSString stringWithFormat:@"%@%@", self.baseUrl, urlstring];
    }
    NSURLSessionDataTask *dataTask = [self.sessionManager POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (block)
        {
            block(formData);
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (aTaskResponse)
        {
            aTaskResponse (task, [RevanHttpResponse responseOfResponseObject:responseObject]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (aTaskResponse)
        {
            aTaskResponse (task, [RevanHttpResponse responseOfError:error]);
        }
    }];
    return dataTask;
}


#pragma mark - private Method
- (BOOL)checkUrlAndNetwork:(NSString *)URLString taskResponse:(void (^)(NSURLSessionDataTask *task, RevanHttpResponse *response))aTaskResponse
{
    if (URLString.length <= 0)
    {
        if (aTaskResponse)
        {
            aTaskResponse (nil, [RevanHttpResponse responseOfEmptyUrl]);
        }
        return NO;
    }
    
    if ([self checkReachable]==NO)
    {
        if (aTaskResponse)
        {
            aTaskResponse (nil, [RevanHttpResponse responseOfNoNetwork]);
        }
        return NO;
    }
    
    return YES;
}

- (BOOL)checkReachable
{
    AFNetworkReachabilityStatus status0 =[AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
    if (status0 == AFNetworkReachabilityStatusNotReachable)
    {
        return NO;
    }
    return YES;
}

#pragma mark - 下载文件

- (NSURLSessionTask *)download:(NSString *)urlString toFolder:(NSString *)folderName parameters:(id)parameters
                  taskResponse:(void (^)(NSString * filePath,RevanHttpResponse *response))aTaskResponse{
    
    
    return [self download:urlString toFolder:folderName parameters:parameters taskResponse:aTaskResponse progressChanged:^(NSProgress * _Nonnull downloadProgress) {
        
    } replaceFilePath:nil];
    
}

- (NSURLSessionDownloadTask *)download:(NSString *)urlString toFolder:(NSString *)folderName parameters:(id)parameters
                          taskResponse:(void (^)(NSString * filePath,RevanHttpResponse *response))aTaskResponse
                       progressChanged:(void (^)(NSProgress * downloadProgress))progressBlock
                       replaceFilePath:(NSString *)replaceFilePath
{
    if (urlString.length <= 0)
    {
        if (aTaskResponse)
        {
            aTaskResponse (nil, [RevanHttpResponse responseOfEmptyUrl]);
        }
        return nil;
    }
    
    if ([self checkReachable]==NO)
    {
        if (aTaskResponse)
        {
            aTaskResponse (nil, [RevanHttpResponse responseOfNoNetwork]);
        }
        return nil;
    }
    
    // 看这个文件存不存在 不存在创建一个
    NSFileManager * fm = [NSFileManager defaultManager];
    NSString * path = [folderName documentDir];
    NSError * err;
    if (![fm fileExistsAtPath:path]) {
        [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&err];
    }
    if (err) {
        NSLog(@"文件夹创建失败 %@",err);
        return nil;
    }
    
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    NSURLSessionDownloadTask * dataTask = [self.sessionManager downloadTaskWithRequest:request progress:progressBlock destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        documentsDirectoryURL = [documentsDirectoryURL URLByAppendingPathComponent:folderName];
        documentsDirectoryURL = [documentsDirectoryURL URLByAppendingPathComponent:realString(replaceFilePath).length? replaceFilePath : [response suggestedFilename]];
        NSLog(@"download文件位置是 %@",documentsDirectoryURL);
        return documentsDirectoryURL;
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error) {
            if (aTaskResponse)
            {
                aTaskResponse (nil, [RevanHttpResponse responseOfError:error]);
            }
        }else{
            if (aTaskResponse)
            {
                RevanHttpResponse * response = [[RevanHttpResponse alloc] init];
                aTaskResponse ([filePath path], response);
            }
        }
    }];
    
    return dataTask;
}




@end

