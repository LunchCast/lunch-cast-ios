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
    
    BackendlessUser *user = backendless.userService.currentUser;
    
    BackendlessDataQuery *dataQuery = [BackendlessDataQuery query];
    dataQuery.whereClause = [NSString stringWithFormat:@"order_id.objectId = \'%@\' AND orderer.objectId = \'%@\'", self.order.objectId, user.objectId];
    
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

- (IBAction)onCreateOrder:(UIBarButtonItem *)sender
{
    
    BackendlessUser *user = backendless.userService.currentUser;
    
    if (self.alreadyOrderedItems.count > 0)
    {
        //delete all OrderItems for user and order
        for (OrderItem *orderIt in self.alreadyOrderedItems) {
            [self deleteOrderItem:orderIt];
        }
    
        //create new orderItems for user and order
        [self createNewOrderItemsForOrder:self.order andUser:user];        
    }
    else
    {
        if (self.isOrderCreated)
        {
//            [self performSegueWithIdentifier:@"makeOrder" sender:nil];
            [self createNewOrderItemsForOrder:self.order andUser:user];
        }
        else
        {
            Order *order = [Order new];
            order.order_time = [backendless randomString:MIN(25,36)];
            order.state = [NSNumber numberWithInt:0];
            order.restaurant = self.restaurant;
            order.order_creator = user;
            [backendless.persistenceService save:order response:^(Order *result) {
                self.order = result;
                [self createNewOrderItemsForOrder:self.order andUser:user];
                [self dismissViewControllerAnimated:YES completion:^{
                    [self.presentingViewController performSegueWithIdentifier:@"toOrders" sender:nil];
                }];
                
                }
                                           error:^(Fault *fault) {}];
        }
    }
    
}

-(void)createNewOrderItemsForOrder: (Order *)order andUser: (BackendlessUser *)user
{
    for (int i=0; i < [self.tableView visibleCells].count; i++)
    {
        MenuCell *cell = [self.tableView visibleCells][i];
        if (cell.amount!=0) {
            OrderItem *orderItem = [OrderItem new];
            orderItem.quantity = [NSNumber numberWithInteger: cell.amount];
            orderItem.meal = cell.meal;
            orderItem.order_id = order;
            orderItem.orderer = user;
            [backendless.persistenceService save:orderItem response:^(OrderItem *result)
             {
             } error:^(Fault *fault) {}];
        }
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self sendNotificationToOwner];
    });
}

-(void)deleteOrderItem:(OrderItem *)orderItem
{
    Responder *responder = [Responder responder:self
                             selResponseHandler:@selector(responseHandler:)
                                selErrorHandler:@selector(errorHandler:)];
    id<IDataStore> dataStore = [backendless.persistenceService of:[OrderItem class]];
    [dataStore remove:orderItem responder:responder];
}

- (void)sendNotificationToOwner
{
    
    BackendlessUser *owner = self.order.order_creator;
    
    BackendlessDataQuery *dataQuery = [BackendlessDataQuery query];
    dataQuery.whereClause = [NSString stringWithFormat:@"objectId = \'%@\'", owner.objectId];
    [backendless.persistenceService find:[BackendlessUser class]
                               dataQuery:dataQuery
                                response:^(BackendlessCollection *collection){
                                    if ([collection.data count]) {
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
                                        [backendless.messagingService publish:@"default" message:@"SomeoneJoinedOrder" publishOptions:publishOptions deliveryOptions:deliveryOptions
                                                                     response:^(MessageStatus *messageStatus)
                                         {
                                             NSLog(@"MessageStatus = %@ <%@>", messageStatus.messageId, messageStatus.status);
                                         } error:^(Fault *fault)
                                         {
                                             NSLog(@"FAULT = %@", fault);
                                         }
                                         ];
                                        
                                        
                                    }
                                }
                                   error:^(Fault *fault)
     {
         NSLog(@"WTF");
     }];
    
    

}

#pragma mark - responder
-(id)responseHandler:(id)response
{
    NSLog(@"%@", response);
    return response;
}
-(id)errorHandler:(Fault *)fault
{
    return fault;
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
