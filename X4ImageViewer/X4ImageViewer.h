//
//  X4ImageViewer.h
//  Pinnacle
//
//  Created by shengyuhong on 15/4/21.
//  Copyright (c) 2015年 The Third Rock Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SMPageControl.h>

typedef NS_ENUM(NSInteger, CarouselType){
    CarouselTypePageControl = 0,
    CarouselTypePageNumber,
    CarouselTypePageNone
};

// Only `CarouselPositionBottomCenter` and `CarouselPositionTopCenter` will be availablle when the carouselType is `CarouselTypePageControl`
typedef NS_ENUM(NSInteger, CarouselPosition){
    CarouselPositionBottomCenter = 0,
    CarouselPositionBottomLeft,
    CarouselPositionBottomRight,
    CarouselPositionTopCenter,
    CarouselPositionTopLeft,
    CarouselPositionTopRight,
};


typedef NS_ENUM(NSInteger, ContentMode){
    /* 
     Images larger than the container will be treated as ContentModeAspectFit,
    and images smaller than the container will be showed in its original size. 
     */
    ContentModeAspectNormal = 0,
    /* 
     The same as UIViewContentModeScaleAspectFit, no matter the image is larger or smaller than the view
    */
    ContentModeAspectFit,
    /*
     The same as UIViewContentModeScaleAspectFill, no matter the image is larger or smaller than the view
     */
    ContentModeAspectFill

};


@class X4ImageViewer;
@protocol X4ImageViewerDataSource <NSObject>

@optional
- (NSArray *)imageViewer:(X4ImageViewer *)imageViewer supplementaryViewsFor:(UIImageView *)imageView atIndex:(NSInteger)index;


@end

@protocol X4ImageViewerDelegate <NSObject>

@optional
- (void)imageViewer:(X4ImageViewer *)imageViewer didSingleTap:(UIImageView *)imageView atIndex:(NSInteger)index inScrollView:(UIScrollView *)scrollView;
- (void)imageViewer:(X4ImageViewer *)imageViewer didDoubleTap:(UIImageView *)imageView atIndex:(NSInteger)index
 inScrollView:(UIScrollView *)scrollView;
- (void)imageViewer:(X4ImageViewer *)imageViewer didSlideFrom:(UIImageView *)fromImageView fromIndex:(NSInteger)fromIndex to:(UIImageView *)toImageView toIndex:(NSInteger)toIndex;
- (void)imageViewer:(X4ImageViewer *)imageViewer didEndZoomingWith:(UIImageView *)imageView atIndex:(NSInteger)index inScrollView:(UIScrollView *)scrollView;

- (void)imageViewer:(X4ImageViewer *)imageViewer loadingInProcess:(UIImageView *)imageView withProcess:(CGFloat)process atIndex:(NSInteger)index;
- (void)imageViewer:(X4ImageViewer *)imageViewer loadingSuccess:(UIImageView *)imageView withImage:(UIImage *)image atIndex:(NSInteger)index;
- (void)imageViewer:(X4ImageViewer *)imageViewer loadingFailed:(UIImageView *)imageView withError:(NSError *)error atIndex:(NSInteger)index;

@end


@interface X4ImageViewer : UIView <UIScrollViewDelegate>

@property (nonatomic, assign) BOOL bZoomEnable;
@property (nonatomic, assign) BOOL bZoomRestoreAfterDimissed;
@property (nonatomic, assign) CarouselPosition carouselPosition;
@property (nonatomic, assign) CarouselType carouselType;
@property (nonatomic, assign) ContentMode contentMode;
@property (nonatomic, assign) NSInteger currentPageIndex;
@property (nonatomic, weak) id<X4ImageViewerDelegate> delegate;
@property (nonatomic, weak) id<X4ImageViewerDataSource> dataSource;

- (NSArray *)currentLoadedImages;
- (NSArray *)imageDataSources;
- (UIImageView *)currentImageView;
- (UIScrollView *)currentScrollView;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame;

- (void)setImages:(NSArray *)images withPlaceholder:(UIImage *)placeholderImage;
- (void)setImages:(NSArray *)images withPlaceholders:(NSArray *)placeholderImages;
- (void)setPageControlCurrentIndicatorImage:(UIImage *)currentIndicatorImage;
- (void)setPageControlIndicatorImage:(UIImage *)indicatorImage;

@end
