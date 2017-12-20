//
//  VCPersonInfoDetail.m
//  Administration
//
//  Created by zhang on 2017/12/8.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCPersonInfoDetailM.h"
#import "ViewShowImage.h"
#import "CellTrack1.h"
#import "VCSpecialityManager.h"
#import "VCAddBrithday.h"
#import "VCBrithdayDetail.h"
#import "UIViewDatePicker.h"
@interface VCPersonInfoDetailM ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIViewDatePickerDelegate>
@property (nonatomic,strong)NSArray *arrayTitle;
@property (nonatomic,strong)NSMutableDictionary *dictInfo;
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,weak)UIImageView *imageView;
@property (nonatomic,strong)NSString *imageUrl;
@property (nonatomic,weak)UIViewDatePicker *datePick;

@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)NSString *age;
@property (nonatomic,strong)NSString *hobby;
@property (nonatomic,strong)NSString *character;
@property (nonatomic,strong)NSString *phone;
@property (nonatomic,strong)NSString *flag;
@property (nonatomic,strong)NSString *brithdayChinese;
@property (nonatomic,strong)NSString *brithdayGer;

@property (nonatomic)BOOL canEdit;
@end

@implementation VCPersonInfoDetailM

#pragma -mark custem
-(void)gtHttpData
{
    NSString *urlStr =[NSString stringWithFormat:@"%@stores/selectstore.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSDictionary *dict = @{@"appkey":appKeyStr,
                           @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                           @"Storeid":[ShareModel shareModel].shopID,
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
            
            
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURLHeader,self.dictInfo[@"photo"]]] placeholderImage:[UIImage imageNamed:@"tjtx"]];
            
            if (self.isAddInfo==NO) {
                CellTrack1 *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
                UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(cell.contentView.frame.size.width-50, 10, 40, 20)];
                [button setTitle:@"提醒" forState:UIControlStateNormal];
                [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                if (![self.dictInfo[@"remind"]isEqualToString:@"0"]) {
                    [button setTitleColor:GetColor(229, 126, 0, 1) forState:UIControlStateNormal];
                }
                [button addTarget:self action:@selector(gotoAddBrithay) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:button];
            }
            
            self.name = self.dictInfo[@"name"];
            self.age = self.dictInfo[@"age"];
            self.flag = self.dictInfo[@"flag"];
            self.brithdayGer = self.dictInfo[@"solarBirthday"];
            self.brithdayChinese = self.dictInfo[@"lunarBirthday"];
            self.phone = self.dictInfo[@"phone"];
            self.character = self.dictInfo[@"feature"];
            self.hobby = self.dictInfo[@"hobby"];
        
            
            [self.tableView reloadData];
            
        }
        
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}

