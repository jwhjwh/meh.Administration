//
//  VCBrithdayDetail.m
//  Administration
//
//  Created by zhang on 2017/11/24.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCBrithdayDetail.h"
#import "CellSetBrithday.h"
#import "ViewChooseDay.h"
#import "VCSendMessage.h"
@interface VCBrithdayDetail ()<UITableViewDelegate,UITableViewDataSource,ViewChooseDayDelegate,UIAlertViewDelegate>

@property (nonatomic,strong)NSArray *arrayTitle;
@property (nonatomic,strong)NSArray *arrayImage;
@property (nonatomic,strong)NSArray *array;
@property (nonatomic,strong)NSDictionary *dict;

@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,weak)UIButton *buttonSure;
@property (nonatomic,weak)ViewChooseDay *chooseDay;

@property (nonatomic)BOOL canEdit;

@end

@implementation VCBrithdayDetail

-(void)getHttpData
{
    NSString *urlStr =[NSString stringWithFormat:@"%@birthdayReminder/queryBirthdayReminderInfo",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSDictionary *dict = @{
                           @"appkey":appKeyStr,
                           @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                           @"CompanyInfoId":compid,
                           @"id":self.remind
                           };
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        
        NSString *code = [responseObject valueForKey:@"status"];
        if ([code isEqualToString:@"0000"]) {
            self.dict = [responseObject valueForKey:@"br"];
            self.array = [responseObject[@"days"] componentsSeparatedByString:@","];
            [self.tableView reloadData];
        }
        
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}

-(void)submitData
{
    NSIndexPath *index = [NSIndexPath indexPathForRow:3 inSection:0];
    CellSetBrithday *cell = [self.tableView cellForRowAtIndexPath:index];
    
    
    NSString *urlStr =[NSString stringWithFormat:@"%@birthdayReminder/updateBirthdayReminder",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSDictionary *info=@{@"appkey":appKeyStr,
                         @"usersid":[USER_DEFAULTS  objectForKey:@"userid"],
                         @"CompanyInfoId":compid,
                         @"clientId":[NSString stringWithFormat:@"%@",self.dictInfo[@"clientId"]],
                         @"name":self.dictInfo[@"name"],
                         @"lunarDate":self.dictInfo[@"lunarBirthday"],
                         @"solarDate":self.dictInfo[@"solarBirthday"],
                         @"flag":[NSString stringWithFormat:@"%@",self.dictInfo[@"flag"]],
                         @"reminderDay":[self.array componentsJoinedByString:@","],
                         @"id":[NSString stringWithFormat:@"%@",self.dictInfo[@"id"]],
                         @"matter":cell.textView.text,
                         @"belog":[NSString stringWithFormat:@"%@",self.dictInfo[@"belong"]]};
    [ZXDNetworking GET:urlStr parameters:info success:^(id responseObject) {
        
        NSString *code = [responseObject valueForKey:@"status"];
        if ([code isEqualToString:@"0000"]) {
            [self.navigationController popViewControllerAnimated:YES];
            return ;
        }
        if ([code isEqualToString:@"0001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"失败" andInterval:1.0];
            return;
        }
        
        
        
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}

-(void)deleteBrithday
{
    NSString *urlStr =[NSString stringWithFormat:@"%@birthdayReminder/delBirthdayReminder",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSDictionary *info=@{@"appkey":appKeyStr,
                         @"usersid":[USER_DEFAULTS  objectForKey:@"userid"],
                         @"CompanyInfoId":compid,
                         @"id":self.remind};
    [ZXDNetworking GET:urlStr parameters:info success:^(id responseObject) {
        
        NSString *code = [responseObject valueForKey:@"status"];
        if ([code isEqualToString:@"0000"]) {
            [self.navigationController popViewControllerAnimated:YES];
            return ;
        }
        
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}

-(void)editBrithday
{
    self.canEdit = YES;
    self.buttonSure.hidden = NO;
    [self.tableView reloadData];
}

-(void)setUI
{
    
    UIView *viewBottom = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Scree_width, 44)];
    [self.view addSubview:viewBottom];
    
    
    UIButton *buttonSure = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, Scree_width-20, 44)];
    [buttonSure setTitle:@"确定" forState:UIControlStateNormal];
    [buttonSure setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [buttonSure addTarget:self action:@selector(submitData) forControlEvents:UIControlEventTouchUpInside];
    buttonSure.layer.borderColor = GetColor(234, 235, 236, 1).CGColor;
    buttonSure.layer.borderWidth = 1.0f;
    buttonSure.hidden = YES;
    [viewBottom addSubview:buttonSure];
    self.buttonSure = buttonSure;
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Scree_width, Scree_height) style:UITableViewStylePlain];
    tableView.scrollEnabled = NO;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 100;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = viewBottom;
    [tableView registerClass:[CellSetBrithday class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    UIToolbar*tools=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 100, 39)];
    //解决出现的那条线
    tools.clipsToBounds = YES;
    //解决tools背景颜色的问题
    [tools setBackgroundImage:[UIImage new]forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [tools setShadowImage:[UIImage new]forToolbarPosition:UIToolbarPositionAny];
    //添加两个button
    NSMutableArray*buttons=[[NSMutableArray alloc]initWithCapacity:2];
    
    UIButton *button1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [button1 setImage:[UIImage imageNamed:@"bj_ico"] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(editBrithday) forControlEvents:UIControlEventTouchUpInside];
    
    [button1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    UIButton *button2 = [[UIButton alloc]initWithFrame:CGRectMake(31, 0, 25, 25)];
    [button2 setImage:[UIImage imageNamed:@"sc_ico"] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(showAlertView) forControlEvents:UIControlEventTouchUpInside];
    [button2 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithCustomView:button1];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc]initWithCustomView:button2];
    
    [buttons addObject:item1];
    [buttons addObject:item2];
    [tools setItems:buttons animated:NO];
    UIBarButtonItem *btn=[[UIBarButtonItem  alloc]initWithCustomView:tools];
    
    self.navigationItem.rightBarButtonItem = btn;
}

-(void)showChooseDay
{
    [self.view endEditing:YES];
    ViewChooseDay *view = [[ViewChooseDay alloc]initWithFrame:self.view.bounds];
    view.delegate =self;
    [self.view.window addSubview:view];
    
    self.chooseDay = view;
}

-(void)showAlertView
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"是否删除？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

#pragma -mark alertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        [self deleteBrithday];
    }
}

#pragma -mark viewChooseDayDelegate

-(void)getSelect
{
    self.array = self.chooseDay.arraySelect;
}

#pragma -mark tableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellSetBrithday *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[CellSetBrithday alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.imageViewHead.image = [UIImage imageNamed:self.arrayImage[indexPath.row]];
    cell.textView.text = self.arrayTitle[indexPath.row];
    
    if (self.canEdit==NO) {
        cell.userInteractionEnabled = NO;
    }else
    {
        cell.userInteractionEnabled = YES;
    }
    
    if (indexPath.row==0) {
        UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(Scree_width-48, 2, 40, 40)];
        imageView1.layer.cornerRadius = 20;
        imageView1.layer.masksToBounds = YES;
        [imageView1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURLImage,self.dictInfo[@"icon"]]] placeholderImage:[UIImage imageNamed:@"banben100"]];
        [cell.contentView addSubview:imageView1];
    }
    
    if (indexPath.row==2) {
        UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(Scree_width-38, 10, 30, 21)];
        imageView1.image = [UIImage imageNamed:@"down"];
        [cell.contentView addSubview:imageView1];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showChooseDay)];
        [cell.textView addGestureRecognizer:tap];
    }
    
    if(indexPath.row==3)
    {
        cell.textView.text = self.dict[@"matter"];
        cell.textView.editable = YES;
    }
    
    if (indexPath.row>2) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 30;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==4) {
        VCSendMessage *vc = [[VCSendMessage alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


#pragma -mark system

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: YES];
    [self getHttpData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = self.dictInfo[@"name"];
    
    self.canEdit = NO;
    
    [self setUI];
    
    self.array = [NSArray array];
    
    NSString *brithday; ;
    
    if ([self.dictInfo[@"flag"] intValue]==1) {
        brithday = self.dictInfo[@"lunarBirthday"];
    }
    else
    {
        brithday = self.dictInfo[@"solarBirthday"];
    }
    
    self.arrayImage = @[@"yh_ico",@"rl_ico",@"nz_ico",@"ms",@"dx_ico"];
    
    self.arrayTitle = @[self.dictInfo[@"name"],brithday,@"提醒天数",@"",@"送出祝福"];
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
