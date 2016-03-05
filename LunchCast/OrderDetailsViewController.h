//
//  OrderDetailsViewController.h
//  LunchCast
//
//  Created by Aleksandra Stevović on 2/19/16.
//  Copyright © 2016 Aleksandra Stevović. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Order.h"
#import "Meal.h"

@interface GroupByMeal : NSObject

@property (nonatomic, strong)Meal *meal;
@property (nonatomic, strong)NSString *orderers;
@property (nonatomic)int quantity;

@end

@interface GroupByPerson : NSObject

@property (nonatomic, strong)BackendlessUser *orderer;
@property (nonatomic, strong)NSString *meals;

@end


@interface OrderDetailsViewController : UIViewController

@property (nonatomic, strong) Order *order;

@end
