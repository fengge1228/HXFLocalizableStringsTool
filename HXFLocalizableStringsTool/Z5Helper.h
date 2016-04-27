//
//  Z5Helper.h
//  UseeTV
//
//  Created by admin on 15/10/26.
//  Copyright (c) 2015年 Asep Mulyana. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Z5Helper : NSObject
/**
 *  Data判空
 */
+ (BOOL)DataIsEmpty:(NSData *)data;
/**
 *  字符串判空
 */
+ (BOOL)StringIsEmpt:(NSString *)str;

/**
 *  字符串转Date
 */
+ (NSDate *)dateFromString:(NSString *)time
                WithFormat:(NSString *)format
                      Zone:(NSTimeZone *)zone;
+ (NSString *)stringFromDate:(NSDate *)time
                  WithFormat:(NSString *)format
                        Zone:(NSTimeZone *)zone;
/**
 *  字典判空
 */
+ (BOOL)DictionaryIsEmpty: (NSDictionary *)dic;
/**
 *  数组判空
 */
+ (BOOL)ArrayIsEmpty:(NSArray *)array;
@end
