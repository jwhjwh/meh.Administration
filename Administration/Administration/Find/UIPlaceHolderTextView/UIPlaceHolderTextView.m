//
//  UIPlaceHolderTextView.m
//  BocElife
//
//  Created by Joe Wang on 14-7-2.
//  Copyright (c) 2014年 wanhuahai. All rights reserved.
//

#import "UIPlaceHolderTextView.h"

@implementation UIPlaceHolderTextView

@synthesize placeHolderLabel;
@synthesize placeholder;
@synthesize placeholderColor;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setPlaceholder:@""];
        [self setPlaceholderColor:[UIColor lightGrayColor]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChangeed:) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self setPlaceholder:@""];
        [self setPlaceholderColor:[UIColor lightGrayColor]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChangeed:) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

-(void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void) awakeFromNib{
    [super awakeFromNib];
    [self setPlaceholderColor:[UIColor lightGrayColor]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChangeed:) name:UITextViewTextDidChangeNotification object:nil];
    
}

-(void) textChangeed:(NSNotification *)notification {
    if (self.placeholder.length==0) {
        return;
    }
    
    if (self.text.length==0) {
        [[self viewWithTag:999] setAlpha:1];
        
    }else{
        [[self viewWithTag:999] setAlpha:0];
    }
}

-(void) setText:(NSString *)text{
    [super setText:text];
    [self textChangeed:nil];
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    if (self.placeholder.length>0) {
        if (self.placeHolderLabel==nil) {
            placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, self.bounds.size.width-16, 0)];
            placeHolderLabel.lineBreakMode=NSLineBreakByWordWrapping;
            placeHolderLabel.numberOfLines=0;
            placeHolderLabel.font = self.font;
            placeHolderLabel.backgroundColor = [UIColor clearColor];
            placeHolderLabel.textColor = self.placeholderColor;
            placeHolderLabel.alpha=0;
            placeHolderLabel.tag=999;
            [self addSubview:placeHolderLabel];
        }
        placeHolderLabel.text = self.placeholder;
        [placeHolderLabel sizeToFit];
        [self sendSubviewToBack:placeHolderLabel];
    }
    if (self.text.length==0 && self.placeholder.length>0) {
        [[self viewWithTag:999] setAlpha:1];
    }
    [super drawRect:rect];
}

-(BOOL) textView:(UITextView *) textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{

    return YES;
}

@end
