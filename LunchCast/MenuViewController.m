//
//  RestaurantMenuViewController.m
//  LunchCast
//
//  Created by Aleksandra Stevović on 2/19/16.
//  Copyright © 2016 Aleksandra Stevović. All rights reserved.
//

#import "MenuViewController.h"
#import "Backendless.h"
#import "MenuCell.h"

@interface MenuViewController() <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray * searchResults;
@end

@implementation MenuViewController



-(void)viewDidLoad
{
    [super viewDidLoad];
//    
//    self.searchResults = [NSArray new];
//    
//    //basic search for Restaurants
//    
//    QueryOptions *queryOptions = [QueryOptions query];
//    queryOptions.relationsDepth = @1;
//    BackendlessDataQuery *dataQuery = [BackendlessDataQuery query];
//    dataQuery.queryOptions = queryOptions;
//    
//    [backendless.persistenceService find:[Restaurant class]
//                               dataQuery:dataQuery
//                                response:^(BackendlessCollection *collection) {
//                                    
//                                    self.searchResults = collection.data;
//                                    [self.tableView reloadData];
//                                }
//                                   error:^(Fault *fault) {
//                                       
//                                   }];
//    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;//self.searchResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Menu" forIndexPath:indexPath];
    
    
    return cell;
}


@end
