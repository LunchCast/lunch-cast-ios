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
#import "UIColor+NewColorAdditions.h"

@interface OrdersViewController()

@property (nonatomic,strong) NSMutableArray *searchResults;
@property (nonatomic,strong) NSMutableArray *userOrders;
@property (nonatomic,strong) NSMutableArray *activeOrders;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation OrdersViewController


-(void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Orders";
    self.searchResults = [NSMutableArray new];
    self.userOrders = [NSMutableArray new];
    self.activeOrders = [NSMutableArray new];
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
                                response:^(BackendlessCollection *collection){
                                    [self.activeOrders removeAllObjects];
                                    [self.searchResults removeAllObjects];
                                    for (Order *order in collection.data)
                                    {
                                        if ([order.state intValue] <2)
                                        {
                                            [self.searchResults addObject:order];
                                            if ([order.state intValue]==0)
                                            {
                                                [self.activeOrders addObject:order];
                                            }
                                        }
                                    }
                                    [self addObjectsToUserOrders];
                                }
                                   error:^(Fault *fault) {
                                       
                                   }];
 
}
-(void)addObjectsToUserOrders
{
    BackendlessDataQuery *dataQuery = [BackendlessDataQuery query];
    dataQuery.whereClause = [NSString stringWithFormat:@"orderer.objectId = \'%@\'",
                             backendless.userService.currentUser.objectId];
    
    [backendless.persistenceService find:[OrderItem class]
                               dataQuery:dataQuery
                                response:^(BackendlessCollection *collection){
                                    [self.userOrders removeAllObjects];
                                    for (OrderItem *orderItem in collection.data)
                                    {
                                        for(Order *order in self.searchResults)
                                        {
                                            if ([orderItem.order_id.objectId isEqualToString:order.objectId] ) {
                                                if (![self.userOrders containsObject:order]) {
                                                    [self.userOrders addObject:order];
                                                    [self.activeOrders removeObject:order];
                                                }
                                            }
                                        }
                                    }
                                    [self.tableView reloadData];
                                }
                                   error:^(Fault *fault) {}];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.userOrders.count > 0)
    {
        return 2;
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0;
    }
    return 10.0;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *v = (UITableViewHeaderFooterView *)view;
    v.backgroundView.backgroundColor = [UIColor blackColor];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return self.userOrders.count;
    }
    return self.activeOrders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrdersCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Order" forIndexPath:indexPath];
    Order *order;
    if (indexPath.section == 0 && self.userOrders.count)
    {
        order = self.userOrders[indexPath.row];
    }
    else
    {
        order = self.activeOrders[indexPath.row];
    }

    cell.order = order;
    [cell.restaurantName setText: [order.restaurant.name uppercaseString]];
    [cell.restourantImageView setImage:[UIImage imageNamed:order.restaurant.image]];
    
    NSString *tags = @"";
    for(Tag *tag in order.restaurant.tags)
    {
        tags = [tags stringByAppendingString:@"#"];
        tags = [tags stringByAppendingString:[tag.name lowercaseString]];
        tags = [tags stringByAppendingString:@" "];
    }
    [cell.tags setText:tags];
    
    [cell.eta setText:[NSString stringWithFormat:@"ETA: %@'",order.restaurant.eta]];

    [cell.orderer setText:[NSString stringWithFormat:@"Admin: %@",order.order_creator.name]];
    
    if ([order.state intValue] == 0)
    {
        //otvorena
        cell.stateLabel.textColor = [UIColor toxicGreenColor];
        cell.stateLabel.text = @"OPENED";
    }
    else if ([order.state intValue] ==1)
    {
        //zatvorena
        cell.stateLabel.textColor = [UIColor darkishPinkColor];
        cell.stateLabel.text = @"CLOSED";
    }
    
    return cell;
}

#pragma mark - Prepare for segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"openOrder"])
    {
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        Order *order;
        if (path.section == 0 && self.userOrders.count)
        {
            order = self.userOrders[path.row];
        }
        else
        {
            order = self.activeOrders[path.row];
        }
        OrderDetailsViewController *mvc = (OrderDetailsViewController *)segue.destinationViewController;
        mvc.order = order;
    }
}

@end
