//
//  RevanAlertTool.h
//  module
//
//  Created by 紫荆秋雪 on 2017/5/11.
//  Copyright © 2017年 紫荆秋雪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RevanAlertTool : NSObject

+ (void)revan_alertTitle:(NSString *)titile type:(UIAlertControllerStyle)alertType message:(NSString *)message didTask:(void(^)())task;

@end
