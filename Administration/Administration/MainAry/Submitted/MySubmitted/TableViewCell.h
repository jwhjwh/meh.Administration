//
//  TableViewCell.h
//  textViewCell
//
//  Created by ww on 16/12/31.
//  Copyright © 2016年 zww. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TableViewCell;

@protocol TextViewCellDelegate <NSObject>

- (void)textViewCell:(TableViewCell *)cell didChangeText:(UITextView *)textView;

@end
@interface TableViewCell : UITableViewCell<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic,weak) id <TextViewCellDelegate>textViewCellDelegate;
@property (weak, nonatomic) IBOutlet UILabel *cellLabel;

@end
