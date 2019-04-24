//
//  NSString+RevanHttp.h
//  QMKit
//
//  Created by Revan on 2018/7/19.
//

#import <Foundation/Foundation.h>

@interface NSString (RevanHttp)
/**
 是否是一个字符串

 @param str 传入字符串
 */
- (NSString*)revan_realString;
// 传入字符串,直接在沙盒Document中生成路径
- (NSString *)documentDir;

NSString * realString(id str);

@end
