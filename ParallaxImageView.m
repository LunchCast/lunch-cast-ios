//
//  ParallaxImageView.m
//  OnePaste
//
//  Created by Marko Čančar on 12/17/14.
//  Copyright (c) 2014 12Rockets. All rights reserved.
//

#import "ParallaxImageView.h"

#define USING_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define IPAD_MAX 100.0
#define IPHONE_MAX 50.0

#define MAX_VALUE   (USING_IPAD ? IPAD_MAX : IPHONE_MAX)

@implementation ParallaxImageView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupParallaxEffect];
    }
    return self;
}

- (void)setupParallaxEffect
{
    UIInterpolatingMotionEffect *leftRight = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    leftRight.minimumRelativeValue = @(-MAX_VALUE);
    leftRight.maximumRelativeValue = @(MAX_VALUE);
    
    self.parallaxGroup = [[UIMotionEffectGroup alloc] init];
    self.parallaxGroup.motionEffects = @[leftRight];
    
    [self addMotionEffect:self.parallaxGroup];
}
@end
