//
//  VCPersonInfoDetail.m
//  Administration
//
//  Created by zhang on 2017/12/8.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCPersonInfoDetail.h"
#import "ViewShowImage.h"
#import "CellTrack1.h"
#import "VCSpeciality.h"
#import "VCAddBrithday.h"
#import "VCBrithdayDetail.h"
@interface VCPersonInfoDetail ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSArray *arrayTitle;
@property (nonatomic,strong)NSMutableDictionary *dictInfo;
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,weak)UIImageView *imageView;
@property (nonatomic,strong)NSString *imageUrl;
@end

@implementation VCPersonInfoDetail

#pragma -mark custem
-(void)gtHttpData
{
    NSString *urlStr =[NSString stringWithFormat:@"%@stores/selectstore.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSDictionary *dict = @{@"appkey":appKeyStr,
                           @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                           @"Storeid":self.shopID,
                           @"store":@"3",
                           @"StoreClerkId":self.personID
                           };
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        
        NSString *code = [responseObject valueForKey:@"status"];
        if ([code isEqualToString:@"0000"]) {
            NSDictionary *dictinfo = [responseObject valueForKey:@"list"][0];
            
            [dictinfo enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                
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
                [self.dictInfo setObject:obj forKey:key];
            }];
            
            if (![self.dictInfo[@"photo"] isKindOfClass:[NSNull class]]) {
                self.imageUrl =self.dictInfo[@"photo"];
            }else
            {
                self.imageUrl = @"";
            }
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURLImage,self.dictInfo[@"photo"]]] placeholderImage:[UIImage imageNamed:@"tjtx"]];
            
            CellTrack1 *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(cell.contentView.frame.size.width-50, 10, 40, 20)];
            [button setTitle:@"提醒" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            if (![self.dictInfo[@"remind"]isEqualToString:@"0"]) {
                [button setTitleColor:GetColor(229, 126, 0, 1) forState:UIControlStateNormal];
            }
            [button addTarget:self action:@selector(gotoAddBrithay) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:button];
            
            [self.tableView reloadData];
            
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
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.arrayTitle.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrayTitle[section]count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellTrack1 *cell  = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[CellTrack1 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textView.userInteractionEnabled = NO;
    cell.labelTitle.text = self.arrayTitle[indexPath.section][indexPath.row];
    
    if (indexPath.section==1) {
        if (indexPath.row==4) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    if (indexPath.section==2) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (indexPath.section==0) {
        switch (indexPath.row) {
            case 0:
                cell.textView.text = self.dictInfo[@"name"];
                break;
            case 1:
                cell.textView.text = self.dictInfo[@"age"];
                break;
                
            default:
                break;
        }
    }else if(indexPath.section==1)
    {
        switch (indexPath.row) {
            case 0:
            {
                if ([self.dictInfo[@"flag"] isEqualToString:@"1"]) {
                    cell.textView.text = self.dictInfo[@"lunarBirthday"];
                }else
                {
                    cell.textView.text = self.dictInfo[@"solarBirthday"];
                }
//                UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(cell.contentView.frame.size.width-50, 10, 40, 20)];
//                [button setTitle:@"提醒" forState:UIControlStateNormal];
//                [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//                if (![self.dictInfo[@"remind"]isEqualToString:@"0"]) {
//                    [button setTitleColor:GetColor(229, 126, 0, 1) forState:UIControlStateNormal];
//                }
//                [button addTarget:self action:@selector(gotoAddBrithay) forControlEvents:UIControlEventTouchUpInside];
//                [cell.contentView addSubview:button];
            }
                break;
            case 1:
                cell.textView.text = self.dictInfo[@"hobby"];
                break;
            case 2:
                cell.textView.text = self.dictInfo[@"feature"];
                break;
            case 3:
                cell.textView.text = self.dictInfo[@"phone"];
                break;
            default:
                break;
        }
    }
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    VCSpeciality *vc = [[VCSpeciality alloc]init];
    if (indexPath.section==1) {
        if (indexPath.row==4) {
            vc.content = self.dictInfo[@"specialty"];
            vc.stringTitle = @"特长";
        }
    }
    if (indexPath.section==2) {
        vc.content = self.dictInfo[@"overallMerit"];
        vc.stringTitle = @"综合研判";
    }
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma -mark system
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"店员信息";
    self.dictInfo = [NSMutableDictionary dictionary];
    self.arrayTitle = @[@[@"姓名",@"年龄"],@[@"生日",@"爱好",@"性格",@"电话",@"特长"],@[@"综合研判"]];
    [self setUI];
    [self gtHttpData];
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
