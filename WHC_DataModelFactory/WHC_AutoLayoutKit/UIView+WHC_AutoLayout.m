//
//  WHC_VIEW+WHC_AutoLayout.m
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

#import "UIView+WHC_AutoLayout.h"
#import <objc/runtime.h>

#if TARGET_OS_IPHONE || TARGET_OS_TV

#define kDeprecatedVerticalAdapter (0)

typedef NS_OPTIONS(NSUInteger, WHCNibType) {
    XIB = 1 << 0,
    SB = 1 << 1
};

#pragma mark - UI自动布局 -

@interface WHC_Line : WHC_VIEW
@end

@implementation WHC_Line
@end

#endif

@implementation WHC_VIEW (WHC_AutoLayout)

- (void)setCurrentConstraint:(NSLayoutConstraint *)currentConstraint {
    objc_setAssociatedObject(self, @selector(currentConstraint), currentConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)currentConstraint {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setLeftConstraint:(NSLayoutConstraint *)leftConstraint {
    objc_setAssociatedObject(self, @selector(leftConstraint), leftConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)leftConstraint {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setRightConstraint:(NSLayoutConstraint *)rightConstraint {
    objc_setAssociatedObject(self, @selector(rightConstraint), rightConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)rightConstraint {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setTopConstraint:(NSLayoutConstraint *)topConstraint {
    objc_setAssociatedObject(self, @selector(topConstraint), topConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)topConstraint {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setBottomConstraint:(NSLayoutConstraint *)bottomConstraint {
    objc_setAssociatedObject(self, @selector(bottomConstraint), bottomConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)bottomConstraint {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setLeadingConstraint:(NSLayoutConstraint *)leadingConstraint {
    objc_setAssociatedObject(self, @selector(leadingConstraint), leadingConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)leadingConstraint {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setTrailingConstraint:(NSLayoutConstraint *)trailingConstraint {
    objc_setAssociatedObject(self, @selector(trailingConstraint), trailingConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)trailingConstraint {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setWidthConstraint:(NSLayoutConstraint *)widthConstraint {
    objc_setAssociatedObject(self, @selector(widthConstraint), widthConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)widthConstraint {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setHeightConstraint:(NSLayoutConstraint *)heightConstraint {
    objc_setAssociatedObject(self, @selector(heightConstraint), heightConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)heightConstraint {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setCenterXConstraint:(NSLayoutConstraint *)centerXConstraint {
    objc_setAssociatedObject(self, @selector(centerXConstraint), centerXConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)centerXConstraint {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setCenterYConstraint:(NSLayoutConstraint *)centerYConstraint {
    objc_setAssociatedObject(self, @selector(centerYConstraint), centerYConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)centerYConstraint {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setLastBaselineConstraint:(NSLayoutConstraint *)lastBaselineConstraint {
    objc_setAssociatedObject(self, @selector(lastBaselineConstraint), lastBaselineConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)lastBaselineConstraint {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setFirstBaselineConstraint:(NSLayoutConstraint *)firstBaselineConstraint {
    objc_setAssociatedObject(self, @selector(firstBaselineConstraint), firstBaselineConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)firstBaselineConstraint {
    return objc_getAssociatedObject(self, _cmd);
}

#pragma mark - removeConstraint api v2.0 -

- (ResetConstraintAttribute)whc_ResetConstraint {
    __weak typeof(self) weakSelf = self;
    return ^() {
        [weakSelf whc_ResetConstraints];
        return weakSelf;
    };
}

- (RemoveConstraintAttribute)whc_RemoveLayoutAttrs {
    __weak typeof(self) weakSelf = self;
    return ^(NSLayoutAttribute attributes, ...) {
        va_list attrs;
        va_start(attrs, attributes);
        NSLayoutAttribute maxAttr = [weakSelf whc_GetMaxLayoutAttribute];
        while(attributes > NSLayoutAttributeNotAnAttribute && attributes <= maxAttr) {
            if (attributes > 0) {
                [weakSelf whc_SwitchRemoveAttr:attributes view:weakSelf.superview removeSelf:YES];
            }
            attributes = va_arg(attrs, NSLayoutAttribute);
        }
        va_end(attrs);
        return weakSelf;
    };
}

- (RemoveConstraintFromViewAttribute)whc_RemoveFromLayoutAttrs {
    __weak typeof(self) weakSelf = self;
    return ^(WHC_VIEW * view,NSLayoutAttribute attributes, ...) {
        va_list attrs;
        va_start(attrs, attributes);
        NSLayoutAttribute maxAttr = [weakSelf whc_GetMaxLayoutAttribute];
        while(attributes > NSLayoutAttributeNotAnAttribute && attributes <= maxAttr) {
            if (attributes > 0) {
                [weakSelf whc_SwitchRemoveAttr:attributes view:view removeSelf:NO];
            }
            attributes = va_arg(attrs, NSLayoutAttribute);
        }
        va_end(attrs);
        return weakSelf;
    };
}

- (ClearConstraintAttribute)whc_ClearLayoutAttr {
    __weak typeof(self) weakSelf = self;
    return ^() {
        [weakSelf whc_ClearLayoutAttrs];
        return weakSelf;
    };
}

#pragma mark - constraintsPriority api v2.0 -

- (PriorityLow)whc_PriorityLow {
    __weak typeof(self) weakSelf = self;
    return ^() {
        [weakSelf whc_priorityLow];
        return weakSelf;
    };
}

- (PriorityHigh)whc_PriorityHigh {
    __weak typeof(self) weakSelf = self;
    return ^() {
        [weakSelf whc_priorityHigh];
        return weakSelf;
    };
}

- (PriorityRequired)whc_PriorityRequired {
    __weak typeof(self) weakSelf = self;
    return ^() {
        [weakSelf whc_priorityRequired];
        return weakSelf;
    };
}

- (PriorityFitting)whc_PriorityFitting {
    __weak typeof(self) weakSelf = self;
    return ^() {
        [weakSelf whc_priorityFitting];
        return weakSelf;
    };
}

- (PriorityValue)whc_Priority {
    __weak typeof(self) weakSelf = self;
    return ^(CGFloat value) {
        [weakSelf whc_priority:value];
        return weakSelf;
    };
}

#pragma mark - api version 2.0 -
- (LeftSpace)whc_LeftSpace {
    __weak typeof(self) weakSelf = self;
    return ^(CGFloat space) {
        [weakSelf whc_LeftSpace:space];
        return weakSelf;
    };
}

- (LeftSpaceToView)whc_LeftSpaceToView {
    __weak typeof(self) weakSelf = self;
    return ^(CGFloat space, WHC_VIEW * toView) {
        [weakSelf whc_LeftSpace:space toView:toView];
        return weakSelf;
    };
}

- (LeftSpaceEqualView)whc_LeftSpaceEqualView {
    __weak typeof(self) weakSelf = self;
    return ^(WHC_VIEW * view) {
        [weakSelf whc_LeftSpaceEqualView:view];
        return weakSelf;
    };
}

- (LeftSpaceEqualViewOffset)whc_LeftSpaceEqualViewOffset {
    __weak typeof(self) weakSelf = self;
    return ^(WHC_VIEW * view, CGFloat offset) {
        [weakSelf whc_LeftSpaceEqualView:view offset:offset];
        return weakSelf;
    };
}

- (LeadingSpace)whc_LeadingSpace {
    __weak typeof(self) weakSelf = self;
    return ^(CGFloat space) {
        [weakSelf whc_LeadingSpace:space];
        return weakSelf;
    };
}

- (LeadingSpaceToView)whc_LeadingSpaceToView {
    __weak typeof(self) weakSelf = self;
    return ^(CGFloat value , WHC_VIEW * toView) {
        [weakSelf whc_LeadingSpace:value toView:toView];
        return weakSelf;
    };
}

- (LeadingSpaceEqualView)whc_LeadingSpaceEqualView {
    __weak typeof(self) weakSelf = self;
    return ^(WHC_VIEW * view) {
        [weakSelf whc_LeadingSpaceEqualView:view];
        return weakSelf;
    };
}

- (LeadingSpaceEqualViewOffset)whc_LeadingSpaceEqualViewOffset {
    __weak typeof(self) weakSelf = self;
    return ^(WHC_VIEW * view, CGFloat offset) {
        [weakSelf whc_LeadingSpaceEqualView:view offset:offset];
        return weakSelf;
    };
}

- (TrailingSpace)whc_TrailingSpace {
    __weak typeof(self) weakSelf = self;
    return ^(CGFloat space) {
        [weakSelf whc_TrailingSpace:space];
        return weakSelf;
    };
}

- (TrailingSpaceToView)whc_TrailingSpaceToView {
    __weak typeof(self) weakSelf = self;
    return ^(CGFloat value , WHC_VIEW * toView) {
        [weakSelf whc_TrailingSpace:value toView:toView];
        return weakSelf;
    };
}

- (TrailingSpaceEqualView)whc_TrailingSpaceEqualView {
    __weak typeof(self) weakSelf = self;
    return ^(WHC_VIEW * view) {
        [weakSelf whc_TrailingSpaceEqualView:view];
        return weakSelf;
    };
}

- (TrailingSpaceEqualViewOffset)whc_TrailingSpaceEqualViewOffset {
    __weak typeof(self) weakSelf = self;
    return ^(WHC_VIEW * view, CGFloat offset) {
        [weakSelf whc_TrailingSpaceEqualView:view offset:offset];
        return weakSelf;
    };
}

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)
- (BaseLineSpace)whc_FirstBaseLine {
    __weak typeof(self) weakSelf = self;
    return ^(CGFloat space) {
        [weakSelf whc_FirstBaseLine:space];
        return weakSelf;
    };
}

- (BaseLineSpaceToView)whc_FirstBaseLineToView {
    __weak typeof(self) weakSelf = self;
    return ^(CGFloat value , WHC_VIEW * toView) {
        [weakSelf whc_FirstBaseLine:value toView:toView];
        return weakSelf;
    };
}

- (BaseLineSpaceEqualView)whc_FirstBaseLineEqualView {
    __weak typeof(self) weakSelf = self;
    return ^(WHC_VIEW * view) {
        [weakSelf whc_FirstBaseLineEqualView:view];
        return weakSelf;
    };
}

- (BaseLineSpaceEqualViewOffset)whc_FirstBaseLineEqualViewOffset {
    __weak typeof(self) weakSelf = self;
    return ^(WHC_VIEW * view, CGFloat offset) {
        [weakSelf whc_FirstBaseLineEqualView:view offset:offset];
        return weakSelf;
    };
}

#endif

- (BaseLineSpace)whc_LastBaseLine {
    __weak typeof(self) weakSelf = self;
    return ^(CGFloat space) {
        [weakSelf whc_LastBaseLine:space];
        return weakSelf;
    };
}

- (BaseLineSpaceToView)whc_LastBaseLineToView {
    __weak typeof(self) weakSelf = self;
    return ^(CGFloat value , WHC_VIEW * toView) {
        [weakSelf whc_LastBaseLine:value toView:toView];
        return weakSelf;
    };
}

- (BaseLineSpaceEqualView)whc_LastBaseLineEqualView {
    __weak typeof(self) weakSelf = self;
    return ^(WHC_VIEW * view) {
        [weakSelf whc_LastBaseLineEqualView:view];
        return weakSelf;
    };
}

- (BaseLineSpaceEqualViewOffset)whc_LastBaseLineEqualViewOffset {
    __weak typeof(self) weakSelf = self;
    return ^(WHC_VIEW * view, CGFloat offset) {
        [weakSelf whc_LastBaseLineEqualView:view offset:offset];
        return weakSelf;
    };
}

- (RightSpace)whc_RightSpace {
    __weak typeof(self) weakSelf = self;
    return ^(CGFloat space) {
        [weakSelf whc_RightSpace:space];
        return weakSelf;
    };
}

- (RightSpaceToView)whc_RightSpaceToView {
    __weak typeof(self) weakSelf = self;
    return ^(CGFloat value , WHC_VIEW * toView) {
        [weakSelf whc_RightSpace:value toView:toView];
        return weakSelf;
    };
}

- (RightSpaceEqualView)whc_RightSpaceEqualView {
    __weak typeof(self) weakSelf = self;
    return ^(WHC_VIEW * toView) {
        [weakSelf whc_RightSpaceEqualView:toView];
        return weakSelf;
    };
}

- (RightSpaceEqualViewOffset)whc_RightSpaceEqualViewOffset {
    __weak typeof(self) weakSelf = self;
    return ^(WHC_VIEW * toView, CGFloat offset) {
        [weakSelf whc_RightSpaceEqualView:toView offset:offset];
        return weakSelf;
    };
}

- (TopSpace)whc_TopSpace {
    __weak typeof(self) weakSelf = self;
    return ^(CGFloat space) {
        [weakSelf whc_TopSpace:space];
        return weakSelf;
    };
}

- (TopSpaceToView)whc_TopSpaceToView {
    __weak typeof(self) weakSelf = self;
    return ^(CGFloat value , WHC_VIEW * toView) {
        [weakSelf whc_TopSpace:value toView:toView];
        return weakSelf;
    };
}

- (TopSpaceEqualView)whc_TopSpaceEqualView {
    __weak typeof(self) weakSelf = self;
    return ^(WHC_VIEW * view) {
        [weakSelf whc_TopSpaceEqualView:view];
        return weakSelf;
    };
}

- (TopSpaceEqualViewOffset)whc_TopSpaceEqualViewOffset {
    __weak typeof(self) weakSelf = self;
    return ^(WHC_VIEW * view, CGFloat offset) {
        [weakSelf whc_TopSpaceEqualView:view offset:offset];
        return weakSelf;
    };
}

- (BottomSpace)whc_BottomSpace {
    __weak typeof(self) weakSelf = self;
    return ^(CGFloat space) {
        [weakSelf whc_BottomSpace:space];
        return weakSelf;
    };
}

- (BottomSpaceToView)whc_BottomSpaceToView {
    __weak typeof(self) weakSelf = self;
    return ^(CGFloat value , WHC_VIEW * toView) {
        [weakSelf whc_BottomSpace:value toView:toView];
        return weakSelf;
    };
}

- (BottomSpaceEqualView)whc_BottomSpaceEqualView {
    __weak typeof(self) weakSelf = self;
    return ^(WHC_VIEW * toView) {
        [weakSelf whc_BottomSpaceEqualView:toView];
        return weakSelf;
    };
}

- (BottomSpaceEqualViewOffset)whc_BottomSpaceEqualViewOffset {
    __weak typeof(self) weakSelf = self;
    return ^(WHC_VIEW * toView, CGFloat offset) {
        [weakSelf whc_BottomSpaceEqualView:toView offset:offset];
        return weakSelf;
    };
}

- (Width)whc_Width {
    __weak typeof(self) weakSelf = self;
    return ^(CGFloat value) {
        [weakSelf whc_Width:value];
        return weakSelf;
    };
}

- (WidthAuto)whc_WidthAuto {
    __weak typeof(self) weakSelf = self;
    return ^() {
        [weakSelf whc_AutoWidth];
        return weakSelf;
    };
}

- (WidthEqualView)whc_WidthEqualView {
    __weak typeof(self) weakSelf = self;
    return ^(WHC_VIEW * view) {
        [weakSelf whc_WidthEqualView:view];
        return weakSelf;
    };
}

- (WidthEqualViewRatio)whc_WidthEqualViewRatio {
    __weak typeof(self) weakSelf = self;
    return ^(WHC_VIEW * view , CGFloat value) {
        [weakSelf whc_WidthEqualView:view ratio:value];
        return weakSelf;
    };
}

- (WidthHeightRatio)whc_WidthHeightRatio {
    __weak typeof(self) weakSelf = self;
    return ^(CGFloat value) {
        [weakSelf whc_WidthHeightRatio:value];
        return weakSelf;
    };
}

- (Height)whc_Height {
    __weak typeof(self) weakSelf = self;
    return ^(CGFloat value) {
        [weakSelf whc_Height:value];
        return weakSelf;
    };
}

- (HeightAuto)whc_HeightAuto {
    __weak typeof(self) weakSelf = self;
    return ^() {
        [weakSelf whc_AutoHeight];
        return weakSelf;
    };
}

- (HeightEqualView)whc_HeightEqualView {
    __weak typeof(self) weakSelf = self;
    return ^(WHC_VIEW * view) {
        [weakSelf whc_HeightEqualView:view];
        return weakSelf;
    };
}

- (HeightEqualViewRatio)whc_HeightEqualViewRatio {
    __weak typeof(self) weakSelf = self;
    return ^(WHC_VIEW * view , CGFloat value) {
        [weakSelf whc_HeightEqualView:view ratio:value];
        return weakSelf;
    };
}

- (HeightWidthRatio)whc_HeightWidthRatio {
    __weak typeof(self) weakSelf = self;
    return ^(CGFloat value) {
        [weakSelf whc_HeightWidthRatio:value];
        return weakSelf;
    };
}

- (CenterX)whc_CenterX {
    __weak typeof(self) weakSelf = self;
    return ^(CGFloat value) {
        [weakSelf whc_CenterX:value];
        return weakSelf;
    };
}

- (CenterXToView)whc_CenterXToView {
    __weak typeof(self) weakSelf = self;
    return ^(CGFloat value,WHC_VIEW * toView) {
        [weakSelf whc_CenterX:value toView:toView];
        return weakSelf;
    };
}

- (CenterY)whc_CenterY {
    __weak typeof(self) weakSelf = self;
    return ^(CGFloat value) {
        [weakSelf whc_CenterY:value];
        return weakSelf;
    };
}

- (CenterYToView)whc_CenterYToView {
    __weak typeof(self) weakSelf = self;
    return ^(CGFloat value,WHC_VIEW * toView) {
        [weakSelf whc_CenterY:value toView:toView];
        return weakSelf;
    };
}

- (Center)whc_Center {
    __weak typeof(self) weakSelf = self;
    return ^(CGFloat x, CGFloat y) {
        [weakSelf whc_Center:CGPointMake(x, y)];
        return weakSelf;
    };
}

- (CenterToView)whc_CenterToView {
    __weak typeof(self) weakSelf = self;
    return ^(CGPoint center,WHC_VIEW * toView) {
        [weakSelf whc_Center:center toView:toView];
        return weakSelf;
    };
}

- (size)whc_Size {
    __weak typeof(self) weakSelf = self;
    return ^(CGFloat width, CGFloat height) {
        [weakSelf whc_Size:CGSizeMake(width, height)];
        return weakSelf;
    };
}

- (SizeEqual)whc_SizeEqualView {
    __weak typeof(self) weakSelf = self;
    return ^(WHC_VIEW * view) {
        [weakSelf whc_SizeEqualView:view];
        return weakSelf;
    };
}

- (FrameEqual)whc_FrameEqualView {
    __weak typeof(self) weakSelf = self;
    return ^(WHC_VIEW * view) {
        [weakSelf whc_FrameEqualView:view];
        return weakSelf;
    };
}

#pragma mark - removeConstraint api v1.0 -

- (NSLayoutAttribute)whc_GetMaxLayoutAttribute {
    NSLayoutAttribute maxAttr = NSLayoutAttributeNotAnAttribute;
#if TARGET_OS_IPHONE || TARGET_OS_TV
#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000)
    maxAttr = NSLayoutAttributeCenterYWithinMargins;
#else
    maxAttr = NSLayoutAttributeLastBaseline;
#endif
    
#elif TARGET_OS_MAC
#if (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)
    maxAttr = NSLayoutAttributeFirstBaseline;
#else
    maxAttr = NSLayoutAttributeLastBaseline;
#endif
    
#endif
    return maxAttr;
}

- (WHC_VIEW *)whc_MainViewConstraint:(NSLayoutConstraint *)constraint {
    WHC_VIEW * view = nil;
    if (constraint) {
        if (constraint.secondAttribute == NSLayoutAttributeNotAnAttribute ||
            constraint.secondItem == nil) {
            view = constraint.firstItem;
        }else {
            WHC_VIEW * firstItem = constraint.firstItem;
            WHC_VIEW * secondItem = constraint.secondItem;
            if (firstItem.superview == secondItem.superview) {
                view = firstItem.superview;
            }else {
                view = secondItem;
            }
        }
    }
    return view;
}

- (void)whc_CommonRemoveConstraint:(NSLayoutAttribute)attribute view:(WHC_VIEW *)mainView {
    NSLayoutConstraint * constraint = nil;
    WHC_VIEW * view = nil;
    switch (attribute) {
#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)
        case NSLayoutAttributeFirstBaseline:
            constraint = [self firstBaselineConstraint];
            if (constraint) {
                view = [self whc_MainViewConstraint:constraint];
                if (view) [view removeConstraint:constraint];
                [self setFirstBaselineConstraint:nil];
            }
            break;
#endif
        case NSLayoutAttributeLastBaseline:
            constraint = [self lastBaselineConstraint];
            if (constraint) {
                view = [self whc_MainViewConstraint:constraint];
                if (view) [view removeConstraint:constraint];
                [self setLastBaselineConstraint:nil];
            }
            break;
        case NSLayoutAttributeCenterY:
            constraint = [self centerYConstraint];
            if (constraint) {
                view = [self whc_MainViewConstraint:constraint];
                if (view) [view removeConstraint:constraint];
                [self setCenterYConstraint:nil];
            }
            break;
        case NSLayoutAttributeCenterX:
            constraint = [self centerXConstraint];
            if (constraint) {
                view = [self whc_MainViewConstraint:constraint];
                if (view) [view removeConstraint:constraint];
                [self setCenterXConstraint:nil];
            }
            break;
        case NSLayoutAttributeTrailing:
            constraint = [self trailingConstraint];
            if (constraint) {
                view = [self whc_MainViewConstraint:constraint];
                if (view) [view removeConstraint:constraint];
                [self setTrailingConstraint:nil];
            }
            break;
        case NSLayoutAttributeLeading:
            constraint = [self leadingConstraint];
            if (constraint) {
                view = [self whc_MainViewConstraint:constraint];
                if (view) [view removeConstraint:constraint];
                [self setLeadingConstraint:nil];
            }
            break;
        case NSLayoutAttributeBottom:
            constraint = [self bottomConstraint];
            if (constraint) {
                view = [self whc_MainViewConstraint:constraint];
                if (view) [view removeConstraint:constraint];
                [self setBottomConstraint:nil];
            }
            break;
        case NSLayoutAttributeTop:
            constraint = [self topConstraint];
            if (constraint) {
                view = [self whc_MainViewConstraint:constraint];
                if (view) [view removeConstraint:constraint];
                [self setTopConstraint:nil];
            }
            break;
        case NSLayoutAttributeRight:
            constraint = [self rightConstraint];
            if (constraint) {
                view = [self whc_MainViewConstraint:constraint];
                if (view) [view removeConstraint:constraint];
                [self setRightConstraint:nil];
            }
            break;
        case NSLayoutAttributeLeft:
            constraint = [self leftConstraint];
            if (constraint) {
                view = [self whc_MainViewConstraint:constraint];
                if (view) [view removeConstraint:constraint];
                [self setLeftConstraint:nil];
            }
            break;
        case NSLayoutAttributeWidth:
            constraint = [self widthConstraint];
            if (constraint) {
                view = [self whc_MainViewConstraint:constraint];
                if (view) [view removeConstraint:constraint];
                [self setWidthConstraint:nil];
            }
            break;
        case NSLayoutAttributeHeight:
            constraint = [self heightConstraint];
            if (constraint) {
                view = [self whc_MainViewConstraint:constraint];
                if (view) [view removeConstraint:constraint];
                [self setHeightConstraint:nil];
            }
            break;
        default:
            break;
    }
    if (mainView) {
        NSArray<NSLayoutConstraint *> * constraints = mainView.constraints;
        [constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.firstItem == self &&
                obj.firstAttribute == attribute) {
                [mainView removeConstraint:obj];
            }
        }];
    }
}

- (void)whc_SwitchRemoveAttr:(NSLayoutAttribute)attr view:(WHC_VIEW *)view removeSelf:(BOOL)removeSelf {
    switch (attr) {
#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)
        case NSLayoutAttributeFirstBaseline:
#endif
#if ((TARGET_OS_IPHONE || TARGET_OS_TV) && (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000))
        case NSLayoutAttributeLeftMargin:
        case NSLayoutAttributeRightMargin:
        case NSLayoutAttributeTopMargin:
        case NSLayoutAttributeBottomMargin:
        case NSLayoutAttributeLeadingMargin:
        case NSLayoutAttributeTrailingMargin:
        case NSLayoutAttributeCenterXWithinMargins:
        case NSLayoutAttributeCenterYWithinMargins:
#endif
        case NSLayoutAttributeLastBaseline:
        case NSLayoutAttributeCenterY:
        case NSLayoutAttributeCenterX:
        case NSLayoutAttributeTrailing:
        case NSLayoutAttributeLeading:
        case NSLayoutAttributeBottom:
        case NSLayoutAttributeTop:
        case NSLayoutAttributeRight:
        case NSLayoutAttributeLeft:
            [self whc_CommonRemoveConstraint:attr view:view];
            break;
        case NSLayoutAttributeWidth:
        case NSLayoutAttributeHeight:
            if (removeSelf) {
                [self whc_CommonRemoveConstraint:attr view:self];
            }
            [self whc_CommonRemoveConstraint:attr view:view];
            break;
        default:
            break;
    }
}

- (WHC_VIEW *)whc_ResetConstraints {
    WHC_VIEW * (^getMainView)(NSLayoutConstraint * constraint) = ^(NSLayoutConstraint * constraint){
        WHC_VIEW * view = nil;
        if (constraint && constraint.secondAttribute != NSLayoutAttributeNotAnAttribute && constraint.secondItem != nil) {
            WHC_VIEW * firstItem = constraint.firstItem;
            WHC_VIEW * secondItem = constraint.secondItem;
            if (firstItem.superview == secondItem.superview) {
                view = firstItem.superview;
            }else {
                view = secondItem;
            }
        }
        return view;
    };

    NSLayoutConstraint * constraint = [self firstBaselineConstraint];
    WHC_VIEW * mainView = getMainView(constraint);
    if (mainView) {
        [mainView removeConstraint:constraint];
        [self setFirstBaselineConstraint:nil];
    }
    
    constraint = [self lastBaselineConstraint];
    mainView = getMainView(constraint);
    if (mainView) {
        [mainView removeConstraint:constraint];
        [self setLastBaselineConstraint:nil];
    }
    
    constraint = [self centerYConstraint];
    mainView = getMainView(constraint);
    if (mainView) {
        [mainView removeConstraint:constraint];
        [self setCenterYConstraint:nil];
    }
    
    constraint = [self centerXConstraint];
    mainView = getMainView(constraint);
    if (mainView) {
        [mainView removeConstraint:constraint];
        [self setCenterXConstraint:nil];
    }
    
    constraint = [self trailingConstraint];
    mainView = getMainView(constraint);
    if (mainView) {
        [mainView removeConstraint:constraint];
        [self setTrailingConstraint:nil];
    }

    constraint = [self leadingConstraint];
    mainView = getMainView(constraint);
    if (mainView) {
        [mainView removeConstraint:constraint];
        [self setLeadingConstraint:nil];
    }

    constraint = [self bottomConstraint];
    mainView = getMainView(constraint);
    if (mainView) {
        [mainView removeConstraint:constraint];
        [self setBottomConstraint:nil];
    }
    
    constraint = [self topConstraint];
    mainView = getMainView(constraint);
    if (mainView) {
        [mainView removeConstraint:constraint];
        [self setTopConstraint:nil];
    }

    constraint = [self rightConstraint];
    mainView = getMainView(constraint);
    if (mainView) {
        [mainView removeConstraint:constraint];
        [self setRightConstraint:nil];
    }

    constraint = [self leftConstraint];
    mainView = getMainView(constraint);
    if (mainView) {
        [mainView removeConstraint:constraint];
        [self setLeftConstraint:nil];
    }

    constraint = [self widthConstraint];
    mainView = getMainView(constraint);
    if (mainView) {
        [mainView removeConstraint:constraint];
        [self setWidthConstraint:nil];
    }
    
    constraint = [self heightConstraint];
    mainView = getMainView(constraint);
    if (mainView) {
        [mainView removeConstraint:constraint];
        [self setHeightConstraint:nil];
    }
    return self;
}

- (WHC_VIEW *)whc_ClearLayoutAttrs {
    @autoreleasepool {
        NSArray<NSLayoutConstraint *> * constraints = self.constraints;
        if (constraints) {
            [constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.firstItem == self &&
                    obj.secondAttribute == NSLayoutAttributeNotAnAttribute) {
                    [self removeConstraint:obj];
                }
            }];
        }
        WHC_VIEW * superView = self.superview;
        if (superView) {
            constraints = superView.constraints;
            if (constraints) {
                [constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (obj.firstItem == self) {
                        [superView removeConstraint:obj];
                    }
                }];
            }
        }
    }
    return self;
}

- (WHC_VIEW *)whc_RemoveFrom:(WHC_VIEW *)view layoutAttrs:(NSLayoutAttribute)attributes, ... {
    va_list attrs;
    va_start(attrs, attributes);
    NSLayoutAttribute maxAttr = [self whc_GetMaxLayoutAttribute];
    while(attributes > NSLayoutAttributeNotAnAttribute && attributes <= maxAttr) {
        if (attributes > 0) {
            [self whc_SwitchRemoveAttr:attributes view:view removeSelf:NO];
        }
        attributes = va_arg(attrs, NSLayoutAttribute);
    }
    va_end(attrs);
    return self;
}

- (WHC_VIEW *)whc_RemoveLayoutAttr:(NSLayoutAttribute)attributes, ... {
    va_list attrs;
    va_start(attrs, attributes);
    NSLayoutAttribute maxAttr = [self whc_GetMaxLayoutAttribute];
    while(attributes > NSLayoutAttributeNotAnAttribute && attributes <= maxAttr) {
        if (attributes > 0) {
            [self whc_SwitchRemoveAttr:attributes view:self.superview removeSelf:YES];
        }
        attributes = va_arg(attrs, NSLayoutAttribute);
    }
    va_end(attrs);
    return self;
}

#pragma mark - constraintsPriority api v1.0 -

- (WHC_VIEW *)whc_HandleConstraintsPriority:(WHC_LayoutPriority)priority {
    NSLayoutConstraint * constraints = [self currentConstraint];
    if (constraints && constraints.priority != priority) {
#if TARGET_OS_IPHONE || TARGET_OS_TV
        if (constraints.priority == UILayoutPriorityRequired) {
#elif TARGET_OS_MAC
        if (constraints.priority == NSLayoutPriorityRequired) {
#endif
            if (!constraints.secondItem ||
                constraints.secondAttribute == NSLayoutAttributeNotAnAttribute) {
                [self removeConstraint:constraints];
                constraints.priority = priority;
                [self addConstraint:constraints];
            }else {
                if (self.superview) {
                    [self.superview removeConstraint:constraints];
                    constraints.priority = priority;
                    [self.superview addConstraint:constraints];
                }
            }
        }else if (constraints) {
            constraints.priority = priority;
        }
    }
    return self;
}

- (WHC_VIEW *)whc_priorityLow {
#if TARGET_OS_IPHONE || TARGET_OS_TV
    return [self whc_HandleConstraintsPriority:UILayoutPriorityDefaultLow];
#elif TARGET_OS_MAC
    return [self whc_HandleConstraintsPriority:NSLayoutPriorityDefaultLow];
#endif
}

- (WHC_VIEW *)whc_priorityHigh {
#if TARGET_OS_IPHONE || TARGET_OS_TV
    return [self whc_HandleConstraintsPriority:UILayoutPriorityDefaultHigh];
#elif TARGET_OS_MAC
    return [self whc_HandleConstraintsPriority:NSLayoutPriorityDefaultHigh];
#endif
}

- (WHC_VIEW *)whc_priorityRequired {
#if TARGET_OS_IPHONE || TARGET_OS_TV
    return [self whc_HandleConstraintsPriority:UILayoutPriorityRequired];
#elif TARGET_OS_MAC
    return [self whc_HandleConstraintsPriority:NSLayoutPriorityRequired];
#endif
}

- (WHC_VIEW *)whc_priorityFitting {
#if TARGET_OS_IPHONE || TARGET_OS_TV
    return [self whc_HandleConstraintsPriority:UILayoutPriorityFittingSizeLevel];
#elif TARGET_OS_MAC
    return [self whc_HandleConstraintsPriority:NSLayoutPriorityFittingSizeCompression];
#endif
}
    
- (WHC_VIEW *)whc_priority:(CGFloat)value {
    return [self whc_HandleConstraintsPriority:value];
}

#pragma mark - api version 1.0

- (WHC_VIEW *)whc_LeftSpace:(CGFloat)leftSpace {
    return [self whc_ConstraintWithItem:self.superview
                       attribute:NSLayoutAttributeLeft
                        constant:leftSpace];
}

- (WHC_VIEW *)whc_LeftSpace:(CGFloat)leftSpace toView:(WHC_VIEW *)toView {
    NSLayoutAttribute toAttribute = NSLayoutAttributeRight;
    if (toView.superview == nil) {
        toAttribute = NSLayoutAttributeLeft;
    }else if (self.superview != toView.superview) {
        toAttribute = NSLayoutAttributeLeft;
    }
    return [self whc_ConstraintWithItem:self
                       attribute:NSLayoutAttributeLeft
                       relatedBy:NSLayoutRelationEqual
                          toItem:toView
                       attribute:toAttribute
                      multiplier:1
                        constant:leftSpace];
}

- (WHC_VIEW *)whc_LeftSpaceEqualView:(WHC_VIEW *)view {
    return [self whc_LeftSpaceEqualView:view offset:0];
}

- (WHC_VIEW *)whc_LeftSpaceEqualView:(WHC_VIEW *)view offset:(CGFloat)offset {
    return [self whc_ConstraintWithItem:self
                       attribute:NSLayoutAttributeLeft
                       relatedBy:NSLayoutRelationEqual
                          toItem:view
                       attribute:NSLayoutAttributeLeft
                      multiplier:1
                        constant:offset];
}

- (WHC_VIEW *)whc_RightSpace:(CGFloat)rightSpace {
    return [self whc_ConstraintWithItem:self.superview
                       attribute:NSLayoutAttributeRight
                        constant:0.0 - rightSpace];
}

- (WHC_VIEW *)whc_RightSpace:(CGFloat)rightSpace toView:(WHC_VIEW *)toView {
    NSLayoutAttribute toAttribute = NSLayoutAttributeLeft;
    if (toView.superview == nil) {
        toAttribute = NSLayoutAttributeRight;
    }else if (self.superview != toView.superview) {
        toAttribute = NSLayoutAttributeRight;
    }
    return [self whc_ConstraintWithItem:self
                       attribute:NSLayoutAttributeRight
                       relatedBy:NSLayoutRelationEqual
                          toItem:toView
                       attribute:toAttribute
                      multiplier:1
                        constant:0.0 - rightSpace];
}

- (WHC_VIEW *)whc_RightSpaceEqualView:(WHC_VIEW *)view {
    return [self whc_RightSpaceEqualView:view offset:0];
}

- (WHC_VIEW *)whc_RightSpaceEqualView:(WHC_VIEW *)view offset:(CGFloat)offset {
    return [self whc_ConstraintWithItem:self
                       attribute:NSLayoutAttributeRight
                       relatedBy:NSLayoutRelationEqual
                          toItem:view
                       attribute:NSLayoutAttributeRight
                      multiplier:1
                        constant:0.0 - offset];
}

- (WHC_VIEW *)whc_LeadingSpace:(CGFloat)leadingSpace {
    return [self whc_ConstraintWithItem:self.superview
                       attribute:NSLayoutAttributeLeading
                        constant:leadingSpace];
}

- (WHC_VIEW *)whc_LeadingSpace:(CGFloat)leadingSpace
            toView:(WHC_VIEW *)toView {
    NSLayoutAttribute toAttribute = NSLayoutAttributeTrailing;
    if (toView.superview == nil) {
        toAttribute = NSLayoutAttributeLeading;
    }else if (self.superview != toView.superview) {
        toAttribute = NSLayoutAttributeLeading;
    }
    return [self whc_ConstraintWithItem:self
                       attribute:NSLayoutAttributeLeading
                       relatedBy:NSLayoutRelationEqual
                          toItem:toView
                       attribute:toAttribute
                      multiplier:1
                        constant:leadingSpace];
}

- (WHC_VIEW *)whc_LeadingSpaceEqualView:(WHC_VIEW *)view {
    return [self whc_LeadingSpaceEqualView:view offset:0];
}

- (WHC_VIEW *)whc_LeadingSpaceEqualView:(WHC_VIEW *)view offset:(CGFloat)offset {
    return [self whc_ConstraintWithItem:self
                       attribute:NSLayoutAttributeLeading
                       relatedBy:NSLayoutRelationEqual
                          toItem:view
                       attribute:NSLayoutAttributeLeading
                      multiplier:1
                        constant:offset];
}

- (WHC_VIEW *)whc_TrailingSpace:(CGFloat)trailingSpace {
    return [self whc_ConstraintWithItem:self.superview
                       attribute:NSLayoutAttributeTrailing
                        constant:0.0 - trailingSpace];
}

- (WHC_VIEW *)whc_TrailingSpace:(CGFloat)trailingSpace
             toView:(WHC_VIEW *)toView {
    NSLayoutAttribute toAttribute = NSLayoutAttributeLeading;
    if (toView.superview == nil) {
        toAttribute = NSLayoutAttributeTrailing;
    }else if (self.superview != toView.superview) {
        toAttribute = NSLayoutAttributeTrailing;
    }
    return [self whc_ConstraintWithItem:self
                       attribute:NSLayoutAttributeTrailing
                       relatedBy:NSLayoutRelationEqual
                          toItem:toView
                       attribute:toAttribute
                      multiplier:1
                        constant:0.0 - trailingSpace];
}

- (WHC_VIEW *)whc_TrailingSpaceEqualView:(WHC_VIEW *)view {
    return [self whc_TrailingSpaceEqualView:view offset:0];
}

- (WHC_VIEW *)whc_TrailingSpaceEqualView:(WHC_VIEW *)view offset:(CGFloat)offset {
    return [self whc_ConstraintWithItem:self
                       attribute:NSLayoutAttributeTrailing
                       relatedBy:NSLayoutRelationEqual
                          toItem:view
                       attribute:NSLayoutAttributeTrailing
                      multiplier:1
                        constant:0.0 - offset];
}

- (WHC_VIEW *)whc_TopSpace:(CGFloat)topSpace {
    return [self whc_ConstraintWithItem:self.superview
                       attribute:NSLayoutAttributeTop
                        constant:topSpace];
}

- (WHC_VIEW *)whc_TopSpace:(CGFloat)topSpace toView:(WHC_VIEW *)toView {
    NSLayoutAttribute toAttribute = NSLayoutAttributeBottom;
    if (toView.superview == nil) {
        toAttribute = NSLayoutAttributeTop;
    }else if (self.superview != toView.superview) {
        toAttribute = NSLayoutAttributeTop;
    }
    return [self whc_ConstraintWithItem:self
                       attribute:NSLayoutAttributeTop
                       relatedBy:NSLayoutRelationEqual
                          toItem:toView
                       attribute:toAttribute
                      multiplier:1
                        constant:topSpace];
}

- (WHC_VIEW *)whc_TopSpaceEqualView:(WHC_VIEW *)view {
    return [self whc_TopSpaceEqualView:view offset:0];
}

- (WHC_VIEW *)whc_TopSpaceEqualView:(WHC_VIEW *)view offset:(CGFloat)offset {
    return [self whc_ConstraintWithItem:self
                       attribute:NSLayoutAttributeTop
                       relatedBy:NSLayoutRelationEqual
                          toItem:view
                       attribute:NSLayoutAttributeTop
                      multiplier:1
                        constant:offset];
}

- (WHC_VIEW *)whc_BottomSpace:(CGFloat)bottomSpace {
    return [self whc_ConstraintWithItem:self.superview
                       attribute:NSLayoutAttributeBottom
                        constant:0.0 - bottomSpace];
}

- (WHC_VIEW *)whc_BottomSpace:(CGFloat)bottomSpace toView:(WHC_VIEW *)toView {
    return [self whc_ConstraintWithItem:self
                       attribute:NSLayoutAttributeBottom
                       relatedBy:NSLayoutRelationEqual
                          toItem:toView
                       attribute:NSLayoutAttributeTop
                      multiplier:1
                        constant:bottomSpace];
}

- (WHC_VIEW *)whc_BottomSpaceEqualView:(WHC_VIEW *)view {
    return [self whc_BottomSpaceEqualView:view offset:0];
}

- (WHC_VIEW *)whc_BottomSpaceEqualView:(WHC_VIEW *)view offset:(CGFloat)offset {
    return [self whc_ConstraintWithItem:self
                       attribute:NSLayoutAttributeBottom
                       relatedBy:NSLayoutRelationEqual
                          toItem:view
                       attribute:NSLayoutAttributeBottom
                      multiplier:1
                        constant:0.0 - offset];
}

- (WHC_VIEW *)whc_Width:(CGFloat)width{
    return [self whc_ConstraintWithItem:self
                       attribute:NSLayoutAttributeWidth
                       relatedBy:NSLayoutRelationEqual
                          toItem:nil
                       attribute:NSLayoutAttributeNotAnAttribute
                      multiplier:0
                        constant:width];
}

- (WHC_VIEW *)whc_WidthEqualView:(WHC_VIEW *)view {
    return [self whc_ConstraintWithItem:view
                       attribute:NSLayoutAttributeWidth
                        constant:0];
}

- (WHC_VIEW *)whc_WidthEqualView:(WHC_VIEW *)view ratio:(CGFloat)ratio {
    return [self whc_ConstraintWithItem:view
                       attribute:NSLayoutAttributeWidth
                        constant:0
                      multiplier:ratio];

}

- (WHC_VIEW *)whc_AutoWidth {
#if TARGET_OS_IPHONE || TARGET_OS_TV
    if ([self isKindOfClass:[UILabel class]]) {
        UILabel * selfLabel = (UILabel *)self;
        if (selfLabel.numberOfLines == 0) {
            selfLabel.numberOfLines = 1;
        }
    }
#endif
    return [self whc_ConstraintWithItem:self
                       attribute:NSLayoutAttributeWidth
                       relatedBy:NSLayoutRelationGreaterThanOrEqual
                          toItem:nil
                       attribute:NSLayoutAttributeNotAnAttribute
                      multiplier:1
                        constant:0];
}

- (WHC_VIEW *)whc_WidthHeightRatio:(CGFloat)ratio {
    return [self whc_ConstraintWithItem:self
                       attribute:NSLayoutAttributeWidth
                       relatedBy:NSLayoutRelationEqual
                          toItem:self
                       attribute:NSLayoutAttributeHeight
                      multiplier:ratio
                        constant:0];
}

- (WHC_VIEW *)whc_Height:(CGFloat)height{
    return [self whc_ConstraintWithItem:nil
                       attribute:NSLayoutAttributeHeight
                        constant:height];
}

- (WHC_VIEW *)whc_HeightEqualView:(WHC_VIEW *)view {
    return [self whc_ConstraintWithItem:view
                       attribute:NSLayoutAttributeHeight
                        constant:0];
}

- (WHC_VIEW *)whc_HeightEqualView:(WHC_VIEW *)view ratio:(CGFloat)ratio {
    return [self whc_ConstraintWithItem:view
                       attribute:NSLayoutAttributeHeight
                        constant:0
                      multiplier:ratio];
}

- (WHC_VIEW *)whc_AutoHeight {
#if TARGET_OS_IPHONE || TARGET_OS_TV
    if ([self isKindOfClass:[UILabel class]]) {
        if (((UILabel *)self).numberOfLines != 0) {
            ((UILabel *)self).numberOfLines = 0;
        }
    }
#endif
    return [self whc_ConstraintWithItem:self
                       attribute:NSLayoutAttributeHeight
                       relatedBy:NSLayoutRelationGreaterThanOrEqual
                          toItem:nil
                       attribute:NSLayoutAttributeNotAnAttribute
                      multiplier:1
                        constant:0];

}

- (WHC_VIEW *)whc_HeightWidthRatio:(CGFloat)ratio {
    return [self whc_ConstraintWithItem:self
                       attribute:NSLayoutAttributeHeight
                       relatedBy:NSLayoutRelationEqual
                          toItem:self
                       attribute:NSLayoutAttributeWidth
                      multiplier:ratio
                        constant:0];
}

- (WHC_VIEW *)whc_CenterX:(CGFloat)centerX {
    return [self whc_ConstraintWithItem:self.superview
                       attribute:NSLayoutAttributeCenterX
                        constant:centerX];
}

- (WHC_VIEW *)whc_CenterX:(CGFloat)centerX toView:(WHC_VIEW *)toView {
    return [self whc_ConstraintWithItem:toView
                       attribute:NSLayoutAttributeCenterX
                        constant:centerX];
}

- (WHC_VIEW *)whc_CenterY:(CGFloat)centerY {
    return [self whc_ConstraintWithItem:self.superview
                       attribute:NSLayoutAttributeCenterY
                        constant:centerY];
}

- (WHC_VIEW *)whc_CenterY:(CGFloat)centerY toView:(WHC_VIEW *)toView {
    return [self whc_ConstraintWithItem:toView
                       attribute:NSLayoutAttributeCenterY
                        constant:centerY];
}

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)
- (WHC_VIEW *)whc_FirstBaseLine:(CGFloat)space {
    return [self whc_ConstraintWithItem:self.superview
                       attribute:NSLayoutAttributeFirstBaseline
                        constant:0.0 - space];
}

- (WHC_VIEW *)whc_FirstBaseLine:(CGFloat)space toView:(WHC_VIEW *)toView {
    NSLayoutAttribute toAttribute = NSLayoutAttributeLastBaseline;
    if (toView.superview == nil) {
        toAttribute = NSLayoutAttributeFirstBaseline;
    }else if (self.superview != toView.superview) {
        toAttribute = NSLayoutAttributeFirstBaseline;
    }
    return [self whc_ConstraintWithItem:self
                       attribute:NSLayoutAttributeFirstBaseline
                       relatedBy:NSLayoutRelationEqual
                          toItem:toView
                       attribute:toAttribute
                      multiplier:1
                        constant:space];
}

- (WHC_VIEW *)whc_FirstBaseLineEqualView:(WHC_VIEW *)view {
    return [self whc_FirstBaseLineEqualView:view offset:0];
}

- (WHC_VIEW *)whc_FirstBaseLineEqualView:(WHC_VIEW *)view offset:(CGFloat)offset {
    return [self whc_ConstraintWithItem:view
                       attribute:NSLayoutAttributeFirstBaseline
                        constant:0.0 - offset];
}

#endif

- (WHC_VIEW *)whc_LastBaseLine:(CGFloat)space {
    return [self whc_ConstraintWithItem:self.superview
                       attribute:NSLayoutAttributeLastBaseline
                        constant:0.0 - space];
}

- (WHC_VIEW *)whc_LastBaseLine:(CGFloat)space toView:(WHC_VIEW *)toView {
#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)
    NSLayoutAttribute toAttribute = NSLayoutAttributeFirstBaseline;
#else
    NSLayoutAttribute toAttribute = NSLayoutAttributeTop;
#endif
    if (toView.superview == nil) {
        toAttribute = NSLayoutAttributeLastBaseline;
    }else if (self.superview != toView.superview) {
        toAttribute = NSLayoutAttributeLastBaseline;
    }
    return [self whc_ConstraintWithItem:self
                       attribute:NSLayoutAttributeLastBaseline
                       relatedBy:NSLayoutRelationEqual
                          toItem:toView
                       attribute:toAttribute
                      multiplier:1
                        constant:0.0 - space];
}

- (WHC_VIEW *)whc_LastBaseLineEqualView:(WHC_VIEW *)view {
    return [self whc_LastBaseLineEqualView:view offset:0];
}

- (WHC_VIEW *)whc_LastBaseLineEqualView:(WHC_VIEW *)view offset:(CGFloat)offset {
    return [self whc_ConstraintWithItem:view
                       attribute:NSLayoutAttributeLastBaseline
                        constant:0.0 - offset];
}


- (WHC_VIEW *)whc_Center:(CGPoint)center {
    [self whc_CenterX:center.x];
    return [self whc_CenterY:center.y];
}

- (WHC_VIEW *)whc_Center:(CGPoint)center toView:(WHC_VIEW *)toView {
    [self whc_CenterX:center.x toView:toView];
    return [self whc_CenterY:center.y toView:toView];
}

- (WHC_VIEW *)whc_Frame:(CGFloat)left top:(CGFloat)top width:(CGFloat)width height:(CGFloat)height {
    [self whc_LeftSpace:left];
    [self whc_TopSpace:top];
    [self whc_Width:width];
    return [self whc_Height:height];
}

- (WHC_VIEW *)whc_Size:(CGSize)size {
    [self whc_Width:size.width];
    return [self whc_Height:size.height];
}

- (WHC_VIEW *)whc_SizeEqualView:(WHC_VIEW *)view {
    [self whc_WidthEqualView: view];
    return [self whc_HeightEqualView: view];
}

- (WHC_VIEW *)whc_FrameEqualView:(WHC_VIEW *)view {
    [self whc_LeftSpaceEqualView: view];
    [self whc_TopSpaceEqualView: view];
    return [self whc_SizeEqualView:view];
}

- (WHC_VIEW *)whc_Frame:(CGFloat)left top:(CGFloat)top width:(CGFloat)width height:(CGFloat)height toView:(WHC_VIEW *)toView {
    [self whc_LeftSpace:left toView:toView];
    [self whc_TopSpace:top toView:toView];
    [self whc_Width:width];
    return [self whc_Height:height];
}

- (WHC_VIEW *)whc_AutoSize:(CGFloat)left top:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom {
    [self whc_LeftSpace:left];
    [self whc_TopSpace:top];
    [self whc_RightSpace:right];
    return [self whc_BottomSpace:bottom];
}

- (WHC_VIEW *)whc_AutoWidth:(CGFloat)left top:(CGFloat)top right:(CGFloat)right height:(CGFloat)height {
    [self whc_LeftSpace:left];
    [self whc_TopSpace:top];
    [self whc_RightSpace:right];
    return [self whc_Height:height];
}

- (WHC_VIEW *)whc_AutoHeight:(CGFloat)left top:(CGFloat)top width:(CGFloat)width bottom:(CGFloat)bottom {
    [self whc_LeftSpace:left];
    [self whc_TopSpace:top];
    [self whc_Width:width];
    return [self whc_BottomSpace:bottom];
}

- (WHC_VIEW *)whc_AutoSize:(CGFloat)left top:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom toView:(WHC_VIEW *)toView {
    [self whc_LeftSpace:left toView:toView];
    [self whc_TopSpace:top toView:toView];
    [self whc_RightSpace:right toView:toView];
    return [self whc_BottomSpace:bottom toView:toView];
}

- (WHC_VIEW *)whc_AutoWidth:(CGFloat)left top:(CGFloat)top right:(CGFloat)right height:(CGFloat)height toView:(WHC_VIEW *)toView {
    [self whc_LeftSpace:left toView:toView];
    [self whc_TopSpace:top toView:toView];
    [self whc_RightSpace:right toView:toView];
    return [self whc_Height:height];
}

- (WHC_VIEW *)whc_AutoHeight:(CGFloat)left top:(CGFloat)top width:(CGFloat)width bottom:(CGFloat)bottom toView:(WHC_VIEW *)toView {
    [self whc_LeftSpace:left toView:toView];
    [self whc_TopSpace:top toView:toView];
    [self whc_Width:width];
    return [self whc_BottomSpace:bottom toView:toView];
}

- (WHC_VIEW *)whc_ConstraintWithItem:(WHC_VIEW *)item
                     attribute:(NSLayoutAttribute)attribute
                      constant:(CGFloat)constant {
    return [self whc_ConstraintWithItem:self
                       attribute:attribute
                          toItem:item
                       attribute:attribute
                        constant:constant];
}

- (WHC_VIEW *)whc_ConstraintWithItem:(WHC_VIEW *)item
                     attribute:(NSLayoutAttribute)attribute
                      constant:(CGFloat)constant
                    multiplier:(CGFloat)multiplier {
    return [self whc_ConstraintWithItem:self
                       attribute:attribute
                          toItem:item
                       attribute:attribute
                        constant:constant
                      multiplier:multiplier];
}

- (WHC_VIEW *)whc_ConstraintWithItem:(WHC_VIEW *)item
                     attribute:(NSLayoutAttribute)attribute
                        toItem:(WHC_VIEW *)toItem
                     attribute:(NSLayoutAttribute)toAttribute
                      constant:(CGFloat)constant {
    return [self whc_ConstraintWithItem:item
                       attribute:attribute
                       relatedBy:NSLayoutRelationEqual
                          toItem:toItem
                       attribute:toAttribute
                      multiplier:1
                        constant:constant];
}

- (WHC_VIEW *)whc_ConstraintWithItem:(WHC_VIEW *)item
                     attribute:(NSLayoutAttribute)attribute
                        toItem:(WHC_VIEW *)toItem
                     attribute:(NSLayoutAttribute)toAttribute
                      constant:(CGFloat)constant
                    multiplier:(CGFloat)multiplier {
    return [self whc_ConstraintWithItem:item
                       attribute:attribute
                       relatedBy:NSLayoutRelationEqual
                          toItem:toItem
                       attribute:toAttribute
                      multiplier:multiplier
                        constant:constant];
}

- (WHC_VIEW *)whc_ConstraintWithItem:(WHC_VIEW *)item
                     attribute:(NSLayoutAttribute)attribute
                     relatedBy:(NSLayoutRelation)related
                        toItem:(WHC_VIEW *)toItem
                     attribute:(NSLayoutAttribute)toAttribute
                    multiplier:(CGFloat)multiplier
                      constant:(CGFloat)constant {
    
    WHC_VIEW * superView = item.superview;
    if (toItem) {
        if (toItem.superview == nil) {
            superView = toItem;
        }else if (toItem.superview != item.superview) {
            superView = toItem;
        }
    }else {
        superView = item;
        toAttribute = NSLayoutAttributeNotAnAttribute;
    }
    if (self.translatesAutoresizingMaskIntoConstraints) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
    if (item && item.translatesAutoresizingMaskIntoConstraints) {
        item.translatesAutoresizingMaskIntoConstraints = NO;
    }
    switch (attribute) {
        case NSLayoutAttributeLeft: {
            NSLayoutConstraint * leading = [self leadingConstraint];
            if (leading) {
                [superView removeConstraint:leading];
                [self setLeadingConstraint:nil];
            }
            NSLayoutConstraint * left = [self leftConstraint];
            if (left) {
                if (left.firstAttribute == attribute &&
                    left.secondAttribute == toAttribute &&
                    left.firstItem == item &&
                    left.secondItem == toItem &&
                    left.relation == related &&
                    left.multiplier == multiplier) {
                    left.constant = constant;
                    return self;
                }
                [superView removeConstraint:left];
                [self setLeftConstraint:nil];
            }
        }
            break;
        case NSLayoutAttributeRight: {
            NSLayoutConstraint * trailing = [self trailingConstraint];
            if (trailing) {
                [superView removeConstraint:trailing];
                [self setTrailingConstraint:nil];
            }
            NSLayoutConstraint * right = [self rightConstraint];
            if (right) {
                if (right.firstAttribute == attribute &&
                    right.secondAttribute == toAttribute &&
                    right.firstItem == item &&
                    right.secondItem == toItem &&
                    right.relation == related &&
                    right.multiplier == multiplier) {
                    right.constant = constant;
                    return self;
                }
                [superView removeConstraint:right];
                [self setRightConstraint:nil];
            }
        }
            break;
        case NSLayoutAttributeTop: {
            NSLayoutConstraint * firstBaseline = [self firstBaselineConstraint];
            if (firstBaseline) {
                [superView removeConstraint:firstBaseline];
                [self setFirstBaselineConstraint:nil];
            }
            NSLayoutConstraint * top = [self topConstraint];
            if (top) {
                if (top.firstAttribute == attribute &&
                    top.secondAttribute == toAttribute &&
                    top.firstItem == item &&
                    top.secondItem == toItem &&
                    top.relation == related &&
                    top.multiplier == multiplier) {
                    top.constant = constant;
                    return self;
                }
                [superView removeConstraint:top];
                [self setTopConstraint:nil];
            }
        }
            break;
        case NSLayoutAttributeBottom: {
            NSLayoutConstraint * lastBaseline = [self lastBaselineConstraint];
            if (lastBaseline) {
                [superView removeConstraint:lastBaseline];
                [self setLastBaselineConstraint:nil];
            }
            NSLayoutConstraint * bottom = [self bottomConstraint];
            if (bottom) {
                if (bottom.firstAttribute == attribute &&
                    bottom.secondAttribute == toAttribute &&
                    bottom.firstItem == item &&
                    bottom.secondItem == toItem &&
                    bottom.relation == related &&
                    bottom.multiplier == multiplier) {
                    bottom.constant = constant;
                    return self;
                }
                [superView removeConstraint:bottom];
                [self setBottomConstraint:nil];
            }
        }
            break;
        case NSLayoutAttributeLeading: {
            NSLayoutConstraint * left = [self leftConstraint];
            if (left) {
                [superView removeConstraint:left];
                [self setLeftConstraint:nil];
            }
            NSLayoutConstraint * leading = [self leadingConstraint];
            if (leading) {
                if (leading.firstAttribute == attribute &&
                    leading.secondAttribute == toAttribute &&
                    leading.firstItem == item &&
                    leading.secondItem == toItem &&
                    leading.relation == related &&
                    leading.multiplier == multiplier) {
                    leading.constant = constant;
                    return self;
                }
                [superView removeConstraint:leading];
                [self setLeadingConstraint:nil];
            }
        }
            break;
        case NSLayoutAttributeTrailing: {
            NSLayoutConstraint * right = [self rightConstraint];
            if (right) {
                [superView removeConstraint:right];
                [self setRightConstraint:nil];
            }
            NSLayoutConstraint * trailing = [self trailingConstraint];
            if (trailing) {
                if (trailing.firstAttribute == attribute &&
                    trailing.secondAttribute == toAttribute &&
                    trailing.firstItem == item &&
                    trailing.secondItem == toItem &&
                    trailing.relation == related &&
                    trailing.multiplier == multiplier) {
                    trailing.constant = constant;
                    return self;
                }
                [superView removeConstraint:trailing];
                [self setTrailingConstraint:nil];
            }
        }
            break;
        case NSLayoutAttributeWidth: {
            NSLayoutConstraint * width = [self widthConstraint];
            if (width) {
                if (width.firstAttribute == attribute &&
                    width.secondAttribute == toAttribute &&
                    width.firstItem == item &&
                    width.secondItem == toItem &&
                    width.relation == related &&
                    width.multiplier == multiplier) {
                    width.constant = constant;
                    return self;
                }
                if (width.secondAttribute != NSLayoutAttributeNotAnAttribute) {
                    [superView removeConstraint:width];
                }else {
                    [self removeConstraint:width];
                }
                [self setWidthConstraint:nil];
            }
        }
            break;
        case NSLayoutAttributeHeight: {
            NSLayoutConstraint * height = [self heightConstraint];
            if (height) {
                if (height.firstAttribute == attribute &&
                    height.secondAttribute == toAttribute &&
                    height.firstItem == item &&
                    height.secondItem == toItem &&
                    height.relation == related &&
                    height.multiplier == multiplier) {
                    height.constant = constant;
                    return self;
                }
                if (height.secondAttribute != NSLayoutAttributeNotAnAttribute) {
                    [superView removeConstraint:height];
                }else {
                    [self removeConstraint:height];
                }
                [self setHeightConstraint:nil];
            }
        }
            break;
        case NSLayoutAttributeCenterX: {
            NSLayoutConstraint * centerX = [self centerXConstraint];
            if (centerX) {
                if (centerX.firstAttribute == attribute &&
                    centerX.secondAttribute == toAttribute &&
                    centerX.firstItem == item &&
                    centerX.secondItem == toItem &&
                    centerX.relation == related &&
                    centerX.multiplier == multiplier) {
                    centerX.constant = constant;
                    return self;
                }
                [superView removeConstraint:centerX];
                [self setCenterXConstraint:nil];
            }
        }
            break;
        case NSLayoutAttributeCenterY: {
            NSLayoutConstraint * centerY = [self centerYConstraint];
            if (centerY) {
                if (centerY.firstAttribute == attribute &&
                    centerY.secondAttribute == toAttribute &&
                    centerY.firstItem == item &&
                    centerY.secondItem == toItem &&
                    centerY.relation == related &&
                    centerY.multiplier == multiplier) {
                    centerY.constant = constant;
                    return self;
                }
                [superView removeConstraint:centerY];
                [self setCenterYConstraint:nil];
            }
        }
            break;
        case NSLayoutAttributeLastBaseline: {
            NSLayoutConstraint * bottom = [self bottomConstraint];
            if (bottom) {
                [superView removeConstraint:bottom];
                [self setBottomConstraint:nil];
            }
            NSLayoutConstraint * lastBaseline = [self lastBaselineConstraint];
            if (lastBaseline) {
                if (lastBaseline.firstAttribute == attribute &&
                    lastBaseline.secondAttribute == toAttribute &&
                    lastBaseline.firstItem == item &&
                    lastBaseline.secondItem == toItem &&
                    lastBaseline.relation == related &&
                    lastBaseline.multiplier == multiplier) {
                    lastBaseline.constant = constant;
                    return self;
                }
                [superView removeConstraint:lastBaseline];
                [self setLastBaselineConstraint:nil];
            }
        }
            break;
#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)
        case NSLayoutAttributeFirstBaseline: {
            NSLayoutConstraint * top = [self topConstraint];
            if (top) {
                [superView removeConstraint:top];
                [self setTopConstraint:nil];
            }
            NSLayoutConstraint * firstBaseline = [self firstBaselineConstraint];
            if (firstBaseline) {
                if (firstBaseline.firstAttribute == attribute &&
                    firstBaseline.secondAttribute == toAttribute &&
                    firstBaseline.firstItem == item &&
                    firstBaseline.secondItem == toItem &&
                    firstBaseline.relation == related &&
                    firstBaseline.multiplier == multiplier) {
                    firstBaseline.constant = constant;
                    return self;
                }
                [superView removeConstraint:firstBaseline];
                [self setFirstBaselineConstraint:nil];
            }
        }
            break;
#endif
        default:
            break;
    }
    
    NSLayoutConstraint * constraint = [NSLayoutConstraint constraintWithItem:item
                                             attribute:attribute
                                             relatedBy:related
                                                toItem:toItem
                                             attribute:toAttribute
                                            multiplier:multiplier
                                              constant:constant];
    switch (attribute) {
#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)
        case NSLayoutAttributeFirstBaseline:
            [self setFirstBaselineConstraint:constraint];
            break;
#endif
        case NSLayoutAttributeLastBaseline:
            [self setLastBaselineConstraint:constraint];
            break;
        case NSLayoutAttributeCenterY:
            [self setCenterYConstraint:constraint];
            break;
        case NSLayoutAttributeCenterX:
            [self setCenterXConstraint:constraint];
            break;
        case NSLayoutAttributeTrailing:
            [self setTrailingConstraint:constraint];
            break;
        case NSLayoutAttributeLeading:
            [self setLeadingConstraint:constraint];
            break;
        case NSLayoutAttributeBottom:
            [self setBottomConstraint:constraint];
            break;
        case NSLayoutAttributeTop:
            [self setTopConstraint:constraint];
            break;
        case NSLayoutAttributeRight:
            [self setRightConstraint:constraint];
            break;
        case NSLayoutAttributeLeft:
            [self setLeftConstraint:constraint];
            break;
        case NSLayoutAttributeWidth:
            [self setWidthConstraint:constraint];
            break;
        case NSLayoutAttributeHeight:
            [self setHeightConstraint:constraint];
            break;
        default:
            break;
    }
    [superView addConstraint:constraint];
    [self setCurrentConstraint:constraint];
    return self;
}

#if TARGET_OS_IPHONE || TARGET_OS_TV

#pragma mark - Xib智能布局模块

- (void)whc_AutoXibLayout {
#if kDeprecatedVerticalAdapter
    [self whc_AutoXibLayoutType:DefaultType];
#else
    [self whc_AutoXibHorizontalLayout];
#endif
}

- (void)whc_AutoXibLayoutType:(WHC_LayoutTypeOptions)type {
#if kDeprecatedVerticalAdapter
    [self whc_RunLayoutEngineWithOrientation:All layoutType:type nibType:XIB];
#else
    [self whc_RunLayoutEngineWithOrientation:Horizontal layoutType:type nibType:XIB];
#endif
    
}

- (void)whc_AutoXibHorizontalLayout {
    [self whc_AutoXibHorizontalLayoutType:DefaultType];
}

- (void)whc_AutoXibHorizontalLayoutType:(WHC_LayoutTypeOptions)type {
    [self whc_RunLayoutEngineWithOrientation:Horizontal layoutType:type nibType:XIB];
}

- (void)whc_AutoSBLayout {
#if kDeprecatedVerticalAdapter
    [self whc_AutoSBLayoutType:DefaultType];
#else
    [self whc_AutoSBHorizontalLayout];
#endif
}

- (void)whc_AutoSBLayoutType:(WHC_LayoutTypeOptions)type {
    CGRect initRect = self.bounds;
    self.bounds = CGRectMake(0, 0, 375, 667);
#if kDeprecatedVerticalAdapter
    [self whc_RunLayoutEngineWithOrientation:All layoutType:type nibType:SB];
#else
    [self whc_RunLayoutEngineWithOrientation:Horizontal layoutType:type nibType:SB];
#endif
    
    self.bounds = initRect;
}

- (void)whc_AutoSBHorizontalLayout {
    [self whc_AutoSBHorizontalLayoutType:DefaultType];
}

- (void)whc_AutoSBHorizontalLayoutType:(WHC_LayoutTypeOptions)type {
    CGRect initRect = self.bounds;
    self.bounds = CGRectMake(0, 0, 375, 667);
    [self whc_RunLayoutEngineWithOrientation:Horizontal layoutType:type nibType:SB];
    self.bounds = initRect;
}

- (void)whc_RunLayoutEngineWithOrientation:(WHC_LayoutOrientationOptions)orientation
                                layoutType:(WHC_LayoutTypeOptions)layoutType
                                   nibType:(WHCNibType)nibType {
    NSMutableArray  * subViewArray = [NSMutableArray array];
    if (nibType == SB) {
        for (NSObject * view in self.subviews) {
            if (![NSStringFromClass(view.class) isEqualToString:@"_UILayoutGuide"]) {
                [subViewArray addObject:view];
            }
        }
    }else {
        [subViewArray addObjectsFromArray:self.subviews];
    }
    NSMutableArray  * rowViewArray = [NSMutableArray array];
    for (NSInteger i = 0; i < subViewArray.count; i++) {
        WHC_VIEW * subView = subViewArray[i];
        if(rowViewArray.count == 0) {
            NSMutableArray * subRowViewArray = [NSMutableArray array];
            [subRowViewArray addObject:subView];
            [rowViewArray addObject:subRowViewArray];
        }else{
            BOOL isAddSubView = NO;
            for (NSInteger j = 0; j < rowViewArray.count; j++) {
                NSMutableArray  * subRowViewArray = rowViewArray[j];
                BOOL  isAtRow = YES;
                for (NSInteger w = 0; w < subRowViewArray.count; w++) {
                    WHC_VIEW * rowSubView = subRowViewArray[w];
                    if(CGRectGetMinY(subView.frame) > rowSubView.center.y ||
                       CGRectGetMaxY(subView.frame) < rowSubView.center.y){
                        isAtRow = NO;
                        break;
                    }
                }
                if(isAtRow) {
                    isAddSubView = YES;
                    [subRowViewArray addObject:subView];
                    break;
                }
            }
            if(!isAddSubView) {
                NSMutableArray * subRowViewArr = [NSMutableArray array];
                [subRowViewArr addObject:subView];
                [rowViewArray addObject:subRowViewArr];
            }
        }
    }
    
    NSInteger rowCount = rowViewArray.count;
    for(NSInteger row = 0; row < rowCount; row++){
        NSMutableArray  * subRowViewArray = rowViewArray[row];
        NSInteger columnCount = subRowViewArray.count;
        for (NSInteger column = 0; column < columnCount; column++) {
            for (NSInteger j = column + 1; j < columnCount; j++) {
                WHC_VIEW  * view1 = subRowViewArray[column];
                WHC_VIEW  * view2 = subRowViewArray[j];
                if(view1.center.x > view2.center.x){
                    [subRowViewArray exchangeObjectAtIndex:column withObjectAtIndex:j];
                }
            }
        }
    }

    WHC_VIEW * frontRowView = nil;
    WHC_VIEW * nextRowView = nil;
    
    for (NSInteger row = 0; row < rowCount; row++) {
        NSArray * subRowViewArray = rowViewArray[row];
        NSInteger columnCount = subRowViewArray.count;
        for (NSInteger column = 0; column < columnCount; column++) {
            WHC_VIEW * view = subRowViewArray[column];
            CGFloat superWidthHalf = CGRectGetWidth(view.superview.frame) / 2;
            WHC_VIEW * nextColumnView = nil;
            WHC_VIEW * frontColumnView = nil;
            frontRowView = nil;
            nextRowView = nil;
            BOOL canFitWidthOrHeight = [self canFitWidthOrHeightWithView:view];
            if (row < rowCount - 1) {
                nextRowView = [self getNextRowView:rowViewArray[row + 1] currentView:view];
            }
            if (column < columnCount - 1) {
                nextColumnView = subRowViewArray[column + 1];
            }
            if (row == 0) {
                [view whc_TopSpace:CGRectGetMinY(view.frame)];
            }else {
                frontRowView = [self getFrontRowView:rowViewArray[row - 1] currentView:view];
                [view whc_TopSpace:CGRectGetMinY(view.frame) - CGRectGetMaxY(frontRowView.frame)
                      toView:frontRowView];
            }
            if (column == 0) {
                if (!canFitWidthOrHeight && layoutType == LeftRightType) {
                    if (view.center.x == superWidthHalf) {
                        [view whc_CenterX:0];
                    } else if (view.center.x > superWidthHalf) {
                        if (nextColumnView) {
                            [view whc_TrailingSpace:CGRectGetMinX(nextColumnView.frame) - CGRectGetMaxX(view.frame) toView:nextColumnView];
                        }else {
                            [view whc_TrailingSpace:CGRectGetWidth(view.superview.frame) - CGRectGetMaxX(view.frame)];
                        }
                    }
                }else {
                    [view whc_LeftSpace:CGRectGetMinX(view.frame)];
                }
            }else {
                frontColumnView = subRowViewArray[column - 1];
                if (!canFitWidthOrHeight && layoutType == LeftRightType) {
                    if (view.center.x == superWidthHalf) {
                        [view whc_CenterX:0];
                    }else if (view.center.x > superWidthHalf) {
                        if (nextColumnView) {
                            [view whc_TrailingSpace:CGRectGetMinX(nextColumnView.frame) - CGRectGetMaxX(view.frame) toView:nextColumnView];
                        }else {
                            [view whc_TrailingSpace:CGRectGetWidth(view.superview.frame) - CGRectGetMaxX(view.frame)];
                        }
                    }
                }else {
                    [view whc_LeftSpace:CGRectGetMinX(view.frame) - CGRectGetMaxX(frontColumnView.frame)
                           toView:frontColumnView];
                }
            }
            if (orientation == All ||
                orientation == Vertical) {
                if (canFitWidthOrHeight) {
                    if (nextRowView) {
                        [view whc_HeightEqualView:nextRowView
                                            ratio:CGRectGetHeight(view.frame) / CGRectGetHeight(nextRowView.frame)];
                    }else {
                        [view whc_BottomSpace:CGRectGetHeight(view.superview.frame) - CGRectGetMaxY(view.frame)];
                    }
                }else {
                    [view whc_Height:CGRectGetHeight(view.frame)];
                }
                goto WHC_FIT_WIDTH;
            }else {
            WHC_FIT_WIDTH:
                if (canFitWidthOrHeight) {
                    [view whc_RightSpace:CGRectGetWidth(view.superview.frame) - CGRectGetMaxX(view.frame)];
                }else {
                    [view whc_Width:CGRectGetWidth(view.frame)];
                }
                [view whc_Height:CGRectGetHeight(view.frame)];
            }
            if ([view isKindOfClass:[UITableViewCell class]] ||
                (view.subviews.count > 0 && ([NSStringFromClass(view.class) isEqualToString:@"WHC_VIEW"] ||
                                             [NSStringFromClass(view.class) isEqualToString:@"UIScrollView"])) ||
                [NSStringFromClass(view.class) isEqualToString:@"UITableViewCellContentView"]) {
                [view whc_RunLayoutEngineWithOrientation:orientation layoutType:layoutType nibType:nibType];
            }
        }
    }
}

- (BOOL)canFitWidthOrHeightWithView:(WHC_VIEW *) view {
    if ([view isKindOfClass:[UIImageView class]] ||
        (([view isKindOfClass:[UIButton class]] &&
          (((UIButton *)view).layer.cornerRadius == CGRectGetWidth(view.frame) / 2 ||
           ((UIButton *)view).layer.cornerRadius == CGRectGetHeight(view.frame) / 2 ||
           CGRectGetWidth(view.frame) == CGRectGetHeight(view.frame) ||
           [((UIButton *)view) backgroundImageForState:UIControlStateNormal])))) {
              return NO;
          }
    return YES;
}


- (WHC_VIEW *)getFrontRowView:(NSArray *)rowViewArray
                currentView:(WHC_VIEW *)currentView {
    if (currentView) {
        NSInteger columnCount = rowViewArray.count;
        NSInteger currentViewY = CGRectGetMinY(currentView.frame);
        for (NSInteger row = 0; row < columnCount; row++) {
            WHC_VIEW * view = rowViewArray[row];
            if (CGRectContainsPoint(currentView.frame, CGPointMake(CGRectGetMinX(view.frame), currentViewY)) ||
                CGRectContainsPoint(currentView.frame, CGPointMake(view.center.x, currentViewY)) ||
                CGRectContainsPoint(currentView.frame, CGPointMake(CGRectGetMaxX(view.frame), currentViewY))) {
                return view;
            }
        }
    }else {
        return nil;
    }
    return rowViewArray[0];
}

- (WHC_VIEW *)getNextRowView:(NSArray *)rowViewArray
               currentView:(WHC_VIEW *)currentView {
    return [self getFrontRowView:rowViewArray currentView:currentView];
}


#pragma mark - 自动加边线模块 -

static const int kLeft_Line_Tag = 100000;
static const int kRight_Line_Tag = kLeft_Line_Tag + 1;
static const int kTop_Line_Tag = kRight_Line_Tag + 1;
static const int kBottom_Line_Tag = kTop_Line_Tag + 1;

- (WHC_Line *)createLineWithTag:(int)lineTag {
    WHC_Line * line = nil;
    for (WHC_VIEW * view in self.subviews) {
        if ([view isKindOfClass:[WHC_Line class]] &&
            view.tag == lineTag) {
            line = (WHC_Line *)view;
            break;
        }
    }
    if (line == nil) {
        line = [WHC_Line new];
        line.tag = lineTag;
        [self addSubview:line];
    }
    return line;
}

- (WHC_VIEW *)whc_AddBottomLine:(CGFloat)value lineColor:(UIColor *)color {
    return [self whc_AddBottomLine:value lineColor:color pading:0];
}

- (WHC_VIEW *)whc_AddBottomLine:(CGFloat)value lineColor:(UIColor *)color pading:(CGFloat)pading {
    WHC_Line * line = [self createLineWithTag:kBottom_Line_Tag];
    line.backgroundColor = color;
    [line whc_RightSpace:pading];
    [line whc_LeftSpace:pading];
    [line whc_Height:value];
    [line whc_BottomSpace:0];
    return line;
}

- (WHC_VIEW *)whc_AddTopLine:(CGFloat)value lineColor:(UIColor *)color {
    return [self whc_AddTopLine:value lineColor:color pading:0];
}

- (WHC_VIEW *)whc_AddTopLine:(CGFloat)value lineColor:(UIColor *)color pading:(CGFloat)pading {
    WHC_Line * line = [self createLineWithTag:kTop_Line_Tag];
    line.backgroundColor = color;
    [line whc_RightSpace:pading];
    [line whc_LeftSpace:pading];
    [line whc_Height:value];
    [line whc_TopSpace:0];
    return line;
}

- (WHC_VIEW *)whc_AddLeftLine:(CGFloat)value lineColor:(UIColor *)color padding:(CGFloat)padding
{
    WHC_Line * line = [self createLineWithTag:kLeft_Line_Tag];
    line.backgroundColor = color;
    [line whc_Width:value];
    [line whc_LeftSpace:0];
    [line whc_TopSpace:padding];
    [line whc_BottomSpace:padding];
    return line;
}

- (WHC_VIEW *)whc_AddLeftLine:(CGFloat)value lineColor:(UIColor *)color {
    WHC_Line * line = [self createLineWithTag:kLeft_Line_Tag];
    line.backgroundColor = color;
    [line whc_Width:value];
    [line whc_LeftSpace:0];
    [line whc_TopSpace:0];
    [line whc_BottomSpace:0];
    return line;
}

- (WHC_VIEW *)whc_AddRightLine:(CGFloat)value lineColor:(UIColor *)color {
    WHC_Line * line = [self createLineWithTag:kRight_Line_Tag];
    line.backgroundColor = color;
    [line whc_Width:value];
    [line whc_TrailingSpace:0];
    [line whc_TopSpace:0];
    [line whc_BottomSpace:0];
    return line;
}

- (WHC_VIEW *)whc_AddRightLine:(CGFloat)value lineColor:(UIColor *)color padding:(CGFloat)padding
{
    WHC_Line * line = [self createLineWithTag:kRight_Line_Tag];
    line.backgroundColor = color;
    [line whc_Width:value];
    [line whc_TrailingSpace:0];
    [line whc_TopSpace:padding];
    [line whc_BottomSpace:padding];
    return line;
}
#endif
@end

