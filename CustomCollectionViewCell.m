//
//  CustomCollectionViewCell.m
//  LunchCast
//
//  Created by Aleksandra Stevovic on 6/27/16.
//  Copyright © 2016 Aleksandra Stevović. All rights reserved.
//

#import "CustomCollectionViewCell.h"
#import "UIColor+NewColorAdditions.h"
#import <QuartzCore/QuartzCore.h>

@implementation CustomCollectionViewCell

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setNeedsDisplay]; // force drawRect:
}

-(void)setSelectedMode:(BOOL)selectedMode
{
    _selectedMode = selectedMode;
    
    [self setTagLabelStyle];
    [self setImageForMode];
}
-(void)setImageForMode
{
    NSString *name = [self.tagLabel.text lowercaseString];
    NSString *mode = self.selectedMode ? @"selected" : @"deselected";
    
    if ([UIImage imageNamed: [NSString stringWithFormat:@"%@-%@", name, mode]]) {
         [self.tagImageView setImage:[UIImage imageNamed: [NSString stringWithFormat:@"%@-%@", name, mode]]];
    }
}
-(void)setTagLabelStyle
{
    self.tagLabel.layer.masksToBounds = YES;
    self.tagLabel.layer.cornerRadius = 2.0f;
    self.tagLabel.backgroundColor = self.selectedMode ?  [UIColor darkishPinkColor]: [UIColor softGray];
    self.tagLabel.layer.borderWidth = self.selectedMode ? 1.0f : 0.0f;
    self.tagLabel.layer.borderColor = self.selectedMode ? [UIColor whiteColor].CGColor : [UIColor clearColor].CGColor;
    
}

@end
