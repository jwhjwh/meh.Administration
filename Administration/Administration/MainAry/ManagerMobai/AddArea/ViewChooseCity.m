//
//  ViewChooseCity.m
//  Administration
//
//  Created by zhang on 2017/11/15.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "ViewChooseCity.h"
#import "CellCity.h"
@interface ViewChooseCity ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,weak)UITableView *tableView1;
@property (nonatomic,weak)UITableView *tableView2;
@property (nonatomic,weak)UITableView *tableView3;

@property (nonatomic,strong)NSMutableArray *arrayData;
@property (nonatomic,strong)NSMutableArray *arrayAll;
@property (nonatomic,strong)NSMutableArray *arrayP;
@property (nonatomic,strong)NSMutableArray *arrayC;
@property (nonatomic,strong)NSMutableArray *arrayT;

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
    
    NSArray *array;
    for (NSDictionary *dict in arrayProvince) {
        
        if ([dict[@"name"]isEqualToString:name]) {
            array = dict[@"city"];
        }else
        {
            NSArray *array1 = dict[@"city"];
            for (NSDictionary *dict1 in array1) {
                if ([dict1[@"name"]isEqualToString:name]) {
                    array =  dict1[@"district"];
                    
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
}

-(void)getHttpData
{
    NSString *urlStr =[NSString stringWithFormat:@"%@shop/selectRegion.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSDictionary *dict = @{@"appkey":appKeyStr,
                           @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                           @"CompanyInfoId":compid,
                           @"RoleId":[ShareModel shareModel].roleID,
                           @"DepartmentId":[ShareModel shareModel].departmentID,
                           @"userid":[USER_DEFAULTS valueForKey:@"userid"]
                           };
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        
        NSString *code = [responseObject valueForKey:@"status"];
        if ([code isEqualToString:@"0000"]) {
            
            [self.arrayP removeAllObjects];
            [self.arrayC removeAllObjects];
            [self.arrayT removeAllObjects];
            
            NSArray *array = [responseObject valueForKey:@"list"];
            
            
//            NSDictionary *dictPlist = @{
//                                        
//                                        @"province":@[@{@"name":@"河北",
//                                                        @"city":@[@{@"name":@"保定",
//                                                                    @"district":@[@{@"name":@"小区",
//                                                                                   @"zcode":@"0000"}]}]},
//                                                      @{@"name":@"河北",
              //                                          @"city":@[@{@"name":@"保定",
                                                                  //@"district":@[@{@"name":@"小区",
                                                                                //@"zcode":@"0000"}]}]}],
//                                        
//                                        
//                                        
//                                        };
            
            //按照plist文件格式创建数据源
            NSMutableDictionary *dictplist = [NSMutableDictionary dictionary];
            NSMutableArray *arraydata = [NSMutableArray array];
           
            for (NSDictionary *dictinfo in array) {
                
               NSMutableArray*  province = [[dictinfo[@"province"]componentsSeparatedByString:@","]mutableCopy];
                
                for (NSString *string in province) {
                    if ([string isEqualToString:@""]) {
                        [province removeObject:string];
                    }
                }
                
                
                
               NSMutableArray* city = [[dictinfo[@"city"]componentsSeparatedByString:@","]mutableCopy];
                for (NSString *string in city) {
                    if ([string isEqualToString:@""]) {
                        [city removeObject:string];
                    }
                }
                
               NSMutableArray* district = [[dictinfo[@"county"]componentsSeparatedByString:@","]mutableCopy];
                for (NSString *string in district) {
                    if ([string isEqualToString:@""]) {
                        [district removeObject:string];
                    }
                }
                
                NSMutableArray *array1 = [NSMutableArray array];
                
                for (NSString *string1 in district) {
                    NSMutableDictionary *dictdis = [NSMutableDictionary dictionary];
                    [dictdis setValue:string1 forKey:@"name"];
                    [array1 addObject:dictdis];
                }
                

                NSMutableArray *array2 = [NSMutableArray array];
                for (NSString *string in city) {
                    NSMutableDictionary *dict2 = [NSMutableDictionary dictionary];
                    [dict2 setValue:string forKey:@"name"];
                    
                    
                    if (district.count==0) {
                        [dict2 setValue:[self getList:string] forKey:@"district"];
                    }else
                    {
                        [dict2 setValue:array1 forKey:@"district"];
                    }
                    
                    [array2 addObject:dict2];
                }
               
                
                for (NSString *string in province) {
                    NSMutableDictionary *dictP = [NSMutableDictionary dictionary];
                    [dictP setValue:string forKey:@"name"];
                    
                    if (city.count==0) {
                        [dictP setValue:[self getList:string] forKey:@"city"];
                    }else
                    {
                        [dictP setValue:array2 forKey:@"city"];
                    }
                    
                    
                    [arraydata addObject:dictP];
                }
            }
            
            [dictplist setValue:arraydata forKey:@"province"];
            
            self.arrayP = [dictplist[@"province"]mutableCopy];
            
            for (int i=0;i<self.arrayP.count;i++) {
                NSMutableDictionary *dictP = [self.arrayP[i]mutableCopy];
                [dictP setValue:@"1" forKey:@"isSelect"];
                [self.arrayP replaceObjectAtIndex:i withObject:dictP];
            }
            
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
    
    if (![[ShareModel shareModel].roleID isEqualToString:@"1"]||![[ShareModel shareModel].roleID isEqualToString:@"7"]) {
        
        [self getHttpData];
    }
    
    UITableView *tableView1 = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width/3, 300)style:UITableViewStylePlain];
    tableView1.delegate = self;
    tableView1.dataSource = self;
    tableView1.showsVerticalScrollIndicator = NO;
    [ZXDNetworking setExtraCellLineHidden:tableView1];
    [self addSubview:tableView1];
    self.tableView1 = tableView1;
    
    UITableView *tableView2 = [[UITableView alloc]initWithFrame:CGRectMake(self.frame.size.width/3, 0, self.frame.size.width/3, 300)style:UITableViewStylePlain];
    tableView2.delegate = self;
    tableView2.dataSource = self;
    tableView2.showsVerticalScrollIndicator = NO;
    [ZXDNetworking setExtraCellLineHidden:tableView2];
    [self addSubview:tableView2];
    self.tableView2 = tableView2;
    
    UITableView *tableView3 = [[UITableView alloc]initWithFrame:CGRectMake(self.frame.size.width/3*2, 0, self.frame.size.width/3, 300)style:UITableViewStylePlain];
    tableView3.delegate = self;
    tableView3.dataSource = self;
    tableView3.showsVerticalScrollIndicator = NO;
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
    
    if ([tableView isEqual:self.tableView1]) {
        NSDictionary *dict = self.arrayP[indexPath.row];
        
        cell.labelName.text = dict[@"name"];
        
        if ([dict[@"isSelect"]isEqualToString:@"1"]) {
            cell.imageViewSelect.image = [UIImage imageNamed:@"djq_ico"];
            
        }else
        {
            cell.imageViewSelect.image = [UIImage imageNamed:@"djh_ico"];
        }
        
    }else if([tableView isEqual:self.tableView2])
    {
        NSDictionary *dict = self.arrayC[indexPath.row];
        cell.labelName.text = dict[@"name"];
        if ([dict[@"isSelect"]isEqualToString:@"1"]) {
            cell.imageViewSelect.image = [UIImage imageNamed:@"djq_ico"];
        }else
        {
            cell.imageViewSelect.image = [UIImage imageNamed:@"djh_ico"];
        }
    }else
    {
        NSDictionary *dict = self.arrayT[indexPath.row];
        cell.labelName.text = dict[@"name"];
        if ([dict[@"isSelect"]isEqualToString:@"1"]) {
            cell.imageViewSelect.image = [UIImage imageNamed:@"djq_ico"];
        }else
        {
            cell.imageViewSelect.image = [UIImage imageNamed:@"djh_ico"];
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([tableView isEqual:self.tableView1]) {
        NSMutableDictionary *dict = [self.arrayP[indexPath.row]mutableCopy];
        [self.arrayCity removeAllObjects];
        if ([dict[@"isSelect"]isEqualToString:@"1"]) {
            [dict setValue:@"2" forKey:@"isSelect"];
            [self.arrayProvince addObject:dict[@"name"]];
            [self.arrayAll addObject:dict[@"name"]];
            
        }else
        {
            [dict setValue:@"1" forKey:@"isSelect"];
            [self.arrayProvince removeObject:dict[@"name"]];
            [self.arrayAll removeObject:dict[@"name"]];
        }
        [self.arrayP replaceObjectAtIndex:indexPath.row withObject:dict];
       
        [self.tableView1 reloadData];
        
        for (int i=0 ;i<self.arrayP.count;i++) {
            NSDictionary *dictionary = self.arrayP[i];
            if ([dictionary[@"isSelect"]isEqualToString:@"2"]) {
                dict = self.arrayP[i];
            }
        }
        
        if (self.arrayProvince.count==1) {
            self.arrayC = [dict[@"city"]mutableCopy];
            for (int i=0;i<self.arrayC.count;i++) {
                NSMutableDictionary *dictP = [self.arrayC[i]mutableCopy];
                [dictP setValue:@"1" forKey:@"isSelect"];
                [self.arrayC replaceObjectAtIndex:i withObject:dictP];
            }
            
        }else
        {
            [self.arrayC removeAllObjects];
            [self.arrayT removeAllObjects];
            [self.tableView2 reloadData];
            [self.tableView3 reloadData];
        }
        [self.tableView2 reloadData];
        

    }else if ([tableView isEqual:self.tableView2])
    {
        NSMutableDictionary  *dict = [self.arrayC[indexPath.row]mutableCopy];
        
       
        
        if ([dict[@"isSelect"]isEqualToString:@"1"]) {
            [dict setValue:@"2" forKey:@"isSelect"];
            [self.arrayCity addObject:dict[@"name"]];
            [self.arrayAll addObject:dict[@"name"]];
            
        }else
        {
            [dict setValue:@"1" forKey:@"isSelect"];
            [self.arrayCity removeObject:dict[@"name"]];
            [self.arrayAll removeObject:dict[@"name"]];
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
            self.arrayT = [dict[@"district"]mutableCopy];
            
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
        [self.arrayT replaceObjectAtIndex:indexPath.row withObject:dict];
        [self.tableView3 reloadData];

    }
    self.stringAll = [self.arrayAll componentsJoinedByString:@"/"];
}

#pragma -mark system
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate respondsToSelector:@selector(getCity)]) {
        [self.delegate getCity];
    }
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
