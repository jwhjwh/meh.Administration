
//
//  VCBossFamilyDetail.m
//  Administration
//
//  Created by zhang on 2017/12/9.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCBossFamilyDetailManager.h"
#import "CellTrack1.h"
#import "CellEditTable.h"
#import "UIPlaceHolderTextView.h"
@interface VCBossFamilyDetailManager ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic,strong)NSMutableArray *arrayList;
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,strong)UIButton *buttonAdd;
@property (nonatomic,strong)UIButton *buttonDel;
@property (nonatomic,strong)NSArray *arrayTitle;
@property (nonatomic,strong)NSMutableDictionary *dict;
@property (nonatomic,weak) UIView *viewTop;
@property (nonatomic,strong)NSIndexPath *indexPath;
@property (nonatomic,weak)UIButton *button;
@end

@implementation VCBossFamilyDetailManager

#pragma -mark custem

-(void)getHttpData
{
    NSString *urlStr =[NSString stringWithFormat:@"%@shop/selectFamilienstand.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSDictionary *dict = @{@"appkey":appKeyStr,
                           @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                           @"StoreBossid":self.bossID,
                           };
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        
        NSString *code = [responseObject valueForKey:@"status"];
        if ([code isEqualToString:@"0000"]) {
            
            for (int i=0; i<[[responseObject valueForKey:@"list"] count]; i++) {
                NSMutableDictionary *dict = [[responseObject valueForKey:@"list"][i]mutableCopy];
                [dict setValue:@"1" forKey:@"canEdit"];
                [self.arrayList addObject:dict];
            }
            [self.tableView reloadData];
            return ;
        }
        if ([code isEqualToString:@"5000"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"暂无数据" andInterval:1.0f];
            return;
        }
        
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}

-(void)setUI
{
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
    tableView.tableFooterView = viewBotttom;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}


-(void)addDetailOrDelt:(UIButton *)button
{
    if (button.tag==100) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:@"" forKey:@"name"];
        [dict setValue:@"" forKey:@"age"];
        [dict setValue:@"" forKey:@"relationship"];
        [dict setValue:@"tjtx" forKey:@"photo"];
        [dict setValue:@"2" forKey:@"canEdit"];
        [dict setValue:@"" forKey:@"id"];
        [self.arrayList insertObject:dict atIndex:self.arrayList.count];
        self.buttonDel.userInteractionEnabled = NO;
    }
    else
    {
        if ([self.buttonDel.titleLabel.text isEqualToString:@"删除一项"]) {
            [self.buttonDel setTitle:@"取消删除" forState:UIControlStateNormal];
            [self.buttonAdd setImage:[UIImage imageNamed:@"tj_ico02"] forState:UIControlStateNormal];
            self.buttonAdd.userInteractionEnabled = NO;
            for (int i=0; i<self.arrayList.count; i++) {
                NSMutableDictionary *dict = [self.arrayList[i]mutableCopy];
                [dict setValue:@"3" forKey:@"canEdit"];
                [self.arrayList replaceObjectAtIndex:i withObject:dict];
            }
        }else
        {
            [self.buttonDel setTitle:@"删除一项" forState:UIControlStateNormal];
            [self.buttonAdd setImage:[UIImage imageNamed:@"tj_ico01"] forState:UIControlStateNormal];
            self.buttonAdd.userInteractionEnabled = YES;
            for (int i=0; i<self.arrayList.count; i++) {
                NSMutableDictionary *dict = [self.arrayList[i]mutableCopy];
                [dict setValue:@"1" forKey:@"canEdit"];
                [self.arrayList replaceObjectAtIndex:i withObject:dict];
            }
        }
        
    }
    [self.tableView reloadData];
}

