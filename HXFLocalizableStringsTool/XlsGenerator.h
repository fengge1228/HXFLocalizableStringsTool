//
//  XlsGenerator.h
//  HXFLocalizableStringsTool
//
//  Created by redoor on 16/4/22.
//  Copyright (c) 2016年 redoor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JXLS/JXLS.h>

@interface XlsGenerator : NSObject
@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) NSString *filePath;
- (BOOL)generateFileWithContent:(NSArray *)content error:(NSError **)error;
@end
