//
//  ViewController.m
//  HXFStringsTool
//
//  Created by redoor on 16/4/18.
//  Copyright (c) 2016年 redoor. All rights reserved.
//

#import "ViewController.h"
#import "DHxlsReader.h"
#import "Z5Helper.h"
#import "XlsGenerator.h"

#define kCreateDHxlsReaderFailedNotification @"kCreateDHxlsReaderFailedNotification"
static const int kSheetIndex = 0;
static NSString * const kStringsXlsName = @"Strings.xls";

@interface ViewController () {
    NSInteger radioSelectedIndex;
}
@property (weak) IBOutlet     NSMatrix             * radio;
@property (strong, nonatomic) NSString             * xlsFilePath;
@property (strong, nonatomic) NSMutableArray       * stringsFilePaths;
@property (strong, nonatomic) NSString             * localizeName;
@property (strong, nonatomic) NSFileManager        * fileManager;
@property (strong, nonatomic) NSString             * filePrefix;
@property (strong, nonatomic) NSString             * documentsPath;
@end

@implementation ViewController
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fileManager = [NSFileManager defaultManager];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(createDHxlsReaderFailed:)
                                                 name:kCreateDHxlsReaderFailedNotification
                                               object:nil];
    
    _stringsFilePaths = [@[] mutableCopy];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    
    // Update the view, if already loaded.
}

- (void)createDHxlsReaderFailed:(NSNotification *)notification {
    [self showAlert:@"xls文件格式有误，无法解析"];
}

#pragma mark -action
- (IBAction)selectFilePressed:(NSButton *)button {
    [self getFilePathOfType:radioSelectedIndex ? @"strings" : @"xls"];
}
- (IBAction)radioPressed:(NSMatrix *)sender {
    if (sender.selectedColumn != radioSelectedIndex) {
        radioSelectedIndex = sender.selectedColumn;
        _xlsFilePath = @"";
        _stringsFilePaths = [@[] mutableCopy];
    }
}

- (IBAction)transferPressed:(NSButton *)sender {
    if (radioSelectedIndex) {
        if ([Z5Helper ArrayIsEmpty:_stringsFilePaths]) return;
        
        NSMutableArray *allContent = [@[] mutableCopy];
        for (NSString *path in _stringsFilePaths) {
            NSDictionary *stringContent = [NSDictionary dictionaryWithContentsOfFile:path];
            [allContent addObject:stringContent];
        }
        
        XlsGenerator *generator = [[XlsGenerator alloc] init];
        generator.fileName = kStringsXlsName;
        generator.filePath = [_stringsFilePaths[0] stringByDeletingLastPathComponent];
        BOOL result = [generator generateFileWithContent:allContent error:nil];
        if (result) {
            [self showAlert:@"excel文件生成成功！"];
        }
    }else {
        if([Z5Helper StringIsEmpt:_xlsFilePath]) return;
        else {
            self.documentsPath = [_xlsFilePath stringByDeletingLastPathComponent];
            [self startTransfer];
        }
    }
}

