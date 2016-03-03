//
//  MenuCell.h
//  LunchCast
//
//  Created by Aleksandra Stevovic on 3/1/16.
//  Copyright © 2016 Aleksandra Stevović. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Meal.h"

@protocol MenuCellDelegate

- (void) amountHasBeenChanged:(NSUInteger) amount forMeal: (Meal *)meal;

@end

@interface MenuCell : UITableViewCell

@property (nonatomic, strong) Meal *meal;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *details;

@property (nonatomic) NSUInteger amount;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;

@property(weak, nonatomic) id<MenuCellDelegate>delegate;

@end
