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

@property (nonatomic, strong)NSMutableArray *mealGroups;
@property (nonatomic, strong)NSMutableArray *personGroups;


@property (nonatomic)BOOL groupByName;

@end

@implementation OrderDetailsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    self.groupByName = NO;
    self.switchButton.title = @"Group by Persons";
    
    [self setupLabels];
    
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

- (void)viewWillAppear:(BOOL)animated
{
    [self requestOrderItems];
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
        currentPrice += [o.meal.price intValue] * [o.quantity intValue];
    }
    priceString = [NSString stringWithFormat:@"Total: %d/%@ RSD", currentPrice, self.order.restaurant.minAmount];
    self.currentPriceLabel.text = priceString;
}

- (void)orderItemsReceived:(NSArray *)orderItems
{
    [self setPricesForItems:orderItems];
    self.orderItems = [NSArray arrayWithArray:orderItems];
    
    self.mealGroups = [NSMutableArray array];
    self.personGroups = [NSMutableArray array];

    
    for (OrderItem *oi in orderItems)
    {
        // Load groups by Meals
        BOOL noMeal = YES;
        for (int i=0; i<self.mealGroups.count; i++)
        {
            GroupByMeal *mealGroup = self.mealGroups[i];
            if ([oi.meal.name isEqualToString:mealGroup.meal.name])
            {
                noMeal = NO;
                NSString *format = [NSString stringWithFormat:@", %@", oi.orderer.name];
                mealGroup.orderers = [mealGroup.orderers stringByAppendingString:format];
                mealGroup.quantity += [oi.quantity intValue];
                break;
            }
        }
        if (noMeal)
        {
            GroupByMeal *newGroup = [[GroupByMeal alloc] init];
            newGroup.meal = oi.meal;
            newGroup.orderers = oi.orderer.name;
            newGroup.quantity += [oi.quantity intValue];
            [self.mealGroups addObject:newGroup];
        }
        
        
        
        // Load groups by Persons
        BOOL noPerson = YES;
        for (int i=0; i<self.personGroups.count; i++)
        {
            GroupByPerson *personGroup = self.personGroups[i];
            if ([oi.orderer.email isEqualToString:personGroup.orderer.email])
            {
                noPerson = NO;
                NSString *format = [NSString stringWithFormat:@", %@", oi.meal.name];
                personGroup.meals = [personGroup.meals stringByAppendingString:format];
                personGroup.totalPrice += [oi.meal.price intValue] * [oi.quantity intValue];
                break;
            }
        }
        if (noPerson)
        {
            GroupByPerson *newGroup = [[GroupByPerson alloc] init];
            newGroup.orderer = oi.orderer;
            newGroup.meals = oi.meal.name;
            newGroup.totalPrice = [oi.meal.price intValue] * [oi.quantity intValue];
            [self.personGroups addObject:newGroup];
        }
    }
    
    
    
    
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
    self.groupByName = !self.groupByName;
    self.switchButton.title = self.groupByName ? @"Group by Meals" : @"Group by Persons";
    [self.tableView reloadData];
}

#pragma mark - Table view delegate & data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.groupByName ? self.personGroups.count : self.mealGroups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"groupCell" forIndexPath:indexPath];

    if (!self.groupByName)
    {
        GroupByMeal *mealGroup = self.mealGroups[indexPath.row];
        
        cell.titleLabel.text = [NSString stringWithFormat:@"x%d %@", mealGroup.quantity, mealGroup.meal.name];
        cell.descriptionLabel.text = mealGroup.orderers;
        cell.priceLabel.text = [NSString stringWithFormat:@"%d RSD", ([mealGroup.meal.price intValue] * mealGroup.quantity)];
    }
    else
    {
        GroupByPerson *personGroup = self.personGroups[indexPath.row];
        
        cell.titleLabel.text = personGroup.orderer.name;
        cell.descriptionLabel.text = personGroup.meals;
        cell.priceLabel.text = [NSString stringWithFormat:@"%d RSD", personGroup.totalPrice];
    }
    
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
        mvc.order = self.order;
        mvc.orderCreated = YES;
    }
}



@end


@implementation GroupByMeal

@end

@implementation GroupByPerson

@end