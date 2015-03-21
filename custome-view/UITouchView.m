//
//  UITouchView.m
//  custome-view
//
//  Created by takahiro on 2015/02/22.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import "UITouchView.h"
#import "Contents.h"

@interface UITouchView ()
@property(nonatomic) CGPoint startBegan;
@property(nonatomic) NSTimeInterval timestampBegan;

@end


@implementation UITouchView

- (UIView*)createButton:(int)index image:(UIImage*)image frame:(CGRect)frame
{
/*    UIButton *button = [[UIButton alloc]initWithFrame:frame];
    [button setTitle:[NSString stringWithFormat:@"%d", index] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitle:@"aaa" forState:UIControlStateHighlighted];
    [button setTitle:[NSString stringWithFormat:@"%d", index] forState:UIControlStateDisabled];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateDisabled];
    
    [button.titleLabel setFont:[UIFont systemFontOfSize:40.0f]];
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(downButton2:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = index;
    [self addSubview:button];
 */
    UILabel *imageLabel = [[UILabel alloc]initWithFrame:frame];
    imageLabel.backgroundColor = [UIColor colorWithPatternImage:image];
    [self addSubview:imageLabel];
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    static const NSTimeInterval FlickTimeInterval = 0.3;
    static const NSInteger FlickMini = 10;
    UITouch *touchEnded = [touches anyObject];
    CGPoint pointEnd = [touchEnded locationInView:self];
    NSInteger distanceHorizontal = ABS(pointEnd.x - _startBegan.x);
    NSInteger distanceVertical = ABS(pointEnd.y - _startBegan.y);
    if (FlickMini > distanceHorizontal && FlickMini > distanceVertical) {
        //縦にも横にもあまり移動していなければreturn
        return;
    }
    NSTimeInterval timeBeganToEnded = event.timestamp - _timestampBegan;
    if (FlickTimeInterval > timeBeganToEnded) {
        //フリックした場合の処理
        NSString *message;
        //どの方向にフリックしたかを判定
        if (distanceHorizontal > distanceVertical) {
            if (pointEnd.x > _startBegan.x) {
                message = @"右フリック";
            } else {
                message = @"左フリック";
            }
        } else {
            if (pointEnd.y > _startBegan.y) {
                message = @"下フリック";
            } else {
                message = @"上フリック";
                NSLog(@"%@", event);
            }
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        [alert show];
    }
    //    if (self.isDismissFlg) {
    //        [self dismissAnimated:YES];
    //    }
    
}

@end