//
//  RevanHttpTask.m
//  QMKit
//
//  Created by Revan on 2018/7/19.
//

#import "RevanHttpTask.h"
#import "AFNetworking.h"
#import <CommonCrypto/CommonCrypto.h>
#import "NSString+RevanHttp.h"
#import "RevanHttpENV.h"
#import "RevanHttpParameterConfig.h"


static NSString *RevanHttpTaskSignKey = @"3541917349470978669F5EE891BB107C";
#define kOtherUrlSkipAppendKey @"skip_append_url"

@implementation RevanHttpTask {
    RevanHttpManager *_httpManager;
    NSMutableDictionary * _requestTaskDictionary;
    RevanUserParameters *_userParameters;
}

//+ (void)load {
//    [RevanHttpTask sharedHttpTask];
//}

#pragma mark - 初始化
static RevanHttpTask * _sharedInstance = nil;
static dispatch_once_t onceToken = 0;
+ (instancetype)sharedHttpTask {
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self class] new];
    });
    return _sharedInstance;
}

/**
 网络请求初始化
 
 @param debugHttps 测试环境协议名 eg:@"http://"
 @param debugDomain 测试环境域名
 @param releaseHttps 正式环境协议名 eg:@"https://"
 @param releaseDomain 正式环境域名
 */
+ (void)revan_InitDebugHTTPSEnv:(NSString *)debugHttps debugDomainEnv:(NSString *)debugDomain releaseHTTPSEnv:(NSString *)releaseHttps releaseDomainEnv:(NSString *)releaseDomain {
    [RevanHttpENV sharedHttpEnv].debugHTTPS = debugHttps;
    [RevanHttpENV sharedHttpEnv].debugDomain = debugDomain;
    
    [RevanHttpENV sharedHttpEnv].releaseHTTPS = releaseHttps;
    [RevanHttpENV sharedHttpEnv].releaseDomain = releaseDomain;
    //初始化
    if (!_sharedInstance) {
        [self sharedHttpTask];
    }
    else {
        NSString *baseUrl = [self.class testBaseDomainInDebug];
        _sharedInstance->_httpManager = [[RevanHttpManager alloc] initWithBaseUrl:baseUrl];
        _sharedInstance->_requestTaskDictionary = [NSMutableDictionary dictionary];
    }

}

/* 销毁单例 */
+ (void)destroyInstance {
    RevanHttpManager *httpManager = _sharedInstance->_httpManager;
    httpManager.sessionManager = nil;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSString *baseUrl = [self.class testBaseDomainInDebug];
        _httpManager = [[RevanHttpManager alloc] initWithBaseUrl:baseUrl];
        _requestTaskDictionary = [NSMutableDictionary dictionary];
        
//        QNConfiguration *config = [QNConfiguration build:^(QNConfigurationBuilder *builder) {
//            builder.zone = [QNFixedZone zone2];
//        }];
//        _upManager = [[QNUploadManager alloc] initWithConfiguration:config];
//
        
    }
    return self;
}

+ (NSString *)testBaseDomainInDebug {
    [RevanHttpENV sharedHttpEnv].app = RevanAppMY;
#if DEBUG
    [RevanHttpENV sharedHttpEnv].networkEnv = RevanAppEnvPre;
#else
    [RevanHttpENV sharedHttpEnv].networkEnv = RevanAppEnvRelease;
#endif
    return [[RevanHttpENV sharedHttpEnv] baseAPIUrl];
}

#pragma mark - *************** public Method ***************
/**
 GET请求
 
 @param URLString URL
 @param parameters 参数
 @param aTaskResponse 回调
 */
+ (void)GET:(NSString *)URLString
 parameters:(NSDictionary *)parameters
taskResponse:(void (^)(RevanHttpResponse *response))aTaskResponse {
    [self GET:URLString parameters:parameters H5:NO taskResponse:aTaskResponse];
}

/**
 POST请求
 
 @param URLString URL
 @param parameters 参数
 @param aTaskResponse 回调
 */
+ (void)POST:(NSString *)URLString
  parameters:(NSDictionary *)parameters
taskResponse:(void (^)(RevanHttpResponse *response))aTaskResponse {
    [self POST:URLString parameters:parameters H5:NO taskResponse:aTaskResponse];
}

/**
 POST请求，带协议
 
 @param URLString URL
 @param parameters 参数
 @param block AFMultipartFormData协议
 @param aTaskResponse 回调
 */
