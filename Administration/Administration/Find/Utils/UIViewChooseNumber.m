//
//  UIViewChooseNumber.m
//  Administration
//
//  Created by zhang on 2017/12/18.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "UIViewChooseNumber.h"

@interface UIViewChooseNumber ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic,strong)NSMutableArray *arrayData;
@property (nonatomic,weak)UIPickerView *pickView;

@end

@implementation UIViewChooseNumber

-(instancetype)initWithFrame:(CGRect)frame Title:(NSString *)title ShowYear:(BOOL)showYear
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI:title ShowYear:showYear];
    }
    return self;
}

-(void)setUI:(NSString *)title ShowYear:(BOOL)showYear
{
    self.arrayData = [NSMutableArray array];
    UIColor *color = GetColor(127, 127, 127, 1);
    self.backgroundColor = [color colorWithAlphaComponent:0.5];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width-40, 200)];
    view.backgroundColor = [UIColor lightGrayColor];
    view.center = self.center;
    [self addSubview:view];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width, 21)];
    label.backgroundColor = [UIColor whiteColor];
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    
    UIPickerView *pick = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 22, view.frame.size.width, 135)];
    pick.delegate = self;
    pick.backgroundColor = [UIColor whiteColor];
    [view addSubview:pick];
    self.pickView = pick;
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 158, view.frame.size.width, 44)];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor whiteColor]];
    [button addTarget:self action:@selector(chooseNumer) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    if (showYear) {
        for (int i=2012; i<2021; i++) {
            [self.arrayData addObject:[NSString stringWithFormat:@"%d年",i]];
        }
    }else
    {
        for (int i=0; i<100; i++) {
            [self.arrayData addObject:[NSString stringWithFormat:@"%d",i]];
        }
    }
    
}

-(void)chooseNumer
{
    if ([self.delegate respondsToSelector:@selector(getChoosed:)]) {
        [self.delegate getChoosed:self.pickView];
    }
    [self removeFromSuperview];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
}

#pragma -mark pickView
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.arrayData.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.arrayData[row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.selected = self.arrayData[row];
}

//-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
//{
//    UILabel *mycom1 = [[UILabel alloc] init];
//    mycom1.textAlignment = NSTextAlignmentCenter;
//    mycom1.backgroundColor = [UIColor clearColor];
//    mycom1.frame = CGRectMake(0, 0, pickerView.frame.size.width/2.0, 50);
//    [mycom1 setFont:[UIFont boldSystemFontOfSize:30]];
//    mycom1.text = [self.arrayData objectAtIndex:row];
//    return mycom1;
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
