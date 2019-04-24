//
//  UIImage+RevanVC.m
//  AFNetworking
//
//  Created by Revan on 2018/8/9.
//

#import "UIImage+RevanVC.h"

@implementation UIImage (RevanVC)

/**
 通过路径加载组件中的图片资源
 */
+ (instancetype)imageName:(NSString *)imageName {
    return [self revan_assetImageName:imageName
                inDirectoryBundleName:@"BaseMVCSource"
                         commandClass:self];
}


/**
 通过路径加载组件中的图片资源(使用.xcassets存储图片资源 !!!推荐使用)
 */
+ (instancetype)revan_assetImageName:(NSString *)imageName {
    return [self revan_assetImageName:imageName
         inDirectoryBundleName:@"BaseMVCSource"
                  commandClass:self];
}


/**
 通过路径加载组件中的图片资源(使用.xcassets存储图片资源 !!!推荐使用)
 
 @param imageName 图片名称
 @param bundleName 图片所在bundle(RRR.bundle,只需传RRR)
 @param Class 图片所在类
 @return 图片
 */
+ (instancetype)revan_assetImageName:(NSString *)imageName inDirectoryBundleName:(NSString *)bundleName commandClass:(Class)Class {
    
    NSBundle *bundle = [NSBundle bundleForClass:Class];
    NSURL *url = [bundle URLForResource:bundleName withExtension:@"bundle"];
    if (url) {
        bundle = [NSBundle bundleWithURL:url];
    }
    UIImage *image = [UIImage imageNamed:imageName
                                inBundle:bundle
           compatibleWithTraitCollection:nil];
    //再将图片的类型改为保持圆形
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return image;
}

/**
 通过路径加载组件中的图片资源
 
 @param imageName 图片名称
 @param bundleName 图片所在bundle
 @param Class 图片所在类
 @return 图片
 */
+ (instancetype)revan_imageName:(NSString *)imageName inDirectoryBundleName:(NSString *)bundleName commandClass:(Class)Class {
    /** 屏幕比 */
    NSInteger scale = (NSInteger)[[UIScreen mainScreen] scale];
    /** 当前Bundle */
    NSBundle *currentBundle = [NSBundle bundleForClass:Class];
    /** 图片完整名称 */
    NSString *name = [NSString stringWithFormat:@"%@@%zdx",imageName,scale];
    /** 图片所属bundle */
    NSString *bundleNames = [NSString stringWithFormat:@"%@.bundle",bundleName];
    /** 图片资源路径 */
    NSString *imagePath = [currentBundle pathForResource:name ofType:@"png" inDirectory:bundleNames];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    //再将图片的类型改为保持圆形
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return imagePath ? image : nil;
}

@end
