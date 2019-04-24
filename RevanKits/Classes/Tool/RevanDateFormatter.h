//
//  RevanDateFormatter.h
//  AFNetworking
//
//  Created by RevanWang on 2018/11/5.
//

#import <Foundation/Foundation.h>

/**
 显示时间样式
 */
typedef NS_ENUM (NSUInteger, RevanDateFormatterType) {
    RevanDateFormatterTypeNYRSFMms,         //@"yyyy-MM-dd HH:mm:ss SSS"
    RevanDateFormatterTypeNYRSFM,           //@"yyyy-MM-dd HH:mm:ss"
    RevanDateFormatterTypeNYRSF,            //@"yyyy-MM-dd HH:mm"
    RevanDateFormatterTypeNYRS,             //@"yyyy-MM-dd HH"
    RevanDateFormatterTypeNYR,              //@"yyyy-MM-dd"
    RevanDateFormatterTypeYR,               //@"MM-dd"
    RevanDateFormatterTypeNYR_dian,              //@"yyyy.MM.dd"
};

/**
 时间间隔
 */
typedef NS_ENUM (NSUInteger, RevanDateFormatterIntervalType) {
    RevanDateFormatterIntervalTypeDay,          //间隔多少天
    RevanDateFormatterIntervalTypeHouse,        //间隔多少小时
    RevanDateFormatterIntervalTypeMinute,       //间隔多少分钟
    RevanDateFormatterIntervalTypeSecond,       //间隔多少秒
};

NS_ASSUME_NONNULL_BEGIN

@interface RevanDateFormatter : NSObject

/**
 获取当前时间戳
 
 @param formatterType 时间戳样式
 @return 当前时间戳
 */
+ (NSString *)revan_currentTime:(RevanDateFormatterType)formatterType;

/**
 把一个时间戳转成时间格式
 
 @param transitionTime 时间戳
 @param formatterType 时间样式
 @return 一个时间戳转成时间格式
 */
+ (NSString *)revan_transitionWithTime:(long long)transitionTime formatterType:(RevanDateFormatterType)formatterType;



/**
 返回时间戳与当前时间间隔(当前时间 - 传入的时间)
 
 @param startTime 比较时间戳，如果是时间 * 1000
 @param intervalType 返回间隔类型 天/小时/分钟/秒
 */
+(NSInteger)revan_dateTimeDifferenceWithStartTime:(long long)startTime returnType:(RevanDateFormatterIntervalType)intervalType;



#pragma mark - 获取当前时间戳
/**
 获取当前时间戳
 */
+ (long)revan_getCurrentTimestamp;


@end

NS_ASSUME_NONNULL_END
