//
//  UIAlertController+EasyInit.m
//  OnePaste
//
//  Created by Marko Čančar on 12/4/14.
//  Copyright (c) 2014 12Rockets. All rights reserved.
//

#import "UIAlertController+EasyInit.h"

@implementation UIAlertController (EasyInit)
+ (void)presentAlertViewErrorWithText:(NSString *)text andActionTitle:(NSString *)actionTitle onController:(UIViewController *)presentingViewController withCompletion:(void (^)(UIAlertAction *action))completion
{
    [UIAlertController presentAlertViewWithTitle:@"Error" andBody:text andActionTitle:actionTitle onController:presentingViewController withCompletion:completion];
}

+ (void)presentAlertViewSuccessWithText:(NSString *)text andActionTitle:(NSString *)actionTitle onController:(UIViewController *)presentingViewController withCompletion:(void (^)(UIAlertAction *action))completion
{
    [UIAlertController presentAlertViewWithTitle:@"Success" andBody:text andActionTitle:actionTitle onController:presentingViewController withCompletion:completion];
}

+ (void)presentAlertViewWithTitle:(NSString *)title andBody:(NSString *)body andActionTitle:(NSString *)actionTitle onController:(UIViewController *)presentingViewController withCompletion:(void (^)(UIAlertAction *action))completion
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:body
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleDefault handler:completion];
    [alert addAction:defaultAction];
    [presentingViewController presentViewController:alert animated:YES completion:nil];
}
@end
