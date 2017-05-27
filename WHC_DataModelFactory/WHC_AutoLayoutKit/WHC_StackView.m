//
//  WHC_StackView.m
//  Github <https://github.com/netyouli/WHC_AutoLayoutKit>
//
//  Created by 吴海超 on 16/2/17.
//  Copyright © 2016年 吴海超. All rights reserved.
//

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

#import "WHC_StackView.h"
#import <objc/runtime.h>
#import "UIView+WHC_Frame.h"

#if TARGET_OS_IPHONE || TARGET_OS_TV


@implementation UIButton (WHC_StackView)

- (CGSize)calcTextSize {
    if (self.titleLabel.text != nil) {
        return [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: self.titleLabel.font}];
    }
    return CGSizeZero;
}

- (void)whc_WidthAuto {
    if (self.titleEdgeInsets.left + self.titleEdgeInsets.right != 0) {
        [self whc_Width:[self calcTextSize].width + self.titleEdgeInsets.left + self.titleEdgeInsets.right];
    }else {
        [super whc_AutoWidth];
    }
}

- (void)whc_HeightAuto {
    if (self.titleEdgeInsets.top + self.titleEdgeInsets.bottom != 0) {
        [self whc_Height:[self calcTextSize].height + self.titleEdgeInsets.top + self.titleEdgeInsets.bottom];
    }else {
        [super whc_AutoHeight];
    }
}

@end

@implementation UILabel (WHC_StackView)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method drawTextInRect = class_getInstanceMethod(self, @selector(drawTextInRect:));
        Method myDrawTextInRect = class_getInstanceMethod(self, @selector(myDrawTextInRect:));
        Method textRectForBounds = class_getInstanceMethod(self, @selector(textRectForBounds:limitedToNumberOfLines:));
        Method myTextRectForBounds = class_getInstanceMethod(self, @selector(myTextRectForBounds:limitedToNumberOfLines:));
        method_exchangeImplementations(drawTextInRect, myDrawTextInRect);
        method_exchangeImplementations(textRectForBounds, myTextRectForBounds);
    });
}

- (void)setWhc_LeftPadding:(CGFloat)whc_LeftPadding {
    objc_setAssociatedObject(self, @selector(whc_LeftPadding), @(whc_LeftPadding), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setNeedsDisplay];
}

- (CGFloat)whc_LeftPadding {
    NSNumber * value = objc_getAssociatedObject(self, _cmd);
    return value == nil ? 0 : value.floatValue;
}

- (void)setWhc_TopPadding:(CGFloat)whc_TopPadding {
    objc_setAssociatedObject(self, @selector(whc_TopPadding), @(whc_TopPadding), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setNeedsDisplay];
}

- (CGFloat)whc_TopPadding {
    NSNumber * value = objc_getAssociatedObject(self, _cmd);
    return value == nil ? 0 : value.floatValue;
}

- (void)setWhc_RightPadding:(CGFloat)whc_RightPadding {
    objc_setAssociatedObject(self, @selector(whc_RightPadding), @(whc_RightPadding), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setNeedsDisplay];
}

- (CGFloat)whc_RightPadding {
    NSNumber * value = objc_getAssociatedObject(self, _cmd);
    return value == nil ? 0 : value.floatValue;
}
- (void)setWhc_BottomPadding:(CGFloat)whc_BottomPadding {
    objc_setAssociatedObject(self, @selector(whc_BottomPadding), @(whc_BottomPadding), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setNeedsDisplay];
}

- (CGFloat)whc_BottomPadding {
    NSNumber * value = objc_getAssociatedObject(self, _cmd);
    return value == nil ? 0 : value.floatValue;
}

- (CGSize)calcTextSize {
    if (self.text != nil) {
        return [self.text sizeWithAttributes:@{NSFontAttributeName: self.font}];
    }
    return CGSizeZero;
}

- (void)setWhc_VerticalAlignment:(WHC_UILabelVerticalAlignment)whc_VerticalAlignment {
    objc_setAssociatedObject(self, @selector(whc_VerticalAlignment), @(whc_VerticalAlignment), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setNeedsDisplay];
}

