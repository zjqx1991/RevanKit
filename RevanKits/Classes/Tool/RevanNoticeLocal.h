//
//  RevanNoticeLocal.h
//  module
//
//  Created by 紫荆秋雪 on 2017/5/11.
//  Copyright © 2017年 紫荆秋雪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RevanNoticeLocal : NSObject


+(UILocalNotification*)revan_registerLocalNotificationWithFireDate:(NSDate *)firedate //后台运行的本地通知
                                                  repeatType:(NSCalendarUnit)repeatInterval
                                                   keepSleep:(BOOL)isKeepSleep;




+(void)revan_cancelAllLocalNotifications;
+(void)revan_cancelKeepSleepNotice;
+(void)revan_cancleAlarmNotifications;

@end
