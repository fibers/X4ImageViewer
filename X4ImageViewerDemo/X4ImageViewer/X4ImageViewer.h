//
//  X4ImageViewer.h
//  Pinnacle
//
//  Created by shengyuhong on 15/4/21.
//  Copyright (c) 2015年 The Third Rock Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SMPageControl.h>

typedef NS_ENUM(NSInteger, PaginationType){
    PaginationTypePageControl = 0,
    PaginationTypeNumber
};

@class X4ImageViewer;
@protocol X4ImageViewerDelegate <NSObject>

@optional
- (void)imageViewer:(X4ImageViewer *)imageViewer didTap:(UIImageView *)imageView atIndex:(NSInteger)index inScrollView:(UIScrollView *)scrollView;
- (void)imageViewer:(X4ImageViewer *)imageViewer didDoubleTap:(UIImageView *)imageView atIndex:(NSInteger)index inScrollView:(UIScrollView *)scrollView;
- (void)imageViewer:(X4ImageViewer *)imageViewer didImageSwitchFrom:(NSInteger)oldIndex to:(NSInteger)newIndex;
- (void)imageViewer:(X4ImageViewer *)imageViewer didEndZoomingWith:(UIImageView *)imageView atIndex:(NSInteger)index inScrollView:(UIScrollView *)scrollView;

@end


@interface X4ImageViewer : UIView <UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, assign) NSInteger currentImageIndex;
@property (nonatomic, assign) PaginationType paginationType;
@property (nonatomic, assign) id<X4ImageViewerDelegate> delegate;
@property (nonatomic, strong) SMPageControl *pageControlPagination;
@property (nonatomic, strong) UILabel *numberPagination;
@property (nonatomic, assign) BOOL bZoomEnabled;

- (instancetype)initWithFrame:(CGRect)frame images:(NSArray *)images;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;


@end
