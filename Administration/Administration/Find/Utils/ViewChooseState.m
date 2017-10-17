//
//  ViewChooseState.m
//  Administration
//
//  Created by zhang on 2017/10/11.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "ViewChooseState.h"

@interface ViewChooseState ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSArray *array;

@end

@implementation ViewChooseState


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
    
    self.array = @[@"日待办事项",@"周待办事项",@"店家待办事项",@"其他待办事项"];
    
    
    UIColor *color = GetColor(203, 204, 205, 1);
    self.backgroundColor = [color colorWithAlphaComponent:0.3];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(8, 70, Scree_width-16, 200)];
    view.backgroundColor = GetColor(236,237,238,1);
    [self addSubview:view];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(18,0 , 150, 21)];
    label.text = @"全部待办事项";
    label.backgroundColor = GetColor(236,237,238,1);
    [view addSubview:label];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(view.frame.size.width-30, 3, 20, 15)];
    imageView.image = [UIImage imageNamed:@"down"];
    [view addSubview:imageView];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(10,22,Scree_width-20, 176) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.scrollEnabled = NO;
    [view addSubview:tableView];
    self.tableView = tableView;
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.contentView.backgroundColor = GetColor(236,237,238,1);
    cell.textLabel.text = self.array[indexPath.row];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(getClickIndex)]) {
        [self.delegate getClickIndex];
    }
    [self removeFromSuperview];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
    }

    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        
        [cell setPreservesSuperviewLayoutMargins:NO];
        
    }

    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
    }
    
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
