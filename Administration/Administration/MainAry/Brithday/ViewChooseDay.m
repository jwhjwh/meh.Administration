//
//  ViewChooseDay.m
//  Administration
//
//  Created by zhang on 2017/11/3.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "ViewChooseDay.h"
#import "CellSetDay.h"

@interface ViewChooseDay ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong)NSArray *arrayTitle;

@end

@implementation ViewChooseDay

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
    
    self.arrayTitle = @[@[@"生日当天",@"提前1天"],@[@"提前3天",@"提前5天"],@[@"提前7天",@"提前15天"],@[@"提前30天"]];
    
    self.arraySelect = [NSMutableArray array];
    
    UIColor *color = GetColor(126, 127, 128, 1);
    self.backgroundColor = [color colorWithAlphaComponent:0.3];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 20, self.frame.size.width-40, 290)];
    view.backgroundColor = GetColor(192, 192, 192, 1);
    view.center = self.center;
    [self addSubview:view];
    
    UILabel *labelT = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width, 44)];
    labelT.text = @"选择提醒天数";
    labelT.textAlignment = NSTextAlignmentCenter;
    labelT.backgroundColor = [UIColor whiteColor];
    [view addSubview:labelT];
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    
    //同一行相邻两个cell的最小间距
    
    layout.minimumInteritemSpacing = 0;
    
    //最小两行之间的间距
    
    layout.minimumLineSpacing = 0;
    
    layout.scrollDirection=UICollectionViewScrollDirectionVertical;
    
    UICollectionView * collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 45, view.frame.size.width, 200) collectionViewLayout:layout];
    
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerClass:[CellSetDay class] forCellWithReuseIdentifier:@"cell"];
    collectionView.backgroundColor = [UIColor whiteColor];
    [view addSubview:collectionView];
    self.collectView = collectionView;
    
    UIButton *buttonSure = [[UIButton alloc]initWithFrame:CGRectMake(0, 246, view.frame.size.width, 44)];
    [buttonSure setTitle:@"确定" forState:UIControlStateNormal];
    [buttonSure setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [buttonSure setBackgroundColor:[UIColor whiteColor]];
    [buttonSure addTarget:self action:@selector(buttonSure) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:buttonSure];
}

-(void)buttonSure
{
    if ([self.delegate respondsToSelector:@selector(getSelect)]) {
        [self.delegate getSelect];
    }
    [self removeFromSuperview];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath

{
    
    return CGSizeMake(collectionView.width/2, 44);
    
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section

{
    
    return UIEdgeInsetsMake(1, 0, 0 , 0);
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 4;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section<3) {
        return 2;
    }
    else
    {
        return 1;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CellSetDay *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.labelTitle.text = self.arrayTitle[indexPath.section][indexPath.row];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CellSetDay *cell = (CellSetDay *)[collectionView cellForItemAtIndexPath:indexPath];
    
    NSString *string = [NSString stringWithFormat:@"%ld",indexPath.section*2+1+indexPath.row];
    
    cell.isSelected = !cell.isSelected;
    
    if (cell.isSelected) {
        cell.imageViewSelect.image = [UIImage imageNamed:@"xuanzhong"];
        cell.isSelected = YES;
        [self.arraySelect addObject:string];
    }else
    {
        cell.imageViewSelect.image = [UIImage imageNamed:@"weixuanzhong"];
        cell.isSelected = NO;
        [self.arraySelect removeObject:string];
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
