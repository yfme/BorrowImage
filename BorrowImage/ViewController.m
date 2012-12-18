//
//  ViewController.m
//  BorrowImage
//
//  Created by Yang Fei on 12-11-4.
//  Copyright (c) 2012年 能力有限公司. All rights reserved.
//

#import "ViewController.h"
#import "DetailViewController.h"

#define Target_Path @"/System/Library"//@"/System/Library/PrivateFrameworks"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong)UITableView     *tableView;
@property(nonatomic, strong)NSMutableArray  *imagePathArray;
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
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    //NSString *currentPath = [[NSFileManager defaultManager] currentDirectoryPath];
    //self.title = currentPath;
    
    self.imagePathArray = [NSMutableArray array];
    [NSThread detachNewThreadSelector:@selector(searchImages) toTarget:self withObject:nil];
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


@end
