//
//  UIChooseArea.m
//  Administration
//
//  Created by zhang on 2017/12/11.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "UIChooseArea.h"
#import "CellChooseArea.h"
#import "CellCity.h"
#define WIDTH self.frame.size.width
#define HEIGHT self.frame.size.height

@interface UIChooseArea ()<UITableViewDelegate,UITableViewDataSource>

/*****tableView1和tableView2为单选，tableView3为多选******/
@property (nonatomic,weak)UITableView *tableView1;
@property (nonatomic,weak)UITableView *tableView2;
@property (nonatomic,weak)UITableView *tableView3;

/***********数据源************/
@property (nonatomic,strong)NSMutableArray *arrayP;//省份数据源
@property (nonatomic,strong)NSMutableArray *arrayC;//城市数据源
@property (nonatomic,strong)NSMutableArray *arrayT;//县、区数据源
@property (nonatomic,strong)NSMutableArray *arrayAll;//被选中的县、区数据

/*****分别记录tableView1和tableView2哪行被选中******/
@property (nonatomic,strong)NSIndexPath *indexPath1;
@property (nonatomic,strong)NSIndexPath *indexPath2;
@end

@implementation UIChooseArea

#pragma -mark system
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

#pragma -mark custem
-(void)initData
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"province_data" ofType:@"json"];
    NSData *cityData = [[NSData alloc]initWithContentsOfFile:path];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:cityData options:NSJSONReadingAllowFragments error:nil];
    
    self.arrayP = [dict[@"province"]mutableCopy];
    [self.tableView1 reloadData];
}

-(void)setUI
{
    self.arrayAll = [NSMutableArray array];
    self.dictArea = [NSMutableDictionary dictionary];
    
    [self.dictArea setValue:@"" forKey:@"City"];
    [self.dictArea setValue:@"" forKey:@"County"];
    [self.dictArea setValue:@"" forKey:@"Province"];
    
    UITableView *tableView1 = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH/3,HEIGHT)];
    tableView1.delegate = self;
    tableView1.dataSource = self;
    [ZXDNetworking setExtraCellLineHidden:tableView1];
    [self addSubview:tableView1];
    self.tableView1 = tableView1;
    
    UITableView *tableView2 = [[UITableView alloc]initWithFrame:CGRectMake(WIDTH/3, 0, WIDTH/3,HEIGHT)];
    tableView2.delegate = self;
    tableView2.dataSource = self;
    [ZXDNetworking setExtraCellLineHidden:tableView2];
    [self addSubview:tableView2];
    self.tableView2 = tableView2;
    
    UITableView *tableView3 = [[UITableView alloc]initWithFrame:CGRectMake(WIDTH/3*2, 0, WIDTH/3,HEIGHT)];
    tableView3.delegate = self;
    tableView3.dataSource = self;
    [ZXDNetworking setExtraCellLineHidden:tableView3];
    [self addSubview:tableView3];
    self.tableView3 = tableView3;
    
    [self initData];
}

