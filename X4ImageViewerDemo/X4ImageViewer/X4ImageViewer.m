//
//  X4ImageViewer.m
//  Pinnacle
//
//  Created by shengyuhong on 15/4/21.
//  Copyright (c) 2015年 The Third Rock Ltd. All rights reserved.
//

#import "X4ImageViewer.h"

@interface X4ImageViewer ()

@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSMutableArray *imageViews;
@property (nonatomic, strong) NSMutableArray *innerScrollViews;
@property (nonatomic, strong) UILabel *numberPagination;
@property (nonatomic, strong) UIPageControl *pageControlPagination;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *paginationContainer;

@end


@implementation X4ImageViewer


- (instancetype)initWithFrame:(CGRect)frame images:(NSArray *)images{
    self = [super initWithFrame:frame];
    if(self){
        
        self.backgroundColor = [UIColor blackColor];
    
        _currentImageIndex = 0;
        _paginationType = PaginationTypePageControl;
        
        _images = images;
        
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.delegate = self;
        _scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width * [_images count], _scrollView.bounds.size.height);
        _scrollView.pagingEnabled = YES;
        _scrollView.scrollEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.showsHorizontalScrollIndicator = _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.tag = -1;
        [self addSubview:_scrollView];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapScrollView:)];
        [_scrollView addGestureRecognizer:tapGesture];
        
        CGFloat wPaginationContainer = self.bounds.size.width;
        CGFloat hPaginationContainer = 40;
        CGFloat xPaginationContainer = 0;
        CGFloat yPaginationContainer = self.bounds.size.height - hPaginationContainer;
        CGRect rectPaginationContainer = CGRectMake(xPaginationContainer, yPaginationContainer, wPaginationContainer, hPaginationContainer);
        _paginationContainer = [[UIView alloc] initWithFrame:rectPaginationContainer];
        _paginationContainer.backgroundColor = [UIColor clearColor];
        [self addSubview:_paginationContainer];
        
        CGRect rectPageControlPagination = CGRectMake(0, 0, wPaginationContainer, hPaginationContainer);
        _pageControlPagination = [[UIPageControl alloc] initWithFrame:rectPageControlPagination];
        _pageControlPagination.currentPage = _currentImageIndex;
        _pageControlPagination.numberOfPages = [_images count];
        _pageControlPagination.hidesForSinglePage = YES;
        _pageControlPagination.defersCurrentPageDisplay = YES;
        _pageControlPagination.hidden = NO;
        _pageControlPagination.userInteractionEnabled = NO;
        [_paginationContainer addSubview:_pageControlPagination];
        
        _numberPagination = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 42, 24)];
        _numberPagination.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        _numberPagination.layer.borderWidth = 0;
        _numberPagination.layer.masksToBounds = 1;
        _numberPagination.layer.cornerRadius = 12;
        _numberPagination.font = [UIFont systemFontOfSize:15];
        _numberPagination.textColor = [UIColor whiteColor];
        _numberPagination.textAlignment = NSTextAlignmentCenter;
        _numberPagination.text = [NSString stringWithFormat:@"%ld/%ld", _currentImageIndex + 1, [_images count]];
        _numberPagination.hidden = YES;
        _numberPagination.userInteractionEnabled = NO;
        [_paginationContainer addSubview:_numberPagination];
        
        _imageViews = [[NSMutableArray alloc] init];
        _innerScrollViews = [[NSMutableArray alloc] init];
        
        for(NSUInteger i=0; i<[images count]; i++){
            UIImage *image = [images objectAtIndex:i];
            
            CGRect rectInnerScrollView = _scrollView.bounds;
            rectInnerScrollView.origin.x = i * _scrollView.bounds.size.width;
            rectInnerScrollView.origin.y = 0;
            
            UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:rectInnerScrollView];
            
            UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,image.size.width,image.size.height)];
            iv.contentMode = UIViewContentModeScaleAspectFit;
            
            [scrollView addSubview:iv];
            [_imageViews addObject:iv];
            
            scrollView.delegate = self;
            scrollView.contentSize = image.size;
            
            CGFloat scaleWidth = (CGFloat)scrollView.bounds.size.width / scrollView.contentSize.width;
            CGFloat scaleHeight = (CGFloat)scrollView.bounds.size.height / scrollView.contentSize.height;
            CGFloat minScale = MIN(scaleWidth, scaleHeight);
            
            scrollView.minimumZoomScale = minScale;
            scrollView.maximumZoomScale = 1;
            scrollView.tag = i;
            
            [_innerScrollViews addObject:scrollView];
            
        }

        
        [self loadImages];

        return self;
    }
    return nil;
}


