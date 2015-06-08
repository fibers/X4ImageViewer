//
//  X4ImageView.m
//  X4ImageViewerDemo
//
//  Created by shengyuhong on 15/6/7.
//  Copyright (c) 2015年 Doit. All rights reserved.
//

#import "X4ImageView.h"

@interface X4ImageView ()

@property (nonatomic, strong) UITapGestureRecognizer *tapGestureZoomIn;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureZoomOut;


@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIScrollView *scrollView;


@end

@implementation X4ImageView



- (instancetype)init{
    self = [super init];
    if(self){
        [self setup];
    }
    
    return self;
}



- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setup];
    }
    
    return self;
}



- (void)setup{
    _tapGestureZoomIn = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapForZoomIn:)];
    _tapGestureZoomOut = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapForZoomOut:)];
    
    [self addGestureRecognizer:_tapGestureZoomIn];
    
    self.backgroundColor = [UIColor blackColor];
    
    self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.backgroundColor = [UIColor blackColor];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.imageView];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.scrollView.pagingEnabled = NO;
    self.scrollView.scrollEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    
}

- (void)setImage:(UIImage *)image{

    self.imageView.image = image;
    
    self.scrollView.contentSize = image.size;
    
    CGFloat scaleWidth =  (CGFloat)self.scrollView.bounds.size.width / self.scrollView.contentSize.width;
    CGFloat scaleHeight = (CGFloat)self.scrollView.bounds.size.height / self.scrollView.contentSize.height;
    CGFloat minScale = MIN(scaleWidth, scaleHeight);

    self.scrollView.minimumZoomScale = minScale;
    self.scrollView.zoomScale = minScale;
    
}

- (UIImage *)image{
    return self.imageView.image;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}

- (void)tapForZoomIn:(UITapGestureRecognizer *)gesture{
    
    [self insertSubview:self.scrollView belowSubview:self.imageView];
    
    [UIView animateWithDuration:0.3 animations:^{
//        self.frame.
    }];
}


- (void)tapForZoomOut:(UITapGestureRecognizer *)gesture{
    
}




@end
