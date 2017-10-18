//
//  VCAddPlan.m
//  Administration
//
//  Created by zhang on 2017/9/16.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCAddPlan.h"
#import "CellEditTable.h"
#import "UIPlaceHolderTextView.h"
#import "ViewDatePick.h"
@interface VCAddPlan ()<UITableViewDelegate,UITableViewDataSource,ViewDatePickerDelegate,UITextViewDelegate>
@property (nonatomic,strong)NSMutableArray *arrayList;
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,strong)UIButton *buttonAdd;
@property (nonatomic,strong)UIButton *buttonDel;
@property (nonatomic,strong)UIButton *buttonChooseDate;
@property (nonatomic,weak)UIPlaceHolderTextView *textView2;
@property (nonatomic,weak)ViewDatePick *myDatePick;
@property (nonatomic,strong)NSArray *arrayTitle;
@property (nonatomic,strong)NSMutableDictionary *dict;
@end

@implementation VCAddPlan
#pragma -mark custem

-(void)setUI
{
    UIView *viewTop = [[UIView alloc]initWithFrame:CGRectMake(0, kTopHeight, Scree_width, 81)];
    viewTop.backgroundColor = GetColor(192, 192, 192, 1);
    [self.view addSubview:viewTop];
    
    UILabel *labelDate = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 40)];
    labelDate.text = @"  日期";
    labelDate.backgroundColor = [UIColor whiteColor];
    labelDate.textColor = GetColor(117, 118, 119, 1);
    [viewTop addSubview:labelDate];
    
    UIButton *buttonChooseDate = [[UIButton alloc]initWithFrame:CGRectMake(120, 0, Scree_width-120, 40)];
    buttonChooseDate.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    buttonChooseDate.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [buttonChooseDate setTitle:@"选择日期" forState:UIControlStateNormal];
    [buttonChooseDate setTitleColor:GetColor(117, 118, 119, 1) forState:UIControlStateNormal];
    [buttonChooseDate setBackgroundColor:[UIColor whiteColor]];
    [buttonChooseDate addTarget:self action:@selector(showMyDatePick) forControlEvents:UIControlEventTouchUpInside];
    [viewTop addSubview:buttonChooseDate];
    self.buttonChooseDate= buttonChooseDate;
    
    UILabel *labelDescribe = [[UILabel alloc]initWithFrame:CGRectMake(0, 41, 120, 40)];
    labelDescribe.text = @"  概要描述";
    labelDescribe.textColor = [UIColor lightGrayColor];
    labelDescribe.backgroundColor = [UIColor whiteColor];
    [viewTop addSubview:labelDescribe];
    
    UIPlaceHolderTextView *textView2 = [[UIPlaceHolderTextView alloc]initWithFrame:CGRectMake(120, 41, Scree_width-120, 40)];
    textView2.font = [UIFont systemFontOfSize:18];
    textView2.textColor = GetColor(192, 192, 192, 1);
    textView2.placeholder = @"填写概要描述";
    [viewTop addSubview:textView2];
    self.textView2= textView2;
    
    
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
    
    UITableView *tableView  = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Scree_width, Scree_height) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 100;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.tableHeaderView = viewTop;
    tableView.tableFooterView = viewBotttom;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

-(void)showMyDatePick
{
    ViewDatePick *myDatePick = [[ViewDatePick alloc]initWithFrame:CGRectMake(0, 0, Scree_width, Scree_height)];
    myDatePick.delegate =self;
    [self.view.window addSubview:myDatePick];
    self.myDatePick = myDatePick;
}

-(void)addDetailOrDelt:(UIButton *)button
{
    if (button.tag==100) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:@"" forKey:@"others"];
        [dict setValue:@"" forKey:@"jobAim"];
        [dict setValue:@"" forKey:@"detailMethod"];
        [dict setValue:@"" forKey:@"helped"];
        [dict setValue:@"1" forKey:@"canEdit"];
        [dict setValue:@"notShow" forKey:@"show"];
        [self.arrayList insertObject:dict atIndex:self.arrayList.count];
    }
    else
    {
        if ([self.buttonDel.titleLabel.text isEqualToString:@"删除一项"]) {
            [self.buttonDel setTitle:@"取消删除" forState:UIControlStateNormal];
            [self.buttonAdd setImage:[UIImage imageNamed:@"tj_ico02"] forState:UIControlStateNormal];
            self.buttonAdd.userInteractionEnabled = NO;
            for (int i=0; i<self.arrayList.count; i++) {
                NSMutableDictionary *dict = [self.arrayList[i]mutableCopy];
                [dict setValue:@"notShow" forKey:@"show"];
                [dict setValue:@"1" forKey:@"canEdit"];
                [self.arrayList replaceObjectAtIndex:i withObject:dict];
            }
        }else
            
        {
            [self.buttonDel setTitle:@"删除一项" forState:UIControlStateNormal];
            [self.buttonAdd setImage:[UIImage imageNamed:@"tj_ico01"] forState:UIControlStateNormal];
            self.buttonAdd.userInteractionEnabled = NO;
            for (int i=0; i<self.arrayList.count; i++) {
                NSMutableDictionary *dict = [self.arrayList[i]mutableCopy];
                [dict setValue:@"isShow" forKey:@"show"];
                [dict setValue:@"2" forKey:@"canEdit"];
                [self.arrayList replaceObjectAtIndex:i withObject:dict];
            }
        }
        
    }
    [self.tableView reloadData];
}

