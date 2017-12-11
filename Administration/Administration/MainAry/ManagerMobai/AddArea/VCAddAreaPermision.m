//
//  VCAddAreaPermision.m
//  Administration
//
//  Created by zhang on 2017/11/14.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCAddAreaPermision.h"
#import "CellChargePerson.h"
#import "VCSetArea.h"
#import "VCBuessPostion.h"
@interface VCAddAreaPermision ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray *arrayData;
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,weak)UIButton *buttonAdd;
@property (nonatomic,weak)UIButton *buttonDelet;
@end

@implementation VCAddAreaPermision

-(void)setUI
{
    
    UIView *viewFooter = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Scree_width, 45)];
    viewFooter.backgroundColor = GetColor(192, 192, 192, 1);
    [self.view addSubview:viewFooter];
    
    UIButton *buttonAdd = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, viewFooter.frame.size.width, 44)];
    [buttonAdd setBackgroundColor:[UIColor whiteColor]];
    [buttonAdd setTitle:@"添加一项" forState:UIControlStateNormal];
    [buttonAdd setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [buttonAdd setImage:[UIImage imageNamed:@"tj_ico01"] forState:UIControlStateNormal];
    [buttonAdd addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
    [viewFooter addSubview:buttonAdd];
    self.buttonAdd = buttonAdd;
    
    UIButton *buttonDelet = [[UIButton alloc]initWithFrame:CGRectMake(buttonAdd.frame.size.width,0,viewFooter.frame.size.width,44)];
    [buttonDelet setBackgroundColor:[UIColor whiteColor]];
    [buttonDelet setImage:[UIImage imageNamed:@"sc_ico01"] forState:UIControlStateNormal];
    [buttonDelet setTitle:@"删除一项" forState:UIControlStateNormal];
    [buttonDelet setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [buttonDelet addTarget:self action:@selector(delet) forControlEvents:UIControlEventTouchUpInside];
    [viewFooter addSubview:buttonDelet];
    self.buttonDelet = buttonDelet;
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Scree_width, Scree_height) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = viewFooter;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

-(void)add
{
    NSMutableArray *array = [NSMutableArray array];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@"负责人员" forKey:@"charge"];
    [dict setValue:@"1" forKey:@"state"];  //1为完成 ，2为编辑，3为删除
    [dict setValue:@"tj_ico01" forKey:@"icon"];
    [dict setValue:@"" forKey:@"name"];
    [dict setValue:@"" forKey:@"departmentId"];
    [array addObject:@"负责区域"];
    [array addObject:dict];
    [[ShareModel shareModel].arrayData insertObject:array atIndex:[ShareModel shareModel].arrayData.count];
    [self.buttonAdd setImage:[UIImage imageNamed:@"tj_ico02"] forState:UIControlStateNormal];
    [self.buttonAdd setTitleColor:GetColor(234, 235, 236,1) forState:UIControlStateNormal];
    self.buttonAdd.userInteractionEnabled = NO;
    
    [self.buttonDelet setImage:[UIImage imageNamed:@"sc_ico02"] forState:UIControlStateNormal];
    [self.buttonDelet setTitleColor:GetColor(234, 235, 236, 1) forState:UIControlStateNormal];
    self.buttonDelet.userInteractionEnabled = NO;
    
    [self.tableView reloadData];
}

-(void)delet
{
    if ([self.buttonDelet.titleLabel.text isEqualToString:@"删除一项"]) {
        [self.buttonDelet setTitle:@"取消删除" forState:UIControlStateNormal];
        [self.buttonAdd setImage:[UIImage imageNamed:@"tj_ico02"] forState:UIControlStateNormal];
        [self.buttonAdd setTitleColor:GetColor(234, 235, 236,1) forState:UIControlStateNormal];
        self.buttonAdd.userInteractionEnabled = NO;
        for (int i=0; i<[ShareModel shareModel].arrayData.count; i++) {
            NSMutableArray *array = [ShareModel shareModel].arrayData[i];
            NSMutableDictionary *dict = [array[1]mutableCopy];
            [dict setValue:@"3" forKey:@"state"];
            [array replaceObjectAtIndex:1 withObject:dict];
            [[ShareModel shareModel].arrayData replaceObjectAtIndex:i withObject:array];
        }
        [self.tableView reloadData];
    }else
    {
        [self.buttonDelet setTitle:@"删除一项" forState:UIControlStateNormal];
        [self.buttonAdd setImage:[UIImage imageNamed:@"tj_ico01"] forState:UIControlStateNormal];
        [self.buttonAdd setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        self.buttonAdd.userInteractionEnabled = YES;
        for (int i=0; i<[ShareModel shareModel].arrayData.count; i++) {
            NSMutableArray *array = [ShareModel shareModel].arrayData[i];
            NSMutableDictionary *dict = [array[1]mutableCopy];
            [dict setValue:@"2" forKey:@"state"];
            [array replaceObjectAtIndex:1 withObject:dict];
            [[ShareModel shareModel].arrayData replaceObjectAtIndex:i withObject:array];
        }
        [self.tableView reloadData];
    }
    
}

-(void)submitData:(UIButton *)button
{
    
    NSInteger section = button.tag-10;
    
    NSIndexPath *index = [NSIndexPath indexPathForRow:1 inSection:section];
    NSIndexPath *index2 = [NSIndexPath indexPathForRow:0 inSection:section];
    
    CellChargePerson *cell = [self.tableView cellForRowAtIndexPath:index];
    UITableViewCell *cell2 = [self.tableView cellForRowAtIndexPath:index2];
    
    NSMutableArray *array = [[ShareModel shareModel].arrayData[section]mutableCopy];
    NSMutableDictionary *dictInfo = [array[1]mutableCopy];
    
    if ([button.titleLabel.text isEqualToString:@"完成"]) {
        
        if ([dictInfo[@"name"]isEqualToString:@""]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请添加人" andInterval:1.0];
            return;
        }
    NSString *urlStr =[NSString stringWithFormat:@"%@shop/InsertRegion.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSDictionary *dict = @{@"appkey":appKeyStr,
                           @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                           @"CompanyInfoId":compid,
                           @"RoleId":dictInfo[@"roleId"],
                           @"DepartmentId":dictInfo[@"departmentId"],
                           @"Province":[ShareModel shareModel].stringProvince,
                           @"City":[ShareModel shareModel].stringCity,
                           @"County":[ShareModel shareModel].stringCountry,
                           @"userid":dictInfo[@"selectUserId"]
                           };
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        
        NSString *code = [responseObject valueForKey:@"status"];
        if ([code isEqualToString:@"0000"]) {

//            cell.buttonDel.hidden = YES;
//            cell.buttonDel.userInteractionEnabled = NO;
//            cell.buttonRed.hidden = YES;
//            cell.buttonRed.userInteractionEnabled = NO;
            
            cell.imageViewAdd.userInteractionEnabled = NO;
            cell2.userInteractionEnabled = NO;
            
            self.buttonAdd.frame = CGRectMake(0, 0, Scree_width/2, 44);
            [self.buttonAdd setImage:[UIImage imageNamed:@"tj_ico01"] forState:UIControlStateNormal];
            [self.buttonAdd setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            self.buttonAdd.userInteractionEnabled = YES;
            
            self.buttonDelet.frame = CGRectMake(Scree_width/2, 0, Scree_width/2, 44);
            [self.buttonDelet setImage:[UIImage imageNamed:@"sc_ico01"] forState:UIControlStateNormal];
            [self.buttonDelet setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            self.buttonDelet.userInteractionEnabled = YES;
            
            
            [dictInfo setValue:@"2" forKey:@"state"];
            [array replaceObjectAtIndex:1 withObject:dictInfo];
            [[ShareModel shareModel].arrayData replaceObjectAtIndex:section withObject:array];
            [self.tableView reloadData];
            return ;
        }
        if ([code isEqualToString:@"4444"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"非法请求" andInterval:1.0];
            return;
        }
        if ([code isEqualToString:@"1001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请求超时" andInterval:1.0];
            return;
        }
        if ([code isEqualToString:@"0001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"失败" andInterval:1.0];
            return;
            
        }
        
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
    }else if([button.titleLabel.text isEqualToString:@"编辑"])
    {
        cell2.userInteractionEnabled = YES;
        
        cell.imageViewAdd.userInteractionEnabled = YES;
        
        [dictInfo setValue:@"1" forKey:@"state"];
        [array replaceObjectAtIndex:1 withObject:dictInfo];
        [[ShareModel shareModel].arrayData replaceObjectAtIndex:section withObject:array];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
        
    }else
    {
        [[ShareModel shareModel].arrayData removeObjectAtIndex:section];
        [self.tableView reloadData];
    }
    
}

-(void)addPerson:(UITapGestureRecognizer *)ges
{
    CGPoint point = [ges locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    [ShareModel shareModel].indexPath = indexPath;
    VCBuessPostion *vc = [[VCBuessPostion alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)showDeletButton:(UIButton *)button
{
    
}

-(void)buttonRed:(UIButton *)button
{
    
}

#pragma -mark tableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [ShareModel shareModel].arrayData.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array = [ShareModel shareModel].arrayData[indexPath.section];
    if (indexPath.row==0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = array[0];
        return cell;
    }else
    {
        CellChargePerson *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[CellChargePerson alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addPerson:)];
        [cell.imageViewAdd addGestureRecognizer:tap];
        [cell.buttonDel addTarget:self action:@selector(showDeletButton:) forControlEvents:UIControlEventTouchUpInside];
        [cell.buttonRed addTarget:self action:@selector(buttonRed) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
         NSDictionary *dcit = array[1];
        cell.dict = dcit;
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        VCSetArea *vc = [[VCSetArea alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return 44;
    }
    else
    {
        return 100;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *array = [ShareModel shareModel].arrayData[section];
    NSDictionary *dict = array[1];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
    view.backgroundColor = GetColor(239,239,244, 1);
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(view.frame.size.width-40, 5, 40, 20)];
    button.tag = section+10;
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    if ([dict[@"state"]isEqualToString:@"1"]) {
        [button setTitle:@"完成" forState:UIControlStateNormal];
    }else if ([dict[@"state"]isEqualToString:@"2"])
    {
        [button setTitle:@"编辑" forState:UIControlStateNormal];
    }else
    {
        [button setTitle:@"删除" forState:UIControlStateNormal];
    }
    
    [button addTarget:self action:@selector(submitData:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    return view;
}

#pragma -mark system

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"添加负责区域权限";
    
    [ShareModel shareModel].arrayData = [NSMutableArray array];
    
    [self setUI];
    
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
