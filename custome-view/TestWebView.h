//
//  TestWebView.h
//  custome-view
//
//  Created by takahiro on 2015/02/14.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    QVToolBarScrollStatusInit = 0,
    QVToolBarScrollStatusAnimation ,
}QVToolBarScrollStatus;

// buttonアクションのdelegate設定
@protocol TestWebViewDelegate <NSObject>

- (void)changeView;
@end

@interface TestWebView : UIView<UIScrollViewDelegate, UIWebViewDelegate>

- (void)getUrl:(NSString*)getUrl;

@property(atomic) UIImage *snapshot;
@property(nonatomic, unsafe_unretained)id<TestWebViewDelegate> delegate;

@end