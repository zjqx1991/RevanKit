//
//  NSString+RevanHttp.m
//  QMKit
//
//  Created by Revan on 2018/7/19.
//

#import "NSString+RevanHttp.h"

@implementation NSString (RevanHttp)

- (NSString*)revan_realString {
    if ([self isKindOfClass:[NSNull class]] || self == NULL || self == nil) {
        return @"";
    }
    return [NSString stringWithFormat:@"%@",self];
}


// 传入字符串,直接在沙盒Document中生成路径
- (NSString *)documentDir {
    NSString *doc = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    return [doc stringByAppendingPathComponent:[self lastPathComponent]];
}

NSString * realString(id str) {
    if ([str isKindOfClass:[NSNull class]] || str == NULL || str == nil) {
        return @"";
    }
    return [NSString stringWithFormat:@"%@",str];
}


@end
