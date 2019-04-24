//
//  RevanSystemInformation.h
//  module
//
//  Created by 紫荆秋雪 on 2017/5/11.
//  Copyright © 2017年 紫荆秋雪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RevanSystemInformation : NSObject

/**
 *  设备剩余存储空间
 *
 *  @return 剩余存储空间
 */
+ (NSString *)revan_systemFreeDiskSpace;

@end