/*
+ (void)POST:(NSString *)URLString
  parameters:(NSDictionary *)param
constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
taskResponse:(void (^)(RevanHttpResponse *response))aTaskResponse {
    if ([self checkUrlNeedLogin:URLString]) {
        return;
    }
    NSMutableDictionary * parameters = [NSMutableDictionary dictionaryWithDictionary:param];
    NSString *urlparams = AFQueryStringFromParameters([self filterParameters:@{} withRequestUrl:URLString]);
    if ([parameters objectForKey:kOtherUrlSkipAppendKey]) {
        [parameters removeObjectForKey:kOtherUrlSkipAppendKey];
    } else {
        URLString = [NSString stringWithFormat:@"%@?%@",URLString, urlparams];
    }
    
    RevanHttpManager *httpManager = _sharedInstance->_httpManager;
    [httpManager POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (block) {
            block(formData);
        }
    } taskResponse:^(NSURLSessionDataTask *task, RevanHttpResponse *response) {
        if (aTaskResponse) {
            aTaskResponse(response);
        }
        [self filterResponse:response urlString:URLString andPara:parameters];
    }];
}
*/

#pragma mark *************** private Method ***************

+ (void)GET:(NSString *)URLString
 parameters:(NSDictionary *)parameters
         H5:(BOOL)isH5
taskResponse:(void (^)(RevanHttpResponse *response))aTaskResponse
{
    if ([self checkUrlNeedLogin:URLString]) {
        return;
    }
    if (isH5) {
        parameters = [self configH5WithOriginParameters:parameters withRequestUrl:URLString]; //h5 请求
    }
    else {
        //api的请求处理
        parameters = [self filterParameters:parameters withRequestUrl:URLString];
    }
    
    RevanHttpManager *httpManager = _sharedInstance->_httpManager;
    //请求配置文件使用规定域名
    if ([URLString isEqualToString:@"/sysconf"]) {
        NSString *baseUrl = @"https://p.yanglai.la/";
#ifdef DEBUG
        baseUrl = @"https://s.jdd.ooo/";
#endif
        httpManager = [[RevanHttpManager alloc] initWithBaseUrl:baseUrl];
    }
    NSURLSessionDataTask * task = [httpManager GET:URLString parameters:parameters taskResponse:^(NSURLSessionDataTask *task, RevanHttpResponse *response) {
#ifdef DEBUG
        response.originUrlString = task.originalRequest.URL.absoluteString;
#endif
        if (aTaskResponse) {
            aTaskResponse(response);
        }
        //过滤响应：比如登录过期
        [self filterResponse:response urlString:URLString andPara:parameters];
        
        NSMutableDictionary * dic = _sharedInstance->_requestTaskDictionary;
        if (dic.allKeys.count && dic) {
            [dic removeObjectForKey:URLString];
        }
    }];
}

+ (void)POST:(NSString *)URLString
  parameters:(NSDictionary *)parameters
          H5:(BOOL)isH5
taskResponse:(void (^)(RevanHttpResponse *response))aTaskResponse
{
    if ([self checkUrlNeedLogin:URLString]) {
        return;
    }
    NSDictionary *priPara;
    if (isH5) {
        priPara = [self configH5WithOriginParameters:@{} withRequestUrl:URLString]; //h5 请求
    }
    else {
        priPara = [self filterParameters:@{} withRequestUrl:URLString]; //api的请求处理
    }
    
    NSString *urlparams = AFQueryStringFromParameters(priPara);
    
//    if ([URLString rangeOfString:ZXUrlGrapRequest].location == NSNotFound) {
    //不是抢红包的 添加头
    URLString = [NSString stringWithFormat:@"%@?%@",URLString, urlparams];
//    }
    
    RevanHttpManager *httpManager = _sharedInstance->_httpManager;
    [httpManager POST:URLString parameters:parameters taskResponse:^(NSURLSessionDataTask *task, RevanHttpResponse *response) {
#ifdef DEBUG
        response.originUrlString = task.originalRequest.URL.absoluteString;
#endif
        if (aTaskResponse) {
            aTaskResponse(response);
        }
        [self filterResponse:response urlString:URLString andPara:parameters];
    }];
}


#pragma mark - 过滤响应
+ (void)filterResponse:(RevanHttpResponse *)response urlString:(NSString *)urlString andPara:(NSDictionary *)para
{
    if (response.code == 404) {
        //登录过期
        [[NSNotificationCenter defaultCenter] postNotificationName:KRevan_APPTokenPastDue object:nil];
    }
}

#pragma mark *************** 请求参数配置 ***************
#pragma mark - 配置H5请求参数
+ (NSMutableDictionary *)configH5WithOriginParameters:(NSDictionary *)orginP withRequestUrl:(NSString *)path
{
    static NSString * taskMD5SignKey = @"sy13$#%)s*&a12";
    NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithDictionary:orginP];
    [self configCommonRequestParameter:param andRequestUrl:path];
    
    NSString *tobeMd5 = [NSString stringWithFormat:@"%@%@",[RevanAppInfo revan_deviceId],taskMD5SignKey];
    NSString *sign = [self md5:tobeMd5];
    param[@"sign"] = sign;
    return param;
}

