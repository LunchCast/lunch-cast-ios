//
//  MenuCell.m
//  LunchCast
//
//  Created by Aleksandra Stevovic on 3/1/16.
//  Copyright © 2016 Aleksandra Stevović. All rights reserved.
//

#import "MenuCell.h"

@implementation MenuCell
- (IBAction)onMinusButton:(UIButton *)sender
{
    if (self.amount !=0) {
        self.amount --;
    }
}
- (IBAction)onPlusButton:(UIButton *)sender
{
    self.amount ++;
}

-(void)setAmount:(NSUInteger)amount
{
    _amount = amount;
    [self.amountLabel setText:[NSString stringWithFormat:@"%d",amount]];
}

@end
