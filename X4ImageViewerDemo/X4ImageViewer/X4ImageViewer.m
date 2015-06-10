//
//  X4ImageViewer.m
//  Pinnacle
//
//  Created by shengyuhong on 15/4/21.
//  Copyright (c) 2015年 The Third Rock Ltd. All rights reserved.
//

#import "X4ImageViewer.h"
#import <UIImageView+WebCache.h>
#import "UIImage+SolidColor.h"
#import <SVProgressHUD.h>

static const CGFloat HeightCarousel = 24;

@interface X4ImageViewer ()

@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) NSMutableArray *imageViews;
@property (nonatomic, strong) NSMutableArray *innerScrollViews;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) SMPageControl *pageControl;
@property (nonatomic, strong) UILabel *pageNumber;

@property (nonatomic, assign) CGFloat carouselXRatio;
@property (nonatomic, assign) CGFloat carouselYRatio;

@property (nonatomic, strong) UIImage *defaultImage;

@end


@implementation X4ImageViewer


- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if(self){
        
        self.backgroundColor = [UIColor blackColor];
    
        _currentPageIndex = 0;
        _carouselType = CarouselTypePageControl;
        _bZoomEnable = YES;
        _bZoomRestoreAfterDimissed = YES;
        _defaultImage = [UIImage imageWithSolidColor:[UIColor blackColor]];
        
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.scrollEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.showsHorizontalScrollIndicator = _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.tag = -1;
        [self addSubview:_scrollView];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTappedScrollView:)];
        tapGesture.numberOfTapsRequired = 1;
        [_scrollView addGestureRecognizer:tapGesture];
        
        UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDoubleTappedScrollView:)];
        doubleTapGesture.numberOfTapsRequired = 2;
        [_scrollView addGestureRecognizer:doubleTapGesture];

        [tapGesture requireGestureRecognizerToFail:doubleTapGesture];
        
        CGRect rectPagination = CGRectMake(0, self.bounds.size.height - HeightCarousel, self.bounds.size.width, HeightCarousel);
        
        _carouselXRatio = (rectPagination.origin.x + rectPagination.size.width / 2) / self.bounds.size.width;
        _carouselYRatio = (rectPagination.origin.y + rectPagination.size.height / 2) / self.bounds.size.height;
        
        _pageControl = [[SMPageControl alloc] initWithFrame:rectPagination];
        _pageControl.currentPage = _currentPageIndex;
        _pageControl.hidesForSinglePage = YES;
        _pageControl.defersCurrentPageDisplay = YES;
        _pageControl.hidden = NO;
        [self addSubview:_pageControl];
        
        _pageNumber = [[UILabel alloc] initWithFrame:rectPagination];
        _pageNumber.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        _pageNumber.layer.borderWidth = 0;
        _pageNumber.layer.masksToBounds = YES;
        _pageNumber.layer.cornerRadius = 12;
        _pageNumber.font = [UIFont systemFontOfSize:15];
        _pageNumber.textColor = [UIColor whiteColor];
        _pageNumber.textAlignment = NSTextAlignmentCenter;
        _pageNumber.hidden = YES;
        [self addSubview:_pageNumber];
        
        _images = [NSMutableArray array];
        _imageViews = [NSMutableArray array];
        _innerScrollViews = [NSMutableArray array];
        
        return self;
    }
    return nil;
}

