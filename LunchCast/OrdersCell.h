//
//  CustomTVCell.h
//  LunchCast
//
//  Created by Aleksandra Stevović on 2/19/16.
//  Copyright © 2016 Aleksandra Stevović. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Order.h"

@interface OrdersCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *restaurantName;
@property (weak, nonatomic) IBOutlet UILabel *menu;
@property (weak, nonatomic) IBOutlet UILabel *eta;
@property (weak, nonatomic) IBOutlet UILabel *orderer;

@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;

@property (nonatomic, strong) Order *order;

@end
