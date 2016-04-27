//
//  XlsGenerator.m
//  HXFLocalizableStringsTool
//
//  Created by redoor on 16/4/22.
//  Copyright (c) 2016年 redoor. All rights reserved.
//

#import "XlsGenerator.h"
#import "Z5Helper.h"

@interface XlsGenerator ()
{
    NSInteger columns;
}
@end

@implementation XlsGenerator
- (BOOL)generateFileWithContent:(NSArray *)content error:(NSError **)error
{
    if ([Z5Helper ArrayIsEmpty:content]) {
        return NO;
    }
    
    columns = content.count + 1;
    
    NSString *filePath = [NSString stringWithFormat:@"%@/../%@", self.filePath ,self.fileName];
    
    JXLSCell				*cell;
    
    JXLSWorkBook *workBook = [JXLSWorkBook new];
    
    JXLSWorkSheet *workSheet = [workBook workSheetWithName:@"SHEET1"];
    
    NSMutableArray *allKeys = [@[] mutableCopy];
    for (NSDictionary *string in content) {
        for (NSString *key in string) {
            if (![allKeys containsObject:key]) {
                [allKeys addObject:key];
            }
        }
    }
    
    [allKeys sortUsingSelector:@selector(compare:)];
    
    for (int i = 0; i < allKeys.count; ++i) {
        cell = [workSheet setCellAtRow:i + 1 column:0 toString:allKeys[i]];
        [cell setWraps:YES];
//        [cell setIndentation:INDENT_0 + i];
    }
    
    for (int col = 0; col < content.count; col++) {
        for (int row = 0; row < allKeys.count; row++) {
            NSString *value = [content[col] objectForKey:allKeys[row]];
            if (![Z5Helper StringIsEmpt:value]) {
                cell = [workSheet setCellAtRow:row + 1 column:col + 1 toString:value];
                [cell setWraps:YES];
            }
        }
    }
    
    for (int i = 0; i <= content.count; i++) {
        [workSheet setWidth:10000 forColumn:i defaultFormat:NULL];
    }
    
    [workBook writeToFile:filePath];
    
    NSLog(@"xls文件路径：%@", filePath);
    return YES;
}
@end
