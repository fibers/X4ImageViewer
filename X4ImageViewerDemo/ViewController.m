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

@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) UIImage *placeholderImage;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.imageArray = @[
                            [UIImage imageNamed:@"1.jpg"],
                            [UIImage imageNamed:@"2.jpg"],
                            [UIImage imageNamed:@"3.jpg"],
                            [UIImage imageNamed:@"4.jpg"],
                            [UIImage imageNamed:@"5.jpg"],
                            [UIImage imageNamed:@"6.jpg"]
                            ];
    
    NSArray *imageArray1 = @[
                            [UIImage imageNamed:@"4.jpg"],
                            [UIImage imageNamed:@"5.jpg"]
                            ];
    
    NSArray *imageArray2 = @[
                         [NSURL URLWithString:@"http://res.cloudinary.com/fivemiles/image/upload/v1433411719/ba5jij1imi8e1tbrqbww.jpg"],
                         [UIImage imageNamed:@"1.jpg"]
                         ];
    
    NSArray *imageArray3 = @[
                             [NSURL URLWithString:@"http://res.cloudinary.com/fivemiles/image/upload/v1433411719/ba5jij1imi8e1tbrqbww.jpg"],
                         [NSURL URLWithString:@"http://res.cloudinary.com/fivemiles/image/upload/v1433909562/tl8tadtulxjm3ps4pnvx.jpg"],
                         [UIImage imageNamed:@"1.jpg"],
                         [NSURL URLWithString:@"http://res.cloudinary.com/fivemiles/image/upload/v1433909561/jfqsxgvtpnjgycu6akl1.jpg"],
                         [UIImage imageNamed:@"6.jpg"],
                         [NSURL URLWithString:@"http://res.cloudinary.com/fivemiles/image/upload/v1433909561/lkol5wdzfu64l8bppjpi.jpg"],
                         [UIImage imageNamed:@"5.jpg"],
                         [NSURL URLWithString:@"http://res.cloudinary.com/fivemiles/image/upload/v1433909556/yqryfx1y1bnowzz6tgch.jpg"],
                             [NSURL URLWithString:@"http://res.cloudinary.com/fivemiles/image/upload/v1433411719/ba5jij1imi8e1tbrqbww.jpg"],
                             [NSURL URLWithString:@"http://res.cloudinary.com/fivemiles/image/upload/v1433909562/tl8tadtulxjm3ps4pnvx.jpg"],
                             [UIImage imageNamed:@"1.jpg"],
                             [NSURL URLWithString:@"http://res.cloudinary.com/fivemiles/image/upload/v1433909561/jfqsxgvtpnjgycu6akl1.jpg"],
                             [UIImage imageNamed:@"6.jpg"],
                             [NSURL URLWithString:@"http://res.cloudinary.com/fivemiles/image/upload/v1433909561/lkol5wdzfu64l8bppjpi.jpg"],
                             [UIImage imageNamed:@"5.jpg"],
                             [NSURL URLWithString:@"http://res.cloudinary.com/fivemiles/image/upload/v1433909556/yqryfx1y1bnowzz6tgch.jpg"],
                             [NSURL URLWithString:@"http://res.cloudinary.com/fivemiles/image/upload/v1433411719/ba5jij1imi8e1tbrqbww.jpg"],
                             [NSURL URLWithString:@"http://res.cloudinary.com/fivemiles/image/upload/v1433909562/tl8tadtulxjm3ps4pnvx.jpg"],
                             [UIImage imageNamed:@"1.jpg"],
                             [NSURL URLWithString:@"http://res.cloudinary.com/fivemiles/image/upload/v1433909561/jfqsxgvtpnjgycu6akl1.jpg"],
                             [UIImage imageNamed:@"6.jpg"],
                             [NSURL URLWithString:@"http://res.cloudinary.com/fivemiles/image/upload/v1433909561/lkol5wdzfu64l8bppjpi.jpg"],
                             [UIImage imageNamed:@"5.jpg"],
                             [NSURL URLWithString:@"http://res.cloudinary.com/fivemiles/image/upload/v1433909556/yqryfx1y1bnowzz6tgch.jpg"]
                         ];

    
    
    self.placeholderImage = [UIImage imageNamed:@"3.jpg"];
    
    self.view.backgroundColor = [UIColor greenColor];
    
    
    
    X4ImageViewer *iv = [[X4ImageViewer alloc] initWithFrame:CGRectMake(0,60,320,400)];
    iv.delegate = self;
    iv.currentPageIndex = 3;
    iv.carouselType = CarouselTypePageNumber;
    iv.contentMode = ContentModeAspectNormal;
    iv.carouselPosition = CarouselPositionBottomLeft;
    iv.bZoomEnable = YES;
    iv.bZoomRestoreAfterDimissed = YES;
    
    [iv setImages:self.imageArray withPlaceholder:nil];
    
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
    

//    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActionSheetStyleDefault];
//    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActionSheetStyleBlackOpaque];
//    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActionSheetStyleBlackTranslucent];

    
//    spinner.frame = CGRectMake(50,50, 200, 200);
//    
//    [self.view addSubview:spinner];
//    [spinner startAnimating];
    
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
    
    imageViewer.frame = CGRectMake(20, 20, 200, 200);
//    imageViewer.images = self.imageArray2;
}


@end
