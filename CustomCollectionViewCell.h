//
//  CustomCollectionViewCell.h
//  LunchCast
//
//  Created by Aleksandra Stevovic on 6/27/16.
//  Copyright © 2016 Aleksandra Stevović. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tagImageView;

-(void)selectCell;
-(void)deselectCell;

@end
