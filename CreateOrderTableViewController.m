//
//  CreateOrderTableViewController.m
//  LunchCast
//
//  Created by Aleksandra Stevović on 2/28/16.
//  Copyright © 2016 Aleksandra Stevović. All rights reserved.
//

#import "CreateOrderTableViewController.h"
#import "Backendless.h"
#import "Restaurant.h"
#import "RestaurantCell.h"
#import "Tag.h"

@interface CreateOrderTableViewController()

@property (strong, nonatomic) NSArray * searchResults;

@end
@implementation CreateOrderTableViewController


-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.searchResults = [NSArray new];
    
    //basic search for Restaurants
    
    QueryOptions *queryOptions = [QueryOptions query];
    queryOptions.relationsDepth = @1;
    BackendlessDataQuery *dataQuery = [BackendlessDataQuery query];
    dataQuery.queryOptions = queryOptions;
    
    [backendless.persistenceService find:[Restaurant class]
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
    RestaurantCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Restaurant" forIndexPath:indexPath];
    
    Restaurant *restaurant = self.searchResults[indexPath.row];
    
    cell.restaurant = restaurant;
    [cell.name setText: restaurant.name];
    
    NSString *tags = @"";
    for(Tag *tag in restaurant.tags)
    {
        tags = [tags stringByAppendingString:tag.name];
        tags = [tags stringByAppendingString:@", "];
    }
    
    [cell.menu setText:tags];
    [cell.eta setText:[NSString stringWithFormat:@"Delivery time: %@",restaurant.eta]];
  //  [cell.min setText:]
    
    return cell;
}

@end
