//
//  X4ImageViewer.m
//  Pinnacle
//
//  Created by shengyuhong on 15/4/21.
//  Copyright (c) 2015年 The Third Rock Ltd. All rights reserved.
//

#import "X4ImageViewer.h"
#import <UIImageView+WebCache.h>

@interface X4ImageViewer ()

@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, assign) NSInteger imageCount;
@property (nonatomic, assign) BOOL bWebImageURL;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSMutableArray *imageViewArray;

@property (nonatomic, assign) CGRect rectZoomOut;

@property (nonatomic, strong) UITapGestureRecognizer *tapImageZoomIn;
@property (nonatomic, strong) UITapGestureRecognizer *tapImageZoomOut;

@property (nonatomic, assign) BOOL bDragging;

@end


@implementation X4ImageViewer


- (instancetype)initWithFrame:(CGRect)frame images:(NSArray *)imageArray{
    self = [super initWithFrame:frame];
    if(self){
        
        self.backgroundColor = [UIColor blackColor];
        
        self.rectZoomOut = frame;
        
        self.currentImageIndex = 0;
        
        self.imageArray = imageArray;
        if( [[imageArray firstObject] isKindOfClass:[NSURL class]]){
            self.bWebImageURL = YES;
        }else{
            self.bWebImageURL = NO;
        }
        
        self.imageCount = [imageArray count];
        
        CGRect frameScrollView = CGRectMake(0, 0, frame.size.width, frame.size.height);
        self.scrollView = [[UIScrollView alloc] initWithFrame:frameScrollView];
        self.scrollView.pagingEnabled = YES;
        self.scrollView.scrollEnabled = YES;
        self.scrollView.bounces = NO;
        self.scrollView.showsHorizontalScrollIndicator = self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.delegate = self;
        
        self.scrollView.contentSize = CGSizeMake(frame.size.width * self.imageCount, frame.size.height);
        [self addSubview:self.scrollView];
        
        self.imageViewArray = [[NSMutableArray alloc] init];
        for(int i=0; i<self.imageCount; i++){
            UIImageView *iv = [[UIImageView alloc] init];
            if(self.defaultImage){
                iv.image = self.defaultImage;
            }
            iv.contentMode =  UIViewContentModeScaleAspectFit;
            [self.imageViewArray addObject:iv];
        }
        
        CGFloat wPageControl = frame.size.width;
        CGFloat hPageControl = 37;
        CGFloat xPageControl = 0;
        CGFloat yPageControl = frame.size.height - hPageControl;
        
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(xPageControl, yPageControl, wPageControl, hPageControl)];
        self.pageControl.numberOfPages = self.imageCount;
        self.pageControl.currentPage = self.currentImageIndex;
        self.pageControl.defersCurrentPageDisplay = YES;
        [self addSubview:self.pageControl];
        
        self.userInteractionEnabled = YES;
        self.tapImageZoomIn = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageZoomIn:)];
        self.tapImageZoomOut = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageZoomOut:)];
        [self addGestureRecognizer:self.tapImageZoomIn];
        
        return self;
    }
    return nil;
}

- (void)addConstraint{
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.pageControl attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:37]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.pageControl attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.pageControl attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.pageControl attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    
}

- (void)layoutSubviews{
    
    [self removeAllImages];
    self.scrollView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    self.scrollView.contentSize = CGSizeMake(self.bounds.size.width * self.imageCount, self.bounds.size.height);
    self.scrollView.contentOffset = CGPointMake(self.bounds.size.width * self.currentImageIndex, 0);
    self.pageControl.frame = CGRectMake(0, self.bounds.size.height - self.pageControl.frame.size.height, self.bounds.size.width, self.pageControl.frame.size.height);
    [self loadImages];
    
}

- (void)tapImageZoomIn:(UITapGestureRecognizer *)gesture{
    
    self.frame = self.rectZoomIn;
    [self.scrollView zoomToRect:self.rectZoomIn animated:YES];
    [self removeGestureRecognizer:self.tapImageZoomIn];
    [self addGestureRecognizer:self.tapImageZoomOut];
}

- (void)tapImageZoomOut:(UITapGestureRecognizer *)gesture{
    
    self.frame = self.rectZoomOut;
    [self.scrollView zoomToRect:self.rectZoomOut animated:YES];
    [self removeGestureRecognizer:self.tapImageZoomOut];
    [self addGestureRecognizer:self.tapImageZoomIn];
}


- (void)loadImageAtIndex:(NSInteger)index{
    
    if(index < 0 || index >= self.imageCount){
        return;
    }
    
    UIImageView *ivImage = (UIImageView *)[self.imageViewArray objectAtIndex:index];
    if(self.defaultImage){
        if([ivImage.image isEqual:self.defaultImage]){
            CGRect frameImage = self.scrollView.bounds;
            frameImage.origin.x = frameImage.size.width * index;
            frameImage.origin.y = 0;
            
            ivImage.frame = frameImage;
            if(self.bWebImageURL){
                [ivImage sd_setImageWithURL:[self.imageArray objectAtIndex:index]];
            }else{
                ivImage.image = [self.imageArray objectAtIndex:index];
            }
            
            [self.scrollView addSubview:ivImage];
        }
    }else{
        if(!ivImage.image){
            CGRect frameImage = self.scrollView.bounds;
            frameImage.origin.x = frameImage.size.width * index;
            frameImage.origin.y = 0;
            
            ivImage.frame = frameImage;
            if(self.bWebImageURL){
                [ivImage sd_setImageWithURL:[self.imageArray objectAtIndex:index]];
            }else{
                ivImage.image = [self.imageArray objectAtIndex:index];
            }
            
            [self.scrollView addSubview:ivImage];
        }
    }
}

- (void)removeImageAtIndex:(NSInteger)index{
    
    if(index < 0 || index >= self.imageCount){
        return;
    }

    UIImageView *ivImage = (UIImageView *)[self.imageViewArray objectAtIndex:index];
    if(self.defaultImage){
        if(![ivImage.image isEqual:self.defaultImage]){
            [ivImage removeFromSuperview];
            ivImage.image = self.defaultImage;
        }
    }else{
        if(ivImage.image){
            [ivImage removeFromSuperview];
            ivImage.image = nil;
        }
    }
}

- (void)removeAllImages{
    for(NSInteger i=0; i<self.imageCount; i++){
        [self removeImageAtIndex:i];
    }
}


- (void)loadImages{
    
    self.pageControl.currentPage = self.currentImageIndex;
    
    NSInteger previousImageIndex = self.currentImageIndex - 1;
    NSInteger nextImageIndex = self.currentImageIndex + 1;
    
    for(NSInteger i=0; i<previousImageIndex; i++){
        [self removeImageAtIndex:i];
    }
    
    for(NSInteger i=previousImageIndex; i<=nextImageIndex; i++){
        [self loadImageAtIndex:i];
    }
    
    for(NSInteger i=nextImageIndex+1; i<self.imageCount; i++){
        [self removeImageAtIndex:i];
    }
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if(self.bDragging){
        self.currentImageIndex = (NSInteger)floor((scrollView.contentOffset.x * 2 + scrollView.frame.size.width) / (scrollView.frame.size.width * 2));
        [self loadImages];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.bDragging = NO;
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.bDragging = YES;
}



@end
