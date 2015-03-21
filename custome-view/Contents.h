//
//  contents.h
//  custome-view
//
//  Created by takahiro on 2015/02/08.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Contents : NSObject

+ (Contents*)contents;
- (void)setContentController:(id)object;
- (id)getContentController:(int)index;
- (id)getAllContentController;
- (void)setReplaceContentController:(id)object index:(int)index;

@end