#pragma -mark tableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.tableView1]) {
        return self.arrayP.count;
    }else if([tableView isEqual:self.tableView2])
    {
        return self.arrayC.count;
    }else
    {
        return self.arrayT.count;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.tableView1]||[tableView isEqual:self.tableView2]) {
        CellChooseArea *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[CellChooseArea alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if ([tableView isEqual:self.tableView1]) {
            NSDictionary *dict = self.arrayP[indexPath.row];
            cell.labelName.text = dict[@"name"];
            
            if (indexPath==self.indexPath1) {
                cell.labelName.textColor = [UIColor blueColor];
                cell.labelLine.backgroundColor = [UIColor blueColor];
            }else
            {
                    cell.labelName.textColor = [UIColor blackColor];
                    cell.labelLine.backgroundColor = [UIColor whiteColor];
            }
        }else
        {
            NSDictionary *dict = self.arrayC[indexPath.row];
            cell.labelName.text = dict[@"name"];
            cell.backgroundColor = GetColor(242	,243,244,1);
            cell.labelLine.backgroundColor = GetColor(242,243,244,1);
            if (indexPath==self.indexPath2) {
                cell.labelName.textColor = [UIColor blueColor];
                cell.labelLine.backgroundColor = [UIColor blueColor];
            }else
            {
                cell.labelName.textColor = [UIColor blackColor];
                cell.labelLine.backgroundColor = [UIColor whiteColor];
            }
        }
        
        return cell;
    }else
    {
        CellCity *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[CellCity alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = GetColor(234,235,236,1);
        
        NSDictionary *dict = self.arrayT[indexPath.row];
        cell.labelName.text = dict[@"name"];
        if ([dict[@"isSelect"]isEqualToString:@"1"]) {
            cell.labelName.textColor = [UIColor blackColor];
            cell.imageViewSelect.image = [UIImage imageNamed:@"djq_ico"];
        }else
        {
            cell.labelName.textColor = [UIColor blueColor];
            cell.imageViewSelect.image = [UIImage imageNamed:@"djh_ico"];
        }
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([tableView isEqual:self.tableView1]) {
        NSDictionary *dict = self.arrayP[indexPath.row];
        [self.dictArea setValue:dict[@"name"] forKey:@"Province"];
        self.arrayC = [dict[@"city"]mutableCopy];
        self.indexPath1 = indexPath;
        self.indexPath2 = nil;
        [self.arrayT removeAllObjects];
        [self.tableView1 reloadData];
        [self.tableView2 reloadData];
        [self.tableView3 reloadData];
    }else if ([tableView isEqual:self.tableView2])
    {
        NSDictionary *dict = self.arrayC[indexPath.row];
        [self.dictArea setValue:dict[@"name"] forKey:@"City"];
        self.arrayT = [dict[@"district"]mutableCopy];
        NSDictionary *addDict =@{@"name":@"全部",@"zcode":@"100011"};
        [self.arrayT insertObject:addDict atIndex:0];
        
        for (int i=0; i<self.arrayT.count; i++) {
            NSMutableDictionary *dict = [self.arrayT[i]mutableCopy];
            [dict setValue:@"1" forKey:@"isSelect"];
            [self.arrayT replaceObjectAtIndex:i withObject:dict];
        }
        
        self.indexPath2 = indexPath;
        [self.tableView2 reloadData];
        [self.tableView3 reloadData];
    }else
    {
        CellCity *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (indexPath.row==0) {
            [self.arrayAll removeAllObjects];
           
            cell.isSelect = !cell.isSelect;
            NSDictionary *dict = self.arrayT[0];
            
            for (int i=0; i<self.arrayT.count; i++) {
                NSMutableDictionary *dictinfo = [self.arrayT[i]mutableCopy];
                if ([dict[@"isSelect"]isEqualToString:@"1"]) {
                    [dictinfo setValue:@"2" forKey:@"isSelect"];
                    [self.arrayAll addObject:dictinfo];
                }else
                {
                    [dictinfo setValue:@"1" forKey:@"isSelect"];
                    [self.arrayAll removeObject:dictinfo];
                }
                [self.arrayT replaceObjectAtIndex:i withObject:dictinfo];
            }
        }else
        {
            NSMutableDictionary *dict1 = [self.arrayT[0] mutableCopy];
            [dict1 setValue:@"1" forKey:@"isSelect"];
            [self.arrayT replaceObjectAtIndex:0 withObject:dict1];
            
            NSMutableDictionary *dict = [self.arrayT[indexPath.row]mutableCopy];
            if ([dict[@"isSelect"]isEqualToString:@"1"]) {
                [dict setValue:@"2" forKey:@"isSelect"];
                [self.arrayAll addObject:dict[@"name"]];
            }else
            {
                [dict setValue:@"1" forKey:@"isSelect"];
                [self.arrayAll removeObject:dict[@"name"]];
            }
            [self.arrayT replaceObjectAtIndex:indexPath.row withObject:dict];
        }
        NSString *stringArea = [self.arrayAll componentsJoinedByString:@"/"];
        [self.dictArea setValue:stringArea forKey:@"County"];
        [self.tableView3 reloadData];
    }
}

-(void)willMoveToSuperview:(UIView *)newSuperview
{
    if ([self.delegate respondsToSelector:@selector(getChooseArea)]) {
        [self.delegate getChooseArea];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
