//
//  OrdersViewController.m
//  LunchCast
//
//  Created by Aleksandra Stevović on 2/19/16.
//  Copyright © 2016 Aleksandra Stevović. All rights reserved.
//

#import "OrdersViewController.h"
#import "OrderDetailsViewController.h"
#import "Backendless.h"
#import "Order.h"
#import "Tag.h"
#import "Restaurant.h"
#import "OrdersCell.h"

@interface OrdersViewController()

@property (nonatomic, strong) NSArray *searchResults;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation OrdersViewController


-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.searchResults = [NSArray new];
    
    //basic search for Orders
    
    QueryOptions *queryOptions = [QueryOptions query];
    queryOptions.relationsDepth = @1;
    BackendlessDataQuery *dataQuery = [BackendlessDataQuery query];
    dataQuery.queryOptions = queryOptions;
    
    [backendless.persistenceService find:[Order class]
                               dataQuery:dataQuery
                                response:^(BackendlessCollection *collection) {
                                    
                                    self.searchResults = collection.data;
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
    
    [cell.restaurantLabel setText: order.restaurant.name];
    
    NSString *tags = @"";
    for(Tag *tag in order.restaurant.tags)
    {
        tags = [tags stringByAppendingString:tag.name];
        tags = [tags stringByAppendingString:@", "];
    }
    
    [cell.tagsLabel setText:tags];
    
    return cell;
}

#pragma mark - Prepare for segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"OrderDetails"])
    {
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        Order *order = self.searchResults[path.row];
        OrderDetailsViewController *odvc = (OrderDetailsViewController *)segue.destinationViewController;
        odvc.order = order;
    }
}

@end
