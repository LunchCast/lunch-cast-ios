//
//  RequestCallbackProtocol.h
//  OnePaste
//
//  Created by Marko Čančar on 12/18/14.
//  Copyright (c) 2014 12Rockets. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SignUpRequestCallbackProtocol <NSObject>

- (void)didSignUpWithSuccess;
- (void)didFailToSignUpWithError:(NSInteger)error;

@end

@protocol LogInRequestCallbackProtocol <NSObject>

- (void)didLogInWithSuccess;
- (void)didFailToLogInWithError:(NSInteger)error;

@end

@protocol LogOutRequestCallbackProtocol <NSObject>

- (void)didLogOutWithSuccess;
- (void)didFailToLogOutWithError:(NSInteger)error;

@end

@protocol ChangePasswordRequestCallbackProtocol <NSObject>

- (void)didChangePasswordWithSuccess;
- (void)didFailToChangePasswordWithError:(NSInteger)error;

@end


@protocol WidgetRequestCallbackProtocol <NSObject>

- (void)didUpdateWithSuccess;
- (void)didFailToUpdateWithError:(NSInteger)error;

@end


@protocol ResetPasswordRequestCallbackProtocol <NSObject>

- (void)didResetWithSuccess;
- (void)didFailToResetWithError:(NSInteger)error;

@end


@protocol ValidateRequestCallbackProtocol <NSObject>

- (void)didValidateWithSuccess;
- (void)didFailToValidateWithError:(NSInteger)error;

@end