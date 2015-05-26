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
    
    self.view.backgroundColor = [UIColor whiteColor];
    
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
    return CGRectMake( 100, 50 , 40, 40);
}

@end
