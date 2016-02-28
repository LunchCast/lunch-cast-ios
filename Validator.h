//
//  Validator.h
//  OnePaste
//
//  Created by Marko Čančar on 12/9/14.
//  Copyright (c) 2014 12Rockets. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Validator : NSObject

+ (BOOL)isEmail:(NSString*)email;
+ (BOOL)isUsername:(NSString *)username;
+ (BOOL)isPassword:(NSString*)password;
+ (BOOL)isFieldEmpty:(NSString*)field;
+ (BOOL)doesPassword:(NSString *)password matchWithConfirmPassword:(NSString *)confirmedPassword;

@end
