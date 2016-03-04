//
//  OrderDetailsViewController.m
//  LunchCast
//
//  Created by Aleksandra Stevović on 2/19/16.
//  Copyright © 2016 Aleksandra Stevović. All rights reserved.
//

#import "OrderDetailsViewController.h"
#import "Backendless.h"
#import "Restaurant.h"
#import "Tag.h"
#import "MenuViewController.h"
#import "OrderItem.h"
#import "Meal.h"
#import "GroupTableViewCell.h"

@interface OrderDetailsViewController() <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *deliveryTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *minimumForOrderLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagsLabel;
@property (weak, nonatomic) IBOutlet UILabel *creatorLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentPriceLabel;

@property (weak, nonatomic) IBOutlet UIButton *cancelOrderButton;
@property (weak, nonatomic) IBOutlet UIButton *completeOrderButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *switchButton;
@property (weak, nonatomic) IBOutlet UIButton *pokeButton;

@property (nonatomic, strong)NSArray *orderItems;

@end

@implementation OrderDetailsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    [self setupLabels];
    [self requestOrderItems];
    if ([self isOwner])
    {
        self.creatorLabel.hidden = YES;
    }
    else
    {
        self.cancelOrderButton.hidden = YES;
        self.completeOrderButton.hidden = YES;
        [self.switchButton setEnabled:NO];
        [self.switchButton setTintColor: [UIColor clearColor]];
        self.pokeButton.hidden = YES;
    }
}

- (void)setupLabels
{
    self.descriptionLabel.text = [NSString stringWithFormat:@"Ordering from %@", self.order.restaurant.name];
    self.deliveryTimeLabel.text = [NSString stringWithFormat:@"ETA: %@ mins", self.order.restaurant.eta];
    self.minimumForOrderLabel.text = [NSString stringWithFormat:@"Minimum: %@ RSD", self.order.restaurant.minAmount];
    self.creatorLabel.text = [NSString stringWithFormat:@"Created by: %@", self.order.order_creator.name];
    NSString *prePriceString = [NSString stringWithFormat:@"Total: 0/%@ RSD", self.order.restaurant.minAmount];
    self.currentPriceLabel.text = prePriceString;
    
    [self setTags];
}

- (void)setTags
{
    NSString *tagString = @"";
    for (Tag *t in self.order.restaurant.tags)
    {
        NSString *name = [NSString stringWithFormat:@"#%@ ", t.name];
        tagString = [tagString stringByAppendingString:name];
    }
    self.tagsLabel.text = tagString;
}

- (void)setPricesForItems:(NSArray *)orderItems
{
    NSString *priceString = @"";
    int currentPrice = 0;
    for (OrderItem *o in orderItems)
    {
        currentPrice += [o.meal.price intValue];
        currentPrice *= [o.quantity intValue];
    }
    priceString = [NSString stringWithFormat:@"Total: %d/%@ RSD", currentPrice, self.order.restaurant.minAmount];
    self.currentPriceLabel.text = priceString;
}

- (void)orderItemsReceived:(NSArray *)orderItems
{
    [self setPricesForItems:orderItems];
    self.orderItems = [NSArray arrayWithArray:orderItems];
    [self.tableView reloadData];
}

- (void)requestOrderItems
{
    BackendlessDataQuery *dataQuery = [BackendlessDataQuery query];
    dataQuery.whereClause = [NSString stringWithFormat:@"order_id.objectId = \'%@\'", self.order.objectId];
    [backendless.persistenceService find:[OrderItem class]
                               dataQuery:dataQuery
                                response:^(BackendlessCollection *collection){
                                    NSArray *orderItems = [NSArray arrayWithArray:collection.data];
                                    [self orderItemsReceived:orderItems];
                                }
                                   error:^(Fault *fault) {
                                       NSLog(@"Failed to retrieve tags with error: %@", fault.message);
                                   }];
    
}

- (IBAction)cancelOrderButtonAction:(id)sender
{
    
}

- (IBAction)completeOrderButtonAction:(id)sender
{
    
}

- (IBAction)pokeButtonAction:(id)sender
{
    
}

- (IBAction)switchButtonAction:(id)sender
{

}

#pragma mark - Table view delegate & data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.orderItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"groupCell" forIndexPath:indexPath];

    OrderItem *item = self.orderItems[indexPath.row];
    cell.titleLabel.text = [NSString stringWithFormat:@"x%d %@", [item.quantity intValue], item.meal.name];
    cell.descriptionLabel.text = item.orderer.name;
    cell.priceLabel.text = [NSString stringWithFormat:@"%d RSD", ([item.meal.price intValue] * [item.quantity intValue])];
    
    return cell;
}

#pragma mark - Utilities

- (BOOL)isOwner
{
    return ([self.order.order_creator.email isEqualToString:backendless.userService.currentUser.email]);
}

#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toMenu"])
    {
        MenuViewController *mvc = (MenuViewController *)segue.destinationViewController;
        mvc.restaurant = self.order.restaurant;
        mvc.orderCreated = NO;
    }
}


@end
