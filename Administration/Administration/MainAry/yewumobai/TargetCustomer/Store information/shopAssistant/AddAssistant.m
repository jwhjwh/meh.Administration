//
//  AddAssistant.m
//  Administration
//
//  Created by 九尾狐 on 2017/11/28.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "AddAssistant.h"
#import "ZZYPhotoHelper.h"
#import "DongImage.h"
#import "UIViewDatePicker.h"
#import "DPYJViewController.h"
@interface AddAssistant ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIViewDatePickerDelegate>
@property (nonatomic,retain)UITableView *tableView;
@property (nonatomic ,retain)NSMutableArray *nameArrs;
@property (nonatomic,strong)UIImageView *TXImage;
@property (nonatomic,strong) NSString *logImage;//头像地址
@property (nonatomic,strong) UILabel *DayLabel;//出生日期
@property (nonatomic,strong)NSMutableArray *ligary;
@property (nonatomic,strong)NSMutableArray *texttagary;

@property (nonatomic,strong) NSString *namestr;//姓名
@property (nonatomic,strong) NSString *agestr;//年龄
@property (nonatomic,strong) NSString *daystr;//生日
@property (nonatomic,strong) NSString *HobbyStr;//爱好
@property (nonatomic,strong) NSString *FeatureStr;//性格
@property (nonatomic,strong) NSString *iphonestr;//电话
@property (nonatomic,strong) NSString *Specialty;//特长
@property (nonatomic,strong) NSString *OverallMerit;//评价



@end