-(void)setUI
{
    UIBarButtonItem *rightItem;
    if (self.isAddInfo) {
        
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
        [button setImage:[UIImage imageNamed:@"submit_ico01"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(submitData) forControlEvents:UIControlEventTouchUpInside];
        rightItem = [[UIBarButtonItem alloc]initWithCustomView:button];
        
    }else
    {
        rightItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(rightItem)];
        NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
        [rightItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    }
    self.navigationItem.rightBarButtonItem = rightItem;
    
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
    imageView.userInteractionEnabled = NO;
    [imageView addGestureRecognizer:tap];
    [viewTop addSubview:imageView];
    self.imageView = imageView;
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Scree_width, Scree_height) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 44;
    tableView.tableHeaderView = viewTop;
    [tableView registerClass:[CellTrack1 class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

-(void)rightItem
{
    if (self.isAddInfo) {
        [self submitData];
    }else
    {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
        [button setImage:[UIImage imageNamed:@"submit_ico01"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(submitData) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:button];
        self.navigationItem.rightBarButtonItem = rightItem;
        self.canEdit = YES;
        [self.tableView reloadData];
    }
}

-(void)submitData
{
    NSString *urlStr =[NSString stringWithFormat:@"%@shop/updateStoreBoss1.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSDictionary *dict = @{@"appkey":appKeyStr,
                           @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                           @"Storeid":[ShareModel shareModel].shopID,
                           @"RoleId":[ShareModel shareModel].roleID,
                           
                    
                           @"id":[NSString stringWithFormat:@"%@",self.dictInfo[@"id"]]
                           };
    NSData *pictureData = UIImagePNGRepresentation(self.imageView.image);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"image/jpeg",@"image/png",@"image/gif",@"image/tiff",@"application/octet-stream",@"text/json",nil];
    [manager POST:urlStr parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyMMddHHmm";
        NSString *fileName = [formatter stringFromDate:[NSDate date]];
        NSString *nameStr = @"file";
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [formData appendPartWithFileData:pictureData name:nameStr fileName:[NSString stringWithFormat:@"%@.png", fileName] mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView: self.view animated:NO];        NSString *response = [[NSString alloc] initWithData:(NSData *)responseObject encoding:NSUTF8StringEncoding];
        NSData* jsonData = [response dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSUTF8StringEncoding error:nil];
        NSString *status =  [NSString stringWithFormat:@"%@",[dic valueForKey:@"status"]];
        if ([status isEqualToString:@"0000"]) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"头像上传失败" andInterval:1.0];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

-(void)showDatePick
{
    [self.view endEditing:YES];
    UIViewDatePicker *datePick = [[UIViewDatePicker alloc]initWithFrame:CGRectMake(0, 0, Scree_width, Scree_height)];
    datePick.delegate = self;
    [self.view addSubview:datePick];
    self.datePick = datePick;
}

-(void)showImage
{
    ViewShowImage *showImage =[[ViewShowImage alloc]initWithFrame:CGRectMake(0, 20, Scree_width, Scree_height)];
    [showImage.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURLHeader,self.imageUrl]] placeholderImage:[UIImage imageNamed:@""]];
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

#pragma -mark UIViewDatePicker
-(void)getChooseDate
{
    self.flag = self.datePick.flagggg;
    self.brithdayChinese = self.datePick.stringChinese;
    self.brithdayGer = self.datePick.stringGregorian;
    [self.tableView reloadData];
}

#pragma -mark imagePickController

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    self.imageView.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self.navigationController dismissViewControllerAnimated:picker completion:nil];
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
    cell.labelTitle.text = self.arrayTitle[indexPath.section][indexPath.row];
    
    if (self.isAddInfo) {
        cell.textView.userInteractionEnabled = YES;
    }else
    {
        if (self.canEdit) {
            cell.textView.userInteractionEnabled = YES;
        }else
        {
            cell.textView.userInteractionEnabled = NO;
        }
    }
    
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
                cell.textView.text = self.name;
                break;
            case 1:
                cell.textView.text = self.age;
                break;
                
            default:
                break;
        }
    }else if(indexPath.section==1)
    {
        switch (indexPath.row) {
            case 0:
            {
                if ([self.flag isEqualToString:@"1"]) {
                    cell.textView.text = self.brithdayChinese;
                }else
                {
                    cell.textView.text = self.brithdayGer;
                }
                cell.textView.editable = NO;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showDatePick)];
                [cell.textView addGestureRecognizer:tap];
                
            }
                break;
            case 1:
                cell.textView.text = self.hobby;
                break;
            case 2:
                cell.textView.text = self.character;
                break;
            case 3:
                cell.textView.text = self.phone;
                break;
            case 4:
                [cell.textView removeFromSuperview];
                break;
            default:
                break;
        }
    }else
    {
        [cell.textView removeFromSuperview];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    VCSpecialityManager *vc = [[VCSpecialityManager alloc]init];
    if (indexPath.section==1) {
        if (indexPath.row==4) {
            vc.content = self.dictInfo[@"specialty"];
            vc.stringTitle = @"特长";
            vc.state = @"5";
        }
    }
    if (indexPath.section==2) {
        vc.content = self.dictInfo[@"overallMerit"];
        vc.stringTitle = @"综合研判";
        vc.state = @"6";
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
    if (self.isAddInfo==NO) {
        [self gtHttpData];
    }
    
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
