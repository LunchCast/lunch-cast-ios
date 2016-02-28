//
//  PushNotificationRegistrator.m
//  OnePaste
//
//  Created by Marko Čančar on 12/9/14.
//  Copyright (c) 2014 12Rockets. All rights reserved.
//

#import "PushNotificationRegistrator.h"

@implementation PushNotificationRegistrator

+ (void)registerForPushNotifications
{
    // Register for Push Notitications
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                             categories:nil];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
}

+ (void)unregisterForPushNotifications
{
    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    [[UIApplication sharedApplication] registerUserNotificationSettings:nil];
}


@end
