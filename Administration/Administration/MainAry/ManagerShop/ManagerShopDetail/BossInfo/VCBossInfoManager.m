//
//  VCBossInfo.m
//  Administration
//
//  Created by zhang on 2017/12/7.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCBossInfoManager.h"
#import "ViewShowImage.h"
#import "CellTrack1.h"
#import "VCSpecialityManager.h"
#import "VCBossFamilyDetailManager.h"
#import "VCAddBrithday.h"
#import "VCBrithdayDetail.h"
#import "UIViewDatePicker.h"
@interface VCBossInfoManager ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,UITextViewDelegate,UIViewDatePickerDelegate>
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,strong)NSArray *arrayTitle;
@property (nonatomic,strong)NSDictionary *dictInfo;
@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic,strong)NSString *imageUrl;
@property (nonatomic,weak)UIImagePickerController *imagePicker;
@property (nonatomic,weak)UIViewDatePicker *datePick;

@property (nonatomic)BOOL canEdit;
@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)NSString *qq;
@property (nonatomic,strong)NSString *wx;
@property (nonatomic,strong)NSString *age;
@property (nonatomic,strong)NSString *hobby;
@property (nonatomic,strong)NSMutableArray *arrayPhone;

@property (nonatomic,strong)NSString *flag;
@property (nonatomic,strong)NSString *brithdayChines;
@property (nonatomic,strong)NSString *brithdayGer;
@end

@implementation VCBossInfoManager

#pragma -mark custem

-(BOOL)isValidatePhoneNumber:(NSString *)phoneNumber
{
    NSString *realNameRegex = @"^1[3|4|5|7|8]\\d{9}$";
    NSPredicate *realNameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",realNameRegex];
    return [realNameTest evaluateWithObject:phoneNumber];
}

-(void)getHttpData
{
    NSString *urlStr =[NSString stringWithFormat:@"%@stores/selectstore.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSDictionary *dict = @{@"appkey":appKeyStr,
                           @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                           @"Storeid":[ShareModel shareModel].shopID,
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
            
            self.flag = [NSString stringWithFormat:@"%@",self.dictInfo[@"flag"]];
            self.brithdayChines = self.dictInfo[@"lunarBirthday"];
            self.brithdayGer = self.dictInfo[@"solarBirthday"];
            
            self.name = self.dictInfo[@"name"];
            self.arrayPhone = [[self.dictInfo[@"phone"]componentsSeparatedByString:@","]mutableCopy];
            self.age = self.dictInfo[@"age"];
            self.qq = self.dictInfo[@"qcode"];
            self.wx = self.dictInfo[@"wcode"];
            
            self.hobby = self.dictInfo[@"hobby"];
            
            [self.tableView reloadData];
            
            CellTrack1 *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(cell.contentView.frame.size.width-50, 10, 40, 20)];
            [button setTitle:@"提醒" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            if (![self.dictInfo[@"remind"]isEqualToString:@"0"]) {
                [button setTitleColor:GetColor(229, 126, 0, 1) forState:UIControlStateNormal];
            }
            [button addTarget:self action:@selector(gotoAddBrithay) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:button];
            
            
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURLHeader,self.dictInfo[@"photo"]]] placeholderImage:[UIImage imageNamed:@"tjtx"]];
            
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

-(void)submitData
{
    NSString *urlStr =[NSString stringWithFormat:@"%@shop/updateStoreBoss1.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    
    NSDictionary *dict = @{@"appkey":appKeyStr,
                           @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                           @"Storeid":[ShareModel shareModel].shopID,
                           @"RoleId":[ShareModel shareModel].roleID,
                           @"Name":self.name,
                           @"Phone":[self.arrayPhone componentsJoinedByString:@","],
                           @"QCode":self.qq,
                           @"WCode":self.wx,
                           @"Age":self.age,
                           @"SolarBirthday":self.brithdayGer,
                           @"LunarBirthday":self.brithdayChines,
                           @"flag":self.flag,
                           @"Hobby":self.hobby,
                           @"Photo":self.imageView.image,
                           @"ReviewsProposal":[ShareModel shareModel].dianping,
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

-(void)setUI
{
    UIView *viewTop = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Scree_width, 70)];
    viewTop.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:viewTop];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(8, 20, 40, 21)];
    label.text = @"照片";
    [viewTop addSubview:label];
    
    UIBarButtonItem *rightItem;
    if (self.isEdit) {
        rightItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(rightItem)];
        NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
        [rightItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    }else
    {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
        [button setImage:[UIImage imageNamed:@"submit_ico01"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(submitData) forControlEvents:UIControlEventTouchUpInside];
        rightItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    }
    self.navigationItem.rightBarButtonItem = rightItem;
    
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
    if (self.isEdit) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"添加照片" message:@"" delegate:self cancelButtonTitle:@"相册" otherButtonTitles:@"拍照", nil];
        [alert show];
        
    }else
    {
    ViewShowImage *showImage =[[ViewShowImage alloc]initWithFrame:CGRectMake(0, 20, Scree_width, Scree_height)];
    [showImage.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURLHeader,self.imageUrl]] placeholderImage:[UIImage imageNamed:@""]];
    [self.view.window addSubview:showImage];
    }
}

