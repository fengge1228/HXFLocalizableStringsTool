//
//  HXFAssertHandler.h
//  HXFStringsTool
//
//  Created by redoor on 16/4/18.
//  Copyright (c) 2016年 redoor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXFReaderNilAssertHandler : NSAssertionHandler
- (void)handleFailureInFunction:(NSString *)functionName file:(NSString *)fileName lineNumber:(NSInteger)line description:(NSString *)format, ...;

- (void)handleFailureInMethod:(SEL)selector object:(id)object file:(NSString *)fileName lineNumber:(NSInteger)line description:(NSString *)format, ...;
@end
