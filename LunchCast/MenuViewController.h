//
//  RestaurantMenuViewController.h
//  LunchCast
//
//  Created by Aleksandra Stevović on 2/19/16.
//  Copyright © 2016 Aleksandra Stevović. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Restaurant.h"
#import "Order.h"

@interface MenuViewController : UIViewController

@property (nonatomic, strong) Restaurant *restaurant;
@property (nonatomic, strong) Order *order;
@property (nonatomic, getter=isOrderCreated) BOOL orderCreated;

@end