- (WHC_UILabelVerticalAlignment)whc_VerticalAlignment {
    NSNumber * value = objc_getAssociatedObject(self, _cmd);
    return value == nil ? Middle : value.integerValue;
}


- (HeightAuto)whc_HeightAuto {
    __weak typeof(self) weakSelf = self;
    return ^() {
        if (weakSelf.whc_TopPadding + weakSelf.whc_BottomPadding != 0) {
            [super whc_Height:[weakSelf calcTextSize].width + weakSelf.whc_TopPadding + weakSelf.whc_BottomPadding + 0.5];
        }else {
            [super whc_AutoHeight];
        }
        return weakSelf;
    };
}

- (WidthAuto)whc_WidthAuto {
    __weak typeof(self) weakSelf = self;
    return ^() {
        if (weakSelf.whc_LeftPadding + weakSelf.whc_RightPadding != 0) {
            [super whc_Width:[weakSelf calcTextSize].width + weakSelf.whc_LeftPadding + weakSelf.whc_RightPadding + 0.5];
        }else {
            [super whc_AutoWidth];
        }
        return weakSelf;
    };
}

- (void)myDrawTextInRect:(CGRect)rect {
    if (self.whc_VerticalAlignment != Middle) {
        CGRect textRect = [self textRectForBounds:rect limitedToNumberOfLines:self.numberOfLines];
        textRect.size.width = CGRectGetWidth(rect);
        switch (self.whc_VerticalAlignment) {
            case Top:
                textRect.size.height += self.whc_TopPadding;
                break;
            case Bottom:
                textRect.origin.y -= self.whc_BottomPadding;
                textRect.size.height += self.whc_BottomPadding;
                break;
            default:
                break;
        }
        CGRect inRect = UIEdgeInsetsInsetRect(textRect, UIEdgeInsetsMake(self.whc_TopPadding, self.whc_LeftPadding, self.whc_BottomPadding, self.whc_RightPadding));
        [self myDrawTextInRect:inRect];
    }else {
        CGRect inRect = UIEdgeInsetsInsetRect(rect, UIEdgeInsetsMake(self.whc_TopPadding, self.whc_LeftPadding, self.whc_BottomPadding, self.whc_RightPadding));
        [self myDrawTextInRect:inRect];
    }
}

- (CGRect)myTextRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    CGRect textRect = [self myTextRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    switch (self.whc_VerticalAlignment) {
        case Top:
            break;
        case Middle:
            break;
        case Bottom:
            textRect.origin.y = bounds.origin.y + bounds.size.height - textRect.size.height;
            break;
        default:
            break;
    }
    return textRect;
}


@end

#endif

@implementation WHC_VIEW (WHC_StackViewCategory)

