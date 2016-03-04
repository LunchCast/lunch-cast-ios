//
//  SubscriptionsTableViewController.m
//  LunchCast
//
//  Created by Marko Cancar on 3.3.16..
//  Copyright © 2016. Aleksandra Stevović. All rights reserved.
//

#import "SubscriptionsTableViewController.h"
#import "Backendless.h"
#import "Tag.h"

@interface SubscriptionsTableViewController ()

@property (nonatomic, strong)NSArray *tags;

@end

@implementation SubscriptionsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tags = [NSArray new];
    
    //basic search for Restaurants
    
    QueryOptions *queryOptions = [QueryOptions query];
    queryOptions.relationsDepth = @1;
    queryOptions.sortBy = @[@"name"];
    BackendlessDataQuery *dataQuery = [BackendlessDataQuery query];
    dataQuery.queryOptions = queryOptions;
    
    [backendless.persistenceService find:[Tag class]
                               dataQuery:dataQuery
                                response:^(BackendlessCollection *collection) {
                                    
                                    self.tags = collection.data;
                                    [self.tableView reloadData];
                                }
                                   error:^(Fault *fault) {
                                       
                                   }];

}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tags.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tagCell" forIndexPath:indexPath];
    
    // Configure the cell...
    Tag *tag = self.tags[indexPath.row];
    cell.textLabel.text = tag.name;
    
    return cell;
}



- (IBAction)saveButtonAction:(UIBarButtonItem *)sender
{
    
}

@end
