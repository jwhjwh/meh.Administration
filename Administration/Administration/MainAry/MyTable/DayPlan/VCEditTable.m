//
//  VCEditTable.m
//  Administration
//
//  Created by zhang on 2017/9/14.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCEditTable.h"
#import "CellEditTable.h"
@interface VCEditTable ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,ViewDatePickerDelegate,UIAlertViewDelegate>
@property (nonatomic,strong)NSMutableArray *arrayDate;
@property (nonatomic,strong)NSArray *arrayTitle;
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,strong)NSString *stringDate;
@property (nonatomic,strong)NSString *stringDescribe;
@property (nonatomic,strong)NSMutableDictionary *dictionary;
@property (nonatomic,strong)UIButton *buttonAdd;
@property (nonatomic,strong)UIButton *buttonDel;
@property (nonatomic)BOOL isFrist;
@property (nonatomic,strong)NSString *string1;
@property (nonatomic,strong)NSString *string2;
@property (nonatomic,strong)NSString *string3;
@property (nonatomic,strong)NSString *string4;
@property (nonatomic,strong)ViewDatePick *datePick;
@property (nonatomic,strong)NSIndexPath *indexPath;

@property (nonatomic,strong)NSString *did;
@property (nonatomic,assign)NSInteger integer;
@end

@implementation VCEditTable

-(void)getData
{
    NSString *urlStr =[NSString stringWithFormat:@"%@report/queryDayPlanInfo",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSDictionary *dict = @{@"appkey":appKeyStr,@"usersid":[USER_DEFAULTS valueForKey:@"userid"],@"CompanyInfoId":compid,@"id":self.dayPlabID,@"RoleId":[ShareModel shareModel].roleID};
    
    [self.arrayDate removeAllObjects];
    [self.dictionary removeAllObjects];
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        NSString *code = [responseObject valueForKey:@"status"];
        if ([code isEqualToString:@"0000"]) {
            self.stringDate = [[responseObject valueForKey:@"date"] substringToIndex:10];
            self.stringDescribe = [responseObject valueForKey:@"describe"];
            
           self.dictionary =  [responseObject mutableCopy];
           [self.dictionary setValue:@"1" forKey:@"canEdit"];
            [self.dictionary setValue:@"A" forKey:@"buttonstate"];
            NSArray *arrayL = self.dictionary[@"lists"];
            
            for (int i=0; i< arrayL.count; i++) {
                NSMutableDictionary *dictinfo = [arrayL[i]mutableCopy];
                [dictinfo setValue:@"1" forKey:@"canEdit"];
                [dictinfo setValue:@"A" forKey:@"buttonstate"];
                [self.arrayDate addObject:dictinfo];
            }
            [self.tableView reloadData];
        }
        
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}

-(void)setUI
{
    
    UIView *viewBotttom = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Scree_width, 40)];
    viewBotttom.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:viewBotttom];

    self.buttonAdd = [[UIButton alloc]initWithFrame:CGRectMake(-1, 0, viewBotttom.frame.size.width/2, 40)];
    self.buttonAdd.tag = 100;
    [self.buttonAdd setImage:[UIImage imageNamed:@"tj_ico01"] forState:UIControlStateNormal];
    [self.buttonAdd setTitle:@"添加一项" forState:UIControlStateNormal];
    [self.buttonAdd setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.buttonAdd addTarget:self action:@selector(addDetailOrDelt:) forControlEvents:UIControlEventTouchUpInside];
    [viewBotttom addSubview:self.buttonAdd];
 
    self.buttonDel = [[UIButton alloc]initWithFrame:CGRectMake(viewBotttom.frame.size.width/2, 0, viewBotttom.frame.size.width/2, 40)];
    self.buttonDel.tag = 200;
    [self.buttonDel setImage:[UIImage imageNamed:@"sc_ico01"] forState:UIControlStateNormal];
    [self.buttonDel setTitle:@"删除一项" forState:UIControlStateNormal];
    [self.buttonDel setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.buttonDel addTarget:self action:@selector(addDetailOrDelt:) forControlEvents:UIControlEventTouchUpInside];
    [viewBotttom addSubview:self.buttonDel];

    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Scree_width, Scree_height) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 100;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.tableFooterView = viewBotttom;
    [tableView registerClass:[CellEditTable class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

-(void)addDetailOrDelt:(UIButton *)button
{
    if (button.tag==100) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:@"" forKey:@"did"];
        [dict setValue:@"" forKey:@"id"];
        [dict setValue:@"" forKey:@"others"];
        [dict setValue:@"" forKey:@"jobAim"];
        [dict setValue:@"" forKey:@"detailMethod"];
        [dict setValue:@"" forKey:@"helped"];
        [dict setValue:@"2" forKey:@"canEdit"];
        [dict setValue:@"B" forKey:@"buttonstate"];
        [self.arrayDate insertObject:dict atIndex:self.arrayDate.count];
    }
    else
    {
        if ([self.buttonDel.titleLabel.text isEqualToString:@"删除一项"]) {
            [self.buttonDel setTitle:@"取消删除" forState:UIControlStateNormal];
            [self.buttonAdd setImage:[UIImage imageNamed:@"tj_ico02"] forState:UIControlStateNormal];
            self.buttonAdd.userInteractionEnabled = NO;
            for (int i=0; i<self.arrayDate.count; i++) {
                NSMutableDictionary *dict = self.arrayDate[i];
                [dict setValue:@"C" forKey:@"buttonstate"];
                [self.arrayDate replaceObjectAtIndex:i withObject:dict];
            }
        }else
        {
        [self.buttonDel setTitle:@"删除一项" forState:UIControlStateNormal];
        [self.buttonAdd setImage:[UIImage imageNamed:@"tj_ico01"] forState:UIControlStateNormal];
        self.buttonAdd.userInteractionEnabled = YES;
        for (int i=0; i<self.arrayDate.count; i++) {
            NSMutableDictionary *dict = self.arrayDate[i];
            [dict setValue:@"A" forKey:@"buttonstate"];
            [self.arrayDate replaceObjectAtIndex:i withObject:dict];
        }
        }
    }
    [self.tableView reloadData];
}

