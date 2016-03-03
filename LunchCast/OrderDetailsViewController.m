//
//  OrderDetailsViewController.m
//  LunchCast
//
//  Created by Aleksandra Stevović on 2/19/16.
//  Copyright © 2016 Aleksandra Stevović. All rights reserved.
//

#import "OrderDetailsViewController.h"
#import "Backendless.h"

@interface OrderDetailsViewController() <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *bottomButton;
@property (weak, nonatomic) IBOutlet UIView *infoView;

@end

@implementation OrderDetailsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
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

@end