- (void)layoutSubviews{
    
    _currentPageIndex = self.currentPageIndex < [self.images count] ? self.currentPageIndex : 0;
    
    self.scrollView.frame = self.bounds;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width * [self.images count], self.scrollView.bounds.size.height);
    self.scrollView.contentOffset = CGPointMake(self.currentPageIndex * self.scrollView.bounds.size.width, 0);
    
    CGPoint carouselCenter = CGPointMake(self.bounds.size.width * self.carouselXRatio, self.bounds.size.height * self.carouselYRatio);
    CGRect boundsPageControl = self.pageControl.bounds;
    boundsPageControl.size.width = self.bounds.size.width;
    self.pageControl.bounds = boundsPageControl;
    CGPoint centerPageControl = self.pageControl.center;
    centerPageControl.y = self.carouselCenter.y;
    self.pageControl.center = centerPageControl;
    
    self.pageNumber.center = carouselCenter;
    
    for(NSUInteger i=0; i<[self.images count]; i++){
        
        UIImage *image = (UIImage *)[self.images objectAtIndex:i];
        UIImageView *imageView = (UIImageView *)[self.imageViews objectAtIndex:i];
        UIScrollView *scrollView = (UIScrollView *)[self.innerScrollViews objectAtIndex:i];

        imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        imageView.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
        imageView.transform = CGAffineTransformIdentity;
        
        scrollView.frame = CGRectMake(i * self.scrollView.bounds.size.width, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
        scrollView.contentSize = imageView.bounds.size;
        
        CGFloat scaleWidth = (CGFloat)scrollView.bounds.size.width / imageView.bounds.size.width;
        CGFloat scaleHeight = (CGFloat)scrollView.bounds.size.height / imageView.bounds.size.height;
        CGFloat minScale = MIN(scaleWidth, scaleHeight);
        CGFloat maxScale = MAX(scaleWidth, scaleHeight);
        
        if(minScale >= 1){
            
            scrollView.minimumZoomScale = 1;
            if(self.bZoomEnable){
                scrollView.maximumZoomScale = maxScale;
            }else{
                scrollView.maximumZoomScale = 1;
            }
            
        }else{
            scrollView.minimumZoomScale = minScale;
            if(self.bZoomEnable){
                scrollView.maximumZoomScale = 1;
            }else{
                scrollView.maximumZoomScale = minScale;
            }
        }
        
        scrollView.zoomScale = scrollView.minimumZoomScale;
        
        [self move:imageView toCenterOf:scrollView];
    }
    
    [self loadImages];

}

- (void)setImages:(NSArray *)images withPlaceholder:(UIImage *)placeholderImage{

    [self removeAllImages];
    
    [self.images removeAllObjects];
    [self.imageViews removeAllObjects];
    [self.innerScrollViews removeAllObjects];
    
    self.pageControl.numberOfPages = [images count];
    
    for(NSUInteger i=0; i<[images count]; i++){
        
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.delegate = self;
        scrollView.pagingEnabled = NO;
        scrollView.showsHorizontalScrollIndicator = scrollView.showsVerticalScrollIndicator = NO;
        scrollView.tag = i;
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [scrollView addSubview:imageView];

        NSObject *object = [images objectAtIndex:i];
        
        if([object isKindOfClass:[UIImage class]]){
            
            UIImage *image = (UIImage *)object;
            [self.images insertObject:image atIndex:i];
            
        }else if([object isKindOfClass:[NSURL class]]){
            
            NSURL *url = (NSURL *)object;
            if(placeholderImage){
                [self.images insertObject:placeholderImage atIndex:i];
            }else{
                [self.images insertObject:self.defaultImage atIndex:i];
            }
            
            [[SDWebImageManager sharedManager] downloadImageWithURL:url options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
                [SVProgressHUD show];
                
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                [SVProgressHUD dismiss];
                
                [self.images replaceObjectAtIndex:i withObject:image];
                imageView.image = image;
                [self setNeedsLayout];
            }];
        
        }else {
            NSAssert(NO, @"Unsupport type of images! Only `NSURL` or `UIImage` will be accepted.");
        }
        
        [self.imageViews addObject:imageView];
        [self.innerScrollViews addObject:scrollView];
        
    }
    
    [self setNeedsLayout];
}


- (void)setCarouselType:(CarouselType)carouselType{
    
    _carouselType = carouselType;
    
    switch (self.carouselType) {
        case CarouselTypePageControl:
            self.pageControl.hidden = NO;
            self.pageNumber.hidden = YES;
            break;
        case CarouselTypePageNumber:
            self.pageControl.hidden = YES;
            self.pageNumber.hidden = NO;
            break;
        case CarouselTypePageNone:
            self.pageControl.hidden = YES;
            self.pageNumber.hidden = YES;
            break;
        default:
            break;
    }
}

- (void)setCarouselCenter:(CGPoint)carouselCenter{
    
    _carouselCenter = carouselCenter;
    
    self.carouselXRatio = self.carouselCenter.x / self.bounds.size.width;
    self.carouselYRatio = self.carouselCenter.y / self.bounds.size.height;

    [self setNeedsLayout];
}

- (void)setCurrentPageIndex:(NSInteger)currentPageIndex{
    _currentPageIndex = currentPageIndex;
    
    [self setNeedsLayout];
}

- (void)setBZoomEnable:(BOOL)bZoomEnable{
    _bZoomEnable = bZoomEnable;
 
    [self setNeedsLayout];
}


