//
//  VCSetPermission.m
//  Administration
//
//  Created by zhang on 2017/10/30.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCSetPermission.h"
#import "CellPermission.h"
@interface VCSetPermission ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray *arrayData;
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *arrayPer;
@property (nonatomic,strong)NSMutableDictionary  *dictionary;
@property (nonatomic,strong)NSArray  *arrayPermission;
@end

@implementation VCSetPermission

#pragma -mark custem

-(void)drawLineWithBegainX:(float)begainX BegainY:(float)begainY EndX:(float)endX endY:(float)endY View:(UIView *)view
{
    // 1. 初始化 (UIBezierPath) 路径
    UIBezierPath *path = [UIBezierPath bezierPath];
    // 2. 添加起点 moveToPoint:(CGPoint)
    [path moveToPoint:CGPointMake(begainX, begainY)];
    // 3. 添加经过点 addLineToPoint:(CGPoint)
    [path addLineToPoint:CGPointMake(endX,endY)];
    // 如果线要构成闭合图形
    [path closePath];  // 也可以调用-addLineToPoint:方法来添加,添加一个与起点相同的点达到闭合效果
    
    // 1. 初始化CAShapeLayer
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    // 2. 设置ShapeLayer样式
    shapeLayer.borderWidth = 1; // 线宽
    shapeLayer.strokeColor = GetColor(188, 188, 188, 1).CGColor; // 线的颜色
  //  shapeLayer.fillColor = [UIColor whiteColor].CGColor; // 填充色
    // 3. 给画线的视图添加ShapeLayer
    [view.layer addSublayer:shapeLayer];
    
    // 4. 设置shapeLayer的路径
    shapeLayer.path = path.CGPath;
}