#pragma mark - 配置通用请求参数

#pragma mark - 过滤参数
+ (id)filterParameters:(NSDictionary *)parameters withRequestUrl:(NSString *)url {
    NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithDictionary:parameters];
//    [self configCommonRequestParameter:param andRequestUrl:url];
    
    NSArray *array = [param.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];

    NSMutableString *bufferStrM = [NSMutableString new];
    for (NSString *key in array) {
        NSString *value = param[key];
        if (![value isKindOfClass:[NSArray class]] && !([value isKindOfClass:[NSString class]] && [value isEqualToString:@""])) {
            [bufferStrM appendFormat:@"%@=%@&",key,value];
        }
    }
    [bufferStrM appendFormat:@"key=%@",RevanHttpTaskSignKey];
//    NSString *sign = [[self md5:bufferStrM] uppercaseString];
//    param[@"sign"] = sign;
    
    return param;
}

//配置通用请求参数
+ (void)configCommonRequestParameter:(NSMutableDictionary *)param andRequestUrl:(NSString *)path {
    if ([param isKindOfClass:[NSMutableDictionary class]] == NO) {
//        NSLog(@"request error XXXXX");
        return;
    }
#pragma mark -TODU 注释掉的请求参数与用户体系相关
    RevanUserParameters *userParameters = _sharedInstance->_userParameters;
    NSString *sid = userParameters.sid;
    param[@"sid"] = sid?:@"";
    param[@"toid"] = userParameters.uid;
    param[@"token"] = userParameters.token;
    
    param[@"cv"] = [NSString stringWithFormat:@"%@_%@",[RevanHttpParameterConfig revan_channel], [RevanAppInfo revan_appVersion]];
    param[@"ua"] = [RevanAppInfo revan_modelName];
    param[@"language"] = @"cn";
    param[@"dev"] = [RevanAppInfo revan_deviceId];
    param[@"conn"] = [self currentNetwork];
    param[@"osversion"] = [NSString stringWithFormat:@"ios_%@",[RevanAppInfo revan_systemVersion]];
    param[@"nonce"] = [self ret32bitString];
    param[@"cid"] = [RevanHttpParameterConfig revan_cid];
    param[@"appId"] = [RevanAppInfo revan_appId];
    if([RevanHttpENV sharedHttpEnv].networkEnv == RevanAppEnvPre) {
        param[@"debug"] = @"1";
    }
}

#pragma mark  参数修正额外配置 根据url
+ (void)fixReqParameters:(NSMutableDictionary *)mdic withUrlPath:(NSString *)path {
    
//    if (![mdic isKindOfClass:[NSMutableDictionary class]]) {
//        return;
//    }
//    // 目前是处理 可能需要snapData 数据的固定接口
//    if (!path || !kZXUserModel.snapData) {
//        return;
//    }
//    BOOL pathMayFix = NO;
//    NSString *str;
//    for (int i = 0; i < kPortsCount; i++) {
//        str = kCanUseSnapDataPorts[i];
//        if ([path rangeOfString:str].location != NSNotFound) {
//            pathMayFix = YES;
//            break;
//        }
//    }
//    if (!pathMayFix) {
//        return;
//    }
//    if ([ZXCommonTool zx_strIsEmpty:mdic[@"sid"]]) {
//        mdic[@"sid"] = kZXUserModel.snapData[@"sid"];
//    }
//    if ([ZXCommonTool zx_strIsEmpty:mdic[@"token"]]) {
//        mdic[@"token"]  = kZXUserModel.snapData[@"token"];
//    }
//    if ([ZXCommonTool zx_strIsEmpty:mdic[@"toid"]]) {
//        mdic[@"toid"]  = [[kZXUserModel.snapData objectForKey:@"userInfo"] objectForKey:@"uid"];
//    }
}

#pragma mark - 检查URL
+ (BOOL)checkUrlNeedLogin:(NSString *)url {
    if (!([url revan_realString].length)) {
        return NO;
    }
    //判断需要登录才能请求的参数
//    NSArray * arr = @[@"/user",
//                      @"/game/room/quick_start",
//                      @"/grant/im"];
//    for (NSString * subStr in arr) {
//        if ([url rangeOfString:subStr].length) {
//            return YES;
//        }
//    }
    return NO;
}

