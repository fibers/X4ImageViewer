//
//  ViewController.m
//  X4ImageViewer
//
//  Created by shengyuhong on 15/4/21.
//  Copyright (c) 2015年 Doit. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSArray *imageArray = @[
                            [UIImage imageNamed:@"1.jpg"],
                            [UIImage imageNamed:@"2.jpg"],
                            [UIImage imageNamed:@"3.jpg"],
                            [UIImage imageNamed:@"4.jpg"],
                            [UIImage imageNamed:@"5.jpg"],
    ];
    
    self.view.backgroundColor = [UIColor greenColor];
    
    
    
    X4ImageViewer *iv = [[X4ImageViewer alloc] initWithFrame:CGRectMake(0,60,320,400) images:imageArray];
    iv.currentImageIndex = 3;
    iv.delegate = self;
    iv.paginationType = PaginationTypeNumber;
    

    [self.view addSubview:iv];
   
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)imageViewer:(X4ImageViewer *)imageViewer didDoubleTap:(UIImageView *)imageView atIndex:(NSInteger)index inScrollView:(UIScrollView *)scrollView{
    NSLog(@"Double tapped");
}

- (void)imageViewer:(X4ImageViewer *)imageViewer didEndZoomingWith:(UIImageView *)imageView atIndex:(NSInteger)index inScrollView:(UIScrollView *)scrollView{
    
    NSLog(@"End zooming");
}

- (void)imageViewer:(X4ImageViewer *)imageViewer didImageSwitchFrom:(NSInteger)oldIndex to:(NSInteger)newIndex{
    NSLog(@"Image switched.");
}

- (void)imageViewer:(X4ImageViewer *)imageViewer didTap:(UIImageView *)imageView atIndex:(NSInteger)index inScrollView:(UIScrollView *)scrollView{
    NSLog(@"Single tapped");
}

@end
