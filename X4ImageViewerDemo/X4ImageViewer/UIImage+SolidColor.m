//
//  UIImage+SolidColor.m
//  X4ImageViewerDemo
//
//  Created by shengyuhong on 15/6/10.
//  Copyright (c) 2015年 Doit. All rights reserved.
//

#import "UIImage+SolidColor.h"

@implementation UIImage (SolidColor)

+ (UIImage *)imageWithSolidColor:(UIColor *)color{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


@end
