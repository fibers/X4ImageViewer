//
//  X4ImageViewer.h
//  Pinnacle
//
//  Created by shengyuhong on 15/4/21.
//  Copyright (c) 2015年 The Third Rock Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PaginationType){
    PaginationTypePageControl = 0,
    PaginationTypeNumber
};


@protocol X4ImageViewerDelegate <NSObject>

- (CGRect)rectForPagination;

@end

@interface X4ImageViewer : UIView <UIScrollViewDelegate>

@property (nonatomic, assign) NSInteger currentImageIndex;
@property (nonatomic, assign) PaginationType paginationType;
@property (nonatomic, assign) id<X4ImageViewerDelegate> delegate;
@property (nonatomic, strong) UIImage *placeholderImage;

- (instancetype)initWithFrame:(CGRect)frame images:(NSArray *)images imagePosition:(CGRect)imagePosition withPlaceholder:(UIImage *)placeholderImage;
- (instancetype)initWithFrame:(CGRect)frame images:(NSArray *)images imagePosition:(CGRect)imagePosition;
- (instancetype)initWithFrame:(CGRect)frame images:(NSArray *)images;
- (void)loadImages;

@end
