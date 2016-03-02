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
#import "Tag.h"

@interface MenuViewController() <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *menuLabel;
@property (weak, nonatomic) IBOutlet UILabel *etaLabel;
@property (weak, nonatomic) IBOutlet UILabel *minLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagsLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;


@property (nonatomic,strong) Order *order;

@end

@implementation MenuViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
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
    
    [cell.name setText: [meal.name stringByAppendingString:@"  "]];
    [cell.price setText:[NSString stringWithFormat:@"%@ RSD", meal.price]];
    [cell.details setText:meal.description];
    
    return cell;
}

- (IBAction)onCreateOrder:(UIBarButtonItem *)sender
{
    Order *order = [Order new];
    order.order_time = [backendless randomString:MIN(25,36)];
    order.state = [NSNumber numberWithInt:0];
    order.restaurant = self.restaurant;
    BackendlessUser *user = backendless.userService.currentUser;
    order.order_creator = user;
    [backendless.persistenceService save:order response:^(Order *result) {
        self.order = order;
        [self performSegueWithIdentifier:@"makeOrder" sender:nil];
        
    }
                                   error:^(Fault *fault) {
                                       
                                   }];
    
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
