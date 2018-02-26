//
//  VCBossInfo.m
//  Administration
//
//  Created by zhang on 2017/12/7.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCBossInfo.h"
#import "ViewShowImage.h"
#import "CellTrack1.h"
#import "VCSpeciality.h"
#import "VCBossFamilyDetail.h"
#import "VCAddBrithday.h"
#import "VCBrithdayDetail.h"
@interface VCBossInfo ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,strong)NSArray *arrayTitle;
@property (nonatomic,strong)NSDictionary *dictInfo;
@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic,strong)NSString *imageUrl;
@end

@implementation VCBossInfo

#pragma -mark custem

-(void)getHttpData
{
    NSString *urlStr =[NSString stringWithFormat:@"%@stores/selectstore.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSDictionary *dict = @{@"appkey":appKeyStr,
                           @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                           @"Storeid":self.shopID,
                           @"store":@"2"
                           };
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        
        NSString *code = [responseObject valueForKey:@"status"];
        if ([code isEqualToString:@"0000"]) {
            
            NSDictionary *dictInfo = [responseObject valueForKey:@"Boss"];
            [dictInfo enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[NSNull class]]) {
                    if ([obj isKindOfClass:[NSNumber class]]) {
                        obj = [NSString stringWithFormat:@"%@",obj];
                    }else
                    {
                        obj = @"";
                    }
                }else
                {
                    obj = [NSString stringWithFormat:@"%@",obj];
                }
                [self.dictInfo setValue:obj forKey:key];
            }];
            [self.tableView reloadData];
            
            CellTrack1 *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(cell.contentView.frame.size.width-50, 10, 40, 20)];
            [button setTitle:@"提醒" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            if (![self.dictInfo[@"remind"]isEqualToString:@"0"]) {
                [button setTitleColor:GetColor(229, 126, 0, 1) forState:UIControlStateNormal];
            }
            [button addTarget:self action:@selector(gotoAddBrithay) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:button];
            
            if (![self.dictInfo[@"photo"] isKindOfClass:[NSNull class]]) {
                self.imageUrl =self.dictInfo[@"photo"];
            }else
            {
                self.imageUrl = @"";
            }
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURLImage,self.dictInfo[@"photo"]]] placeholderImage:[UIImage imageNamed:@"tjtx"]];
            
        }
        if ([code isEqualToString:@"1001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请求超时" andInterval:1.0];
            return ;
        }
        if ([code isEqualToString:@"5000"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"暂无内容" andInterval:1.0];
            return;
        }
        
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}

-(void)setUI
{
    UIView *viewTop = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Scree_width, 70)];
    viewTop.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:viewTop];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(8, 20, 40, 21)];
    label.text = @"照片";
    [viewTop addSubview:label];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showImage)];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(80, 5, 60, 60)];
    imageView.image = [UIImage imageNamed:@"tjtx"];
    imageView.layer.cornerRadius = 30;
    imageView.layer.masksToBounds = YES;
    imageView.userInteractionEnabled = YES;
    [imageView addGestureRecognizer:tap];
    [viewTop addSubview:imageView];
    self.imageView = imageView;
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Scree_width, Scree_height) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableHeaderView = viewTop;
    tableView.estimatedRowHeight = 44;
    tableView.rowHeight = UITableViewAutomaticDimension;
    [tableView registerClass:[CellTrack1 class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

-(void)showImage
{
    ViewShowImage *showImage =[[ViewShowImage alloc]initWithFrame:CGRectMake(0, 20, Scree_width, Scree_height)];
    [showImage.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURLImage,self.imageUrl]] placeholderImage:[UIImage imageNamed:@""]];
    [self.view.window addSubview:showImage];
}

-(void)gotoAddBrithay
{
    if ([self.dictInfo[@"remind"]intValue] ==0) {
        VCAddBrithday *vc = [[VCAddBrithday alloc]init];
        vc.dictInfo = self.dictInfo;
        
        
        if ([self.dictInfo[@"solarBirthday"]isKindOfClass:[NSNull class]]&&[self.dictInfo[@"lunarBirthday"]isKindOfClass:[NSNull class]]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"暂无生日" andInterval:1.0];
            return;
        }else
        {
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else
    {
        //跳转生日详情
        VCBrithdayDetail *vc = [[VCBrithdayDetail alloc]init];
        vc.remind = [NSString stringWithFormat:@"%@",self.dictInfo[@"remind"]];
        vc.dictInfo = self.dictInfo;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma -mark tableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayTitle.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseidentifier = @"cell";
    CellTrack1 *cell = [tableView dequeueReusableCellWithIdentifier:reuseidentifier];
    if (!cell) {
        cell = [[CellTrack1 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseidentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.labelTitle.text = self.arrayTitle[indexPath.row];
    cell.textView.userInteractionEnabled = NO;
    
    if (indexPath.row==6||indexPath.row==8) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    switch (indexPath.row) {
        case 0:
            cell.textView.text = self.dictInfo[@"name"];
            break;
        case 1:
            cell.textView.text = self.dictInfo[@"phone"];
            break;
        case 2:
            cell.textView.text = self.dictInfo[@"qcode"];
            break;
        case 3:
            cell.textView.text = self.dictInfo[@"wcode"];
            break;
        case 4:
            cell.textView.text = self.dictInfo[@"age"];
            break;
        case 5:
        {
            if ([self.dictInfo[@"flag"]isEqualToString:@"1"]) {
                cell.textView.text = self.dictInfo[@"lunarBirthday"];
            }else
            {
                cell.textView.text = self.dictInfo[@"solarBirthday"];
            }
            
//            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(cell.contentView.frame.size.width-30, 10, 30, 20)];
//            [button setTitle:@"提醒" forState:UIControlStateNormal];
//            [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//            [button addTarget:self action:@selector(gotoAddBrithay) forControlEvents:UIControlEventTouchUpInside];
//            [cell.contentView addSubview:button];
//            
//            if (![self.dictInfo[@"remind"]isEqualToString:@"0"]) {
//                [button setTitleColor:GetColor(229, 126, 0, 1) forState:UIControlStateNormal];
//            }
        }
            break;
        case 7:
            cell.textView.text = self.dictInfo[@"hobby"];
            break;
            
        default:
            break;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==6) {
        VCBossFamilyDetail *vc = [[VCBossFamilyDetail alloc]init];
        vc.bossID = self.dictInfo[@"id"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row==8) {
        VCSpeciality *vc = [[VCSpeciality alloc]init];
        vc.content = self.dictInfo[@"reviewsProposal"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 10;
    }else
    {
        return 0.1f;
    }
}

#pragma -mark system
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"老板信息";
    
    self.arrayTitle = @[@"老板姓名",@"老板电话",@"QQ",@"微信",@"年龄",@"生日",@"家庭情况",@"爱好",@"点评建议"];
    self.dictInfo = [NSMutableDictionary dictionary];
    [self setUI];
    [self getHttpData];
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
