//
//  RevanCacheTool.h
//  module
//
//  Created by 紫荆秋雪 on 2017/5/11.
//  Copyright © 2017年 紫荆秋雪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RevanCacheTool : NSObject

+ (NSString *)revan_getSizeWithPath: (NSString *)path;

+ (void)revan_clearCacheWithPath: (NSString *)path;

@end
