//
//  UIBlurView.h
//  Kaleidoscope
//
//  Created by kobayashi on 2014/01/11.
//  Copyright (c) 2014年 kobayashi-kikai.co.jp. All rights reserved.
//  ぼかし半透明画面処理

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class UIBlurView;

@interface UIBlurView : UIViewController

+ (instancetype)visibleGridMenu;
- (instancetype)initWithView:(CGRect)menuViewRext;
- (void)showInViewController:(UIViewController*)parentViewController;

- (instancetype)initWithView;
// menuView center set
- (void)menuViewCenter:(CGPoint)point;

- (void)dismissAnimated:(BOOL)animated;
- (void)dismissNotAllView;
- (void)dismissAllView;
- (BOOL)isDismissFlg;

@property (nonatomic, strong) UIView *menuView;
@property (nonatomic, assign) CGFloat blurLevel;
@property (nonatomic, strong) UIBezierPath *blurExclusionPath;
@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign) CGFloat animationDuration;
@property (nonatomic, strong) UIColor *itemTextColor;
@property (nonatomic, strong) UIFont *itemFont;
@property (nonatomic, strong) UIColor *highlightColor;
@property (nonatomic, assign) BOOL bounces;

@end
