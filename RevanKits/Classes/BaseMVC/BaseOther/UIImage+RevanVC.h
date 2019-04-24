//
//  UIImage+RevanVC.h
//  AFNetworking
//
//  Created by Revan on 2018/8/9.
//

#import <UIKit/UIKit.h>

@interface UIImage (RevanVC)

/**
 通过路径加载组件中的图片资源(使用.xcassets存储图片资源 !!!推荐使用)
 
 @param imageName 图片名称
 @param bundleName 图片所在bundle(RRR.bundle,只需传RRR)
 @param Class 图片所在类
 @return 图片
 */
+ (instancetype)revan_assetImageName:(NSString *)imageName inDirectoryBundleName:(NSString *)bundleName commandClass:(Class)Class;

/**
 通过路径加载组件中的图片资源
 
 @param imageName 图片名称
 @param bundleName 图片所在bundle
 @param Class 图片所在类
 @return 图片
 */
+ (instancetype)revan_imageName:(NSString *)imageName inDirectoryBundleName:(NSString *)bundleName commandClass:(Class)Class;

@end
