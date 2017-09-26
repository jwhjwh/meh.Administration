//
//  ViewChooseScore.m
//  testTableView
//
//  Created by zhang on 2017/9/20.
//  Copyright © 2017年 zhang. All rights reserved.
//

#import "ViewChooseScore.h"

@interface ViewChooseScore ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation ViewChooseScore


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
    self.backgroundColor = [UIColor colorWithRed:126.0f/255.0f green:127.0f/255.0f blue:128.0f/255.0f alpha:0.5];
    
    UIView  *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 241)];
    view.backgroundColor = [UIColor lightGrayColor];
    view.center = self.center;
    [self addSubview:view];
    
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
    self.label.backgroundColor = [UIColor whiteColor];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.font = [UIFont systemFontOfSize:17];
    [view addSubview:self.label];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 41, 200, 200) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource= self;
    [view addSubview:self.tableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayContent.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.text = self.arrayContent[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self.delegate respondsToSelector:@selector(getIndexPath)]) {
        [self.delegate getIndexPath];
    }
    self.score = self.arrayContent[indexPath.row];
    
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


