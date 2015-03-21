//
//  UITouchView.h
//  custome-view
//
//  Created by takahiro on 2015/02/22.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITouchView : UIView

- (UIView*)createButton:(int)index image:(UIImage*)image frame:(CGRect)frame;

@end