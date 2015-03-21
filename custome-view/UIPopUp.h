//
//  UIPopUp.h
//  custome-view
//
//  Created by takahiro on 2015/02/20.
//  Copyright (c) 2015年 test. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "UIBlurView.h"

@protocol UIPopUpDelegate <NSObject>

- (void)downButton2:(UIButton*)button;
- (void)plusView;
- (void)backOfFunction:(NSInteger)index;

@end

@interface UIPopUp : UIBlurView<UIGestureRecognizerDelegate>

- (void)showInViewController:(UIViewController*)viewController;
@property(nonatomic)id<UIPopUpDelegate> delegate;

@end