- (void)setPaginationType:(PaginationType)paginationType{
    
    _paginationType = paginationType;
    
    if(self.paginationType == PaginationTypeNumber){
        self.pageControlPagination.hidden = YES;
        self.numberPagination.hidden = NO;
    }else if(self.paginationType == PaginationTypePageControl){
        self.pageControlPagination.hidden = NO;
        self.numberPagination.hidden = YES;
    }else{
        self.pageControlPagination.hidden = NO;
        self.numberPagination.hidden = YES;
    }
    
}

- (void)setCurrentImageIndex:(NSUInteger)currentImageIndex{
    _currentImageIndex = currentImageIndex;
    self.scrollView.contentOffset = CGPointMake(self.scrollView.bounds.size.width * self.currentImageIndex, 0);
}



- (void)loadImageAtIndex:(NSInteger)index{
    
    if(index < 0 || index >= [self.images count]){
        return;
    }
    
    UIScrollView *scrollView = (UIScrollView *)[self.innerScrollViews objectAtIndex:index];
    UIImageView *ivImage = (UIImageView *)[self.imageViews objectAtIndex:index];
    
    if(!ivImage.image){

        ivImage.image = (UIImage *)[self.images objectAtIndex:index];
        [self.scrollView addSubview:scrollView];
        
        scrollView.zoomScale = scrollView.minimumZoomScale;
        [self moveImageToCenter:index];
    }
}

- (void)restoreImageAtIndex:(NSInteger)index{
    
    if(index < 0 || index >= [self.images count]){
        return;
    }

    UIScrollView *scrollView = (UIScrollView *)[self.innerScrollViews objectAtIndex:index];
    UIImageView *ivImage = (UIImageView *)[self.imageViews objectAtIndex:index];
    
    if(ivImage.image){
        scrollView.zoomScale = scrollView.minimumZoomScale;
        [self moveImageToCenter:index];
    }
    
}

- (void)removeImageAtIndex:(NSInteger)index{
    
    if(index < 0 || index >= [self.images count]){
        return;
    }

    UIScrollView *scrollView = (UIScrollView *)[self.innerScrollViews objectAtIndex:index];
    UIImageView *ivImage = (UIImageView *)[self.imageViews objectAtIndex:index];
    
    if(ivImage.image){
        [scrollView removeFromSuperview];
        ivImage.image = nil;
    }
}

- (void)removeAllImages{
    for(NSInteger i=0; i<[self.images count]; i++){
        [self removeImageAtIndex:i];
    }
}


- (void)loadImages{
    
    self.pageControlPagination.currentPage = self.currentImageIndex;
    self.numberPagination.text = [NSString stringWithFormat:@"%ld/%ld", self.currentImageIndex + 1, [self.images count]];
    
    NSInteger previousImageIndex = self.currentImageIndex - 1;
    NSInteger nextImageIndex = self.currentImageIndex + 1;
    
    for(NSInteger i=0; i<previousImageIndex; i++){
        [self removeImageAtIndex:i];
    }
    
    for(NSInteger i=previousImageIndex; i<=nextImageIndex; i++){
        [self loadImageAtIndex:i];
    }
    
    for(NSInteger i=nextImageIndex+1; i<[self.images count]; i++){
        [self removeImageAtIndex:i];
    }
}



#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    if(scrollView.tag == -1){
        _currentImageIndex = (NSInteger)floor((scrollView.contentOffset.x * 2 + scrollView.frame.size.width) / (scrollView.frame.size.width * 2));
        [self loadImages];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSInteger previousImageIndex = self.currentImageIndex - 1;
    NSInteger nextImageIndex = self.currentImageIndex + 1;
    
    [self restoreImageAtIndex:previousImageIndex];
    [self restoreImageAtIndex:nextImageIndex];
}



- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    if(scrollView.tag >= 0){
        [self moveImageToCenter:scrollView.tag];
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    if(scrollView.tag >= 0){
        return [self.imageViews objectAtIndex:scrollView.tag];
    }else{
        return nil;
    }
}



- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *view = [super hitTest:point withEvent:event];
    if(view == self || view == self.paginationContainer){
        return self.scrollView;
    }
    
    return view;
}

- (void)onTapScrollView:(UITapGestureRecognizer *)gesture{
    if(self.delegate && [self.delegate respondsToSelector:@selector(didTappedImageWithIndex:)]){
        [self.delegate didTappedImageWithIndex:self.currentImageIndex];
    }
}

- (void)moveImageToCenter:(NSUInteger)index{
    
    UIScrollView *scrollView = (UIScrollView *)[self.innerScrollViews objectAtIndex:index];
    UIImageView *ivImage = (UIImageView *)[self.imageViews objectAtIndex:index];
    
    CGSize scrollViewSize = scrollView.bounds.size;
    CGRect imageFrame = ivImage.frame;
    
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
    
    ivImage.frame = imageFrame;
}


@end
