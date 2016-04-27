//
//  HXFAssertHandler.m
//  HXFStringsTool
//
//  Created by redoor on 16/4/18.
//  Copyright (c) 2016年 redoor. All rights reserved.
//

#import "HXFReaderNilAssertHandler.h"
#define kCreateDHxlsReaderFailedNotification @"kCreateDHxlsReaderFailedNotification"

@implementation HXFReaderNilAssertHandler
- (void)handleFailureInFunction:(NSString *)functionName file:(NSString *)fileName lineNumber:(NSInteger)line description:(NSString *)format, ...  {
    NSLog(@"create DHxlsReader failed");
    [[NSNotificationCenter defaultCenter] postNotificationName:kCreateDHxlsReaderFailedNotification object:nil];
}

- (void)handleFailureInMethod:(SEL)selector object:(id)object file:(NSString *)fileName lineNumber:(NSInteger)line description:(NSString *)format, ... {
    NSLog(@"create DHxlsReader failed");
    [[NSNotificationCenter defaultCenter] postNotificationName:kCreateDHxlsReaderFailedNotification object:nil];

}
@end