#pragma mark - 加密
+ (NSString *)md5:(NSString *)str {
    const char *cStr = [str UTF8String];//转换成utf-8
    unsigned char result[16];//开辟一个16字节（128位：md5加密出来就是128位/bit）的空间（一个字节=8字位=8个二进制数）
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result);
    /*
     extern unsigned char *CC_MD5(const void *data, CC_LONG len, unsigned char *md)官方封装好的加密方法
     把cStr字符串转换成了32位的16进制数列（这个过程不可逆转） 存储到了result这个空间中
     */
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
    /*
     x表示十六进制，%02X  意思是不足两位将用0补齐，如果多余两位则不影响
     DDLogDebug("%02X", 0x888);  //888
     DDLogDebug("%02X", 0x4); //04
     */
}

#pragma mark - 网络情况
#pragma mark - 网络环境
+ (NSString *)currentNetwork {
    NSString * network = @"";
    switch ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus) {
        case AFNetworkReachabilityStatusReachableViaWiFi:
            network = @"WiFi";
            break;
            
        case AFNetworkReachabilityStatusUnknown:
            network = @"Unknown";
            break;
            
        case AFNetworkReachabilityStatusNotReachable:
            network = @"Reachable";
            break;
            
        case AFNetworkReachabilityStatusReachableViaWWAN:
            network = @"WAN";
            break;
            
        default:
            network = @"Mars";
            break;
    }
    return [network revan_realString];
}

+ (NSString *)ret32bitString
{
    char data[32];
    
    for (int x=0;x<32;data[x++] = (char)('A' + (arc4random_uniform(26))));
    
    return [[NSString alloc] initWithBytes:data length:32 encoding:NSUTF8StringEncoding];
    
}

#pragma mark - 外界传入的参数
+ (void)revan_httpTaseWithUserParamets:(RevanUserParameters *)userParameters {
    _sharedInstance->_userParameters = userParameters;
}



#pragma mark - 下载文件
/**
 *  下载文件
 *
 *  @param folderName    下载到的文件夹名字 默认在 document目录下
 *  @param parameters    参数
 *  @param aTaskResponse 结束之后，成功了，返回有path ，否则没有path
 */
+ (void)download:(NSString *)URLString toFolder:(NSString *)folderName parameters:(id)parameters
    taskResponse:(void (^)(NSString * filePath,RevanHttpResponse *response))aTaskResponse {
    
    //    NSString * tojiurl = [URLString copy];
    //    NSString *urlparams = AFQueryStringFromParameters([self filterParameters:@{}]);
    //    URLString = [NSString stringWithFormat:@"%@?%@",URLString, urlparams];
    
    RevanHttpManager *httpManager = _sharedInstance->_httpManager;
    
    // 这个URLString 是 带有 http完整链接的
    NSMutableDictionary * dic = _sharedInstance -> _requestTaskDictionary;
    if (dic[URLString]){
        // 如果已经存在 就不要一直下载
        NSLog(@"路径存在不下载 %@",URLString);
        return;
    }
    
    NSURLSessionTask * downloadTask =
    [httpManager download:URLString toFolder:folderName parameters:parameters taskResponse:^(NSString *filePath, RevanHttpResponse *response) {
        
        [dic removeObjectForKey:URLString];
        
        aTaskResponse(filePath,response);
        
    }];
    [dic setObject:downloadTask forKey:URLString];
    
    [downloadTask resume];
}


+ (void)download:(NSString *)URLString toFolder:(NSString *)folderName parameters:(id)parameters
    taskResponse:(void (^)(NSString * filePath,RevanHttpResponse *response))aTaskResponse
   progressBlock:(void (^)(NSProgress * downloadProgress))progressBlock
 replaceFileName:(NSString *)replaceName
{
    //    NSString * tojiurl = [URLString copy];
    //    NSString *urlparams = AFQueryStringFromParameters([self filterParameters:@{}]);
    //    URLString = [NSString stringWithFormat:@"%@?%@",URLString, urlparams];
    
    RevanHttpManager *httpManager = _sharedInstance->_httpManager;
    
    // 这个URLString 是 带有 http完整链接的
    NSMutableDictionary * dic = _sharedInstance -> _requestTaskDictionary;
    if (dic[URLString] || !URLString.length){
        // 如果已经存在 就不要一直下载
        NSLog(@"路径存在不下载 %@",URLString);
        return;
    }
    
    NSURLSessionTask * downloadTask =
    [httpManager download:URLString toFolder:folderName parameters:parameters taskResponse:^(NSString *filePath, RevanHttpResponse *response) {
        
        [dic removeObjectForKey:URLString];
        
        aTaskResponse(filePath,response);
        
    } progressChanged:progressBlock replaceFilePath:replaceName];
    [dic setObject:downloadTask forKey:URLString];
    
    [downloadTask resume];
}



@end