-(void)setUI
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, kTopHeight, Scree_width, 21)];
    label.text = @"  请勾选管理下属账号的权限";
    label.textColor = GetColor(139, 139, 139, 1);
    [self.view addSubview:label];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, Scree_height-21, Scree_width, 21)];
    label1.backgroundColor = [UIColor whiteColor];
    label1.text = @"  注：改操作与添加人员、冻结账号和人员调配一致";
    label1.textColor = [UIColor redColor];
    label1.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:label];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kTopHeight+21, Scree_width, Scree_height-kTopHeight-21) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = label1;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[CellPermission class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    
}
-(void)getHttpData
{
    NSString *urlStr =[NSString stringWithFormat:@"%@user/queryAccountPermission.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    
    NSDictionary *dict = @{
                           @"appkey":appKeyStr,
                           @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                           @"CompanyInfoId":compid,
                           @"id":self.usersid,
                           @"RoleId":[NSString stringWithFormat:@"(%@)",self.roleIDs],
                           };
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        NSString *code = [responseObject valueForKey:@"status"];
        
        if ([code isEqualToString:@"0000"]) {
            self.arrayData = [[responseObject valueForKey:@"list3"]mutableCopy];
            
            for (int i=0; i<self.arrayData.count; i++) {
                NSMutableDictionary *dict = [self.arrayData[i]mutableCopy];
                NSString *string = @"";
                if (![dict[@"permission"]isKindOfClass:[NSNull class]]) {
                    string = dict[@"permission"];
                }
                
                NSArray *arrayP = [string componentsSeparatedByString:@","];
                
                NSMutableArray *array = [dict[@"list2"]mutableCopy];
                for (int j=0; j<array.count; j++) {
                    NSMutableDictionary *dict1 = [array[j]mutableCopy];
                    for (NSString *stringK in arrayP) {
                        if ([stringK isEqualToString:[NSString stringWithFormat:@"%@",dict1[@"roleId"]]]) {
                            [dict1 setValue:stringK forKey:@"permission"];
                            [array replaceObjectAtIndex:j withObject:dict1];
                            [dict setValue:array forKey:@"list2"];
                            [self.arrayData replaceObjectAtIndex:i withObject:dict];
                        }
                        if ([dict1[@"permission"] isKindOfClass:[NSNull class]]) {
                            [dict1 setValue:@"" forKey:@"permission"];
                            [array replaceObjectAtIndex:j withObject:dict1];
                            [dict setValue:array forKey:@"list2"];
                            [self.arrayData replaceObjectAtIndex:i withObject:dict];
                        }
                    }
                    
                    
                }
                
            }
            
            [self.tableView reloadData];
        }
        
        
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
    
}

-(void)done
{
    NSString *urlStr =[NSString stringWithFormat:@"%@user/updateUserCreatePermission",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    
    NSMutableArray *arrayll = [NSMutableArray array];
    
    for (int i=0; i<self.arrayData.count; i++) {
        NSMutableDictionary *dict = [self.arrayData[i]mutableCopy];
    
        self.dictionary = [NSMutableDictionary dictionary];
        NSMutableArray *array = [dict[@"list2"]mutableCopy];
        for (int j=0; j<array.count; j++) {
            NSMutableDictionary *dict1 = [array[j]mutableCopy];
                if (![dict1[@"permission"] isEqualToString:@""]) {

                    
                        [self.dictionary setValue:self.usersid forKey:@"usersid"];
                        [self.dictionary setValue:[NSString stringWithFormat:@"%@",dict[@"Num"]] forKey:@"RoleId"];
                    //    [self.dictionary setValue:[NSString stringWithFormat:@"%@",dict1[@"roleId"]] forKey:@"Permission"];
                    
                        [arrayll addObject:dict1[@"permission"]];
                    [self.dictionary setValue:[arrayll componentsJoinedByString:@","] forKey:@"Permission"];
                    
                        [self.arrayPer addObject:self.dictionary];
                }
            }
            
            
        }
        
    
    
    NSData *data=[NSJSONSerialization dataWithJSONObject:self.arrayPer options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    
    
    
    NSDictionary *dict = @{
                           @"appkey":appKeyStr,
                           @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                           @"CompanyInfoId":compid,
                           @"auth":jsonStr,
                           };
    
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        NSString *code = [responseObject valueForKey:@"status"];
        if ([code isEqualToString:@"0000"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"成功" andInterval:1.0];
            return ;
        }
        if ([code isEqualToString:@"4444"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"异地登录" andInterval:1.0];
            return;
        }
        if ([code isEqualToString:@"00001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"失败" andInterval:1.0];
            return;
        }
        
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}

-(void)changeState:(UIButton *)button
{
    
    CellPermission *cell = (CellPermission *)[button superview].superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSMutableDictionary *dict = [self.arrayData[indexPath.section]mutableCopy];
    NSMutableArray *array = [dict[@"list2"]mutableCopy];
    NSMutableDictionary *dict1 = [array[indexPath.row]mutableCopy];
    
//    self.dictionary = [NSMutableDictionary dictionary];
//    [self.dictionary setValue:self.usersid forKey:@"usersid"];
//    [self.dictionary setValue:[NSString stringWithFormat:@"%@",dict[@"Num"]] forKey:@"RoleId"];
//    [self.dictionary setValue:[NSString stringWithFormat:@"%@",dict1[@"roleId"]] forKey:@"Permission"];
//    [self.arrayPer addObject:self.dictionary];
    
    if ([dict1[@"permission"] isEqualToString:@""]) {
        [dict1 setValue:[NSString stringWithFormat:@"%@",dict1[@"roleId"]] forKey:@"permission"];
        [array replaceObjectAtIndex:indexPath.row withObject:dict1];
        [dict setValue:array forKey:@"list2"];
        [self.arrayData replaceObjectAtIndex:indexPath.section withObject:dict];
        
        
    }else
    {
        [dict1 setValue:@"" forKey:@"permission"];
        [array replaceObjectAtIndex:indexPath.row withObject:dict1];
        [dict setValue:array forKey:@"list2"];
        [self.arrayData replaceObjectAtIndex:indexPath.section withObject:dict];
       
        
       
    }
    
    [self.tableView reloadData];
    
}
#pragma -mark tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.arrayData.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSDictionary *dict = self.arrayData[section];
    return [dict[@"list2"] count];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellPermission *cell = [[CellPermission alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    if (!cell) {
        cell = [[CellPermission alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dict = self.arrayData[indexPath.section];
    NSArray *array = dict[@"list2"];
    NSDictionary *dict1 = array[indexPath.row];
    cell.labelPostion.text = dict1[@"newName"];
    
    
    
    
    if (indexPath.row==0) {
        cell.labelMan.text = @"可管理的下属职位:";
    }
    
    if (![dict1[@"permission"] isEqualToString:@""]) {
        [cell.buttonSelect setImage:[UIImage imageNamed:@"Choice_ico01"] forState:UIControlStateNormal];
    }else
    {
        [cell.buttonSelect setImage:[UIImage imageNamed:@"xk_ico01"] forState:UIControlStateNormal];
    }
    
    [cell.buttonSelect addTarget:self action:@selector(changeState:) forControlEvents:UIControlEventTouchUpInside];
    [self drawLineWithBegainX:cell.labelPostion.frame.origin.x+50 BegainY:35 EndX:cell.labelPostion.frame.origin.x+50 endY:0 View:cell.contentView];
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView  *view = [[UIView alloc]initWithFrame:CGRectMake(0, 10, tableView.frame.size.width,40)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *labelMan = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 100, 12)];
    labelMan.text = @"管理对象:";
    labelMan.font = [UIFont systemFontOfSize:12];
    [view addSubview:labelMan];
    
    NSDictionary *dict = self.arrayData[section];
    
    if (![dict[@"permission"] isKindOfClass:[NSNull class]]) {
        NSString *string = dict[@"permission"];
        self.arrayPermission = [string componentsSeparatedByString:@","];
    }
    
    UILabel *labelPostion = [[UILabel alloc]initWithFrame:CGRectMake(140, 40, 100, 21)];
    labelPostion.text = dict[@"NewName"];
    labelPostion.layer.borderColor = GetColor(192, 192, 192, 1).CGColor;
    labelPostion.layer.borderWidth = 1.0f;
    labelPostion.layer.cornerRadius = 3.0f;
    labelPostion.layer.masksToBounds = YES;
    labelPostion.textAlignment = NSTextAlignmentCenter;
    [view addSubview:labelPostion];
    
    [self drawLineWithBegainX:labelPostion.frame.origin.x+50 BegainY:61 EndX:labelPostion.frame.origin.x+50 endY:60 View:view];
    
    return view;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}

#pragma -mark system
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.arrayData removeAllObjects];
    [self getHttpData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.title = @"管理下属账号权限";
    [self setUI];
    self.arrayData = [NSMutableArray array];
    self.arrayPer = [NSMutableArray array];
    
    self.arrayPermission = [NSArray array];
   
    
    NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
    [rightItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightItem;                                                                                                                                                                                                                                                                                                                                                                                                                  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
