//
//  CustomTVCell.h
//  LunchCast
//
//  Created by Aleksandra Stevović on 2/19/16.
//  Copyright © 2016 Aleksandra Stevović. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrdersCustomTVCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *tagsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *redGreenImageView;
@property (weak, nonatomic) IBOutlet UILabel *restaurantLabel;

@end
