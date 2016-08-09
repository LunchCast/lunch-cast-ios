//
//  SubscriptionCollectionViewController.m
//  LunchCast
//
//  Created by Aleksandra Stevovic on 6/27/16.
//  Copyright © 2016 Aleksandra Stevović. All rights reserved.
//

#import "SubscriptionCollectionViewController.h"
#import "Backendless.h"
#import "Tag.h"
#import "UserSubscription.h"
#import "BackendlessEntity.h"
#import "CustomCollectionViewCell.h"
#import "UIAlertController+EasyInit.h"
#import "UIColor+NewColorAdditions.h"

static const float defaultCellWidth = 120.0;
static const float defaultCellHeiht = 140.0;
static const float cellsSpacing = 15.0;

@interface SubscriptionCollectionViewController () <UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong)NSArray *tags;
@property (nonatomic, strong)UserSubscription *userSubscription;

@end

@implementation SubscriptionCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = [UIColor darkishPinkColor];
    self.navigationController.navigationBar.translucent  = NO;
    
    self.tags = [NSArray new];
    [self.collectionView setAllowsMultipleSelection:YES];
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
                                    [self.collectionView reloadData];
                                }
                                   error:^(Fault *fault) {
                                       
                                   }];
    
    
    [self getUserSubscription];
    
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
                                        [self.collectionView reloadData];
                                    }
                                }
                                   error:^(Fault *fault) {}];
    
}

#pragma mark - Collection view data source

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellWidth = self.view.frame.size.width/3.0;
    if(cellWidth < defaultCellWidth)
    {
        cellWidth = self.view.frame.size.width/2.0;
    }
    
    return CGSizeMake(cellWidth - cellsSpacing, defaultCellHeiht);
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.tags.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];
    
    // Configure the cell...
    Tag *tag = self.tags[indexPath.row];
    cell.tagLabel.text = tag.name;
    
    if ([self tagExsistsInUserSubscriptions:tag])
    {
        [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
        [cell selectCell];
    }
    else
    {
        [collectionView deselectItemAtIndexPath:indexPath animated:YES];
        [cell deselectCell];
    }
    
    return cell;
}

-(BOOL)tagExsistsInUserSubscriptions: (Tag *)tag
{
    for (Tag *tag1 in self.userSubscription.tags) {
        if ([tag.objectId isEqualToString:tag1.objectId]) {
            return YES;
        }
    }
    return NO;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCollectionViewCell *cell = (CustomCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell selectCell];
    Tag *tag = self.tags[indexPath.row];
    [self.userSubscription.tags addObject:tag];
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCollectionViewCell *cell = (CustomCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell deselectCell];
    Tag *tag = self.tags[indexPath.row];
    
    NSMutableArray *tagsForDeleting = [NSMutableArray new];
    
    for (Tag *subTag in self.userSubscription.tags) {
        if ([subTag.objectId isEqualToString:tag.objectId]) {
            [tagsForDeleting addObject:subTag];
        }
    }
    
    [self.userSubscription.tags removeObjectsInArray:tagsForDeleting];
}

#pragma mark - Button Actions

- (IBAction)onSaveButtonActipn:(UIButton *)sender
{
    }

- (IBAction)cancelButtonAction:(id)sender
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

@end
