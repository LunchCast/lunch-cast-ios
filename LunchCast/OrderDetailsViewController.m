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

@end

@implementation OrderDetailsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self setupLabels];

}

- (void)setupLabels
{
    self.descriptionLabel.text = self.order.description;
    self.deliveryTimeLabel.text = self.order.order_time;
    self.minimumForOrderLabel.text = [NSString stringWithFormat:@"%@ rsd", self.order.restaurant.minAmount];
    self.creatorLabel.text = self.order.order_creator.name;

    [self setTags];
    [self setPrices];
}

- (void)setTags
{
    BackendlessDataQuery *dataQuery = [BackendlessDataQuery query];
    dataQuery.whereClause = [NSString stringWithFormat:@"restaurantId = \'%@\'", self.order.restaurant.objectId];
    [backendless.persistenceService find:[Tag class]
                               dataQuery:dataQuery
                                response:^(BackendlessCollection *collection){
                                    if ([collection.data count]) {
                                        NSArray *tags = [NSArray arrayWithArray:collection.data];
                                        NSString *tagString = @"";
                                        for (Tag *t in tags)
                                        {
                                            NSString *name = [NSString stringWithFormat:@"#%@ ", t.name];
                                            tagString = [tagString stringByAppendingString:name];
                                        }
                                    }
                                }
                                   error:^(Fault *fault) {
                                       NSLog(@"Failed to retrieve tags with error: %@", fault.message);
                                   }];
}

- (void)setPrices
{
    
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


#pragma mark - Table view delegate & data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
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