-(void)editContent:(UIButton *)button
{
    NSUInteger index = button.tag;
    
    if (index-10==0) {
        [self.dictionary setValue:@"2" forKey:@"canEdit"];
        
        
        NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:0 inSection:0];
           CellEditTable *cell1 = [self.tableView cellForRowAtIndexPath:indexPath1];
        self.string1 = cell1.textView.text;
        
        NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:1 inSection:0];
        CellEditTable *cell2 = [self.tableView cellForRowAtIndexPath:indexPath2];
        self.string2 = cell2.textView.text;
        
        if ([button.titleLabel.text isEqualToString:@"编辑"]) {
            [button setTitle:@"完成" forState:UIControlStateNormal];
            [self.buttonAdd setImage:[UIImage imageNamed:@"tj_ico02"] forState:UIControlStateNormal];
            self.buttonAdd.userInteractionEnabled = NO;
            
            [self.buttonDel setImage:[UIImage imageNamed:@"sc_ico02"] forState:UIControlStateNormal];
            self.buttonDel.userInteractionEnabled = NO;
            [self.dictionary setValue:@"B" forKey:@"buttonstate"];
        }else if ([button.titleLabel.text isEqualToString:@"完成"])
        {
            [button setTitle:@"编辑" forState:UIControlStateNormal];
             [self.dictionary setValue:@"A" forKey:@"buttonstate"];
            [self.buttonAdd setImage:[UIImage imageNamed:@"tj_ico01"] forState:UIControlStateNormal];
            self.buttonAdd.userInteractionEnabled = YES;
            
            [self.buttonDel setImage:[UIImage imageNamed:@"sc_ico01"] forState:UIControlStateNormal];
            self.buttonDel.userInteractionEnabled = YES;
            
            if (self.string2==nil||[self.string2 isEqualToString:@""]) {
                [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请填写完整内容" andInterval:1];
                return;
            }
            [self changeTime:self.dayPlabID];
        }
    }else
    {
        NSMutableDictionary *dict = [self.arrayDate[index-10-1]mutableCopy];
        [dict setValue:@"2" forKey:@"canEdit"];
        [self.arrayDate replaceObjectAtIndex:index-10-1 withObject:dict];
        self.isFrist = NO;
        
        NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:0 inSection:index-10];
        CellEditTable *cell1 = [self.tableView cellForRowAtIndexPath:indexPath1];
        self.string1 = cell1.textView.text;
        
        NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:1 inSection:index-10];
        CellEditTable *cell2 = [self.tableView cellForRowAtIndexPath:indexPath2];
        self.string2 = cell2.textView.text;
        
        NSIndexPath *indexPath3 = [NSIndexPath indexPathForRow:2 inSection:index-10];
        CellEditTable *cell3 = [self.tableView cellForRowAtIndexPath:indexPath3];
        self.string3 = cell3.textView.text;
        
        NSIndexPath *indexPath4 = [NSIndexPath indexPathForRow:3 inSection:index-10];
        CellEditTable *cell4 = [self.tableView cellForRowAtIndexPath:indexPath4];
        self.string4 = cell4.textView.text;
        
        
        if ([button.titleLabel.text isEqualToString:@"编辑"]) {
            [button setTitle:@"完成" forState:UIControlStateNormal];
            [self.buttonAdd setImage:[UIImage imageNamed:@"tj_ico02"] forState:UIControlStateNormal];
            self.buttonAdd.userInteractionEnabled = NO;
            
            [self.buttonDel setImage:[UIImage imageNamed:@"sc_ico02"] forState:UIControlStateNormal];
            self.buttonDel.userInteractionEnabled = NO;
            
            [dict setValue:@"B" forKey:@"buttonstate"];
            
        }else if ([button.titleLabel.text isEqualToString:@"完成"])
        {
            [button setTitle:@"编辑" forState:UIControlStateNormal];
            [self.buttonAdd setImage:[UIImage imageNamed:@"tj_ico01"] forState:UIControlStateNormal];
            self.buttonAdd.userInteractionEnabled = YES;
            
            [self.buttonDel setImage:[UIImage imageNamed:@"sc_ico01"] forState:UIControlStateNormal];
            self.buttonDel.userInteractionEnabled = YES;
            [dict setValue:@"A" forKey:@"buttonstate"];
            if (self.string2==nil||[self.string2 isEqualToString:@""]) {
                [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请填写完整内容" andInterval:1];
                return;
            }
            if (self.string1==nil||[self.string1 isEqualToString:@""]) {
                [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请填写完整内容" andInterval:1];
                return;
            }
            if (self.string3==nil||[self.string3 isEqualToString:@""]) {
                [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请填写完整内容" andInterval:1];
                return;
            }
            if (self.string4==nil||[self.string4 isEqualToString:@""]) {
                [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请填写完整内容" andInterval:1];
                return;
            }
            [self changeDayPlanDetail:dict[@"did"] and:self.dayPlabID];
            
        }else
        {
            if (dict[@"did"]) {
                self.did = [NSString stringWithFormat:@"%@",dict[@"did"]];
                self.integer = index-11;
              //  [self delePlan:dict[@"did"] And:index-11];
                [self showAlertView];
            }else
            {
                [self.arrayDate removeObjectAtIndex:index-11];
                [self.tableView reloadData];
            }
            
            [dict setValue:@"C" forKey:@"buttonstate"];
        }
    }
    [self.tableView reloadData];
}

-(void)changeTime:(NSString *)planID;
{
    NSString *urlStr =[NSString stringWithFormat:@"%@report/updateDayPlan",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSDictionary *dict = @{@"appkey":appKeyStr,
                           @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                           @"CompanyInfoId":compid,
                           @"time":self.string1,
                           @"id":planID,
                           @"Describe":self.string2,
                           @"RoleId":[ShareModel shareModel].roleID
                           };
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        NSString *code = [responseObject valueForKey:@"status"];
        if ([code isEqualToString:@"0000"]) {
            [self getData];
        }
        
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}

-(void)changeDayPlanDetail:(NSString *)did and:(NSString *)planID
{
    NSString *urlStr =[NSString stringWithFormat:@"%@report/updateDayPlanDetail",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSDictionary *dict = @{@"appkey":appKeyStr,
                           @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                           @"CompanyInfoId":compid,
                           @"Others":self.string1,
                           @"JobAim":self.string2,
                           @"DetailMethod":self.string3,
                           @"Helped":self.string4,
                           @"did":did,
                           @"id":planID,
                           @"RoleId":[ShareModel shareModel].roleID,
                           @"Name":[USER_DEFAULTS valueForKey:@"name"]
                           };
    
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        NSString *code = [responseObject valueForKey:@"status"];
        if ([code isEqualToString:@"0000"]) {
            [self getData];
            self.string1 = @"";
            self.string2 = @"";
            self.string3 = @"";
            self.string4 = @"";
        }
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}

-(void)delePlan:(NSString *)did And:(NSInteger)integer
{
    NSString *urlStr =[NSString stringWithFormat:@"%@report/delDayPlan",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    
    NSDictionary *dict = @{@"appkey":appKeyStr,
                           @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                           @"CompanyInfoId":compid,
                           @"RoleId":[ShareModel shareModel].roleID,
                           @"did":did,
                           };
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        NSString *code = [responseObject valueForKey:@"status"];
        if ([code isEqualToString:@"0000"]) {
            [self.arrayDate removeObjectAtIndex:integer];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];

}

-(void)showAlertView
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"是否删除此项内容" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

-(void)showDatePick:(UIGestureRecognizer *)ges
{
    self.datePick = [[ViewDatePick alloc]initWithFrame:CGRectMake(0, 0, Scree_width, Scree_height)];
    self.datePick.delegate = self;
    [self.tableView addSubview:self.datePick];
    CGPoint point = [ges locationInView:self.tableView];
    self.indexPath = [self.tableView indexPathForRowAtPoint:point];
}

#pragma -mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        if ([self.did isEqualToString:@""]) {
            [self.arrayDate removeObjectAtIndex:self.integer];
        }else
        {
        [self delePlan:self.did And:self.integer];
        }
        [self.tableView reloadData];
    }
}

#pragma -mark ViewDatePick
-(void)getDate
{
    CellEditTable *cell = [self.tableView cellForRowAtIndexPath:self.indexPath];
    NSDate *date = self.datePick.datePick.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd";
    cell.textView.text = [formatter stringFromDate:date];
}

#pragma -mark tableviw
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.arrayDate.count+1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 2;
    }else
    {
        return 4;
    }
    
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellEditTable *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell==nil) {
        cell = [[CellEditTable alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textView.tag = indexPath.row+30;
    cell.textView.delegate = self;
    if (indexPath.section==0) {
        
        if ([self.dictionary[@"canEdit"]isEqualToString:@"1"]) {
            cell.textView.editable = NO;
            
        }else
        {
            cell.textView.editable = YES;
            
        }
        
        if (indexPath.row==0) {
            cell.labelTitle.text = @"日期";
            cell.textView.text = self.stringDate;
            cell.textView.editable = NO;
            cell.textView.scrollEnabled = NO;
            UITapGestureRecognizer *tap= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showDatePick:)];
            if ([self.dictionary[@"canEdit"]isEqualToString:@"2"]) {
            [cell.textView addGestureRecognizer:tap];
            }
        }
        if (indexPath.row==1) {
            cell.labelTitle.text = @"概要描述";
            cell.textView.text = self.stringDescribe;
        }
    }else
    {
        NSDictionary *dict = self.arrayDate[indexPath.section-1];
        cell.labelTitle.text = self.arrayTitle[indexPath.row];
        if ([dict[@"canEdit"] isEqualToString:@"1"]) {
            cell.textView.editable = NO;
            
        }else
        {
            cell.textView.editable = YES;
            
        }
        if (indexPath.row==0) {
            if (![dict[@"others"]isKindOfClass:[NSNull class]]) {
                cell.textView.text = dict[@"others"];
            }
            
        }
        if (indexPath.row==1) {
            if (![dict[@"jobAim"]isKindOfClass:[NSNull class]]) {
                cell.textView.text = dict[@"jobAim"];
            }
        }
        if (indexPath.row==2) {
            if (![dict[@"detailMethod"]isKindOfClass:[NSNull class]]) {
                cell.textView.text = dict[@"detailMethod"];
            }
        }
        if (indexPath.row==3) {
            if (![dict[@"helped"]isKindOfClass:[NSNull class]]) {
                cell.textView.text = dict[@"helped"];
            }
        }
    }
    
    return cell;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    NSDictionary *dict = [NSDictionary dictionary];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Scree_width, 30)];
    view.backgroundColor = GetColor(237, 238, 239, 1);
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(8, 6, 100, 15)];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor lightGrayColor];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(Scree_width-90, 6, 100, 20)];
    button.titleLabel.font = [UIFont systemFontOfSize:17];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(editContent:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = section+10;
    [view addSubview:button];
    
    if (section==0) {
        label.text = @"其他";
        if ([self.dictionary[@"buttonstate"] isEqualToString:@"A"]) {
            [button setTitle:@"编辑" forState:UIControlStateNormal];
        }else
        {
            [button setTitle:@"完成" forState:UIControlStateNormal];
        }
    }else
    {
        label.text = @"详细事项";
        dict = self.arrayDate[section-1];
        
        if ([dict[@"buttonstate"] isEqualToString:@"A"]) {
            [button setTitle:@"编辑" forState:UIControlStateNormal];
        }else if([dict[@"buttonstate"] isEqualToString:@"B"])
        {
            [button setTitle:@"完成" forState:UIControlStateNormal];
        }else
        {
            [button setTitle:@"删除" forState:UIControlStateNormal];
        }
        
        
    }
    [view addSubview:label];
    
    
   
    return view;
}



-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 0.1;
    
}

#pragma -mark system

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: YES];
    self.string1 = @"";
    self.string2 = @"";
    self.string3 = @"";
    self.string4 = @"";
    [self getData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"日计划";
    
    self.arrayTitle = @[@"事项",@"工作目标",@"具体方法思路",@"需要协调与帮助"];
    self.arrayDate = [NSMutableArray array];
    self.dictionary = [NSMutableDictionary dictionary];
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
