//
//  RestaurantCell.m
//  LunchCast
//
//  Created by Aleksandra Stevović on 2/28/16.
//  Copyright © 2016 Aleksandra Stevović. All rights reserved.
//

#import "RestaurantCell.h"
#import "Backendless.h"
#import "Order.h"

@implementation RestaurantCell

//- (IBAction)onChooseButton:(UIButton *)sender
//{
//    
//        Order *order = [Order new];
//        order.order_time = [backendless randomString:MIN(25,36)];
//        order.state = [NSNumber numberWithInt:0];
//        order.restaurant = self.restaurant;
//        BackendlessUser *user = backendless.userService.currentUser;
//        order.order_creator = user;
//        [backendless.persistenceService save:order response:^(Order *result) {
//            
//        }
//                                       error:^(Fault *fault) {
//                                           
//                                       }];
//}


@end
