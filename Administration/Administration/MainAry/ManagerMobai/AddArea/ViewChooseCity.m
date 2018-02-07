//
//  ViewChooseCity.m
//  Administration
//
//  Created by zhang on 2017/11/15.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "ViewChooseCity.h"
#import "CellCity.h"

#pragma clang diagnostic ignored "Warc-performSelector-leak"

@interface ViewChooseCity ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,weak)UITableView *tableView1;
@property (nonatomic,weak)UITableView *tableView2;
@property (nonatomic,weak)UITableView *tableView3;

@property (nonatomic,strong)NSMutableArray *arrayData;
@property (nonatomic,strong)NSMutableArray *arrayAll;
@property (nonatomic,strong)NSMutableArray *arrayP;
@property (nonatomic,strong)NSMutableArray *arrayC;
@property (nonatomic,strong)NSMutableArray *arrayT;

@property (nonatomic,strong)NSIndexPath *indexPath;
@property (nonatomic)BOOL isRequestData;

@end

@implementation ViewChooseCity

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUI];
    }
    return self;
}

-(NSArray *)getList:(NSString *)name
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"province_data" ofType:@"json"];
    NSData *cityData = [[NSData alloc]initWithContentsOfFile:path];
    NSDictionary *dictdata = [NSJSONSerialization JSONObjectWithData:cityData options:NSJSONReadingAllowFragments error:nil];
    
    NSArray *arrayProvince = dictdata[@"province"];
    NSArray *array = [NSArray array];
    for (NSDictionary *dict in arrayProvince) {
        
        if ([dict[@"provinceName"]isEqualToString:name]) {
            array = dict[@"cityList"];
        }else
        {
            NSArray *array1 = dict[@"cityList"];
            for (NSDictionary *dict1 in array1) {
                if ([dict1[@"cityName"]isEqualToString:name]) {
                    array =  dict1[@"countyList"];
                }
                
            }
        }
    }
    return array;
}


-(void)initData
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"province_data" ofType:@"json"];
    NSData *cityData = [[NSData alloc]initWithContentsOfFile:path];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:cityData options:NSJSONReadingAllowFragments error:nil];
    
    self.arrayP = [dict[@"province"]mutableCopy];
    
    for (int i=0;i<self.arrayP.count;i++) {
        NSMutableDictionary *dictP = [self.arrayP[i]mutableCopy];
        [dictP setValue:@"1" forKey:@"isSelect"];
        [self.arrayP replaceObjectAtIndex:i withObject:dictP];
    }
    
    [self.tableView1 reloadData];
}

-(void)getHttpData
{
    NSString *urlStr =[NSString stringWithFormat:@"%@shop/selectRegion.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSDictionary *dictinfo = @{@"appkey":appKeyStr,
                           @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                           @"CompanyInfoId":compid,
                           @"RoleId":[ShareModel shareModel].roleID,
                           @"DepartmentId":[ShareModel shareModel].departmentID,
                           @"userid":[USER_DEFAULTS valueForKey:@"userid"]
                           };
    [ZXDNetworking GET:urlStr parameters:dictinfo success:^(id responseObject) {
        
        NSString *code = [responseObject valueForKey:@"status"];
        if ([code isEqualToString:@"0000"]) {
            
            [self.arrayP removeAllObjects];
            [self.arrayC removeAllObjects];
            [self.arrayT removeAllObjects];
            
            NSArray *array = [responseObject valueForKey:@"list"];
            
            NSMutableArray *arrayArea = [NSMutableArray array];
            
            for (NSDictionary *dictArea in array) {
                NSData *jsonData = [dictArea[@"province"] dataUsingEncoding:NSUTF8StringEncoding];
                NSError *error;
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
                [arrayArea addObject:dict];
            }
            NSDictionary *dict = [NSDictionary dictionaryWithObject:arrayArea forKey:@"province"];
            
            self.arrayP = [dict[@"province"]mutableCopy];
            self.isRequestData = YES;
            [self.tableView1 reloadData];
            
        }
        
    } failure:^(NSError *error) {
        
    } view:self MBPro:YES];
}

