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
#import "UserSubscription.h"

@interface AccountManager ()

@end

@implementation AccountManager

#pragma mark - Initialization
#pragma mark -

- (instancetype)init
{
    self = [super init];
    if (self)
    {
    }
    return self;
}

+ (AccountManager*)sharedInstance
{
    static AccountManager *_sharedInstance = nil;
    
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[AccountManager alloc] init];
    });
    return _sharedInstance;
}


- (void)logInWithEmail:(NSString *)email andPassword:(NSString *)password
{
    [self setUserEmail:email andPassword:password];
    [self userLogin];
}

- (void)createNewAccountWithEmail:(NSString *)email andPassword:(NSString *)password
{
    [self setUserEmail:email andPassword:password];
    [self userRegistration];
}

- (void)logOut
{
    [AccountData setPassword:@""];
    [AccountData setUserToken:@""];
}

- (void)setUserEmail:(NSString *)email andPassword:(NSString *)password
{
    [AccountData setEmail:email];
    [AccountData setPassword:password];
}

- (BOOL)isCurrentPassword:(NSString *)password
{
    return ([[AccountData getPassword] isEqualToString:password]);
}

- (BOOL)isLoggedIn
{
    return (![[AccountData getUserToken] isEqualToString:@""]);
}

- (void)eraseUserData
{
    [AccountData resetUserData];
}

- (void)validate
{
//    [RequestHandler validateRequest];
}


#pragma mark - Backendless methods

- (void)userRegistration
{
    BackendlessUser *user = [BackendlessUser new];
    user.password = [AccountData getPassword];
    user.email = [AccountData getEmail];
    user.name = @"user";//[AccountData getUsername];

    Responder *responder = [Responder responder:self
                             selResponseHandler:@selector(registrationResponseHandler:)
                                selErrorHandler:@selector(registrationErrorHandler:)];
    [backendless.userService registering:user responder:responder];
}

- (void)userLogin
{
    Responder *responder = [Responder responder:self
                             selResponseHandler:@selector(loginResponseHandler:)
                                selErrorHandler:@selector(loginErrorHandler:)];
    
    [backendless.userService login:[AccountData getEmail] password:[AccountData getPassword] responder:responder];
}

- (void)loginResponseHandler:(id)response;
{
    BackendlessUser *user = (BackendlessUser *)response;
    [AccountData setUserToken:user.getUserToken];
//    [AccountData setBackendlessUser:user];
    [self.authDelegate didLogInUser:user];
}

- (void)registrationResponseHandler:(id)response;
{
    BackendlessUser *user = (BackendlessUser *)response;
  
    //create empty subscription for user
    
    UserSubscription *userSubscription = [UserSubscription new];
    userSubscription.userId = user.objectId;
    userSubscription.tags = [NSMutableArray new];
    [backendless.persistenceService save:userSubscription response:^(UserSubscription *result) {
    } error:^(Fault *fault) {}];

    [self.authDelegate didRegisterUser:user];
}

- (void)registrationErrorHandler:(Fault *)fault
{
    NSLog(@"FAULT = %@ <%@>", fault.message, fault.detail);
    [self.authDelegate didFailToRegisterUserWithError:fault.message];
}

- (void)loginErrorHandler:(Fault *)fault
{
    NSLog(@"FAULT = %@ <%@>", fault.message, fault.detail);
    [self.authDelegate didFailToLogInUserWithError:fault.message];
}


@end
