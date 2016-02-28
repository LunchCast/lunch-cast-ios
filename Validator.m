//
//  Validator.m
//  OnePaste
//
//  Created by Marko Čančar on 12/9/14.
//  Copyright (c) 2014 12Rockets. All rights reserved.
//

#import "Validator.h"

@implementation Validator


+ (BOOL)isEmail:(NSString *)email
{
    NSString *pattern =  @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult *match = [regex firstMatchInString:email options:0 range:NSMakeRange(0,[email length])];
    return match != nil ;
}

+ (BOOL)isUsername:(NSString *)username
{
    return [username length] > 5;
}

+ (BOOL)isPassword:(NSString *)password
{
    return [password length] > 7;
}

+ (BOOL)isFieldEmpty:(NSString *)field
{
    return [field isEqualToString:@""];
}

+ (BOOL)doesPassword:(NSString *)password matchWithConfirmPassword:(NSString *)confirmedPassword
{
    return [password isEqualToString:confirmedPassword];
}


@end
