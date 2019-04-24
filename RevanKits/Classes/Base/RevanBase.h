//
//  RevanBase.h
//  module
//
//  Created by 紫荆秋雪 on 2017/5/11.
//  Copyright © 2017年 紫荆秋雪. All rights reserved.
//

#ifndef RevanBase_h
#define RevanBase_h

#define kBaseUrl @"http://mobile.ximalaya.com/"
#define kLiveUrl @"http://live.ximalaya.com/"
#define kAdUrl @"http://adse.ximalaya.com/"
#define kAlbumUrl @"http://ar.ximalaya.com/"
#define kHybridUrl @"http://hybrid.ximalaya.com/"

// 如果是调试模式(DEBUG 是调试模式下, 自带的宏)
#ifdef DEBUG
#define RevanLog(...) NSLog(__VA_ARGS__);
#else
#define RevanLog(...)
#endif

// 打印调用函数的宏
#define RevanLogFunc NSLog(@"%s",__func__);

#pragma mark -随机颜色
// 随机颜色
#define RevanRGBAColor(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define RevanRGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RevanAlphaColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#define RevanRandomColor XMGColor(arc4random_uniform(255.0), arc4random_uniform(255.0), arc4random_uniform(255.0))
#define RevanCommonColor XMGColor(223, 223, 223)

#pragma mark -屏幕尺寸相关
// 屏幕尺寸相关
#define RevanScreenBounds [[UIScreen mainScreen] bounds]
#define RevanScreenWidth [[UIScreen mainScreen] bounds].size.width
#define RevanScreenHeight [[UIScreen mainScreen] bounds].size.height


#pragma mark -弱引用
// 弱引用
#define RevanWeakSelf __weak typeof(self) weakSelf = self;


#endif /* RevanBase_h */
