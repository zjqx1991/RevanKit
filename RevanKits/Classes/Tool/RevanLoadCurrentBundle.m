//
//  RevanLoadCurrentBundle.m
//  Pods
//
//  Created by 紫荆秋雪 on 2018/8/26.
//

#import "RevanLoadCurrentBundle.h"

@implementation RevanLoadCurrentBundle
/**
 加载当前Bundle
 
 @param class 资源所在的Class
 */
+ (NSBundle *)revan_loadCurrentBundle:(Class)class {
    return [NSBundle bundleForClass:class];
}

/**
 加载组件中的资源路径
 
 @param sourceName 资源名
 @param bundleName 所在bundle的名称(不需要家.bundle)
 @return 资源路径
 */
+ (NSString *)revan_loadSource:(NSString *)sourceName inDirectoryBundleName:(NSString *)bundleName {
    /** 资源在命名空间的路径 */
    NSString *sourceNamePath = [NSString stringWithFormat:@"%@.bundle/%@", bundleName, sourceName];
    return sourceNamePath;
}

/**
 加载组件中的资源路径
 
 @param nibName xib名
 @param bundleName 所在bundle的名称(不需要家.bundle)
 @param Class 资源所在的Class
 @return 资源路径
 */
+ (id)loadCurrentNib:(NSString *)nibName inDirectoryBundleName:(NSString *)bundleName currentClass:(Class)Class {
    /** 当前bundle */
    NSBundle *currentBundle = [self revan_loadCurrentBundle:Class];
    /** 资源在命名空间的路径 */
    NSString *nibNamePath = [self revan_loadSource:nibName inDirectoryBundleName:bundleName];
    return [[currentBundle loadNibNamed:nibNamePath owner:nil options:nil] lastObject];
}

@end