-(void)setUI
{
    UIColor *color = GetColor(239, 239, 244, 1);
    self.backgroundColor = [color colorWithAlphaComponent:0.3];
    
    self.arrayData = [NSMutableArray array];
    self.arrayP = [NSMutableArray array];
    self.arrayC = [NSMutableArray array];
    self.arrayT = [NSMutableArray array];
    
    self.arrayProvince = [NSMutableArray array];
    self.arrayCity = [NSMutableArray array];
    self.arrayCountry = [NSMutableArray array];
    self.arrayAll = [NSMutableArray array];
    
    [self initData];
    
    
    if (![[ShareModel shareModel].roleID isEqualToString:@"1"]&&![[ShareModel shareModel].roleID isEqualToString:@"7"]) {
        
        [self getHttpData];
    }
    
    UITableView *tableView1 = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width/3, 300)style:UITableViewStylePlain];
    tableView1.delegate = self;
    tableView1.dataSource = self;
    tableView1.showsVerticalScrollIndicator = NO;
    [tableView1 registerClass:[CellCity class] forCellReuseIdentifier:@"cell"];
    [ZXDNetworking setExtraCellLineHidden:tableView1];
    [self addSubview:tableView1];
    self.tableView1 = tableView1;
    
    UITableView *tableView2 = [[UITableView alloc]initWithFrame:CGRectMake(self.frame.size.width/3, 0, self.frame.size.width/3, 300)style:UITableViewStylePlain];
    tableView2.delegate = self;
    tableView2.dataSource = self;
    tableView2.showsVerticalScrollIndicator = NO;
    [tableView1 registerClass:[CellCity class] forCellReuseIdentifier:@"cell"];
    [ZXDNetworking setExtraCellLineHidden:tableView2];
    [self addSubview:tableView2];
    self.tableView2 = tableView2;
    
    UITableView *tableView3 = [[UITableView alloc]initWithFrame:CGRectMake(self.frame.size.width/3*2, 0, self.frame.size.width/3, 300)style:UITableViewStylePlain];
    tableView3.delegate = self;
    tableView3.dataSource = self;
    tableView3.showsVerticalScrollIndicator = NO;
    [tableView1 registerClass:[CellCity class] forCellReuseIdentifier:@"cell"];
    [ZXDNetworking setExtraCellLineHidden:tableView3];
    [self addSubview:tableView3];
    self.tableView3 = tableView3;
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
    CellCity *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[CellCity alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (self.isRequestData) {
        
    if ([tableView isEqual:self.tableView1]) {
        NSDictionary *dict = self.arrayP[indexPath.row];
        
        cell.labelName.text = dict[@"provinceName"];
        
        if (indexPath==self.indexPath) {
            cell.imageViewSelect.image = [UIImage imageNamed:@"djh_ico"];
            cell.labelLine.backgroundColor = [UIColor blueColor];
        }else
        {
            cell.imageViewSelect.image = [UIImage imageNamed:@"djq_ico"];
            cell.labelLine.backgroundColor = [UIColor clearColor];
        }
        
    }else if([tableView isEqual:self.tableView2])
    {
        NSDictionary *dict = self.arrayC[indexPath.row];
        cell.labelName.text = dict[@"cityName"];
        cell.backgroundColor = GetColor(242	,243,244,1);
        if ([dict[@"isSelect"]isEqualToString:@"1"]) {
            cell.imageViewSelect.image = [UIImage imageNamed:@"djq_ico"];
            cell.labelLine.backgroundColor = [UIColor clearColor];
        }else
        {
            cell.imageViewSelect.image = [UIImage imageNamed:@"djh_ico"];
            cell.labelLine.backgroundColor = [UIColor blueColor];
        }
    }else
    {
        NSDictionary *dict = self.arrayT[indexPath.row];
        cell.labelName.text = dict[@"name"];
        cell.backgroundColor = GetColor(234,235,236,1);
        if ([dict[@"isSelect"]isEqualToString:@"1"]) {
            cell.imageViewSelect.image = [UIImage imageNamed:@"djq_ico"];
            cell.labelLine.backgroundColor = [UIColor clearColor];
        }else
        {
            cell.imageViewSelect.image = [UIImage imageNamed:@"djh_ico"];
            cell.labelLine.backgroundColor = [UIColor blueColor];
        }
    }
    }else
    {
        if ([tableView isEqual:self.tableView1]) {
            NSDictionary *dict = self.arrayP[indexPath.row];
            
            cell.labelName.text = dict[@"provinceName"];
            
            if (indexPath==self.indexPath) {
                cell.imageViewSelect.image = [UIImage imageNamed:@"djh_ico"];
                cell.labelLine.backgroundColor = [UIColor blueColor];
            }else
            {
                cell.imageViewSelect.image = [UIImage imageNamed:@"djq_ico"];
                cell.labelLine.backgroundColor = [UIColor clearColor];
            }
            
        }else if([tableView isEqual:self.tableView2])
        {
            NSDictionary *dict = self.arrayC[indexPath.row];
            cell.labelName.text = dict[@"cityName"];
            cell.backgroundColor = GetColor(242	,243,244,1);
            if ([dict[@"isSelect"]isEqualToString:@"1"]) {
                cell.imageViewSelect.image = [UIImage imageNamed:@"djq_ico"];
                cell.labelLine.backgroundColor = [UIColor clearColor];
            }else
            {
                cell.imageViewSelect.image = [UIImage imageNamed:@"djh_ico"];
                cell.labelLine.backgroundColor = [UIColor blueColor];
            }
        }else
        {
            NSDictionary *dict = self.arrayT[indexPath.row];
            cell.labelName.text = dict[@"name"];
            cell.backgroundColor = GetColor(234,235,236,1);
            if ([dict[@"isSelect"]isEqualToString:@"1"]) {
                cell.imageViewSelect.image = [UIImage imageNamed:@"djq_ico"];
                cell.labelLine.backgroundColor = [UIColor clearColor];
            }else
            {
                cell.imageViewSelect.image = [UIImage imageNamed:@"djh_ico"];
                cell.labelLine.backgroundColor = [UIColor blueColor];
            }
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isRequestData) {
        
        if ([tableView isEqual:self.tableView1]) {
            NSMutableDictionary *dict = [self.arrayP[indexPath.row]mutableCopy];
            [self.arrayCity removeAllObjects];
            self.indexPath = indexPath;
            [self.arrayProvince removeAllObjects];
            [self.arrayProvince addObject:dict[@"provinceName"]];
            
            [self.tableView1 reloadData];
            
            self.arrayC = [dict[@"cityList"]mutableCopy];
            if ([self.arrayC[0][@"cityName"] isEqualToString:@"全部"]) {
                self.arrayC = [[self getList:self.arrayP[indexPath.row][@"provinceName"]]mutableCopy];
            }
            
            for (int i=0; i<self.arrayC.count; i++) {
                NSMutableDictionary *dictC = [self.arrayC[i]mutableCopy];
                [dictC setValue:@"1" forKey:@"isSelect"];
                [self.arrayCity addObject:dictC[@"cityName"]];
                [self.arrayC replaceObjectAtIndex:i withObject:dictC];
            }
            [self.arrayT removeAllObjects];
            [self.tableView2 reloadData];
            [self.tableView3 reloadData];
            
        }else if ([tableView isEqual:self.tableView2])
        {
            NSMutableDictionary  *dict = [self.arrayC[indexPath.row]mutableCopy];
            
            if ([dict[@"isSelect"]isEqualToString:@"1"]) {
                [dict setValue:@"2" forKey:@"isSelect"];
                [self.arrayCity addObject:dict[@"cityName"]];
                
                
            }else
            {
                [dict setValue:@"1" forKey:@"isSelect"];
                [self.arrayCity removeObject:dict[@"cityName"]];
                
            }
            
            if ([self.arrayCity containsObject:dict[@"cityName"]]) {
                [self.arrayCity removeAllObjects];
                [self.arrayCity addObject:dict[@"cityName"]];
            }
            
            
            [self.arrayC replaceObjectAtIndex:indexPath.row withObject:dict];
            [self.tableView2 reloadData];
            
            //遍历数据源，拿到哪个数据被选中
            for (int i=0 ;i<self.arrayC.count;i++) {
                NSDictionary *dictionary = self.arrayC[i];
                if ([dictionary[@"isSelect"]isEqualToString:@"2"]) {
                    dict = self.arrayC[i];
                }
            }
            
            if (self.arrayCity.count==1) {
                self.arrayT = [dict[@"countyList"]mutableCopy];
                
                if ([dict[@"countyList"][0]isEqualToString:@"全部"]) {
                    self.arrayT = [[self getList:dict[@"cityName"]]mutableCopy];
                }
                
                for (int i=0; i<self.arrayT.count; i++) {
                    if (![self.arrayT[i]isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *dict = [NSDictionary dictionaryWithObject:self.arrayT[i] forKey:@"name"];
                        [self.arrayT replaceObjectAtIndex:i withObject:dict];
                    }
                }
                
                if ([self.arrayT[indexPath.row][@"name"] isEqualToString:@"全部"]) {
                    self.arrayT = [[self getList:dict[@"cityName"]]mutableCopy];
                }
                
                for (int i=0;i<self.arrayT.count;i++) {
                    NSMutableDictionary *dictP = [self.arrayT[i]mutableCopy];
                    [dictP setValue:@"1" forKey:@"isSelect"];
                    [self.arrayCountry addObject:dictP[@"name"]];
                    [self.arrayT replaceObjectAtIndex:i withObject:dictP];
                }
            }else
            {
                [self.arrayT removeAllObjects];
                [self.tableView3 reloadData];
            }
            [self.tableView3 reloadData];
            
        }else
        {
            NSMutableDictionary  *dict = [self.arrayT[indexPath.row]mutableCopy];
            if ([dict[@"isSelect"]isEqualToString:@"1"]) {
                [dict setValue:@"2" forKey:@"isSelect"];
                [self.arrayCountry addObject:dict[@"name"]];
                [self.arrayAll addObject:dict[@"name"]];
                
            }else
            {
                [dict setValue:@"1" forKey:@"isSelect"];
                [self.arrayCountry removeObject:dict[@"name"]];
                [self.arrayAll removeObject:dict[@"name"]];
            }
            
            if ([self.arrayCountry containsObject:dict[@"cityName"]]) {
                [self.arrayCountry removeAllObjects];
                [self.arrayCountry addObject:dict[@"cityName"]];
            }
            
            [self.arrayT replaceObjectAtIndex:indexPath.row withObject:dict];
            [self.tableView3 reloadData];
            
        }
        self.stringAll = [self.arrayAll componentsJoinedByString:@"/"];
    }else
    {
        
        if ([tableView isEqual:self.tableView1]) {
            NSMutableDictionary *dict = [self.arrayP[indexPath.row]mutableCopy];
            [self.arrayCity removeAllObjects];
            self.indexPath = indexPath;
            [self.arrayProvince removeAllObjects];
            [self.arrayProvince addObject:dict[@"provinceName"]];
            
            [self.tableView1 reloadData];
            
            self.arrayC = [dict[@"cityList"]mutableCopy];
            
            for (int i=0; i<self.arrayC.count; i++) {
                NSMutableDictionary *dictC = [self.arrayC[i]mutableCopy];
                [dictC setValue:@"1" forKey:@"isSelect"];
                [self.arrayC replaceObjectAtIndex:i withObject:dictC];
            }
            
            
            [self.arrayT removeAllObjects];
            [self.tableView2 reloadData];
            [self.tableView3 reloadData];
            
            [self.tableView2 reloadData];
            
            
        }else if ([tableView isEqual:self.tableView2])
        {
            NSMutableDictionary  *dict = [self.arrayC[indexPath.row]mutableCopy];
            
            if ([dict[@"isSelect"]isEqualToString:@"1"]) {
                [dict setValue:@"2" forKey:@"isSelect"];
                [self.arrayCity addObject:dict[@"cityName"]];
                [self.arrayAll addObject:dict[@"cityName"]];
                
            }else
            {
                [dict setValue:@"1" forKey:@"isSelect"];
                [self.arrayCity removeObject:dict[@"cityName"]];
                [self.arrayAll removeObject:dict[@"cityName"]];
            }
            
            [self.arrayC replaceObjectAtIndex:indexPath.row withObject:dict];
            [self.tableView2 reloadData];
            
            //遍历数据源，拿到哪个数据被选中
            for (int i=0 ;i<self.arrayC.count;i++) {
                NSDictionary *dictionary = self.arrayC[i];
                if ([dictionary[@"isSelect"]isEqualToString:@"2"]) {
                    dict = self.arrayC[i];
                }
            }
            if (self.arrayCity.count==1) {
                self.arrayT = [dict[@"countyList"]mutableCopy];
                [self.arrayT insertObject:@{@"name":@"全部",@"isSelect":@"1"} atIndex:0];
                
                for (int i=0;i<self.arrayT.count;i++) {
                    NSMutableDictionary *dictP = [self.arrayT[i]mutableCopy];
                    [dictP setValue:@"1" forKey:@"isSelect"];
                    [self.arrayT replaceObjectAtIndex:i withObject:dictP];
                }
            }else
            {
                [self.arrayT removeAllObjects];
                [self.tableView3 reloadData];
            }
            [self.tableView3 reloadData];
            
        }else
        {
            if (indexPath.row==0) {
                NSDictionary *dict = self.arrayT[0];
                [self.arrayCountry removeAllObjects];
                    for (int i=0; i<self.arrayT.count; i++) {
                        NSMutableDictionary *dict1 = [self.arrayT[i]mutableCopy];
                        if ([dict[@"isSelect"]isEqualToString:@"1"]) {
                          [dict1 setValue:@"2" forKey:@"isSelect"];
                            [self.arrayCountry addObject:dict1[@"name"]];
                        }else
                        {
                            [dict1 setValue:@"1" forKey:@"isSelect"];
                            [self.arrayCountry removeObject:dict1[@"name"]];
                        }
                        
                        [self.arrayT replaceObjectAtIndex:i withObject:dict1];
                    }
                
            }else
            {
                NSMutableDictionary *dict1 = [self.arrayT[0] mutableCopy];
                [dict1 setValue:@"1" forKey:@"isSelect"];
                [self.arrayT replaceObjectAtIndex:0 withObject:dict1];
                [self.arrayCountry removeObject:dict1[@"name"]];
                
                NSMutableDictionary *dict = [self.arrayT[indexPath.row]mutableCopy];
                if ([dict[@"isSelect"]isEqualToString:@"1"]) {
                    [dict setValue:@"2" forKey:@"isSelect"];
                    [self.arrayAll addObject:dict[@"name"]];
                    [self.arrayCountry addObject:dict[@"name"]];
                }else
                {
                    [dict setValue:@"1" forKey:@"isSelect"];
                    [self.arrayAll removeObject:dict[@"name"]];
                    [self.arrayCountry removeObject:dict[@"name"]];
                }
                [self.arrayT replaceObjectAtIndex:indexPath.row withObject:dict];
                
                if (self.arrayCountry.count==self.arrayT.count-1) {
                    [dict1 setValue:@"2" forKey:@"isSelect"];
                    [self.arrayT replaceObjectAtIndex:0 withObject:dict1];
                    [self.arrayCountry addObject:dict1[@"name"]];
                }
                
            }
           [self.tableView3 reloadData];
        }
        self.stringAll = [self.arrayAll componentsJoinedByString:@"/"];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

#pragma -mark system
-(void)willMoveToSuperview:(UIView *)newSuperview
{
    if ([self.delegate respondsToSelector:@selector(getCity)]) {
        [self.delegate getCity];
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
