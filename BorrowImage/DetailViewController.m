//
//  DetailViewController.m
//  BorrowImage
//
//  Created by Yang Fei on 12-12-18.
//  Copyright (c) 2012年 能力有限公司. All rights reserved.
//

#import "DetailViewController.h"
#import <MessageUI/MessageUI.h>

@interface DetailViewController () <MFMailComposeViewControllerDelegate>

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
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.pathLabel.frame), 320, 30)];
        self.nameLabel.textAlignment = UITextAlignmentCenter;
        [self.view addSubview:self.nameLabel];
    }
    return self;
}

- (void)sendMail{
    MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
	controller.mailComposeDelegate = self;
	[controller setSubject:@"Share Image"];
    NSString *bodyString = @"Share an iOS image from BorrowImage";
	[controller setMessageBody:bodyString isHTML:NO];
    [controller addAttachmentData:UIImagePNGRepresentation(_imageView.image)
                         mimeType:@"image/PNG"
                         fileName:[NSString stringWithFormat:@"%@",_nameLabel.text]];
	[self presentModalViewController:controller animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(sendMail)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    switch (result) {
        case MFMailComposeResultCancelled:
            //
            break;
        case MFMailComposeResultSaved:
            //
            break;
        case MFMailComposeResultSent:
            //
            break;
        case MFMailComposeResultFailed:
            //
            break;
            
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
