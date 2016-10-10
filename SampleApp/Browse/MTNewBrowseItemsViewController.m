//
//  MTNewBrowseItemsViewController.m
//  SampleApp
//
//  Created by Manoj Rai on 08/10/16.
//  Copyright © 2016 Manoj Rai. All rights reserved.
//

#import "MTNewBrowseItemsViewController.h"
#import "MTNewBrowseCollectionCellCollectionViewCell.h"
#import "SVPullToRefresh.h"
#import "NetworkHandler.h"
#import "Constants.h"
#import "UIKit+AFNetworking.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MTProductDetailsViewController.h"

@interface MTNewBrowseItemsViewController ()
{
    NSUInteger page;
    NSUInteger totalNumberOfPages;

}

@property(nonatomic,strong) NSMutableArray *arrayBrowseData;
@end

@implementation MTNewBrowseItemsViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    // Initilize page by zero
    page = 0;
    totalNumberOfPages = -1;
    self.arrayBrowseData = [[NSMutableArray alloc] init];

    
    // setup infinite scrolling
    [self.collectionViewProducts addInfiniteScrollingWithActionHandler:^{
        [self fetchProductDataForpage:page];
    }];
    
    
    // Fetch Product
    [self fetchProductDataForpage:page];


}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}


- (void)fetchProductDataForpage:(NSUInteger)pageNumber
{
    if (pageNumber == totalNumberOfPages) {
        return;// No product to show
    }
    [self.collectionViewProducts.pullToRefreshView startAnimating];

    NSString *urlString = [NSString stringWithFormat:@"https://api.redmart.com/v1.5.6/catalog/search?theme=all-sales&pageSize=%d&page=%lu",kPageSize,(unsigned long)pageNumber];
    
    [[NetworkHandler sharedInstance] getAPI:urlString params:nil completionHandler:^(id responseObject, NSError *error) {
        if (error == nil && [responseObject isKindOfClass:[NSDictionary class]]) {
            
            [self.arrayBrowseData addObjectsFromArray:[responseObject objectForKey:@"products"]];
            
            int totalEntry = [[responseObject objectForKey:@"total"] intValue];
            if (totalEntry % kPageSize == 0) {
                totalNumberOfPages = totalEntry % kPageSize;
            }else {
                totalNumberOfPages = (totalEntry % kPageSize) + 1;
            }

            page  = [[responseObject objectForKey:@"page"] intValue] + 1;
            [self.collectionViewProducts reloadData];


        }
        
        [self.collectionViewProducts.pullToRefreshView stopAnimating];
        [self.collectionViewProducts.infiniteScrollingView stopAnimating];

        
    }];
    
}

#pragma mark UICollectionView DataSource & Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView;
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger totalCount = [self.arrayBrowseData count];
    return totalCount;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.frame.size.width/2 - 5.0, collectionView.frame.size.width/2 + 40);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MTNewBrowseCollectionCellCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];

    NSDictionary *product = [self.arrayBrowseData objectAtIndex:indexPath.item];
    cell.labelProductTitle.text = [NSString stringWithFormat:@"%@",[product objectForKey:@"title"]];
    cell.labelProductPrice.text = [NSString stringWithFormat:@"$ %@",[[product objectForKey:@"pricing"] objectForKey:@"price"]];
    
    NSString *imageUrl = [NSString stringWithFormat:@"http://media.redmart.com/newmedia/200p%@",[[product objectForKey:@"img"] objectForKey:@"name"]];
    //NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
    //cell.imageViewProduct.image = [UIImage imageWithData:data];

    [cell.imageViewProduct sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
   // [cell.imageViewProduct setImageWithURL:[NSURL URLWithString:imageUrl]];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
{
    NSDictionary *product = [self.arrayBrowseData objectAtIndex:indexPath.item];

    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MTProductDetailsViewController *obj = [storyBoard instantiateViewControllerWithIdentifier:@"MTProductDetailsViewController"];
    obj.dataDict = product;
    [self.navigationController pushViewController:obj animated:true];
}


@end
