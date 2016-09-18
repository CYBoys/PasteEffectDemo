//
//  UIView+LYPaste.m
//  PasteEffectDemo
//
//  Created by chairman on 16/9/12.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//

#import "UIView+LYPaste.h"
#import <objc/runtime.h>

@interface UIView ()
/** 距离顶点多少 */
@property (nonatomic, assign) CGFloat lyPaste_spacing;
/** 原来的rect */
@property (nonatomic, assign) CGRect lyPaste_originRect;
/** 是否改变 */
@property (nonatomic, assign) BOOL lyPaste_isChange;
/** superView */
@property (nonatomic, strong) UIView *lyPaste_superView;
/** view所属控制器 */
@property (nonatomic, strong) UIViewController *lyPaste_viewController;
@end


@implementation UIView (LYPaste)

#pragma mark - Associated Object Methods


- (void)setLyPaste_spacing:(CGFloat)lyPaste_spacing {
    objc_setAssociatedObject(self, @selector(lyPaste_spacing), @(lyPaste_spacing), OBJC_ASSOCIATION_ASSIGN);
}

- (CGFloat)lyPaste_spacing {
    NSNumber *number = objc_getAssociatedObject(self, _cmd);
    return number.doubleValue;
}

- (void)setLyPaste_originRect:(CGRect)lyPaste_originRect {
    NSValue *rectValue = [NSValue valueWithCGRect:lyPaste_originRect];
    objc_setAssociatedObject(self, @selector(lyPaste_originRect), rectValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGRect)lyPaste_originRect {
    NSValue * rectValue = objc_getAssociatedObject(self, _cmd);
    return rectValue.CGRectValue;
}

- (void)setLyPaste_isChange:(BOOL)lyPaste_isChange {
    objc_setAssociatedObject(self, @selector(lyPaste_isChange), @(lyPaste_isChange), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)lyPaste_isChange {
    NSNumber *boolNumber = objc_getAssociatedObject(self, _cmd);
    return boolNumber.boolValue;
}

- (void)setLyPaste_superView:(UIView *)lyPaste_superView {
    objc_setAssociatedObject(self, @selector(lyPaste_superView), lyPaste_superView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)lyPaste_superView {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setLyPaste_viewController:(UIViewController *)lyPaste_viewController {
    objc_setAssociatedObject(self, @selector(lyPaste_viewController), lyPaste_viewController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIViewController *)lyPaste_viewController {
    return objc_getAssociatedObject(self, _cmd);
}

#pragma mark - Public Methods

- (void)lyPaste_topWithSpacing:(CGFloat)spacing {
    UIViewController *viewController = [self findViewController];
    [self setLyPaste_viewController:viewController];
    
    UINavigationController *navi = viewController.navigationController;
    if (navi) {
       CGFloat MaxY = CGRectGetMaxY([self findViewController].navigationController.navigationBar.frame);
        spacing += MaxY;
    }
    [self setLyPaste_spacing:spacing];
    [self setLyPaste_originRect:self.frame];
    [self setLyPaste_isChange:NO];
    [self setLyPaste_superView:self.superview];
}

- (void)lyPaste_currentContentOffset:(CGPoint)offset {
    NSLog(@"point.y = %f",offset.y);
    UIViewController *findViewController = [self lyPaste_viewController];
    if (!findViewController) {
        findViewController = [self findViewController];
        [self setLyPaste_viewController:findViewController];
    }
    BOOL change = [self lyPaste_isChange];
    CGRect originRect = [self lyPaste_originRect];
    CGPoint convertPoint = CGPointMake(0, 0);
    if (!change) {//当未改变时候，即self还没有addSubview到控制器的view上
        convertPoint = [self convertPoint:offset toView:findViewController.view];//转换成在控制器上的像素点
    } else {//当已经改变，即self已经添加到控制器的view上
        convertPoint = CGPointMake(originRect.origin.x, originRect.origin.y);
    }
    CGFloat spacing = [self lyPaste_spacing];
    NSLog(@"converPointY = %f",convertPoint.y);
    CGFloat margin = convertPoint.y - offset.y - spacing;//计算距离自定义的spacing还有多远
    NSLog(@"margin = %f",margin);
    NSLog(@"change = %@",change?@"YES":@"NO");
    if (margin<=0 && !change ) {
        CGRect rect = self.frame;
        rect.origin = CGPointMake(originRect.origin.x, spacing);
        self.frame = rect;
        [findViewController.view addSubview:self];
        [self setLyPaste_isChange:YES];
    } else if (margin >0 && change){
        CGRect rect = self.frame;
        rect.origin.y = originRect.origin.y;
        self.frame = rect;
        UIView *view = [self lyPaste_superView];
        [view addSubview:self];
        [self setLyPaste_isChange:NO];
    }

}
#pragma mark - Private Methods

/** 查找当前控制器 */
- (UIViewController *)findViewController {
    UIView *superView = self.superview;
    while (superView) {
        UIResponder *responder = [superView nextResponder];
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
        superView = superView.superview;
    }
    return nil;
}

@end

