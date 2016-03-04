//
//  HomeViewController.m
//  LunchCast
//
//  Created by Aleksandra Stevović on 2/19/16.
//  Copyright © 2016 Aleksandra Stevović. All rights reserved.
//

#import "HomeViewController.h"
#import "AccountManager.h"
#import "Utilities.h"

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)logOutButtonAction:(UIBarButtonItem *)sender
{
    [[AccountManager sharedInstance] logOut];
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
