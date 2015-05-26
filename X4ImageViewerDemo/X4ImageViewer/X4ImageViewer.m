//
//  X4ImageViewer.m
//  Pinnacle
//
//  Created by shengyuhong on 15/4/21.
//  Copyright (c) 2015年 The Third Rock Ltd. All rights reserved.
//

#import "X4ImageViewer.h"

@interface X4ImageViewer ()

@property (nonatomic, assign) CGRect imagePosition;
@property (nonatomic, assign) NSInteger imagesCount;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSMutableArray *imageViewArray;
@property (nonatomic, strong) UILabel *numberPagination;
@property (nonatomic, strong) UIPageControl *pageControlPagination;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *paginationContainer;


@property (nonatomic, assign) BOOL bDragging;

@end


@implementation X4ImageViewer

- (instancetype)initWithFrame:(CGRect)frame images:(NSArray *)images{
    
    CGRect imagePosition = CGRectMake(0, 0, frame.size.width, frame.size.height);
    return [self initWithFrame:frame images:images imagePosition:imagePosition withPlaceholder:nil];
}

- (instancetype)initWithFrame:(CGRect)frame images:(NSArray *)images imagePosition:(CGRect)imagePosition{
    return [self initWithFrame:frame images:images imagePosition:imagePosition withPlaceholder:nil];
}

- (instancetype)initWithFrame:(CGRect)frame images:(NSArray *)images imagePosition:(CGRect)imagePosition withPlaceholder:(UIImage *)placeholderImage{
    self = [super initWithFrame:frame];
    if(self){
        
        if(CGRectGetWidth(frame) < CGRectGetWidth(imagePosition)
           || CGRectGetHeight(frame) < CGRectGetHeight(imagePosition)){
            NSAssert(NO, @"[X4ImageViewer] The image rect must not be smaller than the image viewer");
        }
        
        if([images count] == 0){
            NSAssert(NO, @"[X4ImageViewer] You must initialize the view with a valid array which contains one image at least.");
        }
        
        
        self.backgroundColor = [UIColor blackColor];
    
        self.currentImageIndex = 0;
        self.paginationType = PaginationTypePageControl;
        self.placeholderImage = placeholderImage;
        
        self.images = images;
        self.imagePosition = imagePosition;
        self.imagesCount = [images count];
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.imagePosition];
        self.scrollView.contentSize = CGSizeMake(self.imagePosition.size.width * self.imagesCount, self.imagePosition.size.height);
        self.scrollView.pagingEnabled = YES;
        self.scrollView.scrollEnabled = YES;
        self.scrollView.bounces = NO;
        self.scrollView.showsHorizontalScrollIndicator = self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.delegate = self;
        [self addSubview:self.scrollView];
        
        CGFloat wPaginationContainer = frame.size.width;
        CGFloat hPaginationContainer = frame.size.height - imagePosition.origin.y - imagePosition.size.height;
        CGFloat xPaginationContainer = 0;
        CGFloat yPaginationContainer = frame.size.height - hPaginationContainer;
        CGRect rectPaginationContainer = CGRectMake(xPaginationContainer, yPaginationContainer, wPaginationContainer, hPaginationContainer);
        self.paginationContainer = [[UIView alloc] initWithFrame:rectPaginationContainer];
        [self addSubview:self.paginationContainer];
        
        CGRect rectPagination = CGRectMake(0, 0, wPaginationContainer, hPaginationContainer);
        self.pageControlPagination = [[UIPageControl alloc] initWithFrame:rectPagination];
        self.pageControlPagination.currentPage = self.currentImageIndex;
        self.pageControlPagination.numberOfPages = self.imagesCount;
        self.pageControlPagination.defersCurrentPageDisplay = YES;
        self.pageControlPagination.hidden = NO;
        [self.paginationContainer addSubview:self.pageControlPagination];
        
        self.numberPagination = [[UILabel alloc] initWithFrame:rectPagination];
        self.numberPagination.font = [UIFont systemFontOfSize:15];
        self.numberPagination.textColor = [UIColor whiteColor];
        self.numberPagination.textAlignment = NSTextAlignmentCenter;
        self.numberPagination.text = [NSString stringWithFormat:@"%ld/%ld", self.currentImageIndex + 1, self.imagesCount];
        self.numberPagination.hidden = YES;
        [self.paginationContainer addSubview:self.numberPagination];
        
        self.imageViewArray = [[NSMutableArray alloc] init];
        for(int i=0; i<self.imagesCount; i++){
            UIImageView *iv = [[UIImageView alloc] init];
            if(self.placeholderImage){
                iv.image = self.placeholderImage;
            }
            iv.contentMode =  UIViewContentModeScaleAspectFit;
            [self.imageViewArray addObject:iv];
        }

        return self;
    }
    return nil;
}


