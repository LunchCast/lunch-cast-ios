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

@interface AccountManager ()

@end

@implementation AccountManager

+ (void)logInWithEmail:(NSString *)email andPassword:(NSString *)password
{
    [AccountManager setUserEmail:email andPassword:password];
//    [RequestHandler logInRequest];
}

+ (void)createNewAccountWithEmail:(NSString *)email andPassword:(NSString *)password
{
    [AccountManager setUserEmail:email andPassword:password];
//    [RequestHandler signUpRequest];
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
