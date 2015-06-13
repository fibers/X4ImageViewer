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

typedef NS_ENUM(NSInteger, ContentMode){
    ContentModeAspectNormal = 0, // Images larger than the view will be treated as ContentModeAspectFit, and images smaller than the view will be show as the normal size.
    ContentModeAspectFit,        // The same as UIViewContentModeScaleAspectFit, no matter the image is larger or smaller than the view
    ContentModeAspectFill,       // The same as UIViewContentModeScaleAspectFill, no matter the image is larger or smaller than the view

};

@class X4ImageViewer;
@protocol X4ImageViewerDelegate <NSObject>

@optional
- (void)imageViewer:(X4ImageViewer *)imageViewer didSingleTap:(UIImageView *)imageView atIndex:(NSInteger)index inScrollView:(UIScrollView *)scrollView;
- (void)imageViewer:(X4ImageViewer *)imageViewer didDoubleTap:(UIImageView *)imageView atIndex:(NSInteger)index
 inScrollView:(UIScrollView *)scrollView;
- (void)imageViewer:(X4ImageViewer *)imageViewer didSlideFrom:(UIImageView *)fromImageView fromIndex:(NSInteger)fromIndex to:(UIImageView *)toImageView toIndex:(NSInteger)toIndex;
- (void)imageViewer:(X4ImageViewer *)imageViewer didEndZoomingWith:(UIImageView *)imageView atIndex:(NSInteger)index inScrollView:(UIScrollView *)scrollView;;

- (void)imageViewer:(X4ImageViewer *)imageViewer loadingInProcess:(UIImageView *)imageView withProcess:(CGFloat)process atIndex:(NSInteger)index;
- (void)imageViewer:(X4ImageViewer *)imageViewer loadingSuccess:(UIImageView *)imageView withImage:(UIImage *)image atIndex:(NSInteger)index;
- (void)imageViewer:(X4ImageViewer *)imageViewer loadingFailed:(UIImageView *)imageView withError:(NSError *)error atIndex:(NSInteger)index;

@end


@interface X4ImageViewer : UIView <UIScrollViewDelegate>


@property (nonatomic, assign) BOOL bZoomEnable;
@property (nonatomic, assign) BOOL bZoomRestoreAfterDimissed;
@property (nonatomic, assign) NSInteger currentPageIndex;
@property (nonatomic, assign) ContentMode contentMode;
@property (nonatomic, assign) CarouselType carouselType;
@property (nonatomic, assign) id<X4ImageViewerDelegate> delegate;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame;

- (void)setImages:(NSArray *)images withPlaceholder:(UIImage *)image;
- (void)setPageControlIndicatorImage:(UIImage *)indicatorImage;
- (void)setPageControlCurrentIndicatorImage:(UIImage *)currentIndicatorImage;

- (void)setCarouselCenter:(CGPoint)center;


@end