- (void)setCurrentImageIndex:(NSInteger)currentImageIndex{
    _currentImageIndex = currentImageIndex;
    
    _pageControlPagination.currentPage = _currentImageIndex;
    _numberPagination.text = [NSString stringWithFormat:@"%ld/%ld", _currentImageIndex + 1, _imagesCount];
    
    _scrollView.contentOffset = CGPointMake(_scrollView.bounds.size.width * _currentImageIndex, 0);
}

- (void)setPaginationType:(PaginationType)paginationType{
    
    _paginationType = paginationType;
    
    if(_paginationType == PaginationTypeNumber){
        _pageControlPagination.hidden = YES;
        _numberPagination.hidden = NO;
    }else if(_paginationType == PaginationTypePageControl){
        _pageControlPagination.hidden = NO;
        _numberPagination.hidden = YES;
    }else{
        _pageControlPagination.hidden = NO;
        _numberPagination.hidden = YES;
    }
}


- (void)layoutSubviews{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(rectForPagination)]){
        self.pageControlPagination.frame = self.numberPagination.frame = [self.delegate rectForPagination];
    }
}


- (void)loadImageAtIndex:(NSInteger)index{
    
    if(index < 0 || index >= self.imagesCount){
        return;
    }
    
    UIImageView *ivImage = (UIImageView *)[self.imageViewArray objectAtIndex:index];
    if(self.placeholderImage){
        if([ivImage.image isEqual:self.placeholderImage]){
            CGRect frameImage = self.scrollView.bounds;
            frameImage.origin.x = frameImage.size.width * index;
            frameImage.origin.y = 0;
            
            ivImage.frame = frameImage;
            ivImage.image = [self.images objectAtIndex:index];
            
            [self.scrollView addSubview:ivImage];
        }
    }else{
        if(!ivImage.image){
            CGRect frameImage = self.scrollView.bounds;
            frameImage.origin.x = frameImage.size.width * index;
            frameImage.origin.y = 0;
            
            ivImage.frame = frameImage;
            ivImage.image = [self.images objectAtIndex:index];
            
            [self.scrollView addSubview:ivImage];
        }
    }
}

- (void)removeImageAtIndex:(NSInteger)index{
    
    if(index < 0 || index >= self.imagesCount){
        return;
    }

    UIImageView *ivImage = (UIImageView *)[self.imageViewArray objectAtIndex:index];
    if(self.placeholderImage){
        if(![ivImage.image isEqual:self.placeholderImage]){
            [ivImage removeFromSuperview];
            ivImage.image = self.placeholderImage;
        }
    }else{
        if(ivImage.image){
            [ivImage removeFromSuperview];
            ivImage.image = nil;
        }
    }
}

- (void)removeAllImages{
    for(NSInteger i=0; i<self.imagesCount; i++){
        [self removeImageAtIndex:i];
    }
}


- (void)loadImages{
    
    self.pageControlPagination.currentPage = self.currentImageIndex;
    self.numberPagination.text = [NSString stringWithFormat:@"%ld/%ld", self.currentImageIndex + 1, self.imagesCount];
    
    NSInteger previousImageIndex = self.currentImageIndex - 1;
    NSInteger nextImageIndex = self.currentImageIndex + 1;
    
    for(NSInteger i=0; i<previousImageIndex; i++){
        [self removeImageAtIndex:i];
    }
    
    for(NSInteger i=previousImageIndex; i<=nextImageIndex; i++){
        [self loadImageAtIndex:i];
    }
    
    for(NSInteger i=nextImageIndex+1; i<self.imagesCount; i++){
        [self removeImageAtIndex:i];
    }
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if(self.bDragging){
        _currentImageIndex = (NSInteger)floor((scrollView.contentOffset.x * 2 + scrollView.frame.size.width) / (scrollView.frame.size.width * 2));
        [self loadImages];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.bDragging = NO;
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.bDragging = YES;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *view = [super hitTest:point withEvent:event];
    if(view == self || view == self.paginationContainer){
        return self.scrollView;
    }
    
    return view;
}


@end