-(void)deletePlan:(UIButton *)button
{
    NSUInteger inter = button.tag-10;
    [self.arrayList removeObjectAtIndex:inter];
    [self.dict setValue:@"1" forKey:@"canEdit"];
    [self.tableView reloadData];
    
    [self.buttonAdd setImage:[UIImage imageNamed:@"tj_ico01"] forState:UIControlStateNormal];
    self.buttonAdd.userInteractionEnabled = YES;
    
}

-(void)submit
{
    
    
    if ([self.buttonChooseDate.titleLabel.text isEqualToString:@"选择日期"]) {
        [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请选择日期" andInterval:1];
        return;
    }
    if (self.textView2.text.length==0) {
        [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请填写概要描述" andInterval:1];
        return;
    }
    NSMutableArray *array = [NSMutableArray array];
    for (int i=0; i<self.arrayList.count; i++) {
        NSMutableDictionary *dictioary = [NSMutableDictionary dictionary];
        for (int j=0; j<4;j++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
            CellEditTable *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            if (cell.textView.text.length==0) {
                [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请填写完整内容" andInterval:1];
                return;
            }else
            {
                if (j==0) {
                    [dictioary setValue:cell.textView.text forKey:@"Others"];
                }
                if (j==1) {
                    [dictioary setValue:cell.textView.text forKey:@"JobAim"];
                }
                if (j==2) {
                    [dictioary setValue:cell.textView.text forKey:@"DetailMethod"];
                }
                if (j==3) {
                    [dictioary setValue:cell.textView.text forKey:@"Helped"];
                }
                
            }
        }
        [array insertObject:dictioary atIndex:array.count];
        
    }
    NSData *data=[NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *jsonStr=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    NSString *urlStr =[NSString stringWithFormat:@"%@report/addUserDayPlan.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    
    NSDictionary *dictinfo = @{@"appkey":appKeyStr,
                               @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                               @"CompanyInfoId":compid,
                               @"RoleId":[ShareModel shareModel].roleID,
                               @"DepartmentID":self.departmentID,
                               @"time":self.buttonChooseDate.titleLabel.text,
                               @"Describe":self.textView2.text,
                               @"Num":[ShareModel shareModel].num,
                               @"info":jsonStr,
                               @"Name":[USER_DEFAULTS valueForKey:@"name"]};
    [ZXDNetworking GET:urlStr parameters:dictinfo success:^(id responseObject) {
        NSString *code = [responseObject valueForKey:@"status"];
        if ([code isEqualToString:@"0000"]) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
    
    
}

#pragma -mark viewDatePick
-(void)getDate
{
    NSDate *date = self.myDatePick.datePick.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *stringDate = [formatter stringFromDate:date];
    [self.buttonChooseDate setTitle:stringDate forState:UIControlStateNormal];
}

-(void)textViewDidChange:(UITextView *)textView
{
    CellEditTable *cell = (CellEditTable *)[textView superview].superview;

    CGRect frame = textView.frame;
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [textView sizeThatFits:constraintSize];
    if (size.height<=frame.size.height) {
        size.height=frame.size.height;
    }
    cell.textView.frame = CGRectMake(frame.origin.x, frame.origin.y,cell.contentView.frame.size.width, size.height);
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}
#pragma -mark tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.arrayList.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellEditTable *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell = [[CellEditTable alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textView.delegate = self;
    NSDictionary *dict = self.arrayList[indexPath.section];
    
    if ([dict[@"canEdit"]isEqualToString:@"1"]) {
        cell.textView.editable = YES;
        
    }else
    {
        cell.textView.editable = NO;
        
    }
    
    cell.labelTitle.text = self.arrayTitle[indexPath.row];
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Scree_width, 30)];
    view.backgroundColor = GetColor(237, 238, 239, 1);
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(8, 8, 120, 14)];
    label.text = @"详细事项";
    [view addSubview:label];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(Scree_width-90, 8, 100, 14)];
    button.tag = section+10;
    [button setTitle:@"删除" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(deletePlan:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    NSDictionary *dict = self.arrayList[section];
    if ([dict[@"show"] isEqualToString:@"isShow"]) {
        button.hidden = NO;
        button.userInteractionEnabled = YES;
    }else
    {
        button.hidden  = YES;
        button.userInteractionEnabled = NO;
    }
    
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==self.arrayList.count-1) {
        return 30.0f;
    }else
    {
        return 0.1f;
    }
}

#pragma -mark system
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"添加日计划";
    
    self.arrayList = [NSMutableArray array];
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:(UIBarButtonItemStyleDone) target:self action:@selector(submit)];
    [rightitem setTitleTextAttributes:dictionary forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightitem;
    
    self.arrayTitle = @[@"事项",@"工作目标",@"具体方法思路",@"需要协调与帮助"];
    self.dict = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@"" forKey:@"others"];
    [dict setValue:@"" forKey:@"jobAim"];
    [dict setValue:@"" forKey:@"detailMethod"];
    [dict setValue:@"" forKey:@"helped"];
    [dict setValue:@"1" forKey:@"canEdit"];
    [dict setValue:@"notShow" forKey:@"show"];
    [self.arrayList insertObject:dict atIndex:self.arrayList.count];
    
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
