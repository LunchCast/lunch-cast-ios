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

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *menuLabel;
@property (weak, nonatomic) IBOutlet UILabel *etaLabel;
@property (weak, nonatomic) IBOutlet UILabel *minLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagsLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;

@property (nonatomic) NSUInteger amount;

@property (nonatomic, strong) NSMutableArray *alreadyOrderedItems;

@end

@implementation MenuViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem.title = self.isOrderCreated ? @"Add" : @"Create";
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setRestaurantDetails];
}

-(void)setRestaurantDetails
{
    NSString *meals = @"";
    for(Meal *meal in self.restaurant.meals)
    {
        meals = [meals stringByAppendingString:meal.name];
        meals = [meals stringByAppendingString:@"; "];
    }
    
    [self.menuLabel setText:meals];
    [self.etaLabel setText:[NSString stringWithFormat:@"Delivery time: %@ min",self.restaurant.eta]];
    [self.minLabel setText:[NSString stringWithFormat:@"Minimum for order: %@ RSD", self.restaurant.minAmount]];
    
    NSString *tags = @"";
    for(Tag *tag in self.restaurant.tags)
    {
        tags = [tags stringByAppendingString:@" #"];
        tags = [tags stringByAppendingString:tag.name];
    }
    [self.tagsLabel setText:tags];
    
    self.alreadyOrderedItems = [NSMutableArray array];
    
    BackendlessDataQuery *dataQuery = [BackendlessDataQuery query];
    dataQuery.whereClause = [NSString stringWithFormat:@"order_id.objectId = \'%@\' AND orderer.objectId = \'%@\'",
                             self.order.objectId,
                             backendless.userService.currentUser.objectId];
    
    [backendless.persistenceService find:[OrderItem class]
                               dataQuery:dataQuery
                                response:^(BackendlessCollection *collection){
                                    [self.alreadyOrderedItems addObjectsFromArray:collection.data];
                                    if (self.alreadyOrderedItems.count > 0) {
                                        self.navigationItem.rightBarButtonItem.title = @"Save";
                                    }
                                    [self.tableView reloadData];
                                }
                                   error:^(Fault *fault) {}];
    
}
- (void)startWaiting
{
    [self.view setUserInteractionEnabled:NO];
    
    for (UIView *v in self.view.subviews)
        [v setAlpha:0.5];
    
    [self.activityIndicator startAnimating];
}

- (void)stopWaitingAndPop
{
        [self.view setUserInteractionEnabled:YES];
        
        for (UIView *v in self.view.subviews)
            [v setAlpha:1.0];
        
        [self.activityIndicator stopAnimating];
        
        if (self.isOrderCreated)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [self dismissViewControllerAnimated:YES completion:^{
                [self.presentingViewController performSegueWithIdentifier:@"toOrders" sender:nil];
            }];
        }
}

- (IBAction)onCreateOrder:(UIBarButtonItem *)sender
{
    [self startWaiting];
    
    if (self.isOrderCreated) // Adding items to existing order
    {
        if (self.alreadyOrderedItems.count > 0)
        {
            // Remove all items for user and order
            [self removeOrderItems];
        }
        [self addItemsToOrder];
    }
    else // Create new order
    {
        Order *order = [Order new];
        order.order_time = [backendless randomString:MIN(25,36)];
        order.state = [NSNumber numberWithInt:0];
        order.restaurant = self.restaurant;
        order.order_creator = backendless.userService.currentUser;
        [backendless.persistenceService save:order response:^(Order *createdOrder)
         {
             self.order = createdOrder;
             [self addItemsToOrder];
             
         } error:^(Fault *fault)
         {
             //TODO: Handle error in a distant, distant future...
             NSLog(@"Failed to create Order: %@", fault);
             [self stopWaitingAndPop];
         }];
    }
}

- (NSMutableArray *)harvestItems
{
    NSMutableArray *orderItems = [NSMutableArray array];
    
    for (MenuCell *cell in [self.tableView visibleCells])
    {
        if (cell.amount!=0) {
            OrderItem *orderItem = [OrderItem new];
            orderItem.quantity = [NSNumber numberWithInteger: cell.amount];
            orderItem.meal = cell.meal;
            orderItem.order_id = self.order;
            orderItem.orderer = backendless.userService.currentUser;
            [orderItems addObject:orderItem];
        }
    }
    return orderItems;
}

-(void)addItemsToOrder
{
    NSMutableArray *orderItems = [self harvestItems];
    if (orderItems.count == 0) [self stopWaitingAndPop];
    
    PersistenceService *service = backendless.persistenceService;
    
    __block NSUInteger successCnt = 0;
    for (OrderItem *i in orderItems)
    {
        [service save:i response:^(OrderItem *result)
         {
             // Send notification after all items are saved
             successCnt++;
             if (successCnt == orderItems.count) //TODO: Add timeout?
             {
                 [self sendAsyncNotification];
                 [self stopWaitingAndPop];
             }
         } error:^(Fault *fault)
         {
             NSLog(@"Failed to save OrderItem: %@", fault);
             [self stopWaitingAndPop];
             //TODO: Handle this error in a distant future...
         }];
    }
}

-(void)removeOrderItems
{
    Fault *fault;
    for (OrderItem *orderItem in self.alreadyOrderedItems)
    {
        id<IDataStore> dataStore = [backendless.persistenceService of:[OrderItem class]];
        [dataStore remove:orderItem fault:&fault]; // Synchronous
        if (fault)
        {
            NSLog(@"Failed to delete Order Item");
            [self stopWaitingAndPop];
            //TODO: Handle this error in a distant future...
        }
    }
}

- (void)sendAsyncNotification
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                   ^{
                       BackendlessDataQuery *dataQuery = [BackendlessDataQuery query];
                       
                       [backendless.persistenceService find:[BackendlessUser class]
                                                  dataQuery:dataQuery
                                                   response:^(BackendlessCollection *collection){
                                                       if ([collection.data count])
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
                                                           
                                                           [backendless.messagingService
                                                            publish:@"default"
                                                            message:@"Person joined order."
                                                            publishOptions:publishOptions
                                                            deliveryOptions:deliveryOptions
                                                            response:^(MessageStatus *messageStatus)
                                                            {
                                                                NSLog(@"MessageStatus = %@ <%@>", messageStatus.messageId, messageStatus.status);
                                                            } error:^(Fault *fault)
                                                            {
                                                                NSLog(@"FAULT = %@", fault);
                                                            }];
                                                       }
                                                       
                                                   }
                                                      error:^(Fault *fault)
                        {
                            NSLog(@"Error: %@", fault);
                        }];
                   });
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
    [cell.details setText:meal.mealDescription];
    
    for (OrderItem *orderIt in self.alreadyOrderedItems) {
        if ([orderIt.meal.objectId isEqualToString:meal.objectId]) {
            cell.amount = [orderIt.quantity intValue];
        }
    }
    
    return cell;
}

@end