- (void)startTransfer {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    self.filePrefix = [NSString stringWithFormat:@"/*\n  Localizable.string %@ \n*/\n\n",[formatter stringFromDate:[NSDate date]]];
    
    DHxlsReader *reader = [DHxlsReader xlsReaderWithPath:_xlsFilePath];
    NSAssert(reader, nil);
    if (!reader) {
        return;
    }
    
    
    NSMutableString *content = [@"" mutableCopy];
    int col = 2;
    DHcell *languageTypeCell = [reader cellInWorkSheetIndex:kSheetIndex row:1 col:col];
    while(![Z5Helper StringIsEmpt:[languageTypeCell str]]) {
        self.localizeName = [languageTypeCell str];
        
        NSError *error = nil;
        //删除先前的文件
        NSString *lastFile = [self.documentsPath stringByAppendingPathComponent:self.localizeName];// [NSString stringWithFormat:@"%@/%@", self.documentsPath,self.localizeName];
        BOOL exist = [self.fileManager fileExistsAtPath:lastFile];
        if (exist) {
            [self.fileManager removeItemAtPath:lastFile  error:&error];
        }
        if (error) {
            NSLog(@"%@", error.description);
            return;
        }else {
            NSLog(@"============Delete %@ success!",self.localizeName);
        }
        
        int row = 2;
        DHcell *keyCell = [reader cellInWorkSheetIndex:kSheetIndex row:row col:1];
        while (![Z5Helper StringIsEmpt:[keyCell str]]) {
            DHcell *valueCell = [reader cellInWorkSheetIndex:kSheetIndex row:row col:col];
            
            NSString *valueStr = [valueCell str];
            if ([Z5Helper StringIsEmpt:valueStr]) {
                valueStr = @"";
            }
            [content appendFormat:@"\"%@\" = \"%@\";\n", [keyCell str], valueStr];
            
            keyCell = [reader cellInWorkSheetIndex:kSheetIndex row:++row col:1];
        }
        languageTypeCell = [reader cellInWorkSheetIndex:kSheetIndex row:1 col:++col];
        if (![self writeLocalizedFileWithContent:content]) {
            return;
        }
        
        content = [@"" mutableCopy];
    }
    
    NSLog(@"++++++++++++++++++您的词条文件路径：%@", self.documentsPath);
    [self showAlert:@"词条文件生成成功"];
}

- (void)showAlert:(NSString *)message
{
    NSAlert *alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle:@"OK"];
    [alert setMessageText:message];
    [alert setAlertStyle:NSWarningAlertStyle];
    [alert beginSheetModalForWindow:[self.view window] completionHandler:nil];
    
}

- (BOOL)writeLocalizedFileWithContent:(NSString *)content {
    BOOL success = YES;
    NSError *error = nil;
    NSString *localizablePath = [NSString stringWithFormat:@"%@/%@", self.documentsPath, self.localizeName];
    if([self.fileManager createDirectoryAtPath:localizablePath withIntermediateDirectories:YES attributes:nil error:&error] == NO)
    {
        [self showAlert:[NSString stringWithFormat:@"create file error with message : %@",[error description]]];
        success = NO;
    }
    
    NSString *filename = [localizablePath stringByAppendingPathComponent:@"Localizable.strings"];
    
    content = [NSString stringWithFormat:@"%@%@",self.filePrefix,content];
    [content writeToFile:filename atomically:YES encoding:NSUTF8StringEncoding error:&error];
    
    if (error) {
        [self showAlert:[NSString stringWithFormat:@"create file error with message : %@",[error description]]];
        success = NO;
    }
    NSLog(@"%@",error.description);
    
    if (success) NSLog(@"############ write file %@ succeed ! ###############", filename);
    
    return success;
}


- (void)getFilePathOfType:(NSString *)type {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    NSArray* fileTypes = [[NSArray alloc] initWithObjects:type, nil];
    [panel setMessage:@"select a file"];
    [panel setPrompt:@"OK"];
    [panel setCanChooseDirectories:NO];
    [panel setCanCreateDirectories:YES];
    [panel setCanChooseFiles:YES];
    if ([type isEqualToString:@"strings"]) {
        [panel setAllowsMultipleSelection:YES];
    }
    
    [panel setAllowedFileTypes:fileTypes];
    NSArray *selectFiles = nil;
    NSInteger result = [panel runModal];
    if (result == NSFileHandlingPanelOKButton)
    {
        selectFiles = [panel URLs];
    }
    
    if([type isEqualToString:@"xls"]) {
        _xlsFilePath = [[[panel URLs] firstObject] path];
    }else {
        for (NSURL *url in [panel URLs]) {
            if (![_stringsFilePaths containsObject:[url path]]) {
                [_stringsFilePaths addObject:[url path]];
            }
        }
    }
}

@end