@implementation AddAssistant

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加店员信息";
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    if (self.issssend == NO) {
        UIBarButtonItem *rightitem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:(UIBarButtonItemStyleDone) target:self action:@selector(rightItemAction:)];
        NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
        [rightitem setTitleTextAttributes:dict forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = rightitem;
    }else{
        UIButton *rightitem = [UIButton buttonWithType:UIButtonTypeCustom];
        rightitem.frame =CGRectMake(self.view.frame.size.width-30, 0, 28,28);
        [rightitem setBackgroundImage:[UIImage imageNamed:@"submit_ico01"] forState:UIControlStateNormal];
        [rightitem addTarget: self action: @selector(rightItemAction:) forControlEvents: UIControlEventTouchUpInside];
        UIBarButtonItem *rbuttonItem=[[UIBarButtonItem alloc]initWithCustomView:rightitem];
        self.navigationItem.rightBarButtonItem = rbuttonItem;
    }
    
   _nameArrs = [[NSMutableArray alloc]initWithObjects:@[@"照片"],@[@"姓名",@"年龄",@"生日",@"爱好",@"性格",@"电话",@"特长",@"综合研判"], nil];
    _ligary = [[NSMutableArray alloc]initWithObjects:@[@""],@[@"填写姓名",@"填写年龄",@"填写生日",@"填写爱好",@"填写性格",@"填写电话"], nil];
    _texttagary = [[NSMutableArray alloc]initWithObjects:@[@""],@[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8"], nil];
    [self addViewremind];
}
-(void)addViewremind{
    self.tableView= [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    NSString* phoneModel = [UIDevice devicePlatForm];
    if ([phoneModel isEqualToString:@"iPhone Simulator"]||[phoneModel isEqualToString:@"iPhone X"]) {
        self.tableView.frame =CGRectMake(0,88,self.view.bounds.size.width,self.view.bounds.size.height-50);
    }else{
        self.tableView.frame =CGRectMake(0,65,self.view.bounds.size.width,self.view.bounds.size.height-50);
    }
    self.tableView.dataSource=self;
    self.tableView.delegate =self;
    [ZXDNetworking setExtraCellLineHidden:self.tableView];
    [self.view addSubview:self.tableView];
}
-(void)rightItemAction:(UIBarButtonItem *)btn{
    if ([btn.title isEqualToString:@"编辑"]) {
        btn.title = @"完成";
        self.issssend = YES;
        [self.tableView reloadData];
        NSLog(@"编辑");
    }else if ([btn.title isEqualToString:@"完成"]){
        btn.title =@"编辑";
        self.issssend = NO;
        [self.tableView reloadData];
        NSLog(@"完成");
    }else{
        NSLog(@"提交");
        [self insertStoreClerk];
    }
    
}
-(void)showDatePicker
{
    UIViewDatePicker *datePick = [[UIViewDatePicker alloc]initWithFrame:CGRectMake(0, 0, Scree_width, Scree_height)];
    datePick.delegate = self;
    [self.view endEditing:YES];
    [self.view.window addSubview:datePick];

    NSLog(@"----%@-----%@----%@",_DayLabel.text,[ShareModel shareModel].stringChinese,[ShareModel shareModel].stringGregorian);
}
-(void)getChooseDate
{
    [self.tableView reloadData];
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 2:
            
            [self showDatePicker];
            break;
        case 6:
            
            break;
        case 7:
        {
            DPYJViewController *targetVC=[[DPYJViewController alloc]init];
            targetVC.number=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
            targetVC.dateStr = _OverallMerit; //点评建议
            targetVC.modifi = _issssend;//可否编辑
            targetVC.blcokStr=^(NSString *content,int num){
                if (num==7) {
                    if (_issssend == YES) {
                        _OverallMerit = content;
                    }
                    //同事协助须知
                    
                }
            };
            [self.navigationController pushViewController:targetVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}
-(void)insertStoreClerk{
   //NSString * flag = [ShareModel shareModel].flag;
    NSString *uStr =[NSString stringWithFormat:@"%@user/insertStoreClerk.action",KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dict=@{@"appkey":apKeyStr,
                         @"usersid":[USER_DEFAULTS  objectForKey:@"userid"],
                         @"flag":[ShareModel shareModel].flag,
                         @"SolarBirthday":[ShareModel shareModel].stringChinese,
                         @"LunarBirthday":[ShareModel shareModel].stringGregorian,
                         @"Storeid":self.shopid,
                         @"Name":_namestr,
                         @"Age":_agestr,
                         @"Hobby":_HobbyStr,
                         @"Feature":_FeatureStr,
                         @"Specialty":_Specialty,
                         @"OverallMerit":_OverallMerit,
                         @"Phone":_iphonestr};
    NSData *pictureData = UIImagePNGRepresentation(self.TXImage.image);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"image/jpeg",@"image/png",@"image/gif",@"image/tiff",@"application/octet-stream",@"text/json",nil];
    [manager POST:uStr parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyMMddHHmm";
        NSString *fileName = [formatter stringFromDate:[NSDate date]];
        NSString *nameStr = @"file";
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [formData appendPartWithFileData:pictureData name:nameStr fileName:[NSString stringWithFormat:@"%@.png", fileName] mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView: self.view animated:NO];
        NSString *response = [[NSString alloc] initWithData:(NSData *)responseObject encoding:NSUTF8StringEncoding];
        NSData* jsonData = [response dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSUTF8StringEncoding error:nil];
        NSString *status =  [NSString stringWithFormat:@"%@",[dict valueForKey:@"status"]];
        
        if ([status isEqualToString:@"0000"]) {
           
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"上传成功" andInterval:1.0];
            
            
            [self.tableView reloadData];
            
        } else {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"上传失败" andInterval:1.0];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 80.0f;
    }else{
            return 50.0f;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_nameArrs[section]count];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0;
    }else{
        return 10;
    }
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString * str = [NSString stringWithFormat:@"  "];
    return str;
}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    
    view.tintColor = GetColor(230,230,230,1);
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.textColor = [UIColor grayColor];
    header.textLabel.font = [UIFont systemFontOfSize:14.0f];
    
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _nameArrs.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifi = @"gameeCell";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifi];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *tlelabel = [[UILabel alloc]init];
    if (indexPath.section == 0) {
        tlelabel.frame = CGRectMake(10, 25, 50, 30);
    }else{
        tlelabel.frame = CGRectMake(10, 10, 110, 30);
    }
    tlelabel.text =  _nameArrs[indexPath.section][indexPath.row];
    tlelabel.font = [UIFont systemFontOfSize:15.0f];
    [cell addSubview:tlelabel];
    
    if (indexPath.section == 0) {
        _TXImage = [[UIImageView alloc]initWithFrame:CGRectMake(120, 15, 50, 50)];
        if (_logImage.length<1) {
            _TXImage.image = [UIImage imageNamed:@"tjtx"];
        }else{
            [_TXImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURLHeader,_logImage]] placeholderImage:[UIImage  imageNamed:@"hp_ico"]];
        }
        _TXImage.backgroundColor = [UIColor whiteColor];
        _TXImage.layer.masksToBounds = YES;
        _TXImage.layer.cornerRadius = 25.0;//设置圆角
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPage3:)];
        tapGesturRecognizer.numberOfTapsRequired = 1; //设置单击几次才触发方法
        [_TXImage addGestureRecognizer:tapGesturRecognizer];
        _TXImage.userInteractionEnabled = YES;
        [cell addSubview:_TXImage];
    }else{
        if (indexPath.row>5) {
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;//右箭头
        }else{
            if(indexPath.row==2){
                [_DayLabel removeFromSuperview];
                
                _DayLabel = [[UILabel alloc]initWithFrame:CGRectMake(150, 1, self.view.bounds.size.width-170, 48)];
                _DayLabel.text = @"";
                [cell addSubview:_DayLabel];
                if ([[ShareModel shareModel].flag isEqualToString:@"1"]) {
                    _DayLabel.text = [ShareModel shareModel].stringChinese;
                }else if([[ShareModel shareModel].flag isEqualToString:@"2"])
                {
                    _DayLabel.text = [ShareModel shareModel].stringGregorian;
                }else
                {
                    //_DayLabel.text = [NSString stringWithFormat:@"%@",_InterNameAry[indexPath.section-1][indexPath.row]];
                }
                _DayLabel.font = [UIFont boldSystemFontOfSize:13.0f];
            }else{
                //老板姓名
                UITextField *bossname = [[UITextField alloc]initWithFrame:CGRectMake(120, 10, cell.width-120, 30)];
                bossname.placeholder = _ligary[indexPath.section][indexPath.row];
                bossname.font = [UIFont systemFontOfSize:14.0f];
                placeholder(bossname);
                bossname.tag = 1;
                bossname.delegate = self;
                [bossname addTarget:self action:@selector(PersonFieldText:) forControlEvents:UIControlEventEditingChanged];
                bossname.enabled = self.issssend;
                //bossname.text = _InfonAry[indexPath.section][indexPath.row];
                [cell addSubview:bossname];
            }
        }
        
    }
    
    
    return cell;
}
-(void)tapPage3:(UITapGestureRecognizer*)sender
{
    if (self.issssend==NO) {
    NSLog(@"头像放大");
    [DongImage showImage:_TXImage];
}else{
    [[ZZYPhotoHelper shareHelper] showImageViewSelcteWithResultBlock:^(id data) {
        _TXImage.image = (UIImage *)data;
    }];
}
    
}
- (void)PersonFieldText:(UITextField *)textField{
    switch (textField.tag) {
        case 0:
            _namestr = textField.text;
            break;
        case 1:
            _agestr = textField.text;
            break;
        case 3:
            _HobbyStr = textField.text;
            break;
        case 4:
            _FeatureStr = textField.text;
            break;
        case 5:
            _iphonestr = textField.text;
            break;
        default:
            break;
    }
}
-(void)buLiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 补全分隔线左侧缺失
- (void)viewDidLayoutSubviews {
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
