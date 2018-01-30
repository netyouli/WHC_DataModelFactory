//
//  ViewController.m
//  WHC_DataModelFactory
//
//  Created by 吴海超 on 15/4/30.
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
// VERSON (1.8.4)

#import "ViewController.h"
#import "WHC_XMLParser.h"
#import <objc/runtime.h>
#import "WHC_AutoLayout.h"


#define kWHC_DEFAULT_CLASS_NAME @("WHC")
#define kWHC_CLASS       @("\n@interface %@ :NSObject\n%@\n@end\n")
#define kWHC_CodingCLASS       @("\n@interface %@ :NSObject <NSCoding>\n%@\n@end\n")
#define kWHC_CopyingCLASS       @("\n@interface %@ :NSObject <NSCopying>\n%@\n@end\n")
#define kWHC_CodingAndCopyingCLASS       @("\n@interface %@ :NSObject <NSCoding,NSCopying>\n%@\n@end\n")

#define kWHC_PROPERTY(s)    ((s) == 'c' ? @("@property (nonatomic , copy) %@              * %@;\n") : @("@property (nonatomic , strong) %@              * %@;\n"))
#define kWHC_ASSIGN_PROPERTY    @("@property (nonatomic , assign) %@              %@;\n")
#define kWHC_CLASS_M     @("@implementation %@\n\n@end\n")
#define kWHC_CodingCLASS_M     @("@implementation %@\n- (id)initWithCoder:(NSCoder *)decoder {\n       if (self = [super init]) { \n              [self whc_Decode:decoder]; \n       }\n       return self;\n  \n} \n- (void)encodeWithCoder:(NSCoder *)encoder {\n       [self whc_Encode:encoder]; \n} \n\n\n@end\n\n")

#define kWHC_CopyingCLASS_M     @("@implementation %@ \n- (id)copyWithZone:(NSZone *)zone { \n       return [self whc_Copy]; \n} \n\n\n@end\n\n")
#define kWHC_CodingAndCopyingCLASS_M @("@implementation %@ \n- (id)initWithCoder:(NSCoder *)decoder {\n       if (self = [super init]) { \n              [self whc_Decode:decoder]; \n       }\n        return self;\n } \n\n- (void)encodeWithCoder:(NSCoder *)encoder {\n       [self whc_Encode:encoder]; \n} \n\n - (id)copyWithZone:(NSZone *)zone { \n       return [self whc_Copy]; \n} \n \n@end\n\n")

#define kWHC_CLASS_Prefix_M     @("@implementation %@\n+ (NSString *)prefix {\n    return @\"%@\";\n}\n\n@end\n\n")

#define kWHC_Prefix_H_Func @("\n+ (NSString *)prefix;\n")

#define kSWHC_Prefix_Func @("class func prefix() -> String {\n    return \"%@\"\n}\n")

#define kSWHC_CLASS @("\nclass %@ :NSObject {\n%@\n}\n")
#define kSexyJson_Class @("\nclass %@: SexyJson {\n%@\n}\n")
#define kSexyJson_Struct @("\nstruct %@: SexyJson {\n%@\n}\n")

#define kSexyJson_FuncMap (@"\n       public func sexyMap(_ map: [String : Any]) {\n       %@       \n       }\n")
#define kSexyJson_Struct_FuncMap (@"\n       public mutating func sexyMap(_ map: [String : Any]) {\n       %@       \n       }\n")
#define kSexyJson_Map (@"\n              %@        <<<        map[\"%@\"]")

#define kSexyJson_CodingCLASS @("\nclass %@ :NSObject, SexyJson, NSCoding {\n \n       required init(coder decoder: NSCoder) {\n              super.init()\n              self.sexy_decode(decoder)\n       }\n\n       func encode(with aCoder: NSCoder) {\n              self.sexy_encode(aCoder)\n       }\n\n       required override init() {}  \n\n%@\n}\n")

#define kSexyJson_CopyingCLASS @("\nclass %@ :NSObject, SexyJson, NSCopying {\n \n       func copy(with zone: NSZone? = nil) -> Any {\n              return self.sexy_copy()\n       }\n\n       required override init() {}  \n\n %@\n}\n")

