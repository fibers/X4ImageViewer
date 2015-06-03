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
@property (nonatomic, strong) UIScrollView *scrollView;

@end


@implementation X4ImageViewer


- (instancetype)initWithFrame:(CGRect)frame images:(NSArray *)images{
    
    self = [super initWithFrame:frame];
    if(self){
        
        self.backgroundColor = [UIColor blackColor];
    
        _currentImageIndex = 0;
        _paginationType = PaginationTypePageControl;
        _bZoomEnabled = YES;
        
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
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTappedScrollView:)];
        [_scrollView addGestureRecognizer:tapGesture];
        
        UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDoubleTappedScrollView:)];
        doubleTapGesture.numberOfTapsRequired = 2;
        doubleTapGesture.numberOfTouchesRequired = 1;
        [_scrollView addGestureRecognizer:doubleTapGesture];

        
        CGRect rectPagination = CGRectMake(0, self.bounds.size.height - 20, self.bounds.size.width, 20);
        
        _pageControlPagination = [[SMPageControl alloc] initWithFrame:rectPagination];
        _pageControlPagination.currentPage = _currentImageIndex;
        _pageControlPagination.numberOfPages = [_images count];
        _pageControlPagination.hidesForSinglePage = YES;
        _pageControlPagination.defersCurrentPageDisplay = YES;
        _pageControlPagination.hidden = NO;
        [self addSubview:_pageControlPagination];
        
        _numberPagination = [[UILabel alloc] initWithFrame:rectPagination];
        _numberPagination.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        _numberPagination.layer.borderWidth = 0;
        _numberPagination.layer.masksToBounds = 1;
        _numberPagination.layer.cornerRadius = 10;
        _numberPagination.font = [UIFont systemFontOfSize:15];
        _numberPagination.textColor = [UIColor whiteColor];
        _numberPagination.textAlignment = NSTextAlignmentCenter;
        _numberPagination.text = [NSString stringWithFormat:@"%ld/%ld", _currentImageIndex + 1, [_images count]];
        _numberPagination.hidden = YES;
        [self addSubview:_numberPagination];
        
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
            scrollView.pagingEnabled = NO;
            scrollView.showsHorizontalScrollIndicator = scrollView.showsVerticalScrollIndicator = NO;
            scrollView.tag = i;
            
            CGFloat scaleWidth = (CGFloat)scrollView.bounds.size.width / scrollView.contentSize.width;
            CGFloat scaleHeight = (CGFloat)scrollView.bounds.size.height / scrollView.contentSize.height;
            CGFloat minScale = MIN(scaleWidth, scaleHeight);
        
            scrollView.minimumZoomScale = minScale;
            if(_bZoomEnabled){
                scrollView.maximumZoomScale = 1;
            }else{
                scrollView.maximumZoomScale = minScale;
            }
            
            
            [_innerScrollViews addObject:scrollView];
            scrollView.zoomScale = scrollView.minimumZoomScale;

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

- (void)setCurrentImageIndex:(NSInteger)currentImageIndex{
    _currentImageIndex = currentImageIndex;
    self.scrollView.contentOffset = CGPointMake(self.scrollView.bounds.size.width * self.currentImageIndex, 0);
}

- (void)setBZoomEnabled:(BOOL)bZoomEnabled{
    _bZoomEnabled = bZoomEnabled;
    for(UIScrollView *scrollView in self.innerScrollViews){
        if(self.bZoomEnabled){
            scrollView.maximumZoomScale = 1;
        }else{
            scrollView.maximumZoomScale = scrollView.minimumZoomScale;
        }
    }
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
    }
}

- (void)restoreImageAtIndex:(NSInteger)index{
    
    if(index < 0 || index >= [self.images count]){
        return;
    }
    
    UIScrollView *scrollView = (UIScrollView *)[self.innerScrollViews objectAtIndex:index];
    UIImageView *ivImage = (UIImageView *)[self.imageViews objectAtIndex:index];
    
    if(ivImage.image){
        
        scrollView.zoomScale = self.scrollView.minimumZoomScale;
    }
}


- (void)removeImageAtIndex:(NSInteger)index{
    
    if(index < 0 || index >= [self.images count]){
        return;
    }

    UIScrollView *scrollView = (UIScrollView *)[self.innerScrollViews objectAtIndex:index];
    UIImageView *ivImage = (UIImageView *)[self.imageViews objectAtIndex:index];
    
    if(ivImage.image){
        
        ivImage.image = nil;
        [scrollView removeFromSuperview];
    }
}

- (void)removeAllImages{
    for(NSInteger i=0; i<[self.images count]; i++){
        [self removeImageAtIndex:i];
    }
}


- (void)loadImages{
    
    self.pageControlPagination.currentPage = self.currentImageIndex;
    NSString *text = [NSString stringWithFormat:@"%ld/%ld", self.currentImageIndex + 1, [self.images count]];
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX,self.numberPagination.bounds.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]} context:nil];
    
    self.numberPagination.text = text;
    CGRect frame = self.numberPagination.frame;
    frame.size.width = rect.size.width + 24;
    
    self.numberPagination.frame = frame;
    
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


- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    if(scrollView.tag >= 0){
        [self moveImageToCenter:scrollView.tag];
        if(scrollView.minimumZoomScale == scrollView.zoomScale){
            scrollView.scrollEnabled = NO;
        }else{
            scrollView.scrollEnabled = YES;
        }
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
    
    if(view == self || view == self.pageControlPagination || view == self.numberPagination){
        return self.scrollView;
    }

    return view;
}

- (void)onTappedScrollView:(UITapGestureRecognizer *)gesture{
    if(self.delegate && [self.delegate respondsToSelector:@selector(didTapped:withImageView:atIndex:inScrollView:)]){
        
        UIImageView *imageView = (UIImageView *)[self.imageViews objectAtIndex:self.currentImageIndex];
        UIScrollView *scrollView = (UIScrollView *)[self.innerScrollViews objectAtIndex:self.currentImageIndex];
        
        [self.delegate didTapped:self withImageView:imageView atIndex:self.currentImageIndex inScrollView:scrollView];
    }
}

- (void)onDoubleTappedScrollView:(UITapGestureRecognizer *)gesture{
    
    UIImageView *imageView = (UIImageView *)[self.imageViews objectAtIndex:self.currentImageIndex];
    UIScrollView *scrollView = (UIScrollView *)[self.innerScrollViews objectAtIndex:self.currentImageIndex];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(didDoubleTapped:withImageView:atIndex:inScrollView:)]){
        
        [self.delegate didDoubleTapped:self withImageView:imageView atIndex:self.currentImageIndex inScrollView:scrollView];
    }else{
        if(scrollView.zoomScale == scrollView.minimumZoomScale){
            scrollView.zoomScale = scrollView.maximumZoomScale;
        }else{
            scrollView.zoomScale = scrollView.minimumZoomScale;
        }
    }
}


- (void)moveImageToCenter:(NSInteger)index{
    
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
