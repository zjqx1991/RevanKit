//
//  RevanSystemInformation.m
//  module
//
//  Created by 紫荆秋雪 on 2017/5/11.
//  Copyright © 2017年 紫荆秋雪. All rights reserved.
//

#import "RevanSystemInformation.h"
#include <sys/param.h>
#include <sys/mount.h>

@implementation RevanSystemInformation


+ (NSString *)revan_systemFreeDiskSpace {

    struct statfs buf;
    float freespace = -1;
    if(statfs("/var", &buf) >= 0){
        freespace = (long long)(buf.f_bsize * buf.f_bfree);
    }
    
    // 处理单位
    NSArray *units = @[@"B", @"KB", @"MB", @"GB", @"TB"];
    NSInteger count = 1000;
    NSInteger index = 0;
    while (freespace > count) {
        freespace = freespace / count;
        index ++;
    }
    
    NSString *formatStr = [NSString stringWithFormat:@"%.1f%@", freespace, units[index]];
    
    return formatStr;

}

@end
