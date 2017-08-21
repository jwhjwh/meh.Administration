//
//  UIPlaceHolderTextView.h
//  BocElife
//
//  Created by Joe Wang on 14-7-2.
//  Copyright (c) 2014年 wanhuahai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPlaceHolderTextView : UITextView{
    NSString *placeholder;
    UIColor *placeholderColor;
    @private
    UILabel *placeHolderLabel;
}

@property(strong,nonatomic) UILabel *placeHolderLabel;
@property(strong,nonatomic) NSString *placeholder;
@property(strong,nonatomic) UIColor *placeholderColor;

-(void) textChangeed:(NSNotification *)notification ;
@end