-(void)deletePlan:(UIButton *)button
{
    NSUInteger inter = button.tag-10;
    NSMutableDictionary *dict = [self.arrayList[inter]mutableCopy];
    
    if ([dict[@"canEdit"]isEqualToString:@"3"]) {
        [self deleInfo:button];
    }else
    {
        [self submit:button];
    }

    [self.buttonAdd setImage:[UIImage imageNamed:@"tj_ico01"] forState:UIControlStateNormal];
    self.buttonAdd.userInteractionEnabled = YES;
    
}

-(void)deleInfo:(UIButton *)button
{
    NSUInteger inter = button.tag-10;
    NSMutableDictionary *dictinfo = [self.arrayList[inter]mutableCopy];
    
    if ([[NSString stringWithFormat:@"%@",dictinfo[@"id"]]isEqualToString:@""]) {
        [self.arrayList removeObjectAtIndex:inter];
        [self.tableView reloadData];
        return;
    }
    
    NSString *urlStr =[NSString stringWithFormat:@"%@shop/updateFamilienstandid.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSDictionary *dict = @{
                           @"appkey":appKeyStr,
                           @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                           @"StoreBossid":self.bossID,
                           @"id":[NSString stringWithFormat:@"%@",dictinfo[@"id"]],
                           @"RoleId":[ShareModel shareModel].roleID,
                           };
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        
        NSString *code = [responseObject valueForKey:@"status"];
        if ([code isEqualToString:@"0000"]) {
            [self.arrayList removeObjectAtIndex:inter];
            [self.tableView reloadData];
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

-(void)submit:(UIButton *)button
{
    NSUInteger inter = button.tag-10;
    NSDictionary *dict = self.arrayList[inter];
    
    NSString *urlStr;
    NSDictionary *dictinfo;
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    if ([[NSString stringWithFormat:@"%@",dict[@"id"]]isEqualToString:@""]) {
        urlStr =[NSString stringWithFormat:@"%@shop/insertFamilienstand.action",KURLHeader];
        dictinfo = @{
                     @"appkey":appKeyStr,
                     @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                     @"StoreBossid":self.bossID,
                     @"Name":dict[@"name"],
                     @"Relationship":dict[@"relationship"],
                     @"Age":dict[@"age"],
                     @"file":dict[@"photo"]
                     };
    }else
    {
        urlStr = [NSString stringWithFormat:@"%@shop/updateFamilienstand.action",KURLHeader];
        dictinfo = @{
                     @"appkey":appKeyStr,
                     @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                     @"StoreBossid":self.bossID,
                     @"Name":dict[@"name"],
                     @"Relationship":dict[@"relationship"],
                     @"Age":dict[@"age"],
                     @"file":dict[@"photo"],
                     @"id":[NSString stringWithFormat:@"%@",dict[@"id"]],
                     @"RoleId":[ShareModel shareModel].roleID
                     };
    }
    NSData *pictureData = UIImagePNGRepresentation(dict[@"photo"]);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"image/jpeg",@"image/png",@"image/gif",@"image/tiff",@"application/octet-stream",@"text/json",nil];
    [manager POST:urlStr parameters:dictinfo constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
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
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"成功" andInterval:1.0];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:self.indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
            return ;
        } else {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"头像上传失败" andInterval:1.0];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

-(void)showImage:(UITapGestureRecognizer *)tapGes
{
    CGPoint point = [tapGes locationInView:self.tableView];
    self.indexPath = [self.tableView indexPathForRowAtPoint:point];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"添加照片" message:@"" delegate:self cancelButtonTitle:@"相册" otherButtonTitles:@"拍照", nil];
    [alert show];
}

#pragma -mark alertView
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *imagePick = [[UIImagePickerController alloc]init];
    if (buttonIndex==0) {
        imagePick.delegate = self;
        [self.navigationController presentViewController:imagePick animated:YES completion:nil];
    }else
    {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"设备不支持" andInterval:1.0];
            return;
        }else
        {
            imagePick.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
    }
}

