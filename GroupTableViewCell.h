//
//  GroupTableViewCell.h
//  LunchCast
//
//  Created by Marko Cancar on 4.3.16..
//  Copyright © 2016. Aleksandra Stevović. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end
