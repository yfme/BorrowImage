//
//  DetailViewController.m
//  BorrowImage
//
//  Created by Yang Fei on 12-12-18.
//  Copyright (c) 2012年 能力有限公司. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor whiteColor];
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 30, 320-80, 220)];
        self.imageView.backgroundColor = [UIColor lightGrayColor];
        //self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:self.imageView];
        
        self.pathLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.imageView.frame), 320-40, 100)];
        self.pathLabel.numberOfLines = 0;
        [self.view addSubview:self.pathLabel];
        
        self.sizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
        self.sizeLabel.textAlignment = UITextAlignmentCenter;
        [self.view addSubview:self.sizeLabel];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