#define kSexyJson_CodingAndCopyingCLASS @("\nclass %@ :NSObject, SexyJson, NSCoding, NSCopying {\n\n       required init(coder decoder: NSCoder) {\n              super.init()\n              self.sexy_decode(decoder)\n       }\n\n       func encode(with aCoder: NSCoder) {\n              self.sexy_encode(aCoder)\n       } \n\n       func copy(with zone: NSZone? = nil) -> Any {\n              return self.sexy_copy()\n       }\n\n       required override init() {} \n\n%@\n}\n")

#define kSWHC_CodingCLASS @("\nclass %@ :NSObject, NSCoding {\n \n       required init(coder aDecoder: NSCoder) {\n              super.init()\n              self.whc_Decode(aDecoder)\n       }\n\n       func encode(with aCoder: NSCoder) {\n              self.whc_Encode(aCoder)\n       }  \n\n%@\n}\n")

#define kSWHC_CopyingCLASS @("\nclass %@ :NSObject, NSCopying {\n \n       func copy(with zone: NSZone? = nil) -> Any {\n              return self.whc_Copy()\n       }  \n\n %@\n}\n")

#define kSWHC_CodingAndCopyingCLASS @("\nclass %@ :NSObject, NSCoding, NSCopying {\n\n       required init(coder aDecoder: NSCoder) {\n              super.init()\n              self.whc_Decode(aDecoder)\n       }\n\n       func encode(with aCoder: NSCoder) {\n              self.whc_Encode(aCoder)\n       } \n\n       func copy(zone: NSZone? = nil) -> Any {\n              return self.whc_Copy()\n       } \n\n%@\n}\n")

#define kSWHC_PROPERTY @("       var %@: %@?\n")
#define kSWHC_ASSGIN_PROPERTY @("       var %@: %@\n")

#define kInputJsonPlaceholdText @("请输入json或者xml字符串")
#define kSourcePlaceholdText @("自动生成对象模型类源文件")
#define kHeaderPlaceholdText @("自动生成对象模型类头文件")


typedef enum : NSUInteger {
    Objc = 0,
    Swift,
    SexyJson_struct,
    SexyJson_class
} WHCModelType;

@interface ViewController (){
    NSMutableString       *   _classString;        //存类头文件内容
    NSMutableString       *   _classMString;       //存类源文件内容
    NSString              *   _classPrefixName;    //类前缀
    BOOL                      _didMake;
    BOOL                      _firstLower;         //首字母小写
}
@property (weak) IBOutlet NSLayoutConstraint *classMHeightConstraint;

@property (nonatomic , strong)IBOutlet  NSTextField  * classNameField;
@property (nonatomic , strong)IBOutlet  NSTextView  * jsonField;
@property (nonatomic , strong)IBOutlet  NSTextView  * classField;
@property (nonatomic , strong)IBOutlet  NSTextView  * classMField;
@property (nonatomic , strong)IBOutlet  NSComboBox       * comboBox;
@property (nonatomic , strong)IBOutlet  NSButton       * codingCheckBox;
@property (nonatomic , strong)IBOutlet  NSButton       * copyingCheckBox;
@property (nonatomic , strong)IBOutlet  NSButton       * checkUpdateButton;

@property (nonatomic , strong) NSArray * comboxTitles;
@property (nonatomic , assign) BOOL isSwift;
@property (nonatomic , assign) WHCModelType index;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _classString = [NSMutableString new];
    _classMString = [NSMutableString new];
    _classField.editable = NO;
    _classMField.editable = NO;
    _firstLower = YES;
    // Do any additional setup after loading the view.
    [self setTextViewStyle];
    [self setClassSourceContent:kSourcePlaceholdText];
    [self setClassHeaderContent:kHeaderPlaceholdText];
    NSRect frmae = self.view.frame;
    frmae.size.height = 800;
    self.view.frame = frmae;
    
    _comboxTitles = @[@"Objective-c",@"Swift",@"SexyJson(struct)",@"SexyJson(class)"];
    [_comboBox addItemsWithObjectValues:_comboxTitles];
    [_comboBox selectItemWithObjectValue:@"Objective-c"];
    
    
}

