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
#import "AccountData.h"
#import "MessagingService.h"
#import "BackendlessUser.h"

@interface OrderDetailsViewController() <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *userInfoView;
@property (weak, nonatomic) IBOutlet UIView *creatorInfoView;

@property (weak, nonatomic) IBOutlet UILabel *deliveryTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *creatorLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *sortedByLabel;

@property (weak, nonatomic) IBOutlet UIImageView *restaurantImage;

@property (weak, nonatomic) IBOutlet UIButton *cancelOrderButton;
@property (weak, nonatomic) IBOutlet UIButton *completeOrderButton;
@property (weak, nonatomic) IBOutlet UIButton *switchButton;
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
    [self.sortedByLabel setText:@"MEALS"];
    [self setupLabels];
    [self customizeCompleteButton];
    
    if ([self isOwner])
    {
        self.userInfoView.hidden = YES;
        self.creatorInfoView.hidden = NO;
        if ([self.order.state intValue] == 2) // Food is here
        {
            //food is here mode
            self.cancelOrderButton.hidden = YES;
            self.completeOrderButton.hidden = YES;
            self.navigationItem.rightBarButtonItem.enabled = NO;
        }
        else if ([self.order.state intValue] == 1) // Completed
        {
            self.cancelOrderButton.hidden = YES;
            self.completeOrderButton.hidden = NO;
            [self.completeOrderButton setTitle:@"FOOD IS HERE" forState:UIControlStateNormal];

            self.navigationItem.rightBarButtonItem.enabled = NO;
        }
        else if ([self.order.state intValue] == 0) // Open
        {
            self.cancelOrderButton.hidden = NO;
            self.completeOrderButton.hidden = NO;
            [self.completeOrderButton setTitle:@"COMPLETE ORDER" forState:UIControlStateNormal];
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }
    }
    else
    {
        self.userInfoView.hidden = NO;
        self.creatorInfoView.hidden =YES;
        
        self.cancelOrderButton.hidden = YES;
        self.completeOrderButton.hidden = YES;
        [self.switchButton setEnabled:NO];
        
        if ([self.order.state intValue] == 1) {
            self.navigationItem.rightBarButtonItem.enabled = NO;
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [self requestOrderItems];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(personJoinedOrder)
                                                 name:@"PersonJoinedOrder"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orderIsClosed)
                                                 name:@"OrderIsClosed"
                                               object:nil];
}

- (void)setupLabels
{
    [self.restaurantImage setImage:[UIImage imageNamed:self.order.restaurant.image]];
    self.deliveryTimeLabel.text = [NSString stringWithFormat:@"ETA: %@'", self.order.restaurant.eta];
    self.creatorLabel.text = self.order.order_creator.name;
    
    NSString *priceString = @"";
//    NSInteger currentPrice = 0;
    NSInteger minPrice = [self.order.restaurant.minAmount integerValue];

    priceString = [NSString stringWithFormat:@"Minimum for delivery: %ld €", minPrice];
    self.orderStatusLabel.text = priceString;
//    self.orderStatusLabel.textColor = (currentPrice < minPrice) ? [UIColor redColor] : [UIColor whiteColor];
    
    self.currentPriceLabel.text = @"0";
}
-(void)customizeCompleteButton
{
    [self.completeOrderButton.layer setCornerRadius: 3.0f];
    [self.completeOrderButton.layer setBorderWidth: 1.5f];
    [self.completeOrderButton.layer setBorderColor:[UIColor whiteColor].CGColor];
}

- (void)setPricesForItems:(NSArray *)orderItems
{
    NSString *priceString = @"";
    NSInteger currentPrice = 0;
    NSInteger minPrice = [self.order.restaurant.minAmount integerValue];
    for (OrderItem *o in orderItems)
    {
        currentPrice += [o.meal.price integerValue] * [o.quantity integerValue];
    }
    priceString = [NSString stringWithFormat:@"Minimum for delivery: %ld €", minPrice];
    self.orderStatusLabel.text = priceString;
//    self.orderStatusLabel.textColor = (currentPrice < minPrice) ? [UIColor redColor] : [UIColor whiteColor];
    self.currentPriceLabel.text =[NSString stringWithFormat:@"%ld", currentPrice];
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
                NSString *format = [NSString stringWithFormat:@", x%d %@", [oi.quantity intValue], oi.meal.name];
                personGroup.meals = [personGroup.meals stringByAppendingString:format];
                personGroup.totalPrice += [oi.meal.price intValue] * [oi.quantity intValue];
                break;
            }
        }
        if (noPerson)
        {
            GroupByPerson *newGroup = [[GroupByPerson alloc] init];
            newGroup.orderer = oi.orderer;
            NSString *format = [NSString stringWithFormat:@"Meals: x%d %@", [oi.quantity intValue], oi.meal.name];
            newGroup.meals = format;
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
    [self deleteOrderAndPop];
}

