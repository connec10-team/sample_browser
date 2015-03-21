//
//  ViewController.m
//  custome-view
//
//  Created by takahiro on 2015/02/08.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import "ViewController.h"
#import "TestSubViewController.h"
#import "contents.h"
#import "TestWebView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    self.view.backgroundColor = [UIColor blackColor];
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    view.backgroundColor = [UIColor whiteColor];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 200, 200)];

    [button setTitle:@"押してねaaaaaaaaaaaaaaaaa" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitle:@"ぽちaaaaaaaaaaaaaaaaa" forState:UIControlStateHighlighted];
    [button setTitle:@"押せませんaaaaaaaaaaaaaaaaa" forState:UIControlStateDisabled];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateDisabled];
    [button addTarget:self action:@selector(downButton:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    view3.backgroundColor = [UIColor redColor];
    UIButton *button3 = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 200, 200)];
    [button3 setTitle:@"押してね" forState:UIControlStateNormal];
    [button3 setTitle:@"ぽち" forState:UIControlStateHighlighted];
    [button3 setTitle:@"押せません" forState:UIControlStateDisabled];
    [button3 addTarget:self action:@selector(downButton:) forControlEvents:UIControlEventTouchUpInside];
    [view3 addSubview:button3];

    
//    [self.view addSubview:view];
//    [[Contents contents]setContentController:view];
//    [[Contents contents]setContentController:view3];
    NSLog(@"subview count %lu", (unsigned long)[[self.view subviews]count]);
    NSLog(@"count %lu", (unsigned long)[[[Contents contents]getAllContentController]count]);
    NSInteger count = [[[Contents contents]getAllContentController] count];
    if (count == 0) {
        [self tabViewInsert:@"http://www.yahoo.co.jp"];
    }else{
        [self.view addSubview:[[Contents contents] getContentController:(int)count - 1]];
    }
    // Do any additional setup after loading the view, typically from a nib.
}




- (void)tabViewInsert:(NSString*)url
{
    TestWebView *wv = [[TestWebView alloc]initWithFrame:self.view.bounds];
    [wv setDelegate:self];
    [self.view addSubview:wv];
    [wv getUrl:url];
    [[Contents contents]setContentController:wv];
}

// ページ読込開始時にインジケータをくるくるさせる
-(void)webViewDidStartLoad:(UIWebView*)webView{
    NSLog(@"webviewdidstartload");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

// ページ読込完了時にインジケータを非表示にする
-(void)webViewDidFinishLoad:(UIWebView*)webView{
    NSLog(@"webviewdidfinishload");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)backOfFunction:(NSInteger)index
{
    NSLog(@"ccccccccccccccccccccccc %d", index);
    [self.view addSubview:[[Contents contents]getContentController:index]];
}

- (void)plusView
{
    NSLog(@"plus view");
    [self tabViewInsert:@"http://www.google.com"];
}

- (void)changeView
{
    // view change
    NSLog(@"change view");
    UIPopUp *blur = [[UIPopUp alloc]initWithView:self.view.frame];
    blur.delegate = self;
    [blur showInViewController:self];
    
    NSLog(@"subview count %lu", (unsigned long)[[self.view subviews]count]);
}

- (void)downButton:(UIButton*)button
{
    NSLog(@"downButton");
    UIPopUp *blur = [[UIPopUp alloc]initWithView:self.view.frame];
    blur.delegate = self;

//    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
//    view2.backgroundColor = [UIColor grayColor];
//    [blur.menuView addSubview:button2];
    [blur showInViewController:self];
    
    NSLog(@"subview count %lu", (unsigned long)[[self.view subviews]count]);
//    [view2 addSubview:button2];
//    [[Contents contents]setContentController:view2];
//    NSLog(@"count %lu", (unsigned long)[[[Contents contents]getAllContentController]count]);
//    NSLog(@"subview count %lu", (unsigned long)[[self.view subviews]count]);
//    [self.view addSubview:view2];
}

- (void)downButton2:(UIButton*)button
{
    NSLog(@"downButton2");
//    NSLog(@"count %lu", (unsigned long)[[[Contents contents]getAllContentController]count]);
//    NSLog(@"subview count %lu", (unsigned long)[[self.view subviews]count]);
//    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//    self.view.backgroundColor = [UIColor yellowColor];
    //[[Contents contents]setReplaceContentController:[self.view.subviews objectAtIndex:(int)[[self.view subviews]count]-1] index:2];
//    [self.view addSubview:[[Contents contents] getContentController:1]];
}

- (void)downButton3:(UIButton*)button
{
    NSLog(@"downButton3");
//    NSLog(@"count %lu", (unsigned long)[[[Contents contents]getAllContentController]count]);
//    NSLog(@"subview count %lu", (unsigned long)[[self.view subviews]count]);
//    [self.view addSubview:[[Contents contents] getContentController:2]];
}


- (void)displayChange:(UIViewController*)controller
{
    [self addChildViewController:controller];
    controller.view.frame = self.view.bounds;
    [self.view addSubview:controller.view];
    [controller didMoveToParentViewController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
