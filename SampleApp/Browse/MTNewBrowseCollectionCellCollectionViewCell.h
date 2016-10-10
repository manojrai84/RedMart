//
//  MTNewBrowseCollectionCellCollectionViewCell.h
//  SampleApp
//
//  Created by Manoj Rai on 08/10/16.
//  Copyright © 2016 Manoj Rai. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface MTNewBrowseCollectionCellCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageViewProduct;
@property (weak, nonatomic) IBOutlet UILabel *labelProductPrice;
@property (weak, nonatomic) IBOutlet UIButton *btnLike;
@property (weak, nonatomic) IBOutlet UILabel *labelProductTitle;

@end
