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
#import "VCAddPersonSpeciality.h"
#import "UIChooseState.h"
@interface VCPersonInfoDetailM ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIViewDatePickerDelegate,UITextViewDelegate,UIAlertViewDelegate,UIChooseDelegate>
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
            
            
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURLImage,self.dictInfo[@"photo"]]] placeholderImage:[UIImage imageNamed:@"tjtx"]];
            
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
        self.navigationItem.rightBarButtonItem = rightItem;
        
    }else
    {
            NSString *string;
            if ([[ShareModel shareModel].roleID isEqualToString:@"6"]) {
                string = @"...";
            }else
            {
                string = @"编辑";
            }
            rightItem = [[UIBarButtonItem alloc]initWithTitle:string style:UIBarButtonItemStyleDone target:self action:@selector(rightItem)];
            NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
            [rightItem setTitleTextAttributes:dict forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
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
    if (self.isAddInfo) {
        imageView.userInteractionEnabled = YES;
    }else
    {
        imageView.userInteractionEnabled = NO;
    }
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
        if ([[ShareModel shareModel].roleID isEqualToString:@"6"]) {
            [self showChooseStateView];
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
}

-(void)deleteCustem
{
    NSString *urlStr =[NSString stringWithFormat:@"%@shop/deleteStore",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSDictionary *dict = @{@"appkey":appKeyStr,
                           @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                           @"Storeid":[ShareModel shareModel].shopID,
                           @"RoleId":[ShareModel shareModel].roleID,
                           @"StoreClerkId":self.personID
                           };
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        NSString *code = [responseObject valueForKey:@"status"];
        if ([code isEqualToString:@"0000"]) {
            [self.navigationController popViewControllerAnimated:YES];
            return ;
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
}

-(void)submitData
{
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSString *urlStr;
    NSDictionary *dict;
    if (self.isAddInfo) {
        urlStr = [NSString stringWithFormat:@"%@shop/insertStoreClerk.action",KURLHeader];
        dict = @{@"appkey":appKeyStr,
                 @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                 @"Storeid":[ShareModel shareModel].shopID,
                 @"Name":self.name,
                 @"Age":self.age,
                 @"SolarBirthday":self.brithdayGer,
                 @"LunarBirthday":self.brithdayChinese,
                 @"flag":self.flag,
                 @"Hobby":self.hobby,
                 @"Feature":self.character,
                 @"Phone":self.phone,
                 @"Specialty":[ShareModel shareModel].techang,
                 @"file":self.imageView.image,
                 @"OverallMerit":[ShareModel shareModel].pingpan
                 };
    }else
    {
        urlStr = [NSString stringWithFormat:@"%@shop/updateStoreClerk1.action",KURLHeader];
        dict = @{@"appkey":appKeyStr,
                 @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                 @"Storeid":[ShareModel shareModel].shopID,
                 @"RoleId":[ShareModel shareModel].roleID,
                 @"id":[NSString stringWithFormat:@"%@",self.dictInfo[@"id"]],
                 @"Name":self.name,
                 @"Age":self.age,
                 @"SolarBirthday":self.brithdayGer,
                 @"LunarBirthday":self.brithdayChinese,
                 @"flag":self.flag,
                 @"Hobby":self.hobby,
                 @"Feature":self.character,
                 @"Phone":self.phone,
                 @"Specialty":[ShareModel shareModel].techang,
                 @"file":self.imageView.image,
                 @"OverallMerit":[ShareModel shareModel].pingpan
                 };
    }
    
    
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
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"添加照片" message:@"" delegate:self cancelButtonTitle:@"相册" otherButtonTitles:@"拍照", nil];
    [alert show];
}

-(void)showChooseStateView
{
    UIChooseState *stateView = [[UIChooseState alloc]initWithFrame:CGRectMake(0, 0, Scree_width, Scree_height) withArray:@[@"编辑",@"删除"]];
    stateView.delegate = self;
    [self.view.window addSubview:stateView];
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

-(void)showAlertView
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否删除顾客" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 100;
    [alert show];
}

#pragma -mark UIChooseStateDelegate
-(void)getChooseIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        self.navigationItem.rightBarButtonItem = nil;
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
        [button setImage:[UIImage imageNamed:@"submit_ico01"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(submitData) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:button];
        self.navigationItem.rightBarButtonItem = rightItem;
        self.canEdit = YES;
        [self.tableView reloadData];
        [self.tableView reloadData];
    }else if (indexPath.row==1)
    {
        [self showAlertView];
    }
}

#pragma -mark alertView
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==100) {
        if (buttonIndex==1) {
            [self deleteCustem];
        }

    }else
    {
    UIImagePickerController *imagePick = [[UIImagePickerController alloc]init];
    imagePick.delegate = self;
    if (buttonIndex==0) {
        [self.navigationController presentViewController:imagePick animated:YES completion:nil];
    }else
    {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"设备不支持" andInterval:1.0];
            return;
        }else
        {
            imagePick.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self.navigationController presentViewController:imagePick animated:YES completion:nil];
        }
    }
    }
}

