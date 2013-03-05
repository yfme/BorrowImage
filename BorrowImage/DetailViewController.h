//
//  DetailViewController.h
//  BorrowImage
//
//  Created by Yang Fei on 12-12-18.
//  Copyright (c) 2012年 能力有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *pathLabel, *sizeLabel, *nameLabel;
@end
