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

#define ANIMATION_DURATION 0.3
#define ANIMATION_SPACE 76

@interface SignInVC ()

@property (weak, nonatomic) IBOutlet CustomActivityIndicator *activityIndicator;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *repeatField;

@property (weak, nonatomic) IBOutlet UILabel *repeatLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondaryLabel;


@property (weak, nonatomic) IBOutlet UIButton *mainButton;
@property (weak, nonatomic) IBOutlet UIButton *secondaryButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (nonatomic, getter=isSignIn)BOOL signIn;

@end

@implementation SignInVC

- (void)viewDidLoad
{
    self.signIn = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"Lunch Cast";
}

- (IBAction)mainButtonAction:(UIButton *)sender
{
    if([self validateAccountData])
    {
        if (![self isSignIn])
        {
            [AccountManager createNewAccountWithEmail:self.enteredUsername andPassword:self.enteredPassword];
        }
        else
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self stopWaiting];
                self.navigationItem.title = @"Log Out";
                [self performSegueWithIdentifier:@"toMain" sender:nil];
            });
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
            if ([self isSignIn])
            {
                return YES;
            }
            else
            {
                if ([Validator doesPassword:self.enteredPassword matchWithConfirmPassword:self.enteredRepeatPassword])
                {
                    return YES;
                }
                else
                {
                    [self handlePassowrdsMismatch];
                    return NO;
                }
            }
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

- (void)handlePassowrdsMismatch
{
    [UIAlertController presentAlertViewErrorWithText:NSLocalizedString(@"Passwords does not match.", nil) andActionTitle:@"OK" onController:self withCompletion:nil];
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

- (NSString *)enteredRepeatPassword
{
    return [self.repeatField text];
}



#pragma mark - Animations

- (IBAction)secondaryButtonAction:(UIButton *)sender
{
    if ([self isSignIn])
    {
        // switch to create
        [self.repeatField setText:@""];
        
        [self changeTitleOnLabel:self.titleLabel toTitle:@"Create New Account"];
        [self changeTitleOnLabel:self.secondaryLabel toTitle:@"Already have an account?"];
        [self changeTitleOnButton:self.secondaryButton toTitle:@"Sign in"];
        [self changeTitleOnButton:self.mainButton toTitle:@"Create"];

        self.topConstraint.constant = -20;
        [UIView animateWithDuration:ANIMATION_DURATION/2
                              delay:0.0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             // show repeat
                             [self.view layoutIfNeeded];
                         }
                         completion:^(BOOL finished) {
                             self.topConstraint.constant = 20;
                             
                             [UIView animateWithDuration:ANIMATION_DURATION/2
                                                   delay:0.0
                                                 options:UIViewAnimationOptionCurveEaseOut
                                              animations:^{
                                                  self.repeatField.alpha = 1.0;
                                                  self.repeatLabel.alpha = 1.0;
                                                  [self.view layoutIfNeeded];
                                              } completion:nil];
                         }];
    }
    else
    {
        // switch to sign in
        [self changeTitleOnLabel:self.titleLabel toTitle:@"Sign In"];
        [self changeTitleOnLabel:self.secondaryLabel toTitle:@"Don't have an account?"];
        [self changeTitleOnButton:self.secondaryButton toTitle:@"Create new"];
        [self changeTitleOnButton:self.mainButton toTitle:@"Sign in"];
        
        self.topConstraint.constant = -8;
        
        [UIView animateWithDuration:ANIMATION_DURATION/2
                              delay:0.0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             self.repeatField.alpha = 0.0;
                             self.repeatLabel.alpha = 0.0;
                             [self.view layoutIfNeeded];
                         }
                         completion:^(BOOL finished) {
                             self.topConstraint.constant = -56;
                             
                             [UIView animateWithDuration:ANIMATION_DURATION/2
                                                   delay:0.0
                                                 options:UIViewAnimationOptionCurveEaseOut
                                              animations:^{
                                                  [self.view layoutIfNeeded];
                                              }
                                              completion:nil];
                         }];
    }
    
    self.signIn = !self.signIn;
}

- (void)changeTitleOnLabel:(UILabel *)label toTitle:(NSString *)title
{
    CATransition *animation = [CATransition animation];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionFade;
    animation.duration = ANIMATION_DURATION;
    [label.layer addAnimation:animation forKey:@"kCATransitionFade"];

    
    [label setText:title];
}
- (void)changeTitleOnButton:(UIButton *)button toTitle:(NSString *)title
{
    [button setTitle:title forState:UIControlStateNormal];
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


#pragma mark - Utils

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self view] endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

@end
