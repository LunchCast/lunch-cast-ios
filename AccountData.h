//
//  AccountData.h
//  OnePaste
//
//  Created by Marko Čančar on 12/9/14.
//  Copyright (c) 2014 12Rockets. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Backendless.h"

@interface AccountData : NSObject

+ (NSString *)getDeviceToken;
+ (void)setDeviceToken:(NSString *)deviceToken;
+ (NSString *)getUserToken;
+ (void)setUserToken:(NSString *)userToken;
+ (NSString *)getPassword;
+ (void)setPassword:(NSString *)password;
+ (NSString *)getEmail;
+ (void)setEmail:(NSString *)email;
+ (NSString *)getUsername;
+ (void)setUsername:(NSString *)username;
+ (void)resetUserData;
@end
