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
    [self customizeNavigationBar];
}

- (IBAction)logOutButtonAction:(UIBarButtonItem *)sender
{
    [[AccountManager sharedInstance] logOut];
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark Utilities

- (void)customizeNavigationBar
{
    self.navigationController.navigationBar.barTintColor = UIColorFromHex(lunchCastTintColor);
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor whiteColor],NSForegroundColorAttributeName,
                                    [UIColor whiteColor],NSBackgroundColorAttributeName,
                                    [UIFont fontWithName:@"HelveticaNeue-Thin" size:22.0], NSFontAttributeName,
                                    nil];
    
    self.navigationController.navigationBar.titleTextAttributes = textAttributes;
}
@end
