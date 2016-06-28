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
@property (weak, nonatomic) IBOutlet UILabel *tags;
@property (weak, nonatomic) IBOutlet UILabel *eta;
@property (weak, nonatomic) IBOutlet UILabel *orderer;
@property (weak, nonatomic) IBOutlet UIImageView *restourantImageView;

@property (weak, nonatomic) IBOutlet UILabel *stateLabel;



@property (nonatomic, strong) Order *order;

@end
