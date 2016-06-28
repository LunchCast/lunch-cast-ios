//
//  CustomCollectionViewCell.m
//  LunchCast
//
//  Created by Aleksandra Stevovic on 6/27/16.
//  Copyright © 2016 Aleksandra Stevović. All rights reserved.
//

#import "CustomCollectionViewCell.h"

@implementation CustomCollectionViewCell

-(void)setSelectedMode:(BOOL)selectedMode
{
    if (selectedMode)
    {
        self.tagLabel.textColor = [UIColor redColor];
    }
    else
    {
         self.tagLabel.textColor = [UIColor blueColor];
    }
}

@end
