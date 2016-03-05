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
#import "Utilities.h"

#define ANIMATION_DURATION 0.5
#define ANIMATION_SPACE 76


@interface SignInVC () <BackendlessAuthReponseDelegate>

@property (weak, nonatomic) IBOutlet CustomActivityIndicator *activityIndicator;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *passwordTopConstraint;

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *nameField;

@property (weak, nonatomic) IBOutlet UIButton *mainButton;
@property (weak, nonatomic) IBOutlet UIButton *secondaryButton;

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, getter=isSignIn)BOOL signIn;

@end

@implementation SignInVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.signIn = YES;
    [self switchToSignIn];
    
    [self customizePlaceholderText];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [AccountManager sharedInstance].authDelegate = self;
    
    [self startWaiting];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self tryAutoLogIn];
    });
    
}

- (IBAction)mainButtonAction:(UIButton *)sender
{
    if([self validateAccountData])
    {
        if (![self isSignIn])
        {
            [[AccountManager sharedInstance] createNewAccountWithEmail:self.enteredUsername andPassword:self.enteredPassword andName:self.enteredName];
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


- (NSString *)enteredName
{
    return [self.nameField text];
}

#pragma mark - Animations

- (IBAction)secondaryButtonAction:(UIButton *)sender
{
    if ([self isSignIn])
    {
        [self switchToCreate];
    }
    else
    {
        [self switchToSignIn];
    }
    
    self.signIn = !self.signIn;
}

- (void)switchToCreate
{
    // switch to create
    [self changeTitleOnButton:self.secondaryButton toTitle:@"Already have an account? Log in."];
    [self.nameField setHidden:NO];
    [self.passwordTopConstraint setConstant:self.passwordField.frame.size.height + 70.0];
    [self.mainButton setImage:[UIImage imageNamed: @"sign-up"] forState:UIControlStateNormal];
    [self.descriptionLabel setText:@"Sing up with your name, email adress and password."];
}

- (void)switchToSignIn
{
    // switch to sign in
    [self changeTitleOnButton:self.secondaryButton toTitle:@"Don't have an account? Sign up."];
    [self.passwordTopConstraint setConstant:50.0];
    [self.nameField setHidden:YES];
    [self.mainButton setImage:[UIImage imageNamed: @"log-in"] forState:UIControlStateNormal];
    [self.descriptionLabel setText:@"Log in with your email adress and password."];
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

- (void)didFailToLogOutUserWithError:(NSString *)error
{
     [UIAlertController presentAlertViewErrorWithText:NSLocalizedString(error, nil) andActionTitle:@"OK" onController:self withCompletion:nil];
}

- (void)didRegisterUser:(BackendlessUser *)user
{
    [self stopWaiting];
    
    // switch to sign in
    [self changeTitleOnButton:self.secondaryButton toTitle:@"Don't have an account? Sign up."];
    [self.passwordTopConstraint setConstant:50.0];
    [self.nameField setHidden:YES];
    [self.mainButton setImage:[UIImage imageNamed: @"log-in"] forState:UIControlStateNormal];
    [self.descriptionLabel setText:@"Log in with your email adress and password."];

    
    self.signIn = !self.signIn;
}

- (void)didLogInUser:(BackendlessUser *)user
{
    [self stopWaiting];
    [self performSegueWithIdentifier:@"toMain" sender:nil];
}

- (void)didLogOutUser
{
    NSLog(@"User logged out");
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
     self.usernameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@" email" attributes:@{NSForegroundColorAttributeName: placeholderColor}];
     self.passwordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@" password" attributes:@{NSForegroundColorAttributeName: placeholderColor}];
    self.nameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@" name" attributes:@{NSForegroundColorAttributeName: placeholderColor}];
}


- (void)tryAutoLogIn
{
    [self stopWaiting];
    if ([[AccountManager sharedInstance] isLoggedIn])
    {
        [self performSegueWithIdentifier:@"toMain" sender:nil];
    }

}

@end