- (void)setJsonContent:(NSString *)content {
    if (content != nil) {
        NSMutableAttributedString * attrContent = [[NSMutableAttributedString alloc] initWithString:content];
        [_jsonField.textStorage setAttributedString:attrContent];
        [_jsonField.textStorage setFont:[NSFont systemFontOfSize:14]];
        [_jsonField.textStorage setForegroundColor:[NSColor orangeColor]];
    }
}

- (NSString *)copyingRight {
    NSMutableString * value = [NSMutableString string];
    NSDate * date = [NSDate date];
    NSDateFormatter * dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString * dateStr = [dateFormatter stringFromDate:date];
    [value appendString:@"\n\n/**\n  * Copyright "];
    [value appendString:[dateStr componentsSeparatedByString:@"-"].firstObject];
    [value appendString:@" WHC_DataModelFactory\n  * Auto-generated: "];
    [value appendString:dateStr];
    [value appendString:@"\n  *\n"];
    [value appendString:@"  * @author netyouli (whc)\n"];
    [value appendString:@"  * @website http://wuhaichao.com\n"];
    [value appendString:@"  * @github https://github.com/netyouli\n  */\n\n\n"];
    return value;
}

- (void)setClassHeaderContent:(NSString *)content {
    if (content != nil) {
        NSMutableAttributedString * attrContent = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",[content isEqualToString:kHeaderPlaceholdText] ? @"" : [self copyingRight],content]];
        [_classField.textStorage setAttributedString:attrContent];
        [_classField.textStorage setFont:[NSFont systemFontOfSize:14]];
        [_classField.textStorage setForegroundColor:[NSColor colorWithRed:61.0 / 255.0 green:160.0 / 255.0 blue:151.0 / 255.0 alpha:1.0]];
    }
}

- (void)setClassSourceContent:(NSString *)content {
    if (content != nil) {
        NSMutableAttributedString * attrContent = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",[content isEqualToString:kSourcePlaceholdText] ? @"" : [self copyingRight],content]];
        [_classMField.textStorage setAttributedString:attrContent];
        [_classMField.textStorage setFont:[NSFont systemFontOfSize:14]];
        [_classMField.textStorage setForegroundColor:[NSColor colorWithRed:61.0 / 255.0 green:160.0 / 255.0 blue:151.0 / 255.0 alpha:1.0]];
    }
}

- (void)setTextViewStyle {
    _jsonField.font = [NSFont systemFontOfSize:14];
    _jsonField.textColor = [NSColor colorWithRed:198.0 / 255.0 green:77.0 / 255.0 blue:21.0 / 255.0 alpha:1.0];
    _jsonField.backgroundColor = [NSColor colorWithRed:40.0 / 255.0 green:40.0 / 255.0 blue:40.0 / 255.0 alpha:1.0];
    _classMField.backgroundColor = _jsonField.backgroundColor;
    _classField.backgroundColor = _jsonField.backgroundColor;
}

