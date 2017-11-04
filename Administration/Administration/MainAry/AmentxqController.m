//
//  AmentxqController.m
//  Administration
//
//  Created by zhang on 2017/2/21.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "AmentxqController.h"
#import "CellPersonN.h"
@interface AmentxqController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSMutableArray  *arrayData;
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic)CGSize size;
@end

@implementation AmentxqController

-(void)getHttpData
{
    NSString *urlStr =[NSString stringWithFormat:@"%@adminNotice/getById.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSString *companyID = [USER_DEFAULTS valueForKey:@"companyinfoid"];
    
    NSDictionary *dict = @{@"appkey":appKeyStr,
                           @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                           @"id":self.self.noticeID,
                           @"comId":companyID
                           };
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        NSString *code = [responseObject valueForKey:@"status"];
        if ([code isEqualToString:@"0000"]) {
            for (NSDictionary *dict in [responseObject valueForKey:@"list"] ) {
                [self.arrayData addObject:dict];
            }
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}

-(void)setUI
{
    self.size = [self.gonModel.content boundingRectWithSize:CGSizeMake(Scree_width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;
    
    UIView *viewHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Scree_width, self.size.height+50)];
    [self.view addSubview:viewHeader];
    
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.layer.cornerRadius = 25;
    imageView.layer.masksToBounds = YES;
    [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURLHeader,self.dict[@"url"]]] placeholderImage:[UIImage imageNamed:@"banben100"]];
    [viewHeader addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(viewHeader.mas_left).offset(10);
        make.top.mas_equalTo(viewHeader.mas_top).offset(8);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(50);
    }];
    
    UILabel *labelTime = [[UILabel alloc]init];
    labelTime.font = [UIFont systemFontOfSize:12];
    labelTime.text = [self.dict[@"time"] substringWithRange:NSMakeRange(5, 11)];
    labelTime.textColor = GetColor(167, 168, 169, 1);
    [viewHeader addSubview:labelTime];
    [labelTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(viewHeader.mas_top).offset(8);
        make.right.mas_equalTo(viewHeader.mas_right).offset(-8);
        make.height.mas_equalTo(12);
    }];
    
    UILabel *labelTitle = [[UILabel alloc]init];
    labelTitle.numberOfLines = 0;
    labelTitle.text = self.dict[@"title"];
    labelTitle.font = [UIFont systemFontOfSize:13];
    labelTitle.textColor = GetColor(78, 79, 80, 1);
    [viewHeader addSubview:labelTitle];
    [labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imageView.mas_right).offset(5);
        make.top.mas_equalTo(viewHeader.mas_top).offset(8);
        make.right.mas_equalTo(viewHeader.mas_right).offset(-100);
    }];
    
    UILabel *labelFrom = [[UILabel alloc]init];
    labelFrom.font = [UIFont systemFontOfSize:12];
    labelFrom.textColor = GetColor(167, 168, 169, 1);
    labelFrom.text = self.dict[@"newName"];
    [viewHeader addSubview:labelFrom];
    [labelFrom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(labelTitle.mas_bottom).offset(5);
        make.left.mas_equalTo(imageView.mas_right).offset(5);
        make.height.mas_equalTo(12);
    }];
    
    UITextView *textView = [[UITextView alloc]init];
    textView.backgroundColor = GetColor(237, 238, 239, 1);
    textView.scrollEnabled = NO;
    textView.editable = NO;
    CGSize size = [self.dict[@"content"] boundingRectWithSize:CGSizeMake(Scree_width-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;
    textView.text = self.dict[@"content"];
    textView.font = [UIFont systemFontOfSize:17];
    textView.textColor = [UIColor blackColor];
    [viewHeader addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(viewHeader.mas_left).offset(10);
        make.top.mas_equalTo(labelFrom.mas_bottom).offset(20);
        make.right.mas_equalTo(viewHeader.mas_right).offset(-8);
        make.height.mas_equalTo(size.height+20);
    }];
    
    UILabel *label = [[UILabel alloc]init];
    label.layer.borderColor = GetColor(192, 192, 192, 1).CGColor;
    label.layer.borderWidth = 1.0f;
    label.text = @"    最近查看";
    label.hidden = YES;
    [viewHeader addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(viewHeader.mas_left).offset(-1);
        make.top.mas_equalTo(textView.mas_bottom).offset(30);
        make.height.mas_equalTo(21);
        make.right.mas_equalTo(viewHeader.mas_right).offset(1);
    }];
    
    NSString *roleID = [USER_DEFAULTS valueForKey:@"roleId"];
    if ([roleID isEqualToString:@"1"]||[roleID isEqualToString:@"7"]) {
        label.hidden = NO;
    }
    
    viewHeader.frame = CGRectMake(0, 0, Scree_width, size.height+150);
    
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Scree_width, Scree_height)style:UITableViewStylePlain];
    [tableView registerClass:[CellPersonN class] forCellReuseIdentifier:@"cell"];
    
//    if (self.gonModel.roleId!=7||self.gonModel.roleId==1) {
//        label.hidden = NO;
        tableView.tableHeaderView = viewHeader;
//    }
    [ZXDNetworking setExtraCellLineHidden:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    
}
-(void)deleteGongao
{
    NSString *urlStr =[NSString stringWithFormat:@"%@adminNotice/deleteNotice.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    
    
    NSDictionary *dict = @{@"appkey":appKeyStr,
                           @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                           @"id":self.self.noticeID
                           };
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        NSString *code = [responseObject valueForKey:@"status"];
        if ([code isEqualToString:@"0000"]) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        if ([code isEqualToString:@"4444"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"异地登录" andInterval:1.0];
            return ;
        }
        if ([code isEqualToString:@"0001 "]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"失败" andInterval:1.0];
            return ;
        }
        if ([code isEqualToString:@"1001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请求超时" andInterval:1.0];
            return ;
        }
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}


#pragma -mark tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellPersonN *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[CellPersonN alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.dict = self.arrayData[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

#pragma -mark system

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self getHttpData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"公告";
    [self setUI];
    self.arrayData  = [NSMutableArray array];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"删除" style:UIBarButtonItemStyleDone target:self action:@selector(deleteGongao)];
    [rightItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = nil;
    NSString *roleID = [USER_DEFAULTS valueForKey:@"roleId"];
    if ([roleID isEqualToString:@"1"]||[roleID isEqualToString:@"7"]) {
        self.navigationItem.rightBarButtonItem = rightItem;
    }
 
}
-(void)buttonLiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
