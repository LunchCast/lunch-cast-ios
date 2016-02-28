//
//  MyProfileViewController.m
//  LunchCast
//
//  Created by Marko Čančar on 28.2.16..
//  Copyright © 2016. Aleksandra Stevović. All rights reserved.
//

#import "MyProfileViewController.h"
#import "Utilities.h"

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
}

- (IBAction)saveButtonAction:(UIBarButtonItem *)sender
{
    // update
    [self.navigationController popViewControllerAnimated:YES];
}


@end