-(void)rightItem
{
    if (self.isEdit) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
        [button setImage:[UIImage imageNamed:@"submit_ico01"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(submitData) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:button];
        self.navigationItem.rightBarButtonItem = rightItem;
        self.canEdit = YES;
        [self.tableView reloadData];
    }else
    {
        [self submitData];
    }
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

-(void)addPhoneNumber
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"老板电话" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    alert.tag = 200;
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *textF = [alert textFieldAtIndex:0];
    textF.keyboardType = UIKeyboardTypePhonePad;
    [alert show];
}

-(void)showChooseBrithday
{
    UIViewDatePicker *datePick = [[UIViewDatePicker alloc]initWithFrame:CGRectMake(0, 0, Scree_width, Scree_height)];
    datePick.delegate = self;
    [self.view addSubview:datePick];
    self.datePick = datePick;
}

#pragma -mark UIViewBrithday

-(void)getChooseDate
{
    self.flag = self.datePick.flagggg;
    self.brithdayChines = self.datePick.stringChinese;
    self.brithdayGer = self.datePick.stringGregorian;

    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:5 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma -mark textView
-(void)textViewDidChange:(UITextView *)textView
{
    CellTrack1 *cell = (CellTrack1 *)[textView superview].superview;
    NSIndexPath *indexp = [self.tableView indexPathForCell:cell];
    switch (indexp.row) {
        case 0:
            self.name = textView.text;
            break;
        case 2:
            self.qq = textView.text;
            break;
        case 3:
            self.wx = textView.text;
            break;
        case 4:
            self.age = textView.text;
            break;
        case 7:
            self.hobby = textView.text;
            break;
            
        default:
            break;
    }
}

#pragma -mark alertView
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==200) {
        
        UITextField *textF = [alertView textFieldAtIndex:0];
        if ([self isValidatePhoneNumber:textF.text]) {
            [self.arrayPhone addObject:textF.text];
            NSIndexPath *index = [NSIndexPath indexPathForRow:1 inSection:0];
            [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
        }else
        {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"手机号无效" andInterval:1.0];
            return;
        }
        
    }else
    {
    if (buttonIndex==0) {
        UIImagePickerController *imagePick = [[UIImagePickerController alloc]init];
        imagePick.delegate = self;
        [self.navigationController presentViewController:imagePick animated:YES completion:nil];
        self.imagePicker = imagePick;
    }else
    {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"设备不支持" andInterval:1.0];
            return;
        }else
        {
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
    }
    }
}

#pragma -mark imagePickController

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    self.imageView.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self.navigationController dismissViewControllerAnimated:picker completion:nil];
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
    
    if (self.isEdit) {
        if (self.canEdit) {
            cell.textView.userInteractionEnabled = YES;
        }else
        {
            cell.textView.userInteractionEnabled = NO;
        }
    }else
    {
        cell.textView.userInteractionEnabled = YES;
    }
    
    
    if (indexPath.row==6||indexPath.row==8) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.userInteractionEnabled = YES;
        [cell.textView removeFromSuperview];
    }
    
    switch (indexPath.row) {
        case 0:
            cell.textView.text = self.name;
            break;
        case 1:
        {
            cell.textView.text = [self.arrayPhone componentsJoinedByString:@"\n"];
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(tableView.frame.size.width-20, 15, 15, 15)];
            [button setTitle:@"+" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(addPhoneNumber) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:button];
        }
            break;
        case 2:
            cell.textView.text = self.qq;
            break;
        case 3:
            cell.textView.text = self.wx;
            break;
        case 4:
            cell.textView.text = self.age;
            break;
        case 5:
        {
            if ([self.flag isEqualToString:@"1"]) {
                cell.textView.text = self.brithdayChines;
            }else
            {
                cell.textView.text = self.brithdayGer;
            }
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showChooseBrithday)];
            [cell.textView addGestureRecognizer:tap];
        }
            break;
        case 7:
            cell.textView.text = self.hobby;
            break;
            
        default:
            break;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==6) {
        VCBossFamilyDetailManager *vc = [[VCBossFamilyDetailManager alloc]init];
        vc.bossID = self.dictInfo[@"id"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row==8) {
        
        
        [ShareModel shareModel].showRightItem = YES;
        
        
        VCSpecialityManager *vc = [[VCSpecialityManager alloc]init];
        vc.content = self.dictInfo[@"reviewsProposal"];
        vc.stringTitle = @"点评建议";
        vc.state = @"7";
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
    self.canEdit = NO;
    
    self.arrayPhone = [NSMutableArray array];
    self.brithdayGer = @"";
    self.brithdayChines = @"";
    self.flag = @"";
    self.name = @"";
    self.age = @"";
    self.qq = @"";
    self.wx = @"";
    self.hobby = @"";
    [ShareModel shareModel].dianping = @"";
    
    
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
