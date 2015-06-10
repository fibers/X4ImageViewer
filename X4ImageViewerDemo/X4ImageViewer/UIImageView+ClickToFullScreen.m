//
//  UIImageView+ClickToFullScreen.m
//  X4ImageViewerDemo
//
//  Created by shengyuhong on 15/6/7.
//  Copyright (c) 2015年 Doit. All rights reserved.
//

#import "UIImageView+ClickToFullScreen.h"

static const NSUInteger TagImageView = 1000;

@implementation UIImageView (ClickToFullScreen)

- (void)enableClickToFullScreen{
    
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapToFullScreen:)];
    tapGesture.delegate = self;
    [self addGestureRecognizer:tapGesture];
}

- (void)onTapToFullScreen:(UITapGestureRecognizer *)gesture{

    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGRect rectInWindow = [self convertRect:self.bounds toView:window];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:window.bounds];
    scrollView.delegate = self;
    scrollView.backgroundColor = [UIColor blackColor];
    scrollView.alpha = 0;
    scrollView.pagingEnabled = NO;
    scrollView.scrollEnabled = NO;
    scrollView.bounces = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.contentSize = self.image.size;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapToNormal:)];
    [scrollView addGestureRecognizer:tapGesture];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:rectInWindow];
    imageView.tag = TagImageView;
    imageView.image = self.image;
    imageView.contentMode = self.contentMode;
    
    [scrollView addSubview:imageView];

    [window addSubview:scrollView];
    
    [UIView animateWithDuration:0.5 animations:^{

        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.frame = window.bounds;
        scrollView.alpha = 1;
        
    } completion:^(BOOL finished) {
        
        imageView.frame = CGRectMake(0, 0, self.image.size.width, self.image.size.height);
        
        CGFloat scaleWidth = (CGFloat)scrollView.bounds.size.width / imageView.bounds.size.width;
        CGFloat scaleHeight = (CGFloat)scrollView.bounds.size.height / imageView.bounds.size.height;
        CGFloat minScale = MIN(scaleWidth, scaleHeight);
        CGFloat maxScale = MAX(scaleWidth, scaleHeight);
        
        if(minScale >= 1){
            scrollView.minimumZoomScale = 1;
            scrollView.maximumZoomScale = maxScale;
        }else{
            scrollView.minimumZoomScale = minScale;
            scrollView.maximumZoomScale = 1;
        }
        
        scrollView.zoomScale = minScale;
        scrollView.scrollEnabled = YES;
        
        [self move:imageView toCenterOf:scrollView];

    }];
    
}

- (void)onTapToNormal:(UITapGestureRecognizer *)gesture{
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGRect rectInWindow = [self convertRect:self.bounds toView:window];
    
    UIScrollView *scrollView = (UIScrollView *)gesture.view;
    UIImageView *imageView = (UIImageView *)[scrollView viewWithTag:TagImageView];

    scrollView.scrollEnabled = NO;
    scrollView.maximumZoomScale = scrollView.minimumZoomScale;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        scrollView.zoomScale = scrollView.minimumZoomScale;
        imageView.frame = rectInWindow;
        scrollView.alpha = 0;
        
    } completion:^(BOOL finished) {
        [scrollView removeFromSuperview];
    }];

}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}


- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    
    UIImageView *imageView = (UIImageView *)[scrollView viewWithTag:1000];
    
    [self move:imageView toCenterOf:scrollView];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return [scrollView viewWithTag:1000];
}

- (void)move:(UIImageView *)imageView toCenterOf:(UIScrollView *)scrollView{
    CGSize scrollViewSize = scrollView.bounds.size;
    CGRect imageFrame = imageView.frame;
    
    if(imageFrame.size.width < scrollViewSize.width){
        imageFrame.origin.x = (scrollViewSize.width - imageFrame.size.width) / 2;
    } else {
        imageFrame.origin.x = 0;
    }
    
    if(imageFrame.size.height < scrollViewSize.height){
        imageFrame.origin.y = (scrollViewSize.height - imageFrame.size.height) / 2;
    } else {
        imageFrame.origin.y = 0;
    }
    
    imageView.frame = imageFrame;

}


@end
