//
//  MyTextField.m
//  testakjdflakdj
//
//  Created by zhang on 2017/9/21.
//  Copyright © 2017年 zhang. All rights reserved.
//

#import "MyTextField.h"

@implementation MyTextField


- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextFillRect(context, CGRectMake(0, CGRectGetHeight(self.frame) - 0.5, CGRectGetWidth(self.frame), 0.5));
    self.keyboardType = UIKeyboardTypeDecimalPad;
    self.textAlignment = NSTextAlignmentCenter;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