- (void)deleteOrderAndPop
{
    self.order.state = [NSNumber numberWithInt:2];
    self.completeOrderButton.hidden = YES;
    [backendless.persistenceService first:[Order class]
                                 response:^(BackendlessEntity *result) {
                                     result.objectId = self.order.objectId;
                                     [backendless.persistenceService save:self.order response:^(Order *result) {
                                         [self.navigationController popViewControllerAnimated:YES];
                                         [self notifyOrderClosed];
                                     } error:^(Fault *fault) {
                                     }];
                                 } error:^(Fault *fault) {
                                 }];
}

- (IBAction)completeOrderButtonAction:(id)sender
{
    if ([self.order.state integerValue] == 1)
    {
        [self deleteOrderAndPop];
    }
    else
    {
        self.order.state = [NSNumber numberWithInt:1];
        self.completeOrderButton.hidden = YES;
        [backendless.persistenceService first:[Order class]
                                     response:^(BackendlessEntity *result) {
                                         result.objectId = self.order.objectId;
                                         [backendless.persistenceService save:self.order response:^(Order *result) {
                                             self.creatorLabel.hidden = YES;
                                             self.cancelOrderButton.hidden = YES;
                                             self.completeOrderButton.hidden = NO;
                                             [self.completeOrderButton setTitle:@"FOOD IS HERE" forState:UIControlStateNormal];
                                             self.navigationItem.rightBarButtonItem.enabled = NO;
                                             [self notifyOrderClosed];
                                         } error:^(Fault *fault) {
                                         }];
                                     } error:^(Fault *fault) {
                                     }];
    }
}


- (IBAction)pokeButtonAction:(id)sender
{

}


- (IBAction)switchButtonAction:(id)sender
{
    self.groupByName = !self.groupByName;
    [self.sortedByLabel setText:self.groupByName ? @"PEOPLE" : @"MEALS"];
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
        cell.priceLabel.text = [NSString stringWithFormat:@"%d €", ([mealGroup.meal.price intValue] * mealGroup.quantity)];
    }
    else
    {
        GroupByPerson *personGroup = self.personGroups[indexPath.row];
        
        cell.titleLabel.text = personGroup.orderer.name;
        cell.descriptionLabel.text = personGroup.meals;
        cell.priceLabel.text = [NSString stringWithFormat:@"%d €", personGroup.totalPrice];
    }
    
    return cell;
}

#pragma mark - Utilities

- (BOOL)isOwner
{
    return ([self.order.order_creator.email isEqualToString:backendless.userService.currentUser.email]);
}

- (void)personJoinedOrder
{
    [self requestOrderItems];
}

- (void)orderIsClosed
{
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
//    if ([self isOwner])
//    {
//        [self.addMealButton setImage:[UIImage imageNamed:@"food-is-here"] forState:UIControlStateNormal];
//    }
//    else
//    {
//        self.addMealButton.enabled = NO;
//        self.addMealButton.alpha = 0.4;
//    }
}

- (void)notifyOrderClosed
{
    BackendlessDataQuery *dataQuery = [BackendlessDataQuery query];
    
    [backendless.persistenceService find:[BackendlessUser class]
                               dataQuery:dataQuery
                                response:^(BackendlessCollection *collection)
     {
         NSArray *results = collection.data;
         NSMutableArray *devices = [NSMutableArray array];
         
         for (BackendlessUser *user in results)
         {
             [devices addObject:[user getProperty:@"deviceId"]];
         }
         
         DeliveryOptions *deliveryOptions = [DeliveryOptions new];
         deliveryOptions.pushSinglecast = devices;
         [deliveryOptions pushPolicy:PUSH_ONLY];
         
         PublishOptions *publishOptions = [PublishOptions new];
         [backendless.messagingService publish:@"default" message:@"Order is closed." publishOptions:publishOptions deliveryOptions:deliveryOptions
                                      response:^(MessageStatus *messageStatus)
          {
              NSLog(@"MessageStatus = %@ <%@>", messageStatus.messageId, messageStatus.status);
          } error:^(Fault *fault)
          {
              NSLog(@"FAULT = %@", fault);
          }
          ];
     }
                                   error:^(Fault *fault)
     {
         NSLog(@"Error: %@", fault);
     }];
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