//
//  TestWebView.m
//  custome-view
//
//  Created by takahiro on 2015/02/14.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import "TestWebView.h"

@interface TestWebView ()

@property(nonatomic) UIWebView *webView;
@property(nonatomic) UINavigationBar *naviBar;
// scroll初期値Yの取得及び保持
@property(nonatomic) CGFloat startScrollY;

// scrollアニメーション判定
@property(nonatomic) BOOL toolBarScrollStatus;
// 画面遷移したらsnapshot撮影
@property(nonatomic) int snapshot_flg;

@end

@implementation TestWebView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor greenColor];
    if(self){
        NSLog(@"testwebview initwithframe");
        [self initWithStart];
    }
    return self;
}

- (void)initWithStart
{
    int naviHeight = 50;
    self.naviBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, naviHeight)];
    //self.naviBar = [[UINavigationBar alloc]init];
    //[self.naviBar sizeToFit];
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0,
                                                              self.naviBar.bounds.size.height,
                                                              self.bounds.size.width,
                                                              self.bounds.size.height-self.naviBar.bounds.size.height)];
    // scrollviewの検知のためdelegate設定
    self.webView.delegate = self;
    self.webView.scrollView.delegate = self;
//    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:@"back" style:UIBarButtonItemStylePlain target:self action:@selector(backWithAction)];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(backWithAction)];
    UIBarButtonItem *changeViewButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(changeView)];
    UINavigationItem *naviItems = [[UINavigationItem alloc]init];
    naviItems.leftBarButtonItems = @[backButton];
    naviItems.rightBarButtonItems = @[changeViewButton];

    [self.naviBar pushNavigationItem:naviItems animated:YES];
    [self addSubview:self.webView];
    [self addSubview:self.naviBar];
    
}

// スクロールビューをドラッグし始めた際に一度実行される
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"start scroll y :%f", [scrollView contentOffset].y);
    self.startScrollY = [scrollView contentOffset].y;
}

// スクロースするたびに呼び出される
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (QVToolBarScrollStatusAnimation == self.toolBarScrollStatus) {
        return;
    }
    NSLog(@"start scroll Y %f", self.startScrollY);
    NSLog(@"start scroll view %f", [scrollView contentOffset].y);

    if(self.startScrollY <= [scrollView contentOffset].y && !self.naviBar.hidden){
        // スクロールが下の場合
//        NSLog(@"scroll Y %f", self.startScrollY);
//        NSLog(@"scroll view %f", [scrollView contentOffset].y);
        [UIView animateWithDuration:0.4 animations:^{
            self.toolBarScrollStatus = QVToolBarScrollStatusAnimation;
            CGRect rect = self.naviBar.frame;
//            NSLog(@"bar height %f", rect.size.height);
            self.naviBar.frame = CGRectMake(rect.origin.x,
                                            rect.origin.y - rect.size.height,
                                            rect.size.width,
                                            rect.size.height);
            CGRect webRec = self.webView.frame;
            self.webView.frame = CGRectMake(webRec.origin.x,
                                            webRec.origin.y - rect.size.height,
                                            webRec.size.width,
                                            webRec.size.height + rect.size.height);
        } completion:^(BOOL finished){
            self.naviBar.hidden = YES;
            self.toolBarScrollStatus = QVToolBarScrollStatusInit;
        }];
    }else if ([scrollView contentOffset].y < self.startScrollY
              && self.naviBar.hidden
              && 0.0 != self.startScrollY){
        // スクロールが上の場合
        self.naviBar.hidden = NO;
        NSLog(@"scroll b");
        [UIView animateWithDuration:0.4 animations:^{
            self.toolBarScrollStatus = QVToolBarScrollStatusAnimation;
            CGRect rect = self.naviBar.frame;
            self.naviBar.frame = CGRectMake(rect.origin.x,
                                            rect.origin.y + rect.size.height,
                                            rect.size.width,
                                            rect.size.height);
            CGRect webRec = self.webView.frame;
            self.webView.frame = CGRectMake(webRec.origin.x,
                                            webRec.origin.y + rect.size.height,
                                            webRec.size.width,
                                            webRec.size.height - rect.size.height);
        }completion:^(BOOL finished){
            self.toolBarScrollStatus = QVToolBarScrollStatusInit;
        }];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"aaaaaaaaaaaaaaaaaaaaaaaaaa");
}


- (void)backWithAction
{
    [self.webView goBack];
}

- (void)changeView
{
    // snapshot
    NSLog(@"change view 222");
    CGRect rect = self.webView.bounds;
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.webView.layer renderInContext:context];
    self.snapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.delegate changeView];
}


- (void)getUrl:(NSString*)getUrl
{
    NSLog(@"getUrl");
    NSURL *url = [NSURL URLWithString:getUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

// ページ読込開始時にインジケータをくるくるさせる
-(void)webViewDidStartLoad:(UIWebView*)webView{
    NSLog(@"webviewdidstartload2");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

// ページ読込完了時にインジケータを非表示にする
-(void)webViewDidFinishLoad:(UIWebView*)webView{
    NSLog(@"webviewdidfinishload2");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

@end
