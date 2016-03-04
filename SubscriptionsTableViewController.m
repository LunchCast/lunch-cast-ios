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
#import "UIAlertController+EasyInit.h"

@interface SubscriptionsTableViewController ()

@property (nonatomic, strong)NSArray *tags;
@property (nonatomic, strong)UserSubscription *userSubscription;

@end

@implementation SubscriptionsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tags = [NSArray new];
    
//    BackendlessUser *user = backendless.userService.currentUser;
    
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
    
    
    [self getUserSubscription];
//    
//    [backendless.persistenceService find:[UserSubscription class]
//                               dataQuery:[BackendlessDataQuery query]
//                                response:^(BackendlessCollection *collection){
//                                    for (UserSubscription *userSub in collection.data) {
//                                        if ([userSub.userId isEqualToString: user.objectId]) {
//                                            self.userSubscription = userSub;
//                                            [self.tableView reloadData];
//                                        }
//                                    }
//                                }
//    error:^(Fault *fault) {}];
    
    

}
-(void)getUserSubscription
{
    BackendlessUser *user = backendless.userService.currentUser;

    BackendlessDataQuery *dataQuery = [BackendlessDataQuery query];
    dataQuery.whereClause = [NSString stringWithFormat:@"userId = \'%@\'", user.objectId];
    [backendless.persistenceService find:[UserSubscription class]
                               dataQuery:dataQuery
                                response:^(BackendlessCollection *collection){
                                    if ([collection.data count]) {
                                    self.userSubscription = [collection.data objectAtIndex:0];
                                    [self.tableView reloadData];
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
            [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
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
    
    NSMutableArray *tagsForDeleting = [NSMutableArray new];
    
    for (Tag *subTag in self.userSubscription.tags) {
        if ([subTag.objectId isEqualToString:tag.objectId]) {
            [tagsForDeleting addObject:subTag];
        }
    }
    
    [self.userSubscription.tags removeObjectsInArray:tagsForDeleting];
}

- (IBAction)saveButtonAction:(UIBarButtonItem *)sender
{
    [backendless.persistenceService first:[UserSubscription class]
                                 response:^(BackendlessEntity *result)
     {
         result.objectId = self.userSubscription.objectId;
         [backendless.persistenceService save:self.userSubscription response:^(UserSubscription *result)
         {
             [self dismissViewControllerAnimated:YES completion:nil];
         } error:^(Fault *fault)
          {
              [UIAlertController presentAlertViewErrorWithText:NSLocalizedString(fault.message, nil) andActionTitle:@"OK" onController:self withCompletion:nil];
          }];
     } error:^(Fault *fault)
     {
         [UIAlertController presentAlertViewErrorWithText:NSLocalizedString(fault.message, nil) andActionTitle:@"OK" onController:self withCompletion:nil];
     }];
}

- (IBAction)cancelButtonAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
