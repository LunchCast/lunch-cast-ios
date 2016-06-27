//
//  TextFieldWithInsets.m
//  LunchCast
//
//  Created by Aleksandra Stevovic on 6/27/16.
//  Copyright © 2016 Aleksandra Stevović. All rights reserved.
//

#import "TextFieldWithInsets.h"

@implementation TextFieldWithInsets

// placeholder position
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 10, 10);
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 10, 10);
}

@end
