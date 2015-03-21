//
//  Contents.m
//  custome-view
//
//  Created by takahiro on 2015/02/08.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import "Contents.h"

@interface Contents()
@property(nonatomic) NSMutableArray *contentArray;
@end

@implementation Contents

static Contents *_contents;
+ (Contents*)contents
{
    if(!_contents){
        _contents = [[Contents alloc]init];
        _contents.contentArray = [[NSMutableArray alloc]init];
    }
    return _contents;
}

- (void)setContentController:(id)object
{
    [_contentArray addObject:object];
}

- (id)getContentController:(int)index
{
    return [_contentArray objectAtIndex:index];
}

- (id)getAllContentController
{
    return _contentArray;
}

- (void)setReplaceContentController:(id)object index:(int)index
{
    [_contentArray replaceObjectAtIndex:index withObject:object];
}

@end