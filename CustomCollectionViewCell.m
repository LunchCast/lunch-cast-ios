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

//-(void)setFrame:(CGRect)frame
//{
//    [super setFrame:frame];
//    [self setNeedsDisplay]; // force drawRect:
//}

-(void)setImageForMode: (BOOL) selectedMode
{
    NSString *name = [self.tagLabel.text lowercaseString];
    NSString *mode = selectedMode ? @"selected" : @"deselected";
    
    [self.tagImageView setImage:[UIImage imageNamed: [NSString stringWithFormat:@"%@-%@", name, mode]]];
}
-(void)setTagLabelStyle: (BOOL) selectedMode
{
    self.tagLabel.layer.masksToBounds = YES;
    self.tagLabel.layer.cornerRadius = 2.0f;
    self.tagLabel.backgroundColor = selectedMode ?  [UIColor darkishPinkColor]: [UIColor softGray];
    self.tagLabel.layer.borderWidth = selectedMode ? 1.0f : 0.0f;
    self.tagLabel.layer.borderColor = selectedMode ? [UIColor whiteColor].CGColor : [UIColor clearColor].CGColor;
}

-(void)selectCell
{
    [self setTagLabelStyle:YES];
    [self setImageForMode:YES];
}
-(void)deselectCell
{
    [self setTagLabelStyle:NO];
    [self setImageForMode:NO];
}

@end
