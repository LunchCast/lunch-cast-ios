//
//  SignInVC.m
//  NomNom
//
//  Created by Marko Čančar on 8/23/15.
//  Copyright © 2015 12Rockets. All rights reserved.
//

#import "SignInVC.h"
#import "Validator.h"
#import "UIAlertController+EasyInit.h"
#import "CustomActivityIndicator.h"
#import "AccountManager.h"
#import "AccountData.h"
#import "BackendlessAuthReponseProtocol.h"


#define UIColorFromHex(rgbValue) \
                [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                         green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
                         blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
                         alpha:1.0]

#define ANIMATION_DURATION 0.5
#define ANIMATION_SPACE 76
#define lunchCastGrayColor   colorWithWhite:0.5 alpha:0.8
#define lunchCastYellowColor 0xAA8F76

@interface SignInVC () <BackendlessAuthReponseDelegate>

@property (weak, nonatomic) IBOutlet CustomActivityIndicator *activityIndicator;

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@property (weak, nonatomic) IBOutlet UILabel *secondaryLabel;

@property (weak, nonatomic) IBOutlet UIButton *mainButton;
@property (weak, nonatomic) IBOutlet UIButton *secondaryButton;

@property (nonatomic, getter=isSignIn)BOOL signIn;

@end

@implementation SignInVC

- (void)viewDidLoad
{
    self.signIn = NO;
    [AccountManager sharedInstance].authDelegate = self;
    
    [self customizePlaceholderText];
    [self customizeNavigationBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self tryAutoLogIn];
}

- (IBAction)mainButtonAction:(UIButton *)sender
{
    if([self validateAccountData])
    {
        if (![self isSignIn])
        {
            [[AccountManager sharedInstance] createNewAccountWithEmail:self.enteredUsername andPassword:self.enteredPassword];
        }
        else
        {
            [[AccountManager sharedInstance] logInWithEmail:self.enteredUsername andPassword:self.enteredPassword];
        }
        [self startWaiting];
    }
}

#pragma mark - Validation

- (BOOL)validateAccountData
{
    if ([Validator isUsername:self.enteredUsername])
    {
        if ([Validator isPassword:self.enteredPassword])
        {
            return YES;
        }
        else
        {
            [self handleInvalidPassword];
            return NO;
        }
    }
    else
    {
        [self handleInvalidUsername];
        return NO;
    }
}

- (void)handleInvalidPassword
{
    [UIAlertController presentAlertViewErrorWithText:NSLocalizedString(@"The password must be at least 6 characters long.", nil) andActionTitle:@"OK" onController:self withCompletion:nil];
}

- (void)handleInvalidUsername
{
    [UIAlertController presentAlertViewErrorWithText:NSLocalizedString(@"Username must be at least 5 characters long.", nil) andActionTitle:@"OK" onController:self withCompletion:nil];
}


- (NSString *)enteredUsername
{
    return [self.usernameField text];
}

- (NSString *)enteredPassword
{
    return [self.passwordField text];
}

#pragma mark - Animations

- (IBAction)secondaryButtonAction:(UIButton *)sender
{
    if ([self isSignIn])
    {
        // switch to create
        [self changeTitleOnLabel:self.secondaryLabel toTitle:@"Already have an account?"];
        [self changeTitleOnButton:self.secondaryButton toTitle:@"Sign in"];
        [self changeTitleOnButton:self.mainButton toTitle:@"Create"];
        [self changeTitleBarToTitle:@"Create New Account"];
    }
    else
    {
        // switch to sign in
        [self changeTitleOnLabel:self.secondaryLabel toTitle:@"Don't have an account?"];
        [self changeTitleOnButton:self.secondaryButton toTitle:@"Create new"];
        [self changeTitleOnButton:self.mainButton toTitle:@"Sign in"];
        [self changeTitleBarToTitle:@"Sign In"];
    }
    
    self.signIn = !self.signIn;
}

- (void)changeTitleOnLabel:(UILabel *)label toTitle:(NSString *)title
{
    [UIView transitionWithView:label duration:0.3f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        label.text = title;
    } completion:nil];
    
}
- (void)changeTitleOnButton:(UIButton *)button toTitle:(NSString *)title
{
    [button setTitle:title forState:UIControlStateNormal];
}

- (void)changeTitleBarToTitle:(NSString *)title
{
    CATransition *fadeTextAnimation = [CATransition animation];
    fadeTextAnimation.duration = 0.3;
    fadeTextAnimation.type = kCATransitionFade;
    
    [self.navigationController.navigationBar.layer addAnimation: fadeTextAnimation forKey: @"fadeText"];
    self.navigationItem.title = title;
}

- (void)startWaiting
{
    [self.view setUserInteractionEnabled:NO];
    
    for (UIView *v in self.view.subviews)
        [v setAlpha:0.5];
    
    [self.activityIndicator startAnimating];
}

- (void)stopWaiting
{
    [self.view setUserInteractionEnabled:YES];
    
    for (UIView *v in self.view.subviews)
        [v setAlpha:1.0];
    
    [self.activityIndicator stopAnimating];
}

#pragma mark - Auth Delegate

- (void)didFailToLogInUserWithError:(NSString *)error
{
    [self stopWaiting];
    [UIAlertController presentAlertViewErrorWithText:NSLocalizedString(error, nil) andActionTitle:@"OK" onController:self withCompletion:nil];
}

- (void)didFailToRegisterUserWithError:(NSString *)error
{
    [self stopWaiting];
    [UIAlertController presentAlertViewErrorWithText:NSLocalizedString(error, nil) andActionTitle:@"OK" onController:self withCompletion:nil];
}

- (void)didRegisterUser:(BackendlessUser *)user
{
    [self stopWaiting];
    
    // switch to sign in
    [self changeTitleOnLabel:self.secondaryLabel toTitle:@"Don't have an account?"];
    [self changeTitleOnButton:self.secondaryButton toTitle:@"Create new"];
    [self changeTitleOnButton:self.mainButton toTitle:@"Sign in"];
    [self changeTitleBarToTitle:@"Sign In"];
    
    self.signIn = !self.signIn;
}

- (void)didLogInUser:(BackendlessUser *)user
{
    [self stopWaiting];
    [self performSegueWithIdentifier:@"toMain" sender:nil];
}

#pragma mark - Utils

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self view] endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void)customizePlaceholderText
{
    UIColor *placeholderColor = [UIColor colorWithWhite:0.8 alpha:0.8];
     self.usernameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"email" attributes:@{NSForegroundColorAttributeName: placeholderColor}];
     self.passwordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"password" attributes:@{NSForegroundColorAttributeName: placeholderColor}];
}

- (void)customizeNavigationBar
{
    self.navigationController.navigationBar.barTintColor = UIColorFromHex(lunchCastYellowColor);
    self.navigationController.navigationBar.translucent = NO;
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor whiteColor],NSForegroundColorAttributeName,
                                    [UIColor whiteColor],NSBackgroundColorAttributeName,
                                    [UIFont fontWithName:@"HelveticaNeue-Thin" size:22.0], NSFontAttributeName,
                                    nil];
    
    self.navigationController.navigationBar.titleTextAttributes = textAttributes;
}

- (void)tryAutoLogIn
{
    if ([[AccountManager sharedInstance] isLoggedIn])
    {
        [self performSegueWithIdentifier:@"toMain" sender:nil];
    }
}

@end
