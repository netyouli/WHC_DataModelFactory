//
//  WHC_XMLParse.h
//  WHC_XMLParse
//
//  Created by 吴海超 on 15/4/28.
//  Copyright (c) 2015年 吴海超. All rights reserved.
//



/*
 *  qq:712641411
 *  gitHub:https://github.com/netyouli
 *  csdn:http://blog.csdn.net/windwhc/article/category/3117381
 */


#import <Foundation/Foundation.h>

typedef enum:NSInteger {
    WHC_XMLParserOptionsProcessNamespaces           = 1 << 0,
    WHC_XMLParserOptionsReportNamespacePrefixes     = 1 << 1,
    WHC_XMLParserOptionsResolveExternalEntities     = 1 << 2,
}WHC_XMLParserOptions;

@interface WHC_XMLParser : NSObject
+ (NSDictionary *)dictionaryForXMLData:(NSData *)data;
+ (NSDictionary *)dictionaryForXMLString:(NSString *)string;
+ (NSDictionary *)dictionaryForXMLData:(NSData *)data options:(WHC_XMLParserOptions)options;
+ (NSDictionary *)dictionaryForXMLString:(NSString *)string options:(WHC_XMLParserOptions)options;
@end
