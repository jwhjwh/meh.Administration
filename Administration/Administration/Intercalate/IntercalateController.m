//
//  IntercalateController.m
//  Administration
//
//  Created by 九尾狐 on 2017/2/14.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "IntercalateController.h"
#import "ManagementViewController.h"
#import "LomapViewController.h"
@interface IntercalateController ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>



{
    UITableView *tableview;
}

@property (strong,nonatomic) NSArray *InterNameAry;
@property (nonatomic, strong) NSMutableArray *InterImageAry;

@property (nonatomic, strong)UIImage *goodPicture;
@property (nonatomic, strong)UIImageView *TXImage;




@end

@implementation IntercalateController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden=NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"设置";
    [self InterTableUI];
    [self makeData];
    [self setExtraCellLineHidden:tableview];
    _InterNameAry = [[NSArray alloc]initWithObjects:@"账号管理",@"账号安全",@"定位",@"关于软件与帮助",@"意见反馈",nil];
    
}
- (void)makeData{
    self.InterImageAry = [NSMutableArray array];
    for (int i = 0; i < 5; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"Inder%d.png",i]];
        [self.InterImageAry addObject:image];
        
    }
}
-(void)InterTableUI
{
    tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 20,self.view.bounds.size.width,self.view.bounds.size.height) style:UITableViewStylePlain];
    tableview.separatorStyle= UITableViewCellSeparatorStyleSingleLine;
    tableview.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    tableview.scrollEnabled =NO;
    tableview.dataSource=self;
    tableview.delegate =self;
    [self.view addSubview:tableview];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //定义个静态字符串为了防止与其他类的tableivew重复
    static NSString *CellIdentifier =@"Cell";
    //定义cell的复用性当处理大量数据时减少内存开销
    UITableViewCell *cell = [tableview  dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell ==nil)
    {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:CellIdentifier];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;//右箭头
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = _InterNameAry[indexPath.row];
    cell.imageView.image = _InterImageAry[indexPath.row];
    
    CGSize itemSize = CGSizeMake(23, 23);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [cell.imageView.image drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if ([cell.textLabel.text  isEqual: @"账号管理"]) {
        _TXImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-80, 5, 40, 40)];
        NSString *logoStr = [USER_DEFAULTS  objectForKey:@"logoImage"];
        [_TXImage sd_setImageWithURL:[NSURL URLWithString:logoStr] placeholderImage:[UIImage  imageNamed:@"tx23"]];
        _TXImage.backgroundColor = [UIColor whiteColor];
        _TXImage.layer.masksToBounds = YES;
        _TXImage.layer.cornerRadius = 20.0;//设置圆角
        [tableview addSubview:_TXImage];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doTap:)];
        // 允许用户交互
        _TXImage.userInteractionEnabled = YES;
        
        [_TXImage addGestureRecognizer:tap];
    };
    return cell;
    
}
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int a = indexPath.row;
    switch (a) {
        case 0:{
            //账号管理
            ManagementViewController *MageVC = [[ManagementViewController alloc]init];
            [self.navigationController showViewController:MageVC sender:nil];
        }
            break;
        case 1:{
            //账号安全

            SecurityViewController *SecurtyVC = [[SecurityViewController alloc]init];
            [self.navigationController showViewController:SecurtyVC sender:nil];
        }
            break;
        case 2:{
            //定位
             int str = [[USER_DEFAULTS objectForKey:@"roleId"]intValue];
            if (str==1||str==7) {
       
                PositioningViewController *PositionVC = [[PositioningViewController alloc]init];
                 [self.navigationController pushViewController:PositionVC animated:nil];
            }else{
                LomapViewController *lomapVC=[[LomapViewController alloc]init];
                [self.navigationController pushViewController:lomapVC animated:nil];
            }
        }
            break;
        case 3:{
            //版本信息
            VersionViewController *VersionVC = [[VersionViewController alloc]init];
            [self.navigationController showViewController:VersionVC sender:nil];
        }
            break;
        case 4:{
            //意见反馈
            OpinionViewController *OpinionVC =[[OpinionViewController alloc]init];
            [self.navigationController showViewController:OpinionVC sender:nil];
        }
            break;
        default:
            break;
    }
    
}

- (void)doTap:(UITapGestureRecognizer*)sender{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"上传照片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }];
    UIAlertAction *libarayAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:picker animated:YES completion:nil];
        }
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertC addAction:photoAction];
    [alertC addAction:libarayAction];
    [alertC addAction:cancelAction];
    [self presentViewController:alertC animated:YES completion:nil];
    
}
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    self.goodPicture = [info objectForKey:UIImagePickerControllerEditedImage];
      NSData *pictureData = UIImagePNGRepresentation(self.goodPicture);
    [self dismissViewControllerAnimated:YES completion:nil];
    NSString *urlStr = [NSString stringWithFormat:@"%@upload/file.action", KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"code":@"1"};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"image/jpeg",@"image/png",@"image/gif",@"image/tiff",@"application/octet-stream",@"text/json",nil];
    [manager POST:urlStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
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
            NSString *msgStr = [NSString stringWithFormat:@"%@%@",KURLHeader,[dic valueForKey:@"url"] ];
        [ELNAlerTool showAlertMassgeWithController:self andMessage:@"保存头像成功" andInterval:1.0];
         [USER_DEFAULTS  setObject:msgStr forKey:@"logoImage"];
            _TXImage.image=self.goodPicture;
            [tableview reloadData];
        } else {
        [ELNAlerTool showAlertMassgeWithController:self andMessage:@"头像上传失败" andInterval:1.0];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}




@end
