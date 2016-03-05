//
//  OrdersViewController.m
//  LunchCast
//
//  Created by Aleksandra Stevović on 2/19/16.
//  Copyright © 2016 Aleksandra Stevović. All rights reserved.
//

#import "OrdersViewController.h"
#import "OrderDetailsViewController.h"
#import "CreateOrderViewController.h"
#import "Backendless.h"
#import "Order.h"
#import "OrderItem.h"
#import "Tag.h"
#import "Meal.h"
#import "Restaurant.h"
#import "OrdersCell.h"

@interface OrdersViewController()

@property (nonatomic, strong) NSMutableArray *searchResults;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation OrdersViewController


-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Orders";
    
    self.searchResults = [NSMutableArray new];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //basic search for Orders
    
    QueryOptions *queryOptions = [QueryOptions query];
    queryOptions.relationsDepth = @1;
    BackendlessDataQuery *dataQuery = [BackendlessDataQuery query];
    dataQuery.queryOptions = queryOptions;
    
    [backendless.persistenceService find:[Order class]
                               dataQuery:dataQuery
                                response:^(BackendlessCollection *collection) {
                                    [self.searchResults removeAllObjects];
                                    for (Order *order in collection.data) {
                                        if ([order.state intValue]<2) {
                                            [self.searchResults addObject:order];
                                        }
                                    }
                                    [self.tableView reloadData];
                                }
                                   error:^(Fault *fault) {
                                       
                                   }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrdersCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Order" forIndexPath:indexPath];
    
    Order *order = self.searchResults[indexPath.row];
    cell.order = order;
    [cell.restaurantName setText: order.restaurant.name];
    
    NSString *meals = @"";
    for(Meal *meal in order.restaurant.meals)
    {
        meals = [meals stringByAppendingString:meal.name];
        meals = [meals stringByAppendingString:@", "];
    }
    
    [cell.menu setText:meals];
    
    [cell.eta setText:[NSString stringWithFormat:@"Delivery time: %@ min",order.restaurant.eta]];

    [cell.orderer setText:[NSString stringWithFormat:@"Order admin: %@",order.order_creator.name]];
    
    if ([order.state intValue] == 0)
    {
        //otvorena
        [cell.statusImageView setImage:[UIImage imageNamed:@"open"]];
    }
    else if ([order.state intValue] ==1)
    {
        //zatvorena
        [cell.statusImageView setImage:[UIImage imageNamed:@"closed"]];
    }
    
    return cell;
}

#pragma mark - Prepare for segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"openOrder"])
    {
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        Order *order = self.searchResults[path.row];
        OrderDetailsViewController *mvc = (OrderDetailsViewController *)segue.destinationViewController;
        mvc.order = order;
    }
}

@end
