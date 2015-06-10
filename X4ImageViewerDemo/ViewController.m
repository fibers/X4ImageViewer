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


@interface ViewController ()

@property (nonatomic, strong) NSArray *imageArray1;
@property (nonatomic, strong) NSArray *imageArray2;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.imageArray1 = @[
                            [UIImage imageNamed:@"1.jpg"],
                            [UIImage imageNamed:@"2.jpg"],
                            [UIImage imageNamed:@"6.jpg"]
                            ];
    
    self.imageArray2 = @[
                            [UIImage imageNamed:@"4.jpg"],
                            [UIImage imageNamed:@"5.jpg"]
                            ];

    
    self.view.backgroundColor = [UIColor greenColor];
    
    
    
    X4ImageViewer *iv = [[X4ImageViewer alloc] initWithFrame:CGRectMake(0,60,320,400)];
    iv.delegate = self;
    iv.images = self.imageArray1;
    iv.currentPageIndex = 3;
    iv.carouselCenter = CGPointMake(160, 380);
    iv.carouselType = CarouselTypePageControl;
    iv.bZoomEnable = YES;
    iv.bZoomRestoreAfterDimissed = YES;
    
    [iv setPageControlCurrentIndicatorImage:[UIImage imageNamed:@"active"]];
    [iv setPageControlIndicatorImage:[UIImage imageNamed:@"inactive"]];

    [self.view addSubview:iv];
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 100,100)];
    
    imageView.image = [UIImage imageNamed:@"6.jpg"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.userInteractionEnabled = YES;
    
    [imageView enableClickToFullScreen];
    
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapGesture1:)];
    [imageView addGestureRecognizer:tapGesture1];
    
//    [self.view addSubview:imageView];
    

    
}


- (void)onTapGesture1:(UITapGestureRecognizer *)gesture{
    NSLog(@"tap gesture 1");
}

- (void)onTapGesture2:(UITapGestureRecognizer *)gesture{
    NSLog(@"tap gesture 2");
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

- (void)imageViewer:(X4ImageViewer *)imageViewer didImageSwitchFrom:(NSInteger)oldIndex to:(NSInteger)newIndex{
    NSLog(@"Image switched.");
}

- (void)imageViewer:(X4ImageViewer *)imageViewer didTap:(UIImageView *)imageView atIndex:(NSInteger)index inScrollView:(UIScrollView *)scrollView{
    NSLog(@"Single tapped");
    
//    imageViewer.frame = CGRectMake(20, 20, 200, 200);
//    imageViewer.images = self.imageArray2;
}

@end
