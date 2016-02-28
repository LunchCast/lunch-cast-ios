//
//  CreateOrderViewController.m
//  LunchCast
//
//  Created by Aleksandra Stevović on 2/19/16.
//  Copyright © 2016 Aleksandra Stevović. All rights reserved.
//

#import "CreateOrderViewController.h"
#import "Backendless.h"
#import "Restaurant.h"

@interface CreateOrderViewController()

@property (strong, nonatomic) NSArray * searchResults;

@end

@implementation CreateOrderViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.searchResults = [NSArray new];
    
    //basic search for Restaurants
    
    QueryOptions *queryOptions = [QueryOptions query];
    queryOptions.relationsDepth = @1;
    BackendlessDataQuery *dataQuery = [BackendlessDataQuery query];
    dataQuery.queryOptions = queryOptions;
    
    [backendless.persistenceService find:[Restaurant class]
                               dataQuery:dataQuery
                                response:^(BackendlessCollection *collection) {
    
         self.searchResults = collection.data;
     }
     error:^(Fault *fault) {
         
     }];


}

- (IBAction)onCreateOrder:(id)sender {
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PropertyCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = @"akgnkjangklangklangklnakglnaklgnak";// self.searchResults[indexPath.row];
    return cell;
}

@end
