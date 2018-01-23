//
//  ViewChooseBacklog.m
//  Administration
//
//  Created by zhang on 2017/10/13.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "ViewChooseBacklog.h"

@interface ViewChooseBacklog ()<UITableViewDelegate,UITableViewDataSource>


@end

@implementation ViewChooseBacklog

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

-(void)setUI
{
    UIColor *color = GetColor(126, 127, 128, 1);
    self.backgroundColor = [color colorWithAlphaComponent:0.3];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 250, 220)];
    tableView.center = self.center;
    tableView.scrollEnabled = NO;
    tableView.delegate =self;
    tableView.dataSource = self;
    [self addSubview:tableView];
    self.tableView = tableView;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayTitle.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.textLabel.text = self.arrayTitle[indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    if (indexPath.row==0) {
        cell.userInteractionEnabled = NO;
        cell.textLabel.textColor = [UIColor blackColor];
    }else
    {
        cell.userInteractionEnabled = YES;
        cell.textLabel.textColor = [UIColor blueColor];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(getChoosed)]) {
        [self.delegate getChoosed];
    }
    [self removeFromSuperview];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
