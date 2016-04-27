//
//  Z5Helper.m
//  UseeTV
//
//  Created by admin on 15/10/26.
//  Copyright (c) 2015年 Asep Mulyana. All rights reserved.
//

#import "Z5Helper.h"
#import <CommonCrypto/CommonCryptor.h>

@implementation Z5Helper
+ (BOOL)DataIsEmpty:(NSData *)data
{
    if ((nil == data) || (0 == [data length]))
    {
        return YES;
    }
    
    return NO;
}

+ (BOOL)StringIsEmpt:(NSString *)str
{
    if (!str) {
        return YES;
    }
    
    if([str isEqual:[NSNull null]]) {
        return YES;
    }
    
    if ([str isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    if (![str isKindOfClass:[NSString class]]) {
        return YES;
    }
    
    if ([str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0) {
        return YES;
    }
    
    return NO;
}

+ (BOOL)DictionaryIsEmpty:(NSDictionary *)dic
{
    if ((nil == dic) || (0 == [dic count]))
    {
        return YES;
    }
    
    return NO;
}
+ (NSDate *)dateFromString:(NSString *)time
                WithFormat:(NSString *)format
                      Zone:(NSTimeZone *)zone
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:format];
    NSLocale *locate = [[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    [formatter setLocale:locate];
    [formatter setTimeZone:zone];
    return [formatter dateFromString:time];

}
+ (NSString *)stringFromDate:(NSDate *)time
                  WithFormat:(NSString *)format
                        Zone:(NSTimeZone *)zone
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:format];
    NSLocale *locate = [[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    [formatter setLocale:locate];
    [formatter setTimeZone:zone];
    return [formatter stringFromDate:time];


}
+ (BOOL)ArrayIsEmpty:(NSArray *)array
{
    if ((nil == array) || (0 == [array count]))
    {
        return YES;
    }
    
    return NO;
}
@end
