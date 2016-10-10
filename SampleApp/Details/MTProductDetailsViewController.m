//
//  MTProductDetailsViewController.m
//  SampleApp
//
//  Created by Manoj Rai on 09/10/16.
//  Copyright © 2016 Manoj Rai. All rights reserved.
//

#import "MTProductDetailsViewController.h"
#import "DMLazyScrollView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface MTProductDetailsViewController () <DMLazyScrollViewDelegate> {
    NSMutableArray *viewControllerArray;

}
@property (weak, nonatomic) IBOutlet DMLazyScrollView *imageScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end

@implementation MTProductDetailsViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
     viewControllerArray = [[NSMutableArray alloc] init];

    self.titleLabel.text = [self.dataDict objectForKey:@"title"];
    self.descriptionLabel.text = [self.dataDict objectForKey:@"desc"];

    NSArray *images = [self.dataDict objectForKey:@"images"];
    self.pageControl.numberOfPages = images.count;
    [self loadBanners:images];
    
    
}


- (void)loadBanners :(NSArray*)images{

    for (NSDictionary *dict in images) {
        [viewControllerArray addObject:[NSNull null]];
    }
    
    [self.imageScrollView setEnableCircularScroll:YES];
    [self.imageScrollView setAutoPlay:false];
    [self.imageScrollView setScrollEnabled:YES];
    self.imageScrollView.controlDelegate = self;
    __weak __typeof(&*self)weakSelf = self;
    
    self.imageScrollView.dataSource = ^(NSUInteger index) {
        return [weakSelf controllerAtIndex:index];
    };
    self.imageScrollView.numberOfPages = viewControllerArray.count;

}
- (UIViewController *) controllerAtIndex:(NSInteger) index {
    
    if (index > viewControllerArray.count || index < 0) return nil;
    
    id res = [viewControllerArray objectAtIndex:index];
    if (res == [NSNull null]) {
      
        UIViewController *contr = [[UIViewController alloc] init];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.imageScrollView.frame.size.width, self.imageScrollView.frame.size.width)];
        NSArray *images = [self.dataDict objectForKey:@"images"];
        NSDictionary *imageDict = [images objectAtIndex:index];
        NSString *imageUrl = [NSString stringWithFormat:@"http://media.redmart.com/newmedia/200p%@",[imageDict objectForKey:@"name"]];
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [contr.view addSubview:imageView];
        
        [viewControllerArray replaceObjectAtIndex:index withObject:contr];
        
        return contr;
    }
    return res;
}

- (void)lazyScrollView:(DMLazyScrollView *)pagingView currentPageChanged:(NSInteger)currentPageIndex
{
    self.pageControl.currentPage = currentPageIndex;
        
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
