//
//  UIAlertController+EasyInit.h
//  OnePaste
//
//  Created by Marko Čančar on 12/4/14.
//  Copyright (c) 2014 12Rockets. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (EasyInit)
+ (void)presentAlertViewErrorWithText:(NSString *)text andActionTitle:(NSString *)actionTitle onController:(UIViewController *)presentingViewController withCompletion:(void (^)(UIAlertAction *action))completion;
+ (void)presentAlertViewSuccessWithText:(NSString *)text andActionTitle:(NSString *)actionTitle onController:(UIViewController *)presentingViewController withCompletion:(void (^)(UIAlertAction *action))completion;
@end