- (void)setPageControlIndicatorImage:(UIImage *)indicatorImage{
    self.pageControl.pageIndicatorImage = indicatorImage;
}

- (void)setPageControlCurrentIndicatorImage:(UIImage *)currentIndicatorImage{
    self.pageControl.currentPageIndicatorImage = currentIndicatorImage;
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
        scrollView.zoomScale = scrollView.minimumZoomScale;
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
    
    self.pageControl.currentPage = self.currentPageIndex;
    
    NSString *text = [NSString stringWithFormat:@"%ld/%ld", self.currentPageIndex + 1, [self.images count]];
    CGRect rect = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, self.pageNumber.bounds.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]} context:nil];
    
    self.pageNumber.text = text;
    
    CGRect boundsPageNumber = self.pageNumber.bounds;
    boundsPageNumber.size.width = rect.size.width + 24;
    self.pageNumber.bounds = boundsPageNumber;
    
    NSInteger previousImageIndex = self.currentPageIndex - 1;
    NSInteger nextImageIndex = self.currentPageIndex + 1;
    
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
    
    if(scrollView.tag == -1 && scrollView.isDragging ){
        
        NSInteger newImageIndex = (NSInteger)floor((scrollView.contentOffset.x * 2 + scrollView.frame.size.width) / (scrollView.frame.size.width * 2));
        
        if(newImageIndex != self.currentPageIndex){
            if(self.delegate && [self.delegate respondsToSelector:@selector(imageViewer:didImageSwitchFrom:to:)]){
                [self.delegate imageViewer:self didImageSwitchFrom:self.currentPageIndex to:newImageIndex];
            }
        }
        _currentPageIndex = newImageIndex;
        [self loadImages];
    }
}


- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    if(scrollView.tag >= 0){
    
        UIImageView *imageView = (UIImageView *)[self.imageViews objectAtIndex:scrollView.tag];
        
        [self move:imageView toCenterOf:scrollView];
        
        if(scrollView.minimumZoomScale == scrollView.zoomScale){
            scrollView.scrollEnabled = NO;
        }else{
            scrollView.scrollEnabled = YES;
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if(self.bZoomRestoreAfterDimissed){
        NSInteger previousImageIndex = self.currentPageIndex - 1;
        [self restoreImageAtIndex:previousImageIndex];
        
        NSInteger nextImageIndex = self.currentPageIndex + 1;
        [self restoreImageAtIndex:nextImageIndex];
    }

}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(imageViewer:didEndZoomingWith:atIndex:inScrollView:)]){
        
        UIScrollView *scrollView = (UIScrollView *)[self.innerScrollViews objectAtIndex:self.currentPageIndex];
        UIImageView *imageView = (UIImageView *)view;
        
        [self.delegate imageViewer:self didEndZoomingWith:imageView atIndex:self.currentPageIndex inScrollView:scrollView];
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
    
    if(view == self || view == self.pageControl || view == self.pageNumber){
        return self.scrollView;
    }

    return view;
}

- (void)onTappedScrollView:(UITapGestureRecognizer *)gesture{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(imageViewer:didTap:atIndex:inScrollView:)]){
        
        UIImageView *imageView = (UIImageView *)[self.imageViews objectAtIndex:self.currentPageIndex];
        UIScrollView *scrollView = (UIScrollView *)[self.innerScrollViews objectAtIndex:self.currentPageIndex];
        
        [self.delegate imageViewer:self didTap:imageView atIndex:self.currentPageIndex inScrollView:scrollView];
    }
}

- (void)onDoubleTappedScrollView:(UITapGestureRecognizer *)gesture{
    
    UIImageView *imageView = (UIImageView *)[self.imageViews objectAtIndex:self.currentPageIndex];
    UIScrollView *scrollView = (UIScrollView *)[self.innerScrollViews objectAtIndex:self.currentPageIndex];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(imageViewer:didDoubleTap:atIndex:inScrollView:)]){
        
        [self.delegate imageViewer:self didDoubleTap:imageView atIndex:self.currentPageIndex inScrollView:scrollView];
    }else{
        if(scrollView.zoomScale == scrollView.minimumZoomScale){
            scrollView.zoomScale = scrollView.maximumZoomScale;
        }else{
            scrollView.zoomScale = scrollView.minimumZoomScale;
        }
    }
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
