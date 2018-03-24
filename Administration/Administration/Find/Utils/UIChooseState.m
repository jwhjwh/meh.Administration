//
//  UIChooseState.m
//  Administration
//
//  Created by zhang on 2018/3/5.
//  Copyright © 2018年 九尾狐. All rights reserved.
//

#import "UIChooseState.h"

@interface UIChooseState ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSArray *arrayData;
@end


@implementation UIChooseState

-(instancetype)initWithFrame:(CGRect)frame withArray:(NSArray *)array
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI:array];
    }
    return self;
}

-(void)setUI:(NSArray *)array
{
    self.arrayData = array;
    UIColor *color = GetColor(126, 127, 128, 1);
    self.backgroundColor = [color colorWithAlphaComponent:0.3];
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"sj_ico"];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-20);
        make.top.mas_equalTo(self.mas_top).offset(64);
        make.width.mas_equalTo(16);
        make.height.mas_equalTo(17);
    }];
    
    UITableView *tableView = [[UITableView alloc]init];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.scrollEnabled = NO;
    tableView.backgroundColor = [UIColor whiteColor];
    [self addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-15);
        make.top.mas_equalTo(imageView.mas_bottom).offset(-5);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(self.arrayData.count*44);
    }];
}

#pragma -mark tabelView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   // dddd
    return self.arrayData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = self.arrayData[indexPath.row];
    cell.textLabel.textColor = [UIColor blueColor];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.backgroundColor = [UIColor whiteColor];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(getChooseIndexPath:)]) {
        [self.delegate getChooseIndexPath:indexPath];
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

