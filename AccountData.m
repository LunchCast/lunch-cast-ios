//
//  AccountData.m
//  OnePaste
//
//  Created by Marko Čančar on 12/9/14.
//  Copyright (c) 2014 12Rockets. All rights reserved.
//

#import "AccountData.h"

#define SUITE_NAME @"group.com.twelverockets.NomNom"

@implementation AccountData

#pragma mark - Setters and getters

+ (NSString *)getDeviceToken
{
    NSString *token = [[[NSUserDefaults alloc] initWithSuiteName:SUITE_NAME] stringForKey:@"deviceToken"];
    return token == nil ? @"" : token;
}

+ (void)setDeviceToken:(NSString *)deviceToken
{
    [[[NSUserDefaults alloc] initWithSuiteName:SUITE_NAME] setValue:deviceToken forKey:@"deviceToken"];
}

+ (NSString *)getUserToken
{
    NSString *token = [[[NSUserDefaults alloc] initWithSuiteName:SUITE_NAME] stringForKey:@"userToken"];
    return token == nil ? @"" : token;
}

+ (void)setUserToken:(NSString *)userToken
{
    [[[NSUserDefaults alloc] initWithSuiteName:SUITE_NAME] setValue:userToken forKey:@"userToken"];
}

+ (NSString *)getPassword
{
    NSString *pass = [[[NSUserDefaults alloc] initWithSuiteName:SUITE_NAME] stringForKey:@"userPassword"];
    return pass == nil ? @"" : pass;
}

+ (void)setPassword:(NSString *)password
{
    [[[NSUserDefaults alloc] initWithSuiteName:SUITE_NAME] setValue:password forKey:@"userPassword"];
}

+ (NSString *)getEmail
{
    NSString *email = [[[NSUserDefaults alloc] initWithSuiteName:SUITE_NAME] stringForKey:@"email"];
    return email == nil ? @"" : email;
}

+ (void)setEmail:(NSString *)email
{
    [[[NSUserDefaults alloc] initWithSuiteName:SUITE_NAME] setValue:email forKey:@"email"];
}

+ (NSString *)getUsername
{
    NSString *username = [[[NSUserDefaults alloc] initWithSuiteName:SUITE_NAME] stringForKey:@"username"];
    return username == nil ? @"" : username;
}

+ (void)setUsername:(NSString *)username
{
    [[[NSUserDefaults alloc] initWithSuiteName:SUITE_NAME] setValue:username forKey:@"username"];
}

+ (void)resetUserData
{
    [AccountData setPassword:nil];
    [AccountData setUsername:nil];
    [AccountData setUserToken:nil];
}

@end