#pragma -mark textView
-(void)textViewDidChange:(UITextView *)textView
{
    
    CellTrack1 *cell = (CellTrack1 *)[textView superview].superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    CGRect frame = textView.frame;
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [textView sizeThatFits:constraintSize];
    if (size.height<=frame.size.height) {
        size.height=frame.size.height;
    }
    
    if (indexPath.section==0) {
        switch (indexPath.row) {
            case 0:
                self.name = textView.text;
                break;
            case 1:
                self.age = textView.text;
                break;
                
            default:
                break;
        }
    }else if (indexPath.section==1)
    {
         switch (indexPath.row) {
            case 1:
                self.hobby = textView.text;
                break;
                
            case 2:
                self.character = textView.text;
                break;
                
            case 3:
                self.phone = textView.text;
                break;
        
            default:
                break;
        }
    }
    
    
    cell.textView.frame = CGRectMake(frame.origin.x, frame.origin.y,cell.contentView.frame.size.width, size.height);
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
}
#pragma -mark UIViewDatePicker
-(void)getChooseDate
{
    self.flag = self.datePick.flagggg;
    self.brithdayChinese = self.datePick.stringChinese;
    self.brithdayGer = self.datePick.stringGregorian;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma -mark imagePickController

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    self.imageView.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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
    cell.textView.delegate = self;
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
    
    
    if (self.isAddInfo) {
        [ShareModel shareModel].showRightItem = YES;
    }else
    {
        [ShareModel shareModel].showRightItem = self.canEdit;
    }
    
    if (indexPath.section==1) {
        if (indexPath.row==4) {
            VCAddPersonSpeciality *vc = [[VCAddPersonSpeciality alloc]init];
            if (![self.dictInfo[@"specialty"]isKindOfClass:[NSNull class]]) {
                [ShareModel shareModel].techang = self.dictInfo[@"specialty"];
            }
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    if (indexPath.section==2) {
        VCSpecialityManager *vc = [[VCSpecialityManager alloc]init];
        if (![self.dictInfo[@"overallMerit"] isKindOfClass:[NSNull class]]) {
            vc.content = self.dictInfo[@"overallMerit"];
        }else
        {
            vc.content = [ShareModel shareModel].pingpan;
        }
        
        vc.stringTitle = @"综合研判";
        vc.state = @"6";
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
}

#pragma -mark system
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"店员信息";
    self.dictInfo = [NSMutableDictionary dictionary];
    self.arrayTitle = @[@[@"姓名",@"年龄"],@[@"生日",@"爱好",@"性格",@"电话",@"特长"],@[@"综合研判"]];
    
    self.name = @"";
    self.age= @"";
    self.hobby= @"";
    self.character= @"";
    self.phone= @"";
    self.flag= @"";
    self.brithdayChinese= @"";
    self.brithdayGer= @"";
    [ShareModel shareModel].techang = @"";
    [ShareModel shareModel].pingpan = @"";
    
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
