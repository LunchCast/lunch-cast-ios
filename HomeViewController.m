//
//  HomeViewController.m
//  LunchCast
//
//  Created by Aleksandra Stevović on 2/19/16.
//  Copyright © 2016 Aleksandra Stevović. All rights reserved.
//

#import "HomeViewController.h"
#import "UIColor+NewColorAdditions.h"
#import "AccountManager.h"
#import "Utilities.h"

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"Back" style: UIBarButtonItemStylePlain target: nil action: nil];
    self.navigationController.navigationBar.barTintColor = [UIColor darkishPinkColor];
    self.navigationController.navigationBar.translucent  = NO;
}

- (IBAction)logOutButtonAction:(UIBarButtonItem *)sender
{
    [[AccountManager sharedInstance] logOut];
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
