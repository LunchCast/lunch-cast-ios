//
//  BackendlessAuthReponseProtocol.h
//  LunchCast
//
//  Created by Marko Čančar on 28.2.16..
//  Copyright © 2016. Aleksandra Stevović. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Backendless.h"

@protocol BackendlessAuthReponseDelegate <NSObject>

@optional

- (void)didRegisterUser:(BackendlessUser *)user;
- (void)didFailToRegisterUserWithError:(NSString *)error;

- (void)didLogInUser:(BackendlessUser *)user;
- (void)didFailToLogInUserWithError:(NSString *)error;

@end