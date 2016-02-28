//
//  PushNotificationRegistrator.h
//  OnePaste
//
//  Created by Marko Čančar on 12/9/14.
//  Copyright (c) 2014 12Rockets. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PushNotificationRegistrator : NSObject
+ (void)registerForPushNotifications;
+ (void)unregisterForPushNotifications;
@end
