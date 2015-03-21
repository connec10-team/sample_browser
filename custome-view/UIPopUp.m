//
//  UIPopUp.m
//  custome-view
//
//  Created by takahiro on 2015/02/20.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import "UIPopUp.h"
#import "Contents.h"
#import "TestWebView.h"
#import "UITouchView.h"

@interface UIPopUp ()
@property(nonatomic) CGPoint startBegan;
@property(nonatomic) NSTimeInterval timestampBegan;

@end

@implementation UIPopUp

-(void)showInViewController:(UIViewController*)viewController
{
    UIButton *plus = [UIButton buttonWithType:UIButtonTypeContactAdd];
    plus.frame = CGRectMake( self.view.frame.size.width/6,
                                                                self.view.frame.size.height-100,
                                                                50,
                                                                50);
    [plus addTarget:self action:@selector(plusButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10,
                                                                               self.view.frame.size.height/2,
                                                                               self.view.frame.size.width,
                                                                               200)];
//    scrollView.backgroundColor = [UIColor blackColor];
//    scrollView.alpha = 0.5f;
    //ページ数分の横幅を確保します
    int PAGE_COUNT = [[[Contents contents]getAllContentController] count];
    scrollView.contentSize = CGSizeMake(120.0 * PAGE_COUNT, 100.0f);
    //1ページごとにめくれるように設定。これがないと中途半端な位置で止まります。
    for(int i = 0; i < PAGE_COUNT; i++){//ページの中身を作成
        NSLog(@"page count");

        UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(110.0f * i, 0, 100, 200)];
        [button setTitle:[NSString stringWithFormat:@"%d", i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitle:@"aaa" forState:UIControlStateHighlighted];
        [button setTitle:[NSString stringWithFormat:@"%d", i] forState:UIControlStateDisabled];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateDisabled];
        
        [button.titleLabel setFont:[UIFont systemFontOfSize:40.0f]];
//        button.backgroundColor = [UIColor yellowColor];
        TestWebView *test = [[Contents contents]getContentController:i];
//        UIImage *image = [[UIImage alloc]init];
//        UIImage *snapshot = test.snapshot;
        [button setImage:test.snapshot forState:UIControlStateNormal];
        [button addTarget:self action:@selector(downButton2:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        
        [scrollView addSubview:button];
//        TestWebView *testView = [[Contents contents]getContentController:i];
//        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(110.0f * i, 0, 100, 100)];
        
//        UITouchView *touchView = [[UITouchView alloc]init];
//        [touchView createButton:i image:testView.snapshot frame:CGRectMake(110.0f * i, 0, 100, 100)];
//        [scrollView addSubview:touchView];
    }
    [self.menuView addSubview:scrollView];
    [self.menuView addSubview:plus];

    [super showInViewController:viewController];
}

- (void)plusButton:(UIButton*)button
{
    [self popUpViewEnd];
    [self.delegate plusView];
}

- (void)downButton2:(UIButton*)button
{
    [self popUpViewEnd];
    NSLog(@"bbbbbbbbbbbbbbbbb  %d", button.tag);
    [self.delegate backOfFunction:button.tag];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    _timestampBegan = event.timestamp;
    _startBegan = [touch locationInView:self.view];
}


- (void)popUpViewEnd
{
    if (self.isDismissFlg) {
        [self dismissAnimated:YES];
    }

}


@end
