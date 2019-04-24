//
//  RevanHttpResponse.m
//  QMKit
//
//  Created by Revan on 2018/7/19.
//

#import "RevanHttpResponse.h"
#import "MJExtension.h"

@interface RevanHttpResponse ()

@property (nonatomic, assign) int code;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) id data;
@property (nonatomic, copy) NSString *errorDomain;

@end

@implementation RevanHttpResponse

+ (instancetype)responseOfResponseObject:(id)aResponseObject {
    //为了适配羊来了
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:aResponseObject options:NSJSONReadingMutableLeaves error:nil];
    
    RevanHttpResponse *response = [[self class] new];
    if ([dic isKindOfClass:[NSDictionary class]]) {
        response.code = [dic[@"state"] intValue];
        response.message = dic[@"msg"];
        response.data = dic;
        response->_serverError = YES;
    }
//    RevanHttpResponse *response = [[self class] new];
//    if ([aResponseObject isKindOfClass:[NSDictionary class]]) {
//        response = [[self class] mj_objectWithKeyValues:aResponseObject];
//        response->_serverError = YES;
//    }
    else if ([aResponseObject isKindOfClass:[NSData class]]) {
        NSData *data = aResponseObject;
        char *buffer = (char *)data.bytes;
        int length = (int)data.length;
        
        if (buffer && buffer[0] != 123) {
            //数据没有加密的话就iu不用解密
            zxDecryptHttpResponse(buffer, length);
            data = [NSData dataWithBytes:buffer length:length];
        }
        
        response = [[self class] mj_objectWithKeyValues:data];
        if (response == nil) {
            response = [[self class] new];
            response.code = -abs((int)NSURLErrorBadServerResponse);
            response.message = @"数据解析错误";
            response->_serverError = YES;
        }
        else {
            if (response.code) {
                response->_serverError = YES;
            }
        }
    }
    return response;
}

+ (instancetype)responseOfError:(NSError *)aError {
    RevanHttpResponse *response = [[self class] new];
    response->_error = aError;
    response.code = -abs((int)aError.code);
    response.errorDomain = aError.domain;
    
    if ([aError.domain isEqualToString:NSURLErrorDomain]) {
        if (aError.code == NSURLErrorTimedOut) {
            response.message = @"网络连接超时(-1001)";
        }else{
            response.message = [NSString stringWithFormat:@"您的网络似乎出现问题(%ld)",(long)aError.code];
        }
    }
    else{
        response.message = aError.description;
    }
    return response;
}

+ (instancetype)responseOfNoNetwork
{
    RevanHttpResponse *response = [[self class] new];
    response.code = -abs((int)NSURLErrorNetworkConnectionLost);
    response.message = @"无网络";
    return response;
}

+ (instancetype)responseOfEmptyUrl
{
    RevanHttpResponse *response = [[self class] new];
    response.code = -abs((int)NSURLErrorBadURL);
    response.message = @"地址为空";
    return response;
}

#pragma mark - private Method
void zxDecryptHttpResponse(char* buf, int len) {
    int c = 0x2b;
    size_t i;
    for (i = 0; i < len; i++) {
        int ch = buf[i] & 0xff;
        buf[i] = (((ch << 5) | (ch >> 3)) & 0xff) ^ c;
        c = ch;
    }
}
@end
