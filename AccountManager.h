//
//  AccountManager.h
//  OnePaste
//
//  Created by Marko Čančar on 12/8/14.
//  Copyright (c) 2014 12Rockets. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountManager : NSObject

+ (void)logOut;
+ (void)logInWithEmail:(NSString *)email andPassword:(NSString *)password;
+ (void)createNewAccountWithEmail:(NSString *)email andPassword:(NSString *)password;
+ (BOOL)isCurrentPassword:(NSString *)password;
+ (BOOL)isLoggedIn;
+ (void)validate;

@end