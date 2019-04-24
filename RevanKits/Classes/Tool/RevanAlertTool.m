//
//  RevanAlertTool.m
//  module
//
//  Created by 紫荆秋雪 on 2017/5/11.
//  Copyright © 2017年 紫荆秋雪. All rights reserved.
//

#import "RevanAlertTool.h"

@implementation RevanAlertTool

+ (void)revan_alertTitle:(NSString *)titile type:(UIAlertControllerStyle)alertType message:(NSString *)message didTask:(void(^)())task {

    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:titile
                         message:message
                  preferredStyle:alertType];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                  style:UIAlertActionStyleCancel
                handler:^(UIAlertAction * _Nonnull action) {
//                    NSLog(@"执行取消任务");
                }];
    
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确定"
                  style:UIAlertActionStyleDefault
                handler:^(UIAlertAction * _Nonnull action) {
//                    NSLog(@"执行确定任务");
                    if (task) {
                        task();
                    }
                  }];
    
    [alertVC addAction:cancelAction];
    [alertVC addAction:defaultAction];
    
    ///获取当前窗口
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertVC animated:YES completion:nil];
}

@end
