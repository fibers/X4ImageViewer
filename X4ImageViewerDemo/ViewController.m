//
//  ViewController.m
//  X4ImageViewer
//
//  Created by shengyuhong on 15/4/21.
//  Copyright (c) 2015年 Doit. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "UIImageView+ClickToFullScreen.h"
#import "UIImage+SolidColor.h"


@interface ViewController ()

@property (weak, nonatomic) IBOutlet X4ImageViewer *imageViewer;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSArray *imageArray = @[
                            [UIImage imageNamed:@"1.jpg"],
                            [UIImage imageNamed:@"2.jpg"],
                            [UIImage imageNamed:@"4.jpg"],
                            [UIImage imageNamed:@"5.jpg"],
                            [UIImage imageNamed:@"6.jpg"]
                            ];
    
    NSArray *urlArray = @[
                           
                            [NSURL URLWithString:@"http://res.cloudinary.com/ddbtyv5bo/image/upload/v1400134498/msdhd8906lz5uxbx3oy7.jpg"],
                            [NSURL URLWithString:@"http://res.cloudinary.com/ddbtyv5bo/image/upload/v1400134672/uputh2onyan9ntui6cwj.jpg"],
                            [NSURL URLWithString:@"http://res.cloudinary.com/ddbtyv5bo/image/upload/v1400074061/lm7xcar9hk6wd9e6ghuv.jpg"],
                            [NSURL URLWithString:@"http://res.cloudinary.com/ddbtyv5bo/image/upload/v1400073989/tfktxvg5crgml9zz3as0.jpg"],
                            [NSURL URLWithString:@"http://res.cloudinary.com/ddbtyv5bo/image/upload/v1400072964/kyr2wee2rvq33low64fl.jpg"]
                            ];
    

    
    
    UIImage *placeholderImage = [UIImage imageNamed:@"3.jpg"];
    
    self.view.backgroundColor = [UIColor grayColor];
    
    self.imageViewer.delegate = self;
    self.imageViewer.currentPageIndex = 3;
    self.imageViewer.carouselType = CarouselTypePageNumber;
    self.imageViewer.contentMode = ContentModeAspectNormal;
    self.imageViewer.carouselPosition = CarouselPositionBottomLeft;
    self.imageViewer.bZoomEnable = YES;
    self.imageViewer.bZoomRestoreAfterDimissed = YES;
    
    [self.imageViewer setImages:imageArray withPlaceholder:placeholderImage];
    [self.imageViewer setPageControlCurrentIndicatorImage:[UIImage imageNamed:@"active"]];
    [self.imageViewer setPageControlIndicatorImage:[UIImage imageNamed:@"inactive"]];
    
    X4ImageViewer *iv = [[X4ImageViewer alloc] initWithFrame:CGRectMake(160, 20 ,160,160)];
    iv.delegate = self;
    iv.currentPageIndex = 3;
    iv.carouselType = CarouselTypePageControl;
    iv.contentMode = ContentModeAspectFill;
    iv.carouselPosition = CarouselPositionTopCenter;
    iv.bZoomEnable = YES;
    iv.bZoomRestoreAfterDimissed = YES;
    
    [iv setImages:urlArray withPlaceholder:placeholderImage];
    [iv setPageControlCurrentIndicatorImage:[UIImage imageNamed:@"active"]];
    [iv setPageControlIndicatorImage:[UIImage imageNamed:@"inactive"]];

    [self.view addSubview:iv];
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 200, 100,100)];
    
    imageView.image = [UIImage imageNamed:@"6.jpg"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.userInteractionEnabled = YES;
    
    [imageView enableClickToFullScreen];
    [self.view addSubview:imageView];

    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)imageViewer:(X4ImageViewer *)imageViewer didDoubleTap:(UIImageView *)imageView atIndex:(NSInteger)index inScrollView:(UIScrollView *)scrollView{
//    NSLog(@"Double tapped");
//}

- (void)imageViewer:(X4ImageViewer *)imageViewer didEndZoomingWith:(UIImageView *)imageView atIndex:(NSInteger)index inScrollView:(UIScrollView *)scrollView{
    
    NSLog(@"End zooming");
}

- (void)imageViewer:(X4ImageViewer *)imageViewer didSlideFrom:(UIImageView *)fromImageView fromIndex:(NSInteger)fromIndex to:(UIImageView *)toImageView toIndex:(NSInteger)toIndex{
    NSLog(@"Image switched.");
}

- (void)imageViewer:(X4ImageViewer *)imageViewer didSingleTap:(UIImageView *)imageView atIndex:(NSInteger)index inScrollView:(UIScrollView *)scrollView{
    NSLog(@"Single tapped");

}


@end
