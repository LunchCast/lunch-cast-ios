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
#import "UserSubscription.h"
#import "BackendlessEntity.h"

@interface SubscriptionsTableViewController ()

@property (nonatomic, strong)NSArray *tags;
@property (nonatomic, strong)UserSubscription *userSubscription;

@end

@implementation SubscriptionsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tags = [NSArray new];
    
    BackendlessUser *user = backendless.userService.currentUser;
    
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
    
    [backendless.persistenceService find:[UserSubscription class]
                               dataQuery:[BackendlessDataQuery query]
                                response:^(BackendlessCollection *collection){
                                    for (UserSubscription *userSub in collection.data) {
                                        if ([userSub.userId isEqualToString: user.objectId]) {
                                            self.userSubscription = userSub;
                                            [self.tableView reloadData];
                                        }
                                    }
                                }
    error:^(Fault *fault) {}];
    
    

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
    
    for (Tag *tag1 in self.userSubscription.tags) {
        if ([tag1.objectId isEqualToString:tag.objectId]) {
            [cell setSelected:YES];
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Tag *tag = self.tags[indexPath.row];
    [self.userSubscription.tags addObject:tag];
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Tag *tag = self.tags[indexPath.row];
    [self.userSubscription.tags removeObject:tag];
}

- (IBAction)saveButtonAction:(UIBarButtonItem *)sender
{
    [backendless.persistenceService first:[UserSubscription class]
                                 response:^(BackendlessEntity *result) {
                                     result.objectId = self.userSubscription.objectId;
                                     [backendless.persistenceService save:self.userSubscription response:^(UserSubscription *result) {
                                     } error:^(Fault *fault) {}];
                                 } error:^(Fault *fault) {}];
}


@end
