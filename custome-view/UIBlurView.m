//
//  UIBlurView.m
//  Kaleidoscope
//
//  Created by kobayashi on 2014/01/11.
//  Copyright (c) 2014年 kobayashi-kikai.co.jp. All rights reserved.
//

#import "UIBlurView.h"
#import <Accelerate/Accelerate.h>

CGFloat const kRNGridMenuDefaultBlur = 0.3f;
CGFloat const kRNGridMenuDefaultDuration = 0.25;

static UIBlurView *rn_view;

@interface UIBlurView ()

@property (nonatomic, strong) UIView *blueView;
@property (nonatomic)  BOOL isDismissFlg;
@end


@implementation UIView (Screenshot)

- (UIImage*)setUIView{
    UIGraphicsBeginImageContext(self.bounds.size);
    if ([self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        NSLog(@"yes");
        [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    }else{
        NSLog(@"no");
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.75);
    image = [UIImage imageWithData:imageData];
    
    return image;
}

@end


@implementation UIImage (Blur)

- (UIImage*)rn_boxblurImageWithBlur:(CGFloat)blur exclusionPath:(UIBezierPath*)exclusionPath{
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    
    int boxSize = (int)(blur * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    
    CGImageRef img = self.CGImage;
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    
    // create unchanged copy of the area inside the exclusionPath
    UIImage *unblurredImage = nil;
    if (exclusionPath != nil) {
        CAShapeLayer *maskLayer = [CAShapeLayer new];
        maskLayer.frame = (CGRect){CGPointZero, self.size};
        maskLayer.backgroundColor = [UIColor blackColor].CGColor;
        maskLayer.fillColor = [UIColor whiteColor].CGColor;
        maskLayer.path = exclusionPath.CGPath;
        
        // create grayscale image to mask context
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
        CGContextRef context = CGBitmapContextCreate(nil, maskLayer.bounds.size.width, maskLayer.bounds.size.height, 8, 0, colorSpace, kCGImageAlphaNone);
        CGContextTranslateCTM(context, 0, maskLayer.bounds.size.height);
        CGContextScaleCTM(context, 1.f, -1.f);
        [maskLayer renderInContext:context];
        CGImageRef imageRef = CGBitmapContextCreateImage(context);
        UIImage *maskImage = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
        CGColorSpaceRelease(colorSpace);
        CGContextRelease(context);
        
        UIGraphicsBeginImageContext(self.size);
        context = UIGraphicsGetCurrentContext();
        CGContextTranslateCTM(context, 0, maskLayer.bounds.size.height);
        CGContextScaleCTM(context, 1.f, -1.f);
        CGContextClipToMask(context, maskLayer.bounds, maskImage.CGImage);
        CGContextDrawImage(context, maskLayer.bounds, self.CGImage);
        unblurredImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    //create vImage_Buffer with data from CGImageRef
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    //create vImage_Buffer for output
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    // Create a third buffer for intermediate processing
    void *pixelBuffer2 = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    vImage_Buffer outBuffer2;
    outBuffer2.data = pixelBuffer2;
    outBuffer2.width = CGImageGetWidth(img);
    outBuffer2.height = CGImageGetHeight(img);
    outBuffer2.rowBytes = CGImageGetBytesPerRow(img);
    
    //perform convolution
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer2, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    error = vImageBoxConvolve_ARGB8888(&outBuffer2, &inBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage(ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    // overlay images?
    if (unblurredImage != nil) {
        UIGraphicsBeginImageContext(returnImage.size);
        [returnImage drawAtPoint:CGPointZero];
        [unblurredImage drawAtPoint:CGPointZero];
        
        returnImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
    }
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    free(pixelBuffer);
    free(pixelBuffer2);
    CFRelease(inBitmapData);
    CGImageRelease(imageRef);
    
    return returnImage;
}

@end



@implementation UIBlurView

+ (instancetype)visibleGridMenu{
    return rn_view;
}

- (instancetype)initWithView{
    if (self = [super init]) {
        _itemSize = CGSizeMake(100.f, 100.f);
        _cornerRadius = 0.f;
        _blurLevel = kRNGridMenuDefaultDuration;
        _itemTextColor = [UIColor whiteColor];
        _itemFont = [UIFont boldSystemFontOfSize:14.f];
        _highlightColor = [UIColor colorWithRed:.02f green:.549f blue:.961f alpha:1.f];
        _menuView = [[UIView alloc]init];
        _bounces = YES;
        _isDismissFlg = YES;
    }
    return self;
}

- (instancetype)initWithView:(CGRect)menuViewRext{
    self = [self initWithView];
    _menuView.frame = menuViewRext;
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
}


- (void)createScreenshotAndLayoutWithScreenshotCompletion:(dispatch_block_t)screenshotCompletion {
    if (self.blurLevel > 0.f) {
        self.blueView.alpha = 0.f;
        
        self.menuView.alpha = 0.f;
        UIImage *screenshot = [self.parentViewController.view setUIView];
        self.menuView.alpha = 1.f;
        self.blueView.alpha = 1.f;
        self.blueView.layer.contents = (id)screenshot.CGImage;

        if (screenshotCompletion != nil) {
            screenshotCompletion();
        }

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0L), ^{
            UIImage *blur = [screenshot rn_boxblurImageWithBlur:self.blurLevel exclusionPath:self.blurExclusionPath];
            dispatch_async(dispatch_get_main_queue(), ^{
                CATransition *transition = [CATransition animation];
                
                transition.duration = 0.2;
                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                transition.type = kCATransitionFade;
                
                [self.blueView.layer addAnimation:transition forKey:nil];
                self.blueView.layer.contents = (id)blur.CGImage;
                
                [self.view setNeedsLayout];
                [self.view layoutIfNeeded];
            });
        });
    }
}

- (void)showInViewController:(UIViewController*)parentViewController{
    [self selectFormView:parentViewController animation:YES];
    self.view.frame = parentViewController.view.bounds;
    [self showAnimated:YES];
}

- (void)showAnimated:(BOOL)animated{
    rn_view = self;
    self.blueView = [[UIView alloc]initWithFrame:self.parentViewController.view.bounds];
    self.blueView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.blueView];
    [self selectWebView];
    [self.view addSubview:self.menuView];
    [self createScreenshotAndLayoutWithScreenshotCompletion:^{
        
    }];
}

- (void)selectWebView{

}

- (void)selectFormView:(UIViewController*)parentViewController animation:(BOOL)animation{
    if (animation) [self beginAppearanceTransition:YES animated:NO];
    [parentViewController addChildViewController:self];
    [parentViewController.view addSubview:self.view];
    [self didMoveToParentViewController:self];
    if (animation) [self endAppearanceTransition];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.isDismissFlg) {
        [self dismissAnimated:YES];
    }
}

- (void)dismissAnimated:(BOOL)animated{
    if (animated) {
        CABasicAnimation *animetion = [CABasicAnimation animationWithKeyPath:@"opacity"];
        animetion.fromValue = @1.;
        animetion.toValue = @0.;
        animetion.duration = self.animationDuration;
        [self.blueView.layer addAnimation:animetion forKey:nil];
        
        self.blueView.layer.opacity = 0;
        [self performSelector:@selector(clearView) withObject:nil afterDelay:self.animationDuration];
    }
    rn_view = nil;
}

- (void)clearView{
    [self blueViewClear:YES];
}

- (void)blueViewClear:(BOOL)animation{
    if (animation) [self beginAppearanceTransition:NO animated:NO];
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    if (animation) [self endAppearanceTransition];
}

- (void)dismissNotAllView{
    _isDismissFlg = NO;
}

- (void)dismissAllView{
    _isDismissFlg = YES;
}
- (void)menuViewCenter:(CGPoint)point{
    self.menuView.center = point;
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField{
    NSLog(@"textFieldShouldReturn");
    [textField resignFirstResponder];
    return YES;
}

@end
