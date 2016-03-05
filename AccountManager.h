//
//  AccountManager.h
//  OnePaste
//
//  Created by Marko Čančar on 12/8/14.
//  Copyright (c) 2014 12Rockets. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BackendlessAuthReponseProtocol.h"

@interface AccountManager : NSObject

+ (AccountManager *)sharedInstance;

@property (nonatomic, weak)id <BackendlessAuthReponseDelegate> authDelegate;

- (void)logOut;
- (void)logInWithEmail:(NSString *)email andPassword:(NSString *)password;
- (void)createNewAccountWithEmail:(NSString *)email andPassword:(NSString *)password andName: (NSString *)name;
- (BOOL)isCurrentPassword:(NSString *)password;
- (BOOL)isLoggedIn;
- (void)validate;

@end