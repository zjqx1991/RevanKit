//
//  RevanCacheTool.m
//  module
//
//  Created by 紫荆秋雪 on 2017/5/11.
//  Copyright © 2017年 紫荆秋雪. All rights reserved.
//

#import "RevanCacheTool.h"
#import <UIKit/UIKit.h>

@implementation RevanCacheTool


+ (NSString *)revan_getSizeWithPath: (NSString *)path {

    NSFileManager *fileManager = [NSFileManager defaultManager];
    CGFloat totalSize = 0;
    BOOL isDirectory = NO;
    if (![fileManager fileExistsAtPath:path isDirectory:&isDirectory]) {
        return @"";
    }
    else if (!isDirectory) {
        totalSize = [fileManager attributesOfItemAtPath:path error:nil].fileSize;
    }
    else {
    
        NSArray *subPaths = [fileManager subpathsAtPath:path];
        
        for (NSString *subPath in subPaths) {
            NSDictionary *dict = [fileManager attributesOfItemAtPath:[path stringByAppendingPathComponent:subPath] error:nil];
            if (dict.fileType == NSFileTypeRegular) {
                totalSize += dict.fileSize;
            }
        }
    }
    
    // 处理单位
    NSArray *units = @[@"B", @"KB", @"MB", @"GB", @"TB"];
    NSInteger count = 1000;
    NSInteger index = 0;
    while (totalSize > 1000) {
        totalSize = totalSize / count;
        index++;
    }
    NSString *formatStr = [NSString stringWithFormat:@"%.1f%@", totalSize, units[index]];
    return formatStr;
}

+ (void)revan_clearCacheWithPath: (NSString *)path {

    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:path error:nil];
}

@end
