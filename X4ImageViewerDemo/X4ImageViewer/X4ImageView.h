//
//  X4ImageView.h
//  X4ImageViewerDemo
//
//  Created by shengyuhong on 15/6/7.
//  Copyright (c) 2015年 Doit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface X4ImageView : UIView <UIScrollViewDelegate>


- (void)setImage:(UIImage *)image;
- (UIImage *)image;

@end