#pragma -mark imagePickController

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSMutableDictionary *dict = [self.arrayList[self.indexPath.section]mutableCopy];
    [dict setValue:[info objectForKey:UIImagePickerControllerOriginalImage] forKey:@"photo"];
    [self.arrayList replaceObjectAtIndex:self.indexPath.section withObject:dict];
    [self.navigationController dismissViewControllerAnimated:picker completion:nil];
//    [self.tableView reloadRowsAtIndexPaths:@[self.indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self submit:self.button];
}

#pragma -mark textView
-(void)textViewDidChange:(UITextView *)textView
{
    
    CellEditTable *cell = (CellEditTable *)[textView superview].superview;
    
    CGRect frame = textView.frame;
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [textView sizeThatFits:constraintSize];
    if (size.height<=frame.size.height) {
        size.height=frame.size.height;
    }
    
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    NSDictionary *dict = self.arrayList[indexPath.section];
    [dict setValue:@"1" forKey:@"canEdit"];
    
    switch (indexPath.row) {
        case 0:
            [dict setValue:textView.text forKey:@"name"];
            
            break;
        case 1:
            [dict setValue:textView.text forKey:@"age"];
            
            break;
        case 2:
            [dict setValue:textView.text forKey:@"relationship"];
            break;
            
        default:
            break;
    }
    
    [self.arrayList replaceObjectAtIndex:indexPath.section withObject:dict];
    
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row<3) {
        return 44;
    }else
    {
        return 70;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellEditTable *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell = [[CellEditTable alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textView.delegate = self;
    cell.textView.editable = YES;
    NSDictionary *dict = self.arrayList[indexPath.section];
    
    if ([dict[@"canEdit"]isEqualToString:@"2"]) {
        cell.userInteractionEnabled = YES;
        
    }else
    {
        cell.userInteractionEnabled = NO;
        
    }

    switch (indexPath.row) {
        case 0:
            cell.textView.text = dict[@"name"];
            break;
        case 1:
            cell.textView.text = [NSString stringWithFormat:@"%@",dict[@"age"]];
            break;
        case 2:
            cell.textView.text = dict[@"relationship"];
            break;
        case 3 :
        {
            [cell.textView removeFromSuperview];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showImage:)];
            UIImageView *imageHead = [[UIImageView alloc]initWithFrame:CGRectMake(150, 10, 50, 50)];
            [imageHead sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURLHeader,dict[@"photo"]]] placeholderImage:[UIImage imageNamed:@"tjtx"]];
            imageHead.userInteractionEnabled = YES;
            [imageHead addGestureRecognizer:tap];
            [cell.contentView addSubview:imageHead];
            
            break;
        }
            
        default:
            break;
    }
    
    cell.labelTitle.text = self.arrayTitle[indexPath.row];
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Scree_width, 30)];
    view.backgroundColor = GetColor(237, 238, 239, 1);
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(Scree_width-90, 8, 100, 14)];
    button.tag = section+10;
//    [button setTitle:@"编辑" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(deletePlan:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    NSMutableDictionary *dict = self.arrayList[section];
    if ([dict[@"canEdit"] isEqualToString:@"1"]) {
        [button setTitle:@"编辑" forState:UIControlStateNormal];
    }else if([dict[@"canEdit"] isEqualToString:@"2"])
    {
        [button setTitle:@"完成" forState:UIControlStateNormal];
    }else
    {
        [button setTitle:@"删除" forState:UIControlStateNormal];
    }
    self.button = button;
    
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
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.arrayList removeAllObjects];
    [self getHttpData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"家庭情况";
    
    self.arrayList = [NSMutableArray array];
    
    self.arrayTitle = @[@"家属姓名",@"关系",@"年龄",@"照片"];
    self.dict = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@"" forKey:@"name"];
    [dict setValue:@"" forKey:@"age"];
    [dict setValue:@"" forKey:@"relationship"];
    [dict setValue:@"tjtx" forKey:@"photo"];
    [dict setValue:@"2" forKey:@"canEdit"];
    [dict setValue:@"" forKey:@"id"];
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
