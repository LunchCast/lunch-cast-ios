//
//  ParentNC.m
//  NomNom
//
//  Created by Marko Čančar on 8/27/15.
//  Copyright © 2015 12Rockets. All rights reserved.
//

#import "ParentNC.h"

@interface ParentNC() <UIGestureRecognizerDelegate>

@end

@implementation ParentNC

- (void)setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated {
    [super setNavigationBarHidden:hidden animated:animated];
    self.interactivePopGestureRecognizer.delegate = self;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.viewControllers.count > 1) {
        return YES;
    }
    return NO;
}

@end
