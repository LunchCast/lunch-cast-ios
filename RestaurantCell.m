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

- (IBAction)onChooseButton:(UIButton *)sender
{
    
    if (![self orderAlreadyExsist]) {
        Order *order = [Order new];
        order.order_time = [backendless randomString:MIN(25,36)];
        order.state = [NSNumber numberWithInt:0];
        order.restaurant = self.restaurant;
        BackendlessUser *user = backendless.userService.currentUser;
        order.order_creator = user;
        [backendless.persistenceService save:order response:^(Order *result) {
            
        }
                                       error:^(Fault *fault) {
                                           
                                       }];
    }
}

-(BOOL)orderAlreadyExsist
{
    //DORADI!!!
    
    NSMutableArray *allOrders = [NSMutableArray new];
    QueryOptions *queryOptions = [QueryOptions query];
    queryOptions.relationsDepth = @1;
    BackendlessDataQuery *dataQuery = [BackendlessDataQuery query];
    dataQuery.queryOptions = queryOptions;
    [backendless.persistenceService find:[Order class]
                               dataQuery:[BackendlessDataQuery query]
                                response:^(BackendlessCollection *collection){
                                    [allOrders arrayByAddingObjectsFromArray: collection.data];
                                }
    error:^(Fault *fault) {
    }];

    for (Order *order in allOrders)
    {
        if ([order.restaurant.objectId isEqualToString:self.restaurant.objectId])
        {
            return YES;
        }
    }
    
    return NO;
}

@end
