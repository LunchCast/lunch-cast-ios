//
//  RestaurantMenuViewController.m
//  LunchCast
//
//  Created by Aleksandra Stevović on 2/19/16.
//  Copyright © 2016 Aleksandra Stevović. All rights reserved.
//

#import "MenuViewController.h"
#import "OrderDetailsViewController.h"
#import "Backendless.h"
#import "MenuCell.h"
#import "Meal.h"
#import "Order.h"
#import "OrderItem.h"
#import "Tag.h"

@interface MenuViewController() <UITableViewDelegate, UITableViewDataSource, MenuCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *menuLabel;
@property (weak, nonatomic) IBOutlet UILabel *etaLabel;
@property (weak, nonatomic) IBOutlet UILabel *minLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagsLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;

@property (nonatomic) NSUInteger amount;

@end

@implementation MenuViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem.title = self.isOrderCreated ? @"ADD" : @"CREATE";
    self.navigationItem.title = self.restaurant.name;
    [self setRestaurantDetails];
}

-(void)setRestaurantDetails
{
    NSString *meals = @"";
    for(Meal *meal in self.restaurant.meals)
    {
        meals = [meals stringByAppendingString:meal.name];
        meals = [meals stringByAppendingString:@", "];
    }
    
    [self.menuLabel setText:meals];
    [self.etaLabel setText:[NSString stringWithFormat:@"Delivery time: %@ hour",self.restaurant.eta]];
    [self.minLabel setText:[NSString stringWithFormat:@"Minimum for order: %@ RSD", self.restaurant.minAmount]];
    
    NSString *tags = @"";
    for(Tag *tag in self.restaurant.tags)
    {
        tags = [tags stringByAppendingString:@"#"];
        tags = [tags stringByAppendingString:tag.name];
    }
    [self.tagsLabel setText:tags];
}

- (IBAction)onCreateOrder:(UIBarButtonItem *)sender
{
    BackendlessUser *user = backendless.userService.currentUser;
    
    if (self.isOrderCreated)
    {
        [self performSegueWithIdentifier:@"makeOrder" sender:nil];
        for (MenuCell *cell in [self.tableView visibleCells]) {
            if (cell.amount!=0) {
                OrderItem *orderItem = [OrderItem new];
                orderItem.quantity = [NSNumber numberWithInteger: cell.amount];
                orderItem.meal = cell.meal;
                orderItem.order_id = self.order;
                orderItem.orderer = user;
                [backendless.persistenceService save:orderItem response:^(OrderItem *result) {} error:^(Fault *fault) {}];
            }
        }
    }
    else
    {
        Order *order = [Order new];
        order.order_time = [backendless randomString:MIN(25,36)];
        order.state = [NSNumber numberWithInt:0];
        order.restaurant = self.restaurant;
        order.order_creator = user;
        [backendless.persistenceService save:order response:^(Order *result) {
            self.order = order;
            [self performSegueWithIdentifier:@"makeOrder" sender:nil];
            for (MenuCell *cell in [self.tableView visibleCells]) {
                if (cell.amount!=0) {
                    OrderItem *orderItem = [OrderItem new];
                    orderItem.quantity = [NSNumber numberWithInteger: cell.amount];
                    orderItem.meal = cell.meal;
                    orderItem.order_id = order;
                    orderItem.orderer = user;
                    [backendless.persistenceService save:orderItem response:^(OrderItem *result) {} error:^(Fault *fault) {}];
                }
            }
        }
                                       error:^(Fault *fault) {
                                           
                                       }];
    }
    
}

#pragma mark - MenuCellDelegate method

- (void) amountHasBeenChanged:(NSUInteger) amount forMeal: (Meal *)meal
{
    self.amount += amount;
    [self.amountLabel setText:[NSString stringWithFormat:@"%lu",(unsigned long)self.amount]];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.restaurant.meals.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Menu" forIndexPath:indexPath];
    
    Meal *meal = self.restaurant.meals[indexPath.row];
    
    cell.delegate = self;
    cell.meal = meal;
    [cell.name setText: [meal.name stringByAppendingString:@"  "]];
    [cell.price setText:[NSString stringWithFormat:@"%@ RSD", meal.price]];
    [cell.details setText:meal.description];
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"makeOrder"])
    {
        OrderDetailsViewController *odvc = (OrderDetailsViewController *)segue.destinationViewController;
        odvc.order = self.order;
    }
}

@end