- (IBAction)clickCheckUpdate:(NSButton *)sender {
    if (sender.tag == 1) {
        [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://www.wuhaichao.com"]];
    }else if (sender.tag == 2) {
        [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://www.wuhaichao.com/pay/"]];
    }
}

- (IBAction)clickFirstLower:(NSButton *)sender {
    _firstLower = sender.state == 1;
    NSString  * json = _jsonField.textStorage.string;
    if (json && json.length > 0) {
        [self clickMakeButton:nil];
    }

}

- (IBAction)clickRadioButtone:(NSButton *)sender{
    NSString  * json = _jsonField.textStorage.string;
    if (json && json.length > 0) {
        [self clickMakeButton:nil];
    }

}
- (IBAction)clickChangeComboBox:(NSComboBox *)sender {
    _index = sender.indexOfSelectedItem;
    _isSwift = _index != 0;
    _classMHeightConstraint.constant = (self.isSwift ? 0 : 180);
    NSString  * json = _jsonField.textStorage.string;
    if (json && json.length > 0) {
        [self clickMakeButton:nil];
    }
}

- (IBAction)clickMakeButton:(NSButton*)sender{
    _didMake = YES;
    [_classString deleteCharactersInRange:NSMakeRange(0, _classString.length)];
    [_classMString deleteCharactersInRange:NSMakeRange(0, _classMString.length)];
    NSString  * className = _classNameField.stringValue;
    NSString  * json = _jsonField.textStorage.string;
    _classPrefixName = @"";
    if(className == nil){
        className = kWHC_DEFAULT_CLASS_NAME;
    }
    if(className.length == 0){
        className = kWHC_DEFAULT_CLASS_NAME;
    }
    if(json && json.length){
        NSDictionary  * dict = nil;
        if([json hasPrefix:@"<"]){
            //xml
            dict = [WHC_XMLParser dictionaryForXMLString:json];
        }else{
            //json
            NSData  * jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
            id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            if (jsonObject) {
                NSData * formatJsonData = [NSJSONSerialization dataWithJSONObject:jsonObject options:NSJSONWritingPrettyPrinted error:nil];
                [self setJsonContent:[[NSString alloc] initWithData:formatJsonData encoding:NSUTF8StringEncoding]];
            }
            dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:NULL];
            if (dict == nil) {
                NSError *error;
                NSPropertyListFormat plistFormat;
                dict = [NSPropertyListSerialization propertyListWithData:jsonData options:NSPropertyListMutableContainers format:&plistFormat error:&error];
            }
        }
        if (dict == nil || ![NSJSONSerialization isValidJSONObject:dict]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
            NSAlert * alert = [NSAlert alertWithMessageText:@"WHC" defaultButton:@"确定" alternateButton:nil otherButton:nil informativeTextWithFormat:@"未知数据格式无法解析(请提供json字符串或者dictionary字符串)"];
            [alert runModal];
#pragma clang diagnostic pop
            return;
        }
        NSString * classContent = [self handleDataEngine:dict key:@""];
        if(!self.isSwift){
            if (_classPrefixName.length > 0) {
                [_classMString appendFormat:kWHC_CLASS_Prefix_M,className,_classPrefixName];
            }else {
                if (_codingCheckBox.state != 0 && _copyingCheckBox.state != 0) {
                    [_classMString appendFormat:kWHC_CodingAndCopyingCLASS_M,className];
                }else if (_codingCheckBox.state != 0) {
                    [_classMString appendFormat:kWHC_CodingCLASS_M,className];
                }else if (_copyingCheckBox.state != 0) {
                    [_classMString appendFormat:kWHC_CopyingCLASS_M,className];
                }else {
                    [_classMString appendFormat:kWHC_CLASS_M,className];
                }
            }
            if (_codingCheckBox.state != 0 && _copyingCheckBox.state != 0) {
                [_classString appendFormat:kWHC_CodingAndCopyingCLASS,className,classContent];
            }else if (_codingCheckBox.state != 0) {
                [_classString appendFormat:kWHC_CodingCLASS,className,classContent];
            }else if (_copyingCheckBox.state != 0) {
                [_classString appendFormat:kWHC_CopyingCLASS,className,classContent];
            }else {
                [_classString appendFormat:kWHC_CLASS,className,classContent];
            }
        }else{
            switch (_index) {
                case SexyJson_class: {
                    if (_codingCheckBox.state != 0 && _copyingCheckBox.state != 0) {
                        [_classString appendFormat:kSexyJson_CodingAndCopyingCLASS,className,classContent];
                    }else if (_codingCheckBox.state != 0) {
                        [_classString appendFormat:kSexyJson_CodingCLASS,className,classContent];
                    }else if (_copyingCheckBox.state != 0) {
                        [_classString appendFormat:kSexyJson_CopyingCLASS,className,classContent];
                    }else {
                        [_classString appendFormat:kSexyJson_Class,className,classContent];
                    }
                }
                    break;
                case SexyJson_struct:
                    [_classString appendFormat:kSexyJson_Struct,className,classContent];
                    break;
                default:
                    if (_codingCheckBox.state != 0 && _copyingCheckBox.state != 0) {
                        [_classString appendFormat:kSWHC_CodingAndCopyingCLASS,className,classContent];
                    }else if (_codingCheckBox.state != 0) {
                        
                        [_classString appendFormat:kSWHC_CodingCLASS,className,classContent];
                    }else if (_copyingCheckBox.state != 0) {
                        [_classString appendFormat:kSWHC_CopyingCLASS,className,classContent];
                    }else {
                        [_classString appendFormat:kSWHC_CLASS,className,classContent];
                    }
                    break;
            }
        }
        [self setClassHeaderContent:_classString];
        [self setClassSourceContent:_classMString];
    }else{
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
        NSAlert * alert = [NSAlert alertWithMessageText:@"WHC" defaultButton:@"确定" alternateButton:nil otherButton:nil informativeTextWithFormat:@"json或者xml数据不能为空"];
        [alert runModal];
#pragma clang diagnostic pop
    }
}

- (NSString *)handleAfterClassName:(NSString *)className {
    if (className != nil && className.length > 0) {
        NSString * first = [className substringToIndex:1];
        NSString * other = [className substringFromIndex:1];
        return [NSString stringWithFormat:@"%@%@%@",_classPrefixName,[first uppercaseString],other];
    }
    return className;
}

- (NSString *)handlePropertyName:(NSString *)propertyName {
    if (_firstLower) {
        if (propertyName != nil && propertyName.length > 0) {
            NSString * first = [propertyName substringToIndex:1];
            NSString * other = [propertyName substringFromIndex:1];
            return [NSString stringWithFormat:@"%@%@",[first lowercaseString],other];
        }
    }
    return propertyName;
}

#pragma mark -解析处理引擎-

- (NSString*)handleDataEngine:(id)object key:(NSString*)key{
    if(object){
        NSMutableString  * property = [NSMutableString new];
        NSMutableString  * propertyMap = [NSMutableString new];
        if([object isKindOfClass:[NSDictionary class]]){
            NSDictionary  * dict = object;
            if (_classPrefixName.length > 0) {
                if (!self.isSwift) {
                    [property appendFormat:kWHC_Prefix_H_Func,_classPrefixName];
                }else {
                    [property appendFormat:kSWHC_Prefix_Func,_classPrefixName];
                }
            }
            [dict enumerateKeysAndObjectsUsingBlock:^(NSString * key, id  _Nonnull subObject, BOOL * _Nonnull stop) {
                NSString * className = [self handleAfterClassName:key];
                NSString * propertyName = [self handlePropertyName:key];
                if([subObject isKindOfClass:[NSDictionary class]]){
                    NSString * classContent = [self handleDataEngine:subObject key:key];
                    if(!self.isSwift) {
                        [property appendFormat:kWHC_PROPERTY('s'),className,propertyName];
                        if (_codingCheckBox.state != 0 && _copyingCheckBox.state != 0) {
                            [_classString appendFormat:kWHC_CodingAndCopyingCLASS,className,classContent];
                        }else if (_codingCheckBox.state != 0) {
                            [_classString appendFormat:kWHC_CodingCLASS,className,classContent];
                        }else if (_copyingCheckBox.state != 0) {
                            [_classString appendFormat:kWHC_CopyingCLASS,className,classContent];
                        }else {
                            [_classString appendFormat:kWHC_CLASS,className,classContent];
                        }
                        if (_classPrefixName.length > 0) {
                            [_classMString appendFormat:kWHC_CLASS_Prefix_M,className,_classPrefixName];
                        }else {
                            if (_codingCheckBox.state != 0 && _copyingCheckBox.state != 0) {
                                [_classMString appendFormat:kWHC_CodingAndCopyingCLASS_M,className];
                            }else if (_codingCheckBox.state != 0) {
                                [_classMString appendFormat:kWHC_CodingCLASS_M,className];
                            }else if (_copyingCheckBox.state != 0) {
                                [_classMString appendFormat:kWHC_CopyingCLASS_M,className];
                            }else {
                                [_classMString appendFormat:kWHC_CLASS_M,className];
                            }
                        }
                    }else{
                        
                        [property appendFormat:kSWHC_PROPERTY,propertyName,className];
                        switch (_index) {
                            case SexyJson_class:
                                if (_codingCheckBox.state != 0 && _copyingCheckBox.state != 0) {
                                    [_classString appendFormat:kSexyJson_CodingAndCopyingCLASS,className,classContent];
                                }else if (_codingCheckBox.state != 0) {
                                    
                                    [_classString appendFormat:kSexyJson_CodingCLASS,className,classContent];
                                }else if (_copyingCheckBox.state != 0) {
                                    [_classString appendFormat:kSexyJson_CopyingCLASS,className,classContent];
                                }else {
                                    [_classString appendFormat:kSexyJson_Class,className,classContent];
                                }
                                [propertyMap appendFormat:kSexyJson_Map,propertyName,key];
                                break;
                            case SexyJson_struct:
                                [_classString appendFormat:kSexyJson_Struct,className,classContent];
                                [propertyMap appendFormat:kSexyJson_Map,propertyName,key];
                                break;
                            default:
                                if (_codingCheckBox.state != 0 && _copyingCheckBox.state != 0) {
                                    [_classString appendFormat:kSWHC_CodingAndCopyingCLASS,className,classContent];
                                }else if (_codingCheckBox.state != 0) {
                                    
                                    [_classString appendFormat:kSWHC_CodingCLASS,className,classContent];
                                }else if (_copyingCheckBox.state != 0) {
                                    [_classString appendFormat:kSWHC_CopyingCLASS,className,classContent];
                                }else {
                                    [_classString appendFormat:kSWHC_CLASS,className,classContent];
                                }
                                break;
                        }
                        
                    }
                }else if ([subObject isKindOfClass:[NSArray class]]){
                    id firstValue = nil;
                    NSString * classContent = nil;
                    if (((NSArray *)subObject).count > 0) {
                        firstValue = ((NSArray *)subObject).firstObject;
                    }else {
                        goto ARRAY_PASER;
                    }
                    if ([firstValue isKindOfClass:[NSString class]] ||
                        [firstValue isKindOfClass:[NSNumber class]]) {
                        if ([firstValue isKindOfClass:[NSString class]]) {
                            if(!self.isSwift){
                                [property appendFormat:kWHC_PROPERTY('c'),[NSString stringWithFormat:@"NSArray<%@ *>",@"NSString"],key];
                            }else{
                                [property appendFormat:kSWHC_PROPERTY,propertyName,[NSString stringWithFormat:@"[%@]",@"String"]];
                                [propertyMap appendFormat:kSexyJson_Map,propertyName,key];
                            }
                        }else {
                            if(!self.isSwift){
                                [property appendFormat:kWHC_PROPERTY('c'),[NSString stringWithFormat:@"NSArray<%@ *>",@"NSNumber"],key];
                            }else{
                                [propertyMap appendFormat:kSexyJson_Map,propertyName,key];
                                if (strcmp([firstValue objCType], @encode(float)) == 0 ||
                                    strcmp([firstValue objCType], @encode(CGFloat)) == 0) {
                                    [property appendFormat:kSWHC_PROPERTY,propertyName,[NSString stringWithFormat:@"[%@]",@"CGFloat"]];
                                }else if (strcmp([firstValue objCType], @encode(double)) == 0) {
                                    [property appendFormat:kSWHC_PROPERTY,propertyName,[NSString stringWithFormat:@"[%@]",@"double"]];
                                }else if (strcmp([firstValue objCType], @encode(BOOL)) == 0) {
                                    [property appendFormat:kSWHC_PROPERTY,propertyName,[NSString stringWithFormat:@"[%@]",@"Bool"]];
                                }else {
                                    [property appendFormat:kSWHC_PROPERTY,propertyName,[NSString stringWithFormat:@"[%@]",@"Int"]];
                                }
                            }
                        }
                    }else {
                    ARRAY_PASER:
                        classContent = [self handleDataEngine:subObject key:key];
                        if(!self.isSwift){
                            [property appendFormat:kWHC_PROPERTY('c'),[NSString stringWithFormat:@"NSArray<%@ *>",className],propertyName];
                            if (_codingCheckBox.state != 0 && _copyingCheckBox.state != 0) {
                                [_classString appendFormat:kWHC_CodingAndCopyingCLASS,className,classContent];
                            }else if (_codingCheckBox.state != 0) {
                                [_classString appendFormat:kWHC_CodingCLASS,className,classContent];
                            }else if (_copyingCheckBox.state != 0) {
                                [_classString appendFormat:kWHC_CopyingCLASS,className,classContent];
                            }else {
                                [_classString appendFormat:kWHC_CLASS,className,classContent];
                            }
                            if (_classPrefixName.length > 0) {
                                [_classMString appendFormat:kWHC_CLASS_Prefix_M,className,_classPrefixName];
                            }else {
                                if (_codingCheckBox.state != 0 && _copyingCheckBox.state != 0) {
                                    [_classMString appendFormat:kWHC_CodingAndCopyingCLASS_M,className];
                                }else if (_codingCheckBox.state != 0) {
                                    [_classMString appendFormat:kWHC_CodingCLASS_M,className];
                                }else if (_copyingCheckBox.state != 0) {
                                    [_classMString appendFormat:kWHC_CopyingCLASS_M,className];
                                }else {
                                    [_classMString appendFormat:kWHC_CLASS_M,className];
                                }
                            }
                        }else{
                            [property appendFormat:kSWHC_PROPERTY,propertyName,[NSString stringWithFormat:@"[%@]",className]];
                            switch (_index) {
                                case SexyJson_class:
                                    if (_codingCheckBox.state != 0 && _copyingCheckBox.state != 0) {
                                        [_classString appendFormat:kSexyJson_CodingAndCopyingCLASS,className,classContent];
                                    }else if (_codingCheckBox.state != 0) {
                                        
                                        [_classString appendFormat:kSexyJson_CodingCLASS,className,classContent];
                                    }else if (_copyingCheckBox.state != 0) {
                                        [_classString appendFormat:kSexyJson_CopyingCLASS,className,classContent];
                                    }else {
                                        [_classString appendFormat:kSexyJson_Class,className,classContent];
                                    }
                                    [propertyMap appendFormat:kSexyJson_Map,propertyName,key];
                                    break;
                                case SexyJson_struct:
                                    [_classString appendFormat:kSexyJson_Struct,className,classContent];
                                    [propertyMap appendFormat:kSexyJson_Map,propertyName,key];
                                    break;
                                default:
                                    if (_codingCheckBox.state != 0 && _copyingCheckBox.state != 0) {
                                        [_classString appendFormat:kSWHC_CodingAndCopyingCLASS,className,classContent];
                                    }else if (_codingCheckBox.state != 0) {
                                        
                                        [_classString appendFormat:kSWHC_CodingCLASS,className,classContent];
                                    }else if (_copyingCheckBox.state != 0) {
                                        [_classString appendFormat:kSWHC_CopyingCLASS,className,classContent];
                                    }else {
                                        [_classString appendFormat:kSWHC_CLASS,className,classContent];
                                    }
                                    break;
                            }
                        }
                    }
                }else if ([subObject isKindOfClass:[NSString class]]){
                    if(!self.isSwift){
                        [property appendFormat:kWHC_PROPERTY('c'),@"NSString",propertyName];
                    }else{
                        [property appendFormat:kSWHC_PROPERTY,propertyName,@"String"];
                        [propertyMap appendFormat:kSexyJson_Map,propertyName,key];
                    }
                }else if ([subObject isKindOfClass:[NSNumber class]]){
                    if(!self.isSwift){
                        if (strcmp([subObject objCType], @encode(float)) == 0 ||
                            strcmp([subObject objCType], @encode(CGFloat)) == 0) {
                            [property appendFormat:kWHC_ASSIGN_PROPERTY,@"CGFloat",propertyName];
                        }else if (strcmp([subObject objCType], @encode(double)) == 0) {
                            [property appendFormat:kWHC_ASSIGN_PROPERTY,@"double",propertyName];
                        }else if (strcmp([subObject objCType], @encode(BOOL)) == 0) {
                            [property appendFormat:kWHC_ASSIGN_PROPERTY,@"BOOL",propertyName];
                        }else {
                            [property appendFormat:kWHC_ASSIGN_PROPERTY,@"NSInteger",propertyName];
                        }
                    }else{
                        [propertyMap appendFormat:kSexyJson_Map,propertyName,key];
                        if (strcmp([subObject objCType], @encode(float)) == 0 ||
                            strcmp([subObject objCType], @encode(CGFloat)) == 0) {
                            [property appendFormat:kSWHC_ASSGIN_PROPERTY,propertyName,@"CGFloat = 0.0"];
                        }else if (strcmp([subObject objCType], @encode(double)) == 0) {
                            [property appendFormat:kSWHC_ASSGIN_PROPERTY,propertyName,@"Double = 0.0"];
                        }else if (strcmp([subObject objCType], @encode(BOOL)) == 0) {
                            [property appendFormat:kSWHC_ASSGIN_PROPERTY,propertyName,@"Bool = false"];
                        }else {
                            [property appendFormat:kSWHC_ASSGIN_PROPERTY,propertyName,@"Int = 0"];
                        }
                    }
                }else{
                    if(subObject == nil){
                        if(!self.isSwift){
                            [property appendFormat:kWHC_PROPERTY('c'),@"NSString",propertyName];
                        }else{
                            [property appendFormat:kSWHC_PROPERTY,propertyName,@"String"];
                            [propertyMap appendFormat:kSexyJson_Map,propertyName,key];
                        }
                    }else if([subObject isKindOfClass:[NSNull class]]){
                        if(!self.isSwift){
                            [property appendFormat:kWHC_PROPERTY('c'),@"NSString",propertyName];
                        }else{
                            [property appendFormat:kSWHC_PROPERTY,propertyName,@"String"];
                            [propertyMap appendFormat:kSexyJson_Map,propertyName,key];
                        }
                    }
                }
            }];
        }else if ([object isKindOfClass:[NSArray class]]){
            NSArray  * dictArr = object;
            NSUInteger  count = dictArr.count;
            if(count){
                NSObject  * tempObject = dictArr[0];
                for (NSInteger i = 0; i < dictArr.count; i++) {
                    NSObject * subObject = dictArr[i];
                    if([subObject isKindOfClass:[NSDictionary class]]){
                        if(((NSDictionary *)subObject).count > ((NSDictionary *)tempObject).count){
                            tempObject = subObject;
                        }
                    }
                    if([subObject isKindOfClass:[NSDictionary class]]){
                        if(((NSArray *)subObject).count > ((NSArray *)tempObject).count){
                            tempObject = subObject;
                        }
                    }
                }
                [property appendString:[self handleDataEngine:tempObject key:key]];
            }
        }else{
            NSLog(@"key = %@",key);
        }
        switch (_index) {
            case SexyJson_struct:
                if (![property containsString:@"public mutating func sexyMap(_ map: [String : Any])"]) {
                    [property appendFormat:kSexyJson_Struct_FuncMap,[self autoAlign:propertyMap]];
                }
                break;
            case SexyJson_class:
                if (![property containsString:@"public func sexyMap(_ map: [String : Any])"]) {
                    [property appendFormat:kSexyJson_FuncMap,[self autoAlign:propertyMap]];
                }
                break;
            default:
                break;
        }
        return property;
    }
    return @"";
}

- (NSString *)autoAlign:(NSString *)content {
    NSMutableString * newContent = [NSMutableString new];
    if (content) {
        NSArray * rows = [content componentsSeparatedByString:@"\n"];
        NSInteger maxLen = 0;
        for (NSString * row in rows) {
            NSRange range = [row rangeOfString:@"<<<"];
            if (range.location != NSNotFound) {
                maxLen = MAX([row rangeOfString:@"<<<"].location, maxLen);
            }
        }
        for (NSString * row in rows) {
            NSInteger rowindex = [row rangeOfString:@"<<<"].location;
            if (rowindex < maxLen && rowindex != NSNotFound) {
                NSInteger dindex = maxLen - rowindex;
                NSMutableString * blank = [NSMutableString new];
                for (int i = 0; i < dindex; i++) {
                    [blank appendString:@" "];
                }
                NSMutableString * mrow = row.mutableCopy;
                [mrow insertString:blank atIndex:rowindex];
                [newContent appendString:mrow];
                [newContent appendString:@"\n"];
            }else {
                [newContent appendString:row];
                [newContent appendString:@"\n"];
            }
        }
    }
    return newContent;
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

@end
