//
//  RevanDateFormatter.m
//  AFNetworking
//
//  Created by RevanWang on 2018/11/5.
//

#import "RevanDateFormatter.h"

@implementation RevanDateFormatter

/**
 把一个时间戳转成时间格式

 @param transitionTime 时间戳
 @param formatterType 时间样式
 @return 一个时间戳转成时间格式
 */
+ (NSString *)revan_transitionWithTime:(long long)transitionTime formatterType:(RevanDateFormatterType)formatterType {
    // timeStampString 是服务器返回的13位时间戳
    // iOS 生成的时间戳是10位
    NSTimeInterval interval    = transitionTime / 1000.0;
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:[self getDateFormatter:formatterType]];
    //设置时区,这个对于时间的处理有时很重要
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSString *dateString       = [formatter stringFromDate: date];
    return dateString;
}


/**
 获取当前时间戳

 @param formatterType 时间戳样式
 @return 当前时间戳
 */
+ (NSString *)revan_currentTime:(RevanDateFormatterType)formatterType {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:[self getDateFormatter:formatterType]]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    //设置时区,这个对于时间的处理有时很重要
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSDate *datenow = [NSDate date];//现在时间
    NSString *currentDate = [formatter stringFromDate:datenow];
    return currentDate;
}

+ (NSString *)getDateFormatter:(RevanDateFormatterType)formatterType {
    switch (formatterType) {
        case RevanDateFormatterTypeNYRSFMms:
            return @"yyyy-MM-dd HH:mm:ss SSS";
            break;
        case RevanDateFormatterTypeNYRSFM:
            return @"yyyy-MM-dd HH:mm:ss";
            break;
        case RevanDateFormatterTypeNYRSF:
            return @"yyyy-MM-dd HH:mm";
            break;
        case RevanDateFormatterTypeNYRS:
            return @"yyyy-MM-dd HH";
            break;
        case RevanDateFormatterTypeNYR:
            return @"yyyy-MM-dd";
            break;
        case RevanDateFormatterTypeYR:
            return @"MM-dd";
            break;
        case RevanDateFormatterTypeNYR_dian:
            return @"yyyy.MM.dd";
            break;
            
        default:
            break;
    }
}

#pragma mark - 时间间隔
/**
 返回时间戳与当前时间间隔(当前时间 - 传入的时间)
 
 @param startTime 比较时间戳，如果是时间 * 1000
 @param intervalType 返回间隔类型 天/小时/分钟/秒
 */
+(NSInteger)revan_dateTimeDifferenceWithStartTime:(long long)startTime returnType:(RevanDateFormatterIntervalType)intervalType {
    
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    //设置时区,这个对于时间的处理有时很重要
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:[self getDateFormatter:RevanDateFormatterTypeNYRSFM]];
    NSString *starString = [self revan_transitionWithTime:startTime formatterType:RevanDateFormatterTypeNYRSFM];
    NSDate *startDate =[formatter dateFromString:starString];
    
    NSString *nowstr = [formatter stringFromDate:now];
    
    NSDate *nowDate = [formatter dateFromString:nowstr];
    
    NSTimeInterval defaultTime = [startDate timeIntervalSince1970]*1;
    
    NSTimeInterval currentTime = [nowDate timeIntervalSince1970]*1;
    
     NSTimeInterval value = currentTime - defaultTime;
    
    int second = (int)value / 1;//秒
    
    int minute = (int)value / 60;
    
    int house = (int)value / 3600;
    
    int day = (int)value / (24 * 3600);
    
    if (intervalType == RevanDateFormatterIntervalTypeDay) {//天
        return day;
    }
    else if (intervalType == RevanDateFormatterIntervalTypeHouse) {//小时
        return house;
    }
    else if (intervalType == RevanDateFormatterIntervalTypeMinute) {//分钟
        return minute;
    }
    else if (intervalType == RevanDateFormatterIntervalTypeSecond) {//秒
        return second;
    }
    return value;
}

#pragma mark - 获取当前时间戳
/**
 获取当前时间戳
 */
+ (long)revan_getCurrentTimestamp {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    //设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:[self getDateFormatter:RevanDateFormatterTypeNYRSFMms]];
    //设置时区,这个对于时间的处理有时很重要
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    return (long)[datenow timeIntervalSince1970] * 1000;
}

@end
