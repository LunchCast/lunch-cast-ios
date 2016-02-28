//
//  CustomActivityIndicator.m
//  OnePaste
//
//  Created by Marko Čančar on 1/13/15.
//  Copyright (c) 2015 12Rockets. All rights reserved.
//

#import "CustomActivityIndicator.h"

@implementation CustomActivityIndicator

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self.layer setBackgroundColor:[[UIColor colorWithWhite:0.0 alpha:0.5] CGColor]];
        [self.layer setCornerRadius:10];
    }
    return self;
}


@end
