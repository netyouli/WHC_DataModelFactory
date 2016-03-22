//
//  ViewController.m
//  WHC_DataModelFactory
//
//  Created by 吴海超 on 15/4/30.
//  Copyright (c) 2015年 吴海超. All rights reserved.
//

/*
 *  qq:712641411
 *  iOS大神qq群:460122071
 *  gitHub:https://github.com/netyouli
 *  csdn:http://blog.csdn.net/windwhc/article/category/3117381
 */

#import "ViewController.h"
#import "WHC_XMLParser.h"
#import <objc/runtime.h>

#define kWHC_DEFAULT_CLASS_NAME @("WHC")
#define kWHC_CLASS       @("\n@interface %@ :NSObject\n%@\n@end\n")
#define kWHC_PROPERTY(s)    ((s) == 'c' ? @("@property (nonatomic , copy) %@              * %@;\n") : @("@property (nonatomic , strong) %@              * %@;\n"))
#define kWHC_CLASS_M     @("@implementation %@\n\n@end\n")


#define kSWHC_CLASS @("\n@objc(%@)\nclass %@ :NSObject{\n%@\n}")
#define kSWHC_PROPERTY @("var %@: %@!;\n")
@interface ViewController (){
    NSMutableString       *   _classString;        //存类头文件内容
    NSMutableString       *   _classMString;       //存类源文件内容
}

@property (nonatomic , strong)IBOutlet  NSTextField  * classNameField;
@property (nonatomic , strong)IBOutlet  NSTextField  * jsonField;
@property (nonatomic , strong)IBOutlet  NSTextField  * classField;
@property (nonatomic , strong)IBOutlet  NSTextField  * classMField;
@property (nonatomic , strong)IBOutlet  NSButton       * checkBox;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _classString = [NSMutableString new];
    _classMString = [NSMutableString new];
    _classField.editable = NO;
    _classMField.editable = NO;
    _jsonField.drawsBackground = NO;
    _classField.drawsBackground = NO;
    _classMField.drawsBackground = NO;
    // Do any additional setup after loading the view.
}

- (IBAction)clickRadioButtone:(NSButton *)sender{
}

- (IBAction)clickMakeButton:(NSButton*)sender{
    [_classString deleteCharactersInRange:NSMakeRange(0, _classString.length)];
    [_classMString deleteCharactersInRange:NSMakeRange(0, _classMString.length)];
    NSString  * className = _classNameField.stringValue;
    NSString  * json = _jsonField.stringValue;
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
            dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:NULL];
        }
        if(_checkBox.state == 0){
            [_classMString appendFormat:kWHC_CLASS_M,className];
            [_classString appendFormat:kWHC_CLASS,className,[self handleDataEngine:dict key:@""]];
        }else{
            [_classString appendFormat:kSWHC_CLASS,className,className,[self handleDataEngine:dict key:@""]];
        }
        _classField.stringValue = _classString;
        _classMField.stringValue = _classMString;
    }else{
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
        NSAlert * alert = [NSAlert alertWithMessageText:@"WHC" defaultButton:@"确定" alternateButton:nil otherButton:nil informativeTextWithFormat:@"json或者xml数据不能为空"];
        [alert runModal];
#pragma clang diagnostic pop
    }
}

- (NSString*)handleDataEngine:(id)object key:(NSString*)key{
    if(object){
        NSMutableString  * property = [NSMutableString new];
        if([object isKindOfClass:[NSDictionary class]]){
            NSDictionary  * dict = object;
            NSInteger       count = dict.count;
            NSArray       * keyArr = [dict allKeys];
            for (NSInteger i = 0; i < count; i++) {
                id subObject = dict[keyArr[i]];
                if([subObject isKindOfClass:[NSDictionary class]]){
                    NSString * classContent = [self handleDataEngine:subObject key:keyArr[i]];
                    if(_checkBox.state == 0){
                        [property appendFormat:kWHC_PROPERTY('s'),keyArr[i],keyArr[i]];
                        [_classString appendFormat:kWHC_CLASS,keyArr[i],classContent];
                        [_classMString appendFormat:kWHC_CLASS_M,keyArr[i]];
                    }else{
                        [property appendFormat:kSWHC_PROPERTY,keyArr[i],keyArr[i]];
                        [_classString appendFormat:kSWHC_CLASS,keyArr[i],keyArr[i],classContent];
                    }
                }else if ([subObject isKindOfClass:[NSArray class]]){
                    NSString * classContent = [self handleDataEngine:subObject key:keyArr[i]];
                    if(_checkBox.state == 0){
                        [property appendFormat:kWHC_PROPERTY('s'),@"NSArray",keyArr[i]];
                        [_classString appendFormat:kWHC_CLASS,keyArr[i],classContent];
                        [_classMString appendFormat:kWHC_CLASS_M,keyArr[i]];
                    }else{
                        [property appendFormat:kSWHC_PROPERTY,keyArr[i],@"NSArray"];
                        [_classString appendFormat:kSWHC_CLASS,keyArr[i],keyArr[i],classContent];
                    }
                }else if ([subObject isKindOfClass:[NSString class]]){
                    if(_checkBox.state == 0){
                        [property appendFormat:kWHC_PROPERTY('c'),@"NSString",keyArr[i]];
                    }else{
                        [property appendFormat:kSWHC_PROPERTY,keyArr[i],@"String"];
                    }
                }else if ([subObject isKindOfClass:[NSNumber class]]){
                    if(_checkBox.state == 0){
                        [property appendFormat:kWHC_PROPERTY('s'),@"NSNumber",keyArr[i]];
                    }else{
                        [property appendFormat:kSWHC_PROPERTY,keyArr[i],@"NSNumber"];
                    }
                }else{
                    if(subObject == nil){
                        if(_checkBox.state == 0){
                            [property appendFormat:kWHC_PROPERTY('c'),@"NSString",keyArr[i]];
                        }else{
                            [property appendFormat:kSWHC_PROPERTY,keyArr[i],@"String"];
                        }
                    }else if([subObject isKindOfClass:[NSNull class]]){
                        if(_checkBox.state == 0){
                            [property appendFormat:kWHC_PROPERTY('c'),@"NSString",keyArr[i]];
                        }else{
                            [property appendFormat:kSWHC_PROPERTY,keyArr[i],@"String"];
                        }
                    }
                }
            }
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
        return property;
    }
    return @"";
}
- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

@end
