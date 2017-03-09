//
//  TableViewCell.m
//  textViewCell
//
//  Created by ww on 16/12/31.
//  Copyright © 2016年 zww. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.textView.delegate = self;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if ([self.textViewCellDelegate respondsToSelector:@selector(textViewCell:didChangeText:)]) {
        [self.textViewCellDelegate textViewCell:self didChangeText:textView];
    }
    CGRect bounds = textView.bounds;
    CGSize maxSize = CGSizeMake(bounds.size.width, bounds.size.height);
    CGSize newSize = [textView sizeThatFits:maxSize];
    bounds.size = newSize;
    textView.bounds = bounds;
    
    UITableView *tableView = [self tableView];
    [tableView beginUpdates];
    [tableView endUpdates];
}

- (UITableView *)tableView
{
    UIView *tableView = self.superview;
    while (![tableView isKindOfClass:[UITableView class]] && tableView) {
        tableView = tableView.superview;
    }
    return (UITableView *)tableView;
}
@end
