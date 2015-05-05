//
//  X4ImageViewer.h
//  Pinnacle
//
//  Created by shengyuhong on 15/4/21.
//  Copyright (c) 2015年 The Third Rock Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol X4ImageViewerDelegate <NSObject>


@end

@interface X4ImageViewer : UIView <UIScrollViewDelegate>

@property (nonatomic, assign) NSInteger currentImageIndex;
@property (nonatomic, strong) UIImage *defaultImage;
@property (nonatomic, assign) CGRect rectZoomIn;

- (instancetype)initWithFrame:(CGRect)frame images:(NSArray *)imageArray;
- (void)loadImages;

@end
