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
    [self.delegate amountHasBeenChanged: (amount - _amount)*[self.meal.price intValue] forMeal:self.meal];
    _amount = amount;
    [self.amountLabel setText:[NSString stringWithFormat:@"%lu",(unsigned long)amount]];

}

@end
