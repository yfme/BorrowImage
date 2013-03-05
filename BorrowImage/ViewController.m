//
//  ViewController.m
//  BorrowImage
//
//  Created by Yang Fei on 12-11-4.
//  Copyright (c) 2012年 能力有限公司. All rights reserved.
//

#import "ViewController.h"
#import "DetailViewController.h"
#import <PSTCollectionView.h>

#define Target_Path @"/"//@"/System/Library"//@"/System/Library/PrivateFrameworks"

@interface BIWallCell : PSUICollectionViewCell
@property (nonatomic, strong) UIImageView *imageView;
@end
@implementation BIWallCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:imageView];
        self.imageView = imageView;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    }
    return self;
}
@end


@interface ViewController ()<UITableViewDataSource, UITableViewDelegate, PSTCollectionViewDataSource, PSTCollectionViewDelegate>
@property(nonatomic, strong)UITableView     *tableView;
@property(nonatomic, strong)NSMutableArray  *imagePathArray;
@property (nonatomic,weak) PSUICollectionView *collectionView;
@end

@implementation ViewController

- (void)updateTitle:(NSString *)str{
    self.title = str;
}

- (void)searchImages{
    @autoreleasepool {
        for (NSString *relativePath in [[NSFileManager defaultManager] enumeratorAtPath:Target_Path])
        {
            if ([relativePath hasSuffix:@".png"]) {
                
                NSArray *array = [relativePath componentsSeparatedByString:@"/"];
                NSString *imageName = [array lastObject];
                NSString *imagePath = [NSString stringWithFormat:@"%@/%@",Target_Path,relativePath];
                NSDictionary *imageDict = [NSDictionary dictionaryWithObjectsAndKeys:imageName,@"ImageName",imagePath,@"ImagePath", nil];
                [self.imagePathArray addObject:imageDict];
                [self performSelectorOnMainThread:@selector(updateTitle:) withObject:[NSString stringWithFormat:@"(%d)%@",[self.imagePathArray count],relativePath] waitUntilDone:YES];
            }
        }
        [self performSelectorOnMainThread:@selector(updateTitle:) withObject:[NSString stringWithFormat:@"(%d)%@",[self.imagePathArray count],Target_Path] waitUntilDone:YES];
        [self.tableView reloadData];
        [self.collectionView reloadData];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.imagePathArray = [NSMutableArray array];
    [NSThread detachNewThreadSelector:@selector(searchImages) toTarget:self withObject:nil];
    
    PSUICollectionViewFlowLayout *layout = [[PSUICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(75, 75);
    layout.minimumInteritemSpacing = 4;
    layout.minimumLineSpacing = 4;
    layout.sectionInset = UIEdgeInsetsMake(4, 4, 4, 4);
    
    PSUICollectionView *collectionView = [[PSUICollectionView alloc] initWithFrame:self.view.bounds
                                                              collectionViewLayout:layout];
    collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    collectionView.alwaysBounceVertical = YES;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor lightGrayColor];
    [collectionView registerClass:[BIWallCell class] forCellWithReuseIdentifier:@"CellReuseIdentifier"];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.imagePathArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ContentsCellIdentifier = @"ContentsCell";
    UITableViewCell *contentsCell = [tableView dequeueReusableCellWithIdentifier:ContentsCellIdentifier];
    if (contentsCell == nil){
        contentsCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ContentsCellIdentifier];
    }
    contentsCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    contentsCell.textLabel.text = [[self.imagePathArray objectAtIndex:indexPath.row] objectForKey:@"ImageName"];
    contentsCell.detailTextLabel.text = [[self.imagePathArray objectAtIndex:indexPath.row] objectForKey:@"ImagePath"];
    contentsCell.imageView.image = [UIImage imageWithContentsOfFile:[[self.imagePathArray objectAtIndex:indexPath.row] objectForKey:@"ImagePath"]];
    contentsCell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    return contentsCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    DetailViewController *dvc = [[DetailViewController alloc] init];
    [dvc.imageView setImage:[UIImage imageWithContentsOfFile:[[self.imagePathArray objectAtIndex:indexPath.row] objectForKey:@"ImagePath"]]];
    [dvc.imageView sizeToFit];
    [dvc.pathLabel setText:[[self.imagePathArray objectAtIndex:indexPath.row] objectForKey:@"ImagePath"]];
    [self.navigationController pushViewController:dvc animated:YES];

}

#pragma mark - PSTUICollecionView

- (NSInteger)collectionView:(PSUICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return self.imagePathArray.count;
}

- (PSUICollectionViewCell *)collectionView:(PSUICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BIWallCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellReuseIdentifier" forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageWithContentsOfFile:[[self.imagePathArray objectAtIndex:indexPath.row] objectForKey:@"ImagePath"]];
    return cell;
}

- (void)collectionView:(PSTCollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    DetailViewController *dvc = [[DetailViewController alloc] init];
    UIImage *image = [UIImage imageWithContentsOfFile:[[self.imagePathArray objectAtIndex:indexPath.row] objectForKey:@"ImagePath"]];
    [dvc.imageView setImage:image];
    [dvc.imageView sizeToFit];
    [dvc.pathLabel setText:[[self.imagePathArray objectAtIndex:indexPath.row] objectForKey:@"ImagePath"]];
    [dvc.sizeLabel setText:[NSString stringWithFormat:@"size: %.0f x %.0f", image.size.width, image.size.height]];
    [dvc.nameLabel setText:[[self.imagePathArray objectAtIndex:indexPath.row] objectForKey:@"ImageName"]];
    [self.navigationController pushViewController:dvc animated:YES];
}

@end
