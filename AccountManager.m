//
//  AccountManager.m
//  OnePaste
//
//  Created by Marko Čančar on 12/8/14.
//  Copyright (c) 2014 12Rockets. All rights reserved.
//

#import "AccountManager.h"
#import "ErrorCoding.h"
#import "PushNotificationRegistrator.h"
#import "AccountData.h"
#import "Backendless.h"

@interface AccountManager ()

@end

@implementation AccountManager

+ (void)logInWithEmail:(NSString *)email andPassword:(NSString *)password
{
    [AccountManager setUserEmail:email andPassword:password];
}


+ (void)userRegistration
{
    BackendlessUser *user = [BackendlessUser new];
    user.password = @"pass123";
    user.email = @"markozr92@gmail.com";
    user.name = @"Marko";
    Responder *responder = [Responder responder:self
                             selResponseHandler:@selector(responseHandler:)
                                selErrorHandler:@selector(errorHandler:)];
    [backendless.userService registering:user responder:responder];
}
+ (id)responseHandler:(id)response;
{
    BackendlessUser *user = (BackendlessUser *)response;
    NSLog(@"user = %@", user);
    return user;
}

+(void)errorHandler:(Fault *)fault
{
    NSLog(@"FAULT = %@ <%@>", fault.message, fault.detail);
}


+ (void)createNewAccountWithEmail:(NSString *)email andPassword:(NSString *)password
{
    [AccountManager setUserEmail:email andPassword:password];
//    [RequestHandler signUpRequest];
    [AccountManager userRegistration];
}

+ (void)logOut
{
//    [RequestHandler logOutRequest];
}

+ (void)setUserEmail:(NSString *)email andPassword:(NSString *)password
{
    [AccountData setUsername:email];
    [AccountData setPassword:password];
}

+ (BOOL)isCurrentPassword:(NSString *)password
{
    return ([[AccountData getPassword] isEqualToString:password]);
}

+ (BOOL)isLoggedIn
{
    return (![[AccountData getUsername] isEqualToString:@""]);
}

+ (void)eraseUserData
{
    [AccountData resetUserData];
}

+ (void)validate
{
//    [RequestHandler validateRequest];
}
@end
