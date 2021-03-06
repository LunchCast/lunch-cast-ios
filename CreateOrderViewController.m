//
//  CreateOrderTableViewController.m
//  LunchCast
//
//  Created by Aleksandra Stevović on 2/28/16.
//  Copyright © 2016 Aleksandra Stevović. All rights reserved.
//

#import "CreateOrderViewController.h"
#import "MenuViewController.h"
#import "Backendless.h"
#import "Restaurant.h"
#import "RestaurantCell.h"
#import "Tag.h"
#import "Meal.h"
#import "UIColor+NewColorAdditions.h"

@interface CreateOrderViewController() <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray * searchResults;

@end
@implementation CreateOrderViewController


-(void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor darkishPinkColor];
    self.navigationController.navigationBar.translucent  = NO;
    
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
- (IBAction)cancel:(UIBarButtonItem *)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{ }];
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
    [cell.name setText: [restaurant.name uppercaseString]];
    
    [cell.restaurantImageView setImage:[UIImage imageNamed:restaurant.image]];
    
    NSString *meals = @"";
    for(Meal *meal in restaurant.meals)
    {
        meals = [meals stringByAppendingString:meal.name];
        meals = [meals stringByAppendingString:@", "];
    }
    
    [cell.menu setText:meals];
    [cell.eta setText:[NSString stringWithFormat:@"ETA: %@'",restaurant.eta]];
    [cell.min setText:[NSString stringWithFormat:@"Minimum: %@ €", restaurant.minAmount]];
    
    return cell;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toMenu"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        MenuViewController *mvc = (MenuViewController *)segue.destinationViewController;
        Restaurant *rest = self.searchResults[indexPath.row];
        mvc.restaurant = rest;
        mvc.orderCreated = NO;
    }
}


@end
