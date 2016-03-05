//
//  MyProfileViewController.m
//  LunchCast
//
//  Created by Marko Čančar on 28.2.16..
//  Copyright © 2016. Aleksandra Stevović. All rights reserved.
//

#import "MyProfileViewController.h"
#import "Utilities.h"
#import "BackendLess.h"
#import "AccountData.h"

@interface MyProfileViewController()

@property (weak, nonatomic) IBOutlet UILabel *labelEmail;
@property (weak, nonatomic) IBOutlet UITextField *textFieldName;
@property (weak, nonatomic) IBOutlet UILabel *labelOrdersDone;
@property (weak, nonatomic) IBOutlet UILabel *labelFavoriteFood;
@property (weak, nonatomic) IBOutlet UILabel *labelFavoriteRestaurant;

@end


@implementation MyProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    BackendlessUser *user = backendless.userService.currentUser;
    self.textFieldName.text = user.name.length ==0 ? @"User" : user.name;
    self.labelEmail.text = user.email;
}

- (IBAction)saveButtonAction:(UIBarButtonItem *)sender
{
    BackendlessUser *user = backendless.userService.currentUser;
    
    [backendless.userService
          update:user
          response:^(BackendlessUser *updatedUser) {
              NSLog(@"User has been updated (ASYNC): %@", updatedUser);
              [user updateProperties:@{@"name" : self.textFieldName.text}];
          }
          error:^(Fault *fault) {
              NSLog(@"Server reported an error (ASYNC): %@", fault);
          }];
    
    [self.textFieldName resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
