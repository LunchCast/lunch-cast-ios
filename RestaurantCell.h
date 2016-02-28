//
//  RestaurantCell.h
//  LunchCast
//
//  Created by Aleksandra Stevović on 2/28/16.
//  Copyright © 2016 Aleksandra Stevović. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RestaurantCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *menu;
@property (weak, nonatomic) IBOutlet UILabel *eta;
@property (weak, nonatomic) IBOutlet UILabel *min;

@end