- (void)setWhc_WidthWeight:(CGFloat)whc_WidthWeight {
    objc_setAssociatedObject(self,
                             @selector(whc_WidthWeight),
                             @(whc_WidthWeight),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)whc_WidthWeight {
    CGFloat weight = [objc_getAssociatedObject(self, _cmd) floatValue];
    if (weight == 0) {
        weight = 1;
    }
    return weight;
}

- (void)setWhc_HeightWeight:(CGFloat)whc_HeightWeight {
    objc_setAssociatedObject(self,
                             @selector(whc_HeightWeight),
                             @(whc_HeightWeight),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)whc_HeightWeight {
    CGFloat weight = [objc_getAssociatedObject(self, _cmd) floatValue];
    if (weight == 0) {
        weight = 1;
    }
    return weight;
}

@end

/// 填充空白视图类
@interface WHC_VacntView : WHC_VIEW

@end

@implementation WHC_VacntView

@end

/// 分割线视图
@interface WHC_StackViewLineView : WHC_VIEW

@end

@implementation WHC_StackViewLineView

@end

@interface WHC_StackView () {
    BOOL      _autoHeight;
    BOOL      _autoWidth;
    NSInteger _lastRowVacantCount;
}

@end

@implementation WHC_StackView

- (instancetype)init {
    self = [super init];
    if (self) {
        #if TARGET_OS_IPHONE || TARGET_OS_TV
        self.backgroundColor = [WHC_COLOR whiteColor];
        #elif TARGET_OS_MAC
        self.makeBackingLayer.backgroundColor = [WHC_COLOR whiteColor].CGColor;
        #endif
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        #if TARGET_OS_IPHONE || TARGET_OS_TV
        self.backgroundColor = [WHC_COLOR whiteColor];
        #elif TARGET_OS_MAC
        self.makeBackingLayer.backgroundColor = [WHC_COLOR whiteColor].CGColor;
        #endif
    }
    return self;
}

- (void)setWhc_WidthWeight:(CGFloat)whc_WidthWeight {
    objc_setAssociatedObject(self,
                             @selector(whc_WidthWeight),
                             @(whc_WidthWeight),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setWhc_ElementHeightWidthRatio:(CGFloat)whc_ElementHeightWidthRatio {
    _whc_ElementHeightWidthRatio = whc_ElementHeightWidthRatio;
    _whc_ElementWidthHeightRatio = 0;
}

- (void)setWhc_ElementWidthHeightRatio:(CGFloat)whc_ElementWidthHeightRatio {
    _whc_ElementWidthHeightRatio = whc_ElementWidthHeightRatio;
    _whc_ElementHeightWidthRatio = 0;
}

- (NSInteger)whc_SubViewCount {
    if (self.whc_Orientation == All) {
        return MAX(0, self.subviews.count - _lastRowVacantCount);
    }
    return self.subviews.count;
}

- (NSInteger)whc_Column {
    return MAX(_whc_Column, 1);
}

- (void)whc_AutoHeight {
    [super whc_AutoHeight];
    _autoHeight = YES;
}

- (HeightAuto)whc_HeightAuto {
    _autoHeight = YES;
    __weak typeof(self) weakSelf = self;
    return ^() {
        [super whc_AutoHeight];
        return weakSelf;
    };
}

- (void)whc_AutoWidth {
    [super whc_AutoWidth];
    _autoWidth = YES;
}

- (WidthAuto)whc_WidthAuto {
    _autoWidth = YES;
    __weak typeof(self) weakSelf = self;
    return ^() {
        [super whc_AutoWidth];
        return weakSelf;
    };
}

- (void)whc_StartLayout {
    [self runStackLayoutEngine];
}

- (WHC_StackViewLineView *)makeLine {
    WHC_StackViewLineView * lineView = [WHC_StackViewLineView new];
    #if TARGET_OS_IPHONE || TARGET_OS_TV
    if (self.whc_SegmentLineColor) {
        lineView.backgroundColor = self.whc_SegmentLineColor;
    }else {
        lineView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    }
    #elif TARGET_OS_MAC
    if (self.whc_SegmentLineColor) {
        lineView.makeBackingLayer.backgroundColor = self.whc_SegmentLineColor.CGColor;
    }else {
        lineView.makeBackingLayer.backgroundColor = [WHC_COLOR colorWithWhite:0.9 alpha:1.0].CGColor;
    }
    #endif
    return lineView;
}

- (void)whc_RemoveAllSubviews {
    [self.subviews enumerateObjectsUsingBlock:^(__kindof WHC_VIEW * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
}

- (void)whc_RemoveAllVacntView {
    _lastRowVacantCount = 0;
    [self.subviews enumerateObjectsUsingBlock:^(__kindof WHC_VIEW * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[WHC_VacntView class]]) {
            [obj removeFromSuperview];
        }
    }];
}

- (void)removeAllSegmentLine {
    [self.subviews enumerateObjectsUsingBlock:^(__kindof WHC_VIEW * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[WHC_StackViewLineView class]]) {
            [obj removeFromSuperview];
        }
    }];
}

- (void)runStackLayoutEngine {
    [self removeAllSegmentLine];
    NSArray * subViews = self.subviews;
    NSInteger count = subViews.count;
    if (count == 0) {
        return;
    }
    WHC_VIEW * toView = nil;
    WHC_LayoutOrientationOptions orientation = self.whc_Orientation;
WHC_GOTO:
    switch (orientation) {
        case Horizontal: {
            for (int i = 0; i < count; i++) {
                WHC_VIEW * view = subViews[i];
                WHC_VIEW * nextView = i < count - 1 ? subViews[i + 1] : nil;
                if (i == 0) {
                    [view whc_LeftSpace:self.whc_Edge.left];
                }else {
                    if (self.whc_SegmentLineSize > 0.0) {
                        WHC_StackViewLineView * lineView = [self makeLine];
                        [self addSubview:lineView];
                        [lineView whc_TopSpace:self.whc_SegmentLinePadding];
                        [lineView whc_BottomSpace:self.whc_SegmentLinePadding];
                        [lineView whc_LeftSpace:self.whc_HSpace / 2.0 toView:toView];
                        [lineView whc_Width:self.whc_SegmentLineSize];
                        [view whc_LeftSpace:self.whc_HSpace / 2.0 toView:lineView];
                    }else {
                        [view whc_LeftSpace:self.whc_HSpace toView:toView];
                    }
                }
                [view whc_TopSpace:self.whc_Edge.top];
                if (nextView) {
                    if (self.whc_SubViewWidth > 0) {
                        [view whc_Width:self.whc_SubViewWidth];
                    }else {
                        if (_whc_ElementWidthHeightRatio > 0) {
                            [view whc_WidthHeightRatio:_whc_ElementWidthHeightRatio];
                        }else {
                            if (_autoWidth) {
                                [view whc_WidthAuto];
                            }else {
                                [view whc_WidthEqualView:nextView
                                                   ratio:view.whc_WidthWeight / nextView.whc_WidthWeight];
                            }
                        }
                    }
                    if (self.whc_SubViewHeight > 0) {
                        [view whc_Height:self.whc_SubViewHeight];
                    }else {
                        if (_whc_ElementHeightWidthRatio > 0) {
                            [view whc_HeightWidthRatio:_whc_ElementHeightWidthRatio];
                        }else {
                            if (_autoHeight) {
                                [view whc_HeightAuto];
                            }else {
                                [view whc_BottomSpace:self.whc_Edge.bottom];
                            }
                        }
                    }
                }else {
                    if (self.whc_SubViewWidth > 0) {
                        [view whc_Width:self.whc_SubViewWidth];
                        if (_autoWidth) {
                            [view whc_RightSpace:self.whc_Edge.right];
                        }
                    }else {
                        if (_whc_ElementWidthHeightRatio > 0) {
                            [view whc_WidthHeightRatio:_whc_ElementWidthHeightRatio];
                            if (_autoWidth) {
                                [view whc_RightSpace:self.whc_Edge.right];
                            }
                        }else {
                            if (_autoWidth) {
                                [view whc_WidthAuto];
                            }
                            [view whc_RightSpace:self.whc_Edge.right];
                        }
                    }
                    if (self.whc_SubViewHeight > 0) {
                        [view whc_Height:self.whc_SubViewHeight];
                        if (_autoHeight) {
                            [view whc_BottomSpace:self.whc_Edge.bottom];
                        }
                    }else {
                        if (_whc_ElementHeightWidthRatio > 0) {
                            [view whc_HeightWidthRatio:_whc_ElementHeightWidthRatio];
                            if (_autoHeight) {
                                [view whc_BottomSpace:self.whc_Edge.bottom];
                            }
                        }else {
                            if (_autoHeight) {
                                [view whc_HeightAuto];
                            }
                            [view whc_BottomSpace:self.whc_Edge.bottom];
                        }
                    }
                }
                toView = view;
                if ([toView isKindOfClass:[WHC_StackView class]]) {
                    [((WHC_StackView *)toView) whc_StartLayout];
                }
            }
            break;
        }
        case Vertical: {
            for (int i = 0; i < count; i++) {
                WHC_VIEW * view = subViews[i];
                WHC_VIEW * nextView = i < count - 1 ? subViews[i + 1] : nil;
                if (i == 0) {
                    [view whc_TopSpace:self.whc_Edge.top];
                }else {
                    if (self.whc_SegmentLineSize > 0.0) {
                        WHC_StackViewLineView * lineView = [self makeLine];
                        [self addSubview:lineView];
                        [lineView whc_LeftSpace:self.whc_SegmentLinePadding];
                        [lineView whc_RightSpace:self.whc_SegmentLinePadding];
                        [lineView whc_Height:self.whc_SegmentLineSize];
                        [lineView whc_TopSpace:self.whc_VSpace / 2.0 toView:toView];
                        [view whc_TopSpace:self.whc_VSpace / 2.0 toView:lineView];
                    }else {
                        [view whc_TopSpace:self.whc_VSpace toView:toView];
                    }
                }
                [view whc_LeftSpace:self.whc_Edge.left];
                if (nextView) {
                    if (self.whc_SubViewWidth > 0) {
                        [view whc_Width:self.whc_SubViewWidth];
                    }else {
                        if (_whc_ElementWidthHeightRatio > 0) {
                            [view whc_WidthHeightRatio:_whc_ElementWidthHeightRatio];
                        }else {
                            if (_autoWidth) {
                                [view whc_WidthAuto];
                            }else {
                                [view whc_RightSpace:self.whc_Edge.right];
                            }
                        }
                    }
                    if (self.whc_SubViewHeight > 0) {
                        [view whc_Height:self.whc_SubViewHeight];
                    }else {
                        if (_whc_ElementHeightWidthRatio > 0) {
                            [view whc_HeightWidthRatio:_whc_ElementHeightWidthRatio];
                        }else {
                            if (_autoHeight) {
                                [view whc_HeightAuto];
                            }else {
                                [view whc_HeightEqualView:nextView
                                                    ratio:view.whc_HeightWeight / nextView.whc_HeightWeight];
                            }
                        }
                    }
                }else {
                    if (self.whc_SubViewWidth > 0) {
                        [view whc_Width:self.whc_SubViewWidth];
                        if (_autoWidth) {
                            [view whc_RightSpace:self.whc_Edge.right];
                        }
                    }else {
                        if (_whc_ElementWidthHeightRatio > 0) {
                            [view whc_WidthHeightRatio:_whc_ElementWidthHeightRatio];
                            if (_autoWidth) {
                                [view whc_RightSpace:self.whc_Edge.right];
                            }
                        }else {
                            if (_autoWidth) {
                                [view whc_WidthAuto];
                            }
                            [view whc_RightSpace:self.whc_Edge.right];
                        }
                    }
                    if (self.whc_SubViewHeight > 0) {
                        [view whc_Height:self.whc_SubViewHeight];
                        if (_autoHeight) {
                            [view whc_BottomSpace:self.whc_Edge.bottom];
                        }
                    }else {
                        if (_whc_ElementHeightWidthRatio > 0) {
                            [view whc_HeightWidthRatio:_whc_ElementHeightWidthRatio];
                            if (_autoHeight) {
                                [view whc_BottomSpace:self.whc_Edge.bottom];
                            }
                        }else {
                            if (_autoHeight) {
                                [view whc_HeightAuto];
                            }
                            [view whc_BottomSpace:self.whc_Edge.bottom];
                        }
                    }
                }
                toView = view;
                if ([toView isKindOfClass:[WHC_StackView class]]) {
                    [((WHC_StackView *)toView) whc_StartLayout];
                }
            }
            break;
        }
        case All: {
            for (WHC_VIEW * view in self.subviews) {
                if ([view isKindOfClass:[WHC_VacntView class]]) {
                    [view removeFromSuperview];
                }
            }
            subViews = self.subviews;
            count = subViews.count;
            if (self.whc_Column < 2) {
                orientation = Vertical;
                goto WHC_GOTO;
            }else {
                NSInteger rowCount = count / self.whc_Column + (count % self.whc_Column == 0 ? 0 : 1);
                NSInteger index = 0;
                _lastRowVacantCount = rowCount * self.whc_Column - count;
                for (NSInteger i = 0; i < _lastRowVacantCount; i++) {
                    WHC_VacntView * view = [WHC_VacntView new];
#if TARGET_OS_IPHONE || TARGET_OS_TV
                    view.backgroundColor = [WHC_COLOR clearColor];
#elif TARGET_OS_MAC
                    view.makeBackingLayer.backgroundColor = [WHC_COLOR clearColor].CGColor;
#endif
                    [self addSubview:view];
                }
                if (_lastRowVacantCount > 0) {
                    subViews = nil;
                    subViews = self.subviews;
                    count = subViews.count;
                }
                WHC_VIEW * frontRowView = nil;
                WHC_VIEW * frontColumnView = nil;
                
                WHC_StackViewLineView * columnLineView = nil;
                for (NSInteger row = 0; row < rowCount; row++) {
                    WHC_VIEW * nextRowView = nil;
                    WHC_VIEW * rowView = subViews[row * self.whc_Column];
                    NSInteger nextRow = (row + 1) * self.whc_Column;
                    if (nextRow < count) {
                        nextRowView = subViews[nextRow];
                    }
                    WHC_StackViewLineView * rowLineView = nil;
                    if (self.whc_SegmentLineSize > 0.0 && row > 0) {
                        rowLineView = [self makeLine];
                        [self addSubview:rowLineView];
                        [rowLineView whc_LeftSpace:self.whc_SegmentLinePadding];
                        [rowLineView whc_RightSpace:self.whc_SegmentLinePadding];
                        [rowLineView whc_Height:self.whc_SegmentLineSize];
                        [rowLineView whc_TopSpace:self.whc_VSpace / 2.0 toView:frontRowView];
                    }
                    for (NSInteger column = 0; column < self.whc_Column; column++) {
                        index = row * self.whc_Column + column;
                        WHC_VIEW * view = subViews[index];
                        WHC_VIEW * nextColumnView = nil;
                        if (column > 0 && self.whc_SegmentLineSize > 0.0) {
                            columnLineView = [self makeLine];
                            [self addSubview:columnLineView];
                            [columnLineView whc_LeftSpace:self.whc_HSpace / 2.0 toView:frontColumnView];
                            [columnLineView whc_TopSpace:self.whc_SegmentLinePadding];
                            [columnLineView whc_BottomSpace:self.whc_SegmentLinePadding];
                            [columnLineView whc_Width:self.whc_SegmentLineSize];
                        }
                        if (column < self.whc_Column - 1 && index < count) {
                            nextColumnView = subViews[index + 1];
                        }
                        if (row == 0) {
                            [view whc_TopSpace:self.whc_Edge.top];
                        }else {
                            if (rowLineView) {
                                [view whc_TopSpace:self.whc_VSpace / 2.0 toView:rowLineView];
                            }else {
                                [view whc_TopSpace:self.whc_VSpace toView:frontRowView];
                            }
                        }
                        if (column == 0) {
                            [view whc_LeftSpace:self.whc_Edge.left];
                        }else {
                            if (columnLineView) {
                                [view whc_LeftSpace:self.whc_HSpace / 2.0 toView:columnLineView];
                            }else {
                                [view whc_LeftSpace:self.whc_HSpace toView:frontColumnView];
                            }
                            
                        }
                        if (nextRowView) {
                            if (self.whc_SubViewHeight > 0) {
                                [view whc_Height:self.whc_SubViewHeight];
                            }else {
                                if (_whc_ElementHeightWidthRatio > 0) {
                                    [view whc_HeightWidthRatio:_whc_ElementHeightWidthRatio];
                                }else {
                                    if (_autoHeight) {
                                        [view whc_HeightAuto];
                                    }else {
                                        [view whc_HeightEqualView:nextRowView
                                                            ratio:view.whc_HeightWeight / nextRowView.whc_HeightWeight];
                                    }
                                }
                            }
                        }else {
                            if (self.whc_SubViewHeight > 0) {
                                [view whc_Height:self.whc_SubViewHeight];
                            }else {
                                if (_whc_ElementHeightWidthRatio > 0) {
                                    [view whc_HeightWidthRatio:_whc_ElementHeightWidthRatio];
                                }else {
                                    if (_autoHeight) {
                                        [view whc_HeightAuto];
                                    }else {
                                        [view whc_BottomSpace:self.whc_Edge.bottom];
                                    }
                                }
                            }
                        }
                        if (nextColumnView) {
                            if (self.whc_SubViewWidth > 0) {
                                [view whc_Width:self.whc_SubViewWidth];
                            }else {
                                if (_whc_ElementWidthHeightRatio > 0) {
                                    [view whc_WidthHeightRatio:_whc_ElementWidthHeightRatio];
                                }else {
                                    if (_autoWidth) {
                                        [view whc_WidthAuto];
                                    }else {
                                        [view whc_WidthEqualView:nextColumnView
                                                       ratio:view.whc_WidthWeight / nextColumnView.whc_WidthWeight];
                                    }
                                }
                            }
                        }else {
                            if (self.whc_SubViewWidth > 0) {
                                [view whc_Width:self.whc_SubViewWidth];
                            }else {
                                if (_whc_ElementWidthHeightRatio > 0) {
                                    [view whc_WidthHeightRatio:_whc_ElementWidthHeightRatio];
                                }else {
                                    if (_autoWidth) {
                                        [view whc_WidthAuto];
                                    }else {
                                        [view whc_RightSpace:self.whc_Edge.right];
                                    }
                                }
                            }
                        }
                        frontColumnView = view;
                        if ([frontColumnView isKindOfClass:[WHC_StackView class]]) {
                            [((WHC_StackView *)frontColumnView) whc_StartLayout];
                        }
                    }
                    frontRowView = rowView;
                }
                
                if (_autoWidth) {
#if TARGET_OS_IPHONE || TARGET_OS_TV
                    [self layoutIfNeeded];
#elif TARGET_OS_MAC
                    [self.makeBackingLayer layoutIfNeeded];
#endif
                    CGFloat rowLastColumnViewMaxX = 0;
                    WHC_VIEW * rowLastColumnViewMaxXView;
                    for (NSInteger r = 1; r <= rowCount; r++) {
                        NSInteger index = r * _whc_Column - 1;
                        WHC_VIEW * maxWidthView = self.subviews[index];
#if TARGET_OS_IPHONE || TARGET_OS_TV
                        [maxWidthView layoutIfNeeded];
#elif TARGET_OS_MAC
                        [maxWidthView.makeBackingLayer layoutIfNeeded];
#endif
                        if (maxWidthView.whc_maxX > rowLastColumnViewMaxX) {
                            rowLastColumnViewMaxX = maxWidthView.whc_maxX;
                            rowLastColumnViewMaxXView = maxWidthView;
                        }
                    }
                    [rowLastColumnViewMaxXView whc_RightSpace:_whc_Edge.right];
                }
                
                if (_autoHeight) {
#if TARGET_OS_IPHONE || TARGET_OS_TV
                    [self layoutIfNeeded];
#elif TARGET_OS_MAC
                    [self.makeBackingLayer layoutIfNeeded];
#endif
                    CGFloat columnLastRowViewMaxY = 0;
                    WHC_VIEW * columnLastRowViewMaxYView;
                    for (NSInteger r = 1; r <= rowCount; r++) {
                        NSInteger index = r * _whc_Column - 1;
                        WHC_VIEW * maxHeightView = self.subviews[index];
#if TARGET_OS_IPHONE || TARGET_OS_TV
                        [maxHeightView layoutIfNeeded];
#elif TARGET_OS_MAC
                        [maxHeightView.makeBackingLayer layoutIfNeeded];
#endif
                        if (maxHeightView.whc_maxY > columnLastRowViewMaxY) {
                            columnLastRowViewMaxY = maxHeightView.whc_maxY;
                            columnLastRowViewMaxYView = maxHeightView;
                        }
                    }
                    [columnLastRowViewMaxYView whc_BottomSpace:_whc_Edge.bottom];
                }
            }
            break;
        }
        default:
            break;
    }
}


@end
