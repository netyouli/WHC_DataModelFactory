//
//  WHC_XMLParse.h
//  WHC_XMLParse
//
//  Created by 吴海超 on 15/4/28.
//  Copyright (c) 2015年 吴海超. All rights reserved.
//

// Github <https://github.com/netyouli/WHC_DataModelFactory>

//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


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
