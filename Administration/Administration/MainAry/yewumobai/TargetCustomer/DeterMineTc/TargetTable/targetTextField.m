//
//  targetTextField.m
//  Administration
//
//  Created by 九尾狐 on 2017/10/20.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "targetTextField.h"

@implementation targetTextField

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextFillRect(context, CGRectMake(0, CGRectGetHeight(self.frame) - 0.5, CGRectGetWidth(self.frame), 0.5));
    self.keyboardType = UIKeyboardTypeDecimalPad;
    self.textAlignment = NSTextAlignmentCenter;
    
}


@end
