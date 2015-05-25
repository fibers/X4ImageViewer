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
    
//    NSArray *imageArray = @[
//                            [NSURL URLWithString:@"http://res.cloudinary.com/ddbtyv5bo/image/upload/v1400074061/lm7xcar9hk6wd9e6ghuv.jpg"],
//                            [NSURL URLWithString:@"http://res.cloudinary.com/ddbtyv5bo/image/upload/v1400134672/uputh2onyan9ntui6cwj.jpg"],
//                             [NSURL URLWithString:@"http://res.cloudinary.com/ddbtyv5bo/image/upload/v1400134498/msdhd8906lz5uxbx3oy7.jpg"],
//                             [NSURL URLWithString:@"http://res.cloudinary.com/ddbtyv5bo/image/upload/v1400073989/tfktxvg5crgml9zz3as0.jpg"]
//    
//    ];
    
    self.view.backgroundColor = [UIColor greenColor];
    
    X4ImageViewer *iv = [[X4ImageViewer alloc] initWithFrame:CGRectMake(10,10,300,300) images:imageArray imagePosition:CGRectMake(20,20,150,150) withPlaceholder:nil];
    iv.currentImageIndex = 2;
    iv.delegate = self;
    iv.paginationType = PaginationTypeNumber;
    [iv loadImages];
    
    [self.view addSubview:iv];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (CGRect)rectForPagination{
    return CGRectMake( 0, 0 , 100, 40);
}

@end
