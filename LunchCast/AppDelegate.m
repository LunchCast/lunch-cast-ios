//
//  AppDelegate.m
//  LunchCast
//
//  Created by Aleksandra Stevović on 2/19/16.
//  Copyright © 2016 Aleksandra Stevović. All rights reserved.
//

#import "AppDelegate.h"
#import "Backendless.h"
#import "AccountData.h"
#import "Utilities.h"

#define APP_ID          @"DC12F089-BB53-9297-FF3A-47B8F24CF100"
#define SECRET_KEY      @"014707B0-21C9-18B8-FF91-AF2AC2D03500"
#define VERSION_NUM     @"v1"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [backendless initApp:APP_ID secret:SECRET_KEY version:VERSION_NUM];
    [backendless.userService setStayLoggedIn:YES];

    
    // Customize Navigation Bar
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setBarTintColor:UIColorFromHex(lunchCastTintColor)];
    [[UINavigationBar appearance] setTranslucent:NO];
    
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor whiteColor],NSForegroundColorAttributeName,
                                    [UIColor whiteColor],NSBackgroundColorAttributeName,
                                    nil];
    
    [[UINavigationBar appearance] setTitleTextAttributes:textAttributes];

    return YES;
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSString *deviceTokenStr = [backendless.messagingService deviceTokenAsString:deviceToken];
    
    @try {
        NSString *deviceRegistrationId = [backendless.messagingService registerDeviceToken:deviceTokenStr];
        
        [AccountData setDeviceToken:deviceRegistrationId];
        BackendlessUser *user = backendless.userService.currentUser;
        [user setProperty:@"deviceId" object:backendless.messagingService.currentDevice.deviceId];
        
        [backendless.userService update:user response:^(BackendlessUser *updatedUser)
         {
             [user updateProperties:@{@"deviceId" : backendless.messagingService.currentDevice.deviceId}];
         }
                                  error:^(Fault *fault)
         {
             NSLog(@"Server reported an error (ASYNC): %@", fault);
         }];
        
        NSLog(@"deviceToken = %@, deviceRegistrationId = %@", deviceTokenStr, deviceRegistrationId);
    }
    @catch (Fault *fault) {
        NSLog(@"deviceToken = %@, FAULT = %@ <%@>", deviceTokenStr, fault.message, fault.detail);
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"%@", userInfo);
    
    NSDictionary *aps = userInfo[@"aps"];
    NSString *alert = aps[@"alert"];
    
    if ([alert isEqualToString:@"Person joined order."])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PersonJoinedOrder" object:nil];
    }
    else if ([alert isEqualToString:@"Order is closed."])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"OrderIsClosed" object:nil];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
