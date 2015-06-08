//
//  UIImageView+X4ImageViewer.m
//  X4ImageViewerDemo
//
//  Created by shengyuhong on 15/6/7.
//  Copyright (c) 2015年 Doit. All rights reserved.
//

#import "UIImageView+X4ImageViewer.h"

static const NSUInteger TagImageView = 1000;

@implementation UIImageView (X4ImageViewer)

- (void)enableClickToFullScreen{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapToFullScreen:)];
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
    imageView.backgroundColor = [UIColor clearColor];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [scrollView addSubview:imageView];

    [window addSubview:scrollView];
    
    [UIView animateWithDuration:0.5 animations:^{
        
        imageView.frame = window.bounds;
        scrollView.alpha = 1;
        
    } completion:^(BOOL finished) {
        
        imageView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);
        
        CGFloat scaleWidth = (CGFloat)scrollView.bounds.size.width / scrollView.contentSize.width;
        CGFloat scaleHeight = (CGFloat)scrollView.bounds.size.height / scrollView.contentSize.height;
        CGFloat minScale = MIN(scaleWidth, scaleHeight);
    
        scrollView.minimumZoomScale = minScale;
        scrollView.maximumZoomScale = 1;
    
        scrollView.zoomScale = minScale;
        scrollView.scrollEnabled = YES;

    }];
    
}

- (void)onTapToNormal:(UITapGestureRecognizer *)gesture{
    
    UIScrollView *scrollView = (UIScrollView *)gesture.view;
    UIImageView *imageView = (UIImageView *)[scrollView viewWithTag:TagImageView];

    scrollView.scrollEnabled = NO;
    scrollView.maximumZoomScale = scrollView.minimumZoomScale;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        scrollView.zoomScale = scrollView.minimumZoomScale;
        imageView.frame = self.frame;
        scrollView.alpha = 0;
        
    } completion:^(BOOL finished) {
        [scrollView removeFromSuperview];
    }];

}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    
    UIImageView *imageView = (UIImageView *)[scrollView viewWithTag:1000];
    
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

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return [scrollView viewWithTag:1000];
}


@end
