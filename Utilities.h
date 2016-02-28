//
//  Utilities.h
//  LunchCast
//
//  Created by Marko Čančar on 28.2.16..
//  Copyright © 2016. Aleksandra Stevović. All rights reserved.
//

#import <Foundation/Foundation.h>

#define UIColorFromHex(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

#define lunchCastGrayColor   colorWithWhite:0.5 alpha:0.8
#define lunchCastTintColor 0x5A7E6A

@interface Utilities : NSObject

@end
