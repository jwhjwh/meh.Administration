//
//  GroupdetailController.m
//  Administration
//
//  Created by zhang on 2017/3/16.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "GroupdetailController.h"
#import "ZXYAlertView.h"
#import "WFPhotosViewController.h"
#import "CrowdViewController.h"
#import "AddmemberController.h"
#import "GroupMenberController.h"
#import "ChatViewController.h"
typedef void (^finish)(id result);
@interface GroupdetailController ()<ZXYAlertViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIAlertViewDelegate>
@property (nonatomic) GroupOccupantType occupantType;
@property (nonatomic, strong)UIImage *goodPicture;

@property (strong, nonatomic) EMGroup *chatGroup;

@property (strong,nonatomic) UIImageView  *background;
@property (assign,nonatomic) NSInteger integer;

@property (strong,nonatomic) NSString * dissOfExit;
@property (strong,nonatomic) UIButton *butn;

@property (strong,nonatomic)  NSArray *groupMembers;
@property (strong,nonatomic)  NSDictionary *groupInformation;

@property (strong,nonatomic) UIImageView *gousImage;
@property (strong,nonatomic) NSArray *arrayGousImage;
@property (strong,nonatomic) UILabel *number;
@property (strong,nonatomic) UIView *backView;

@property (strong,nonatomic)UIButton *button;

@property (strong,nonatomic)UILabel * Introduction;

@end

@implementation GroupdetailController

- (instancetype)initWithGroup:(EMGroup *)chatGroup
{
    self = [super init];
    if (self) {
        // Custom initialization
        _chatGroup = chatGroup;
    }
    return self;
}

- (instancetype)initWithGroupId:(NSString *)chatGroupId
{
    EMGroup *chatGroup = nil;
    NSArray *groupArray = [[EMClient sharedClient].groupManager getJoinedGroups];
    for (EMGroup *group in groupArray) {
        if ([group.groupId isEqualToString:chatGroupId]) {
            chatGroup = group;
            break;
        }
    }
    
    if (chatGroup == nil) {
        chatGroup = [EMGroup groupWithId:chatGroupId];
    }
    
    self = [self initWithGroup:chatGroup];
    if (self) {
        //
    }
    
    return self;
}

-(void)getDetailGroup
{
    NSString *urlStr =[NSString stringWithFormat:@"%@group/selectGroup.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSString *userid = [USER_DEFAULTS objectForKey:@"userid"];
   // NSString *groupNum = self.dictInfo[@"groupNumber"];
    
    NSDictionary *dict = @{@"appkey":appKeyStr,@"usersid":userid,@"GroupNumber":self.groupNum};
    
    
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"])
        {
            
            self.groupInformation = [responseObject valueForKey:@"groupInformation"];
            self.groupMembers = [responseObject valueForKey:@"groupMembers"] ;
            self.Introduction.text = self.groupInformation[@"introduce"];
            NSString *logoImage=[NSString stringWithFormat:@"%@%@",KURLHeader,self.groupInformation[@"img"]];
            [self.background sd_setImageWithURL:[NSURL URLWithString:logoImage] placeholderImage:[UIImage imageNamed:@""]];
            self.number.text=[NSString stringWithFormat:@"%lu名成员",(unsigned long)self.groupMembers.count];
            
            __block NSString *string = string;
            [self.groupInformation enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                if ([key isEqualToString:@"departmentId"]) {
                    string = [NSString stringWithFormat:@"%@",obj];
                    
                }
            }];
            NSLog(@"string = %@",string);
            
            if (![string isEqualToString:@"0"]) {
                self.button.hidden = YES;
            }
            else
            {
                self.button.hidden  = NO;
            }
            
            
            if ([[NSString stringWithFormat:@"%@",self.groupInformation[@"founder"]] isEqualToString:userid]) {
                [self.button setTitle:@"解散群组" forState:UIControlStateNormal];
                [_butn setTitle: @"点击更换头像" forState:UIControlStateNormal];
                _butn.userInteractionEnabled = YES;
            }
            else
            {
                _butn.userInteractionEnabled = NO;
                [self.button setTitle:@"退出群组" forState:UIControlStateNormal];
                
            }
            
            NSDictionary *dict = [NSDictionary dictionary];
            for (int i =0; i<self.groupMembers.count; i++) {
                dict = self.groupMembers[i];
                self.gousImage = self.arrayGousImage[i];
                self.gousImage.backgroundColor = [UIColor blueColor];;
                NSString *headImage=[NSString stringWithFormat:@"%@%@",KURLHeader,dict[@"img"]];
                [self.gousImage sd_setImageWithURL:[NSURL URLWithString:headImage] placeholderImage:[UIImage imageNamed:@"banben100"]];
                
                if (i==1) {
                    break;
                }
            }
            return ;
        }
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"4444"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"非法请求" andInterval:1.0];
            return;
        }
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"1001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请重新登录" andInterval:1.0];
            return;
        }
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"1111"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"失败" andInterval:1.0];
            return;
        }

    } failure:^(NSError *error) {
        
    } view:self.view.window MBPro:YES];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self getDetailGroup];
    [self ui];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"群资料";
    
    self.groupInformation = [NSDictionary dictionary];
    self.groupMembers = [NSArray array];
    
    
}
-(void)ui{

    self.view.backgroundColor=GetColor(216, 216, 216, 1);
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(10, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(LiftItem) forControlEvents: UIControlEventTouchUpInside];
    
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    _background=[[UIImageView alloc]initWithFrame:CGRectMake(0,64,Scree_width, 230)];
    _background.userInteractionEnabled = YES;
   // UserCacheInfo * userInfo = [UserCacheManager getById:_chatGroup.groupId];
   // [_background sd_setImageWithURL:[NSURL URLWithString: userInfo.AvatarUrl] placeholderImage:[UIImage imageNamed:@""]];
    [self.view addSubview:_background];
    
    _butn = [UIButton buttonWithType:UIButtonTypeCustom];
    _butn.frame = CGRectMake(_background.center.x-60, 115, 120, 20);
    [_butn addTarget: self action: @selector(photoItem) forControlEvents: UIControlEventTouchUpInside];
    [_background addSubview:_butn];
    
    UILabel *labeltitle=[[UILabel alloc]initWithFrame:CGRectMake(10, 165,160, 20)];
    labeltitle.textColor=[UIColor whiteColor];
    labeltitle.text =_chatGroup.subject;
    [_background addSubview:labeltitle];
    
    UILabel *labelid=[[UILabel alloc]initWithFrame:CGRectMake(10, 190,160, 20)];
    labelid.textColor=[UIColor whiteColor];
    labelid.text = _chatGroup.groupId;
  //  [_background addSubview:labelid];
    
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0,_background.bottom,Scree_width ,50)];
    view.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:view];
    
    UIImageView *logImage=[[UIImageView alloc]initWithFrame:CGRectMake(10, 8, 50, 34)];
    UITapGestureRecognizer *logtap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(GroupofdetailsTap:)];
    [view addGestureRecognizer:logtap];
    logImage.image=[UIImage imageNamed:@"yq_ico"];
    [view addSubview:logImage];
//    
//    
//    self.number=[[UILabel alloc]initWithFrame:CGRectMake(Scree_width-110,15,80, 20)];
//    [view addSubview:self.number];
    
    UIImageView *gousImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(65, 8, 34, 34)];
    gousImage1.layer.cornerRadius=17.0f;
    //self.gousImage1.backgroundColor = [UIColor redColor];
    gousImage1.layer.masksToBounds = YES;
    [view addSubview:gousImage1];
    
    UIImageView *gousImage2 = [[UIImageView alloc]initWithFrame:CGRectMake(65+39, 8, 34, 34)];
    gousImage2.layer.cornerRadius=17.0f;
    gousImage2.layer.masksToBounds = YES;
    [view addSubview:gousImage2];
    
    self.arrayGousImage = [NSArray arrayWithObjects:gousImage1,gousImage2,nil];
    
    UIImageView *jiao=[[UIImageView alloc]initWithFrame:CGRectMake(Scree_width-20, 15,14,20)];
    jiao.image=[UIImage imageNamed:@"jiantou_03"];
    [view addSubview:jiao];
    
    self.number=[[UILabel alloc]initWithFrame:CGRectMake(Scree_width-110,15,80, 20)];
    [view addSubview:self.number];
    
    UIButton *addbutn = [UIButton buttonWithType:UIButtonTypeCustom];
    addbutn.frame = CGRectMake(Scree_width-160,8, 34, 34);
    [addbutn setBackgroundImage: [UIImage imageNamed:@"ass_ico"] forState:UIControlStateNormal];
    [addbutn addTarget:self action:@selector(addPerson) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:addbutn];
    if ([ShareModel shareModel].isDefaultGroup) {
        addbutn.hidden = YES;
        addbutn.userInteractionEnabled = NO;
    }else
    {
        addbutn.hidden = NO;
        addbutn.userInteractionEnabled = YES;
    }
    
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0,view.bottom, Scree_width,1)];
    [self.view addSubview:line];
    
    UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(0,line.bottom, Scree_width,40)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(notimageTap:)];
    [view1 addGestureRecognizer:tap];
    view1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view1];
    
    UILabel *litbock=[[UILabel alloc]initWithFrame:CGRectMake(10,10,150, 20)];
    litbock.textColor=[UIColor lightGrayColor];
    litbock.text=@"聊天背景";
    [view1 addSubview: litbock];
    
    UIImageView *jiao1=[[UIImageView alloc]initWithFrame:CGRectMake(Scree_width-20, 10,14,20)];
    jiao1.image=[UIImage imageNamed:@"jiantou_03"];
    [view1 addSubview:jiao1];
    
    UIView *view2=[[UIView alloc]initWithFrame:CGRectMake(0,view1.bottom+10, Scree_width,Scree_height-view1.bottom-10)];
    view2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view2];
    
    UILabel * theme = [[UILabel alloc]initWithFrame:CGRectMake(10,15,100,30)];
    theme.text =@"群介绍";
    [view2 addSubview:theme];
    
    self.Introduction = [[UILabel alloc]initWithFrame:CGRectMake(10, 45, Scree_width, 30)];
   // self.Introduction.text =[_chatGroup.description substringToIndex:10];
    self.Introduction.font = [UIFont systemFontOfSize:15];
    self.Introduction.textColor =[UIColor lightGrayColor];
    [view2 addSubview:self.Introduction];
    
    self.button= [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.frame = CGRectMake(Scree_width/2-50,100,100, 34);
    [self.button.layer setCornerRadius:9];
    self.button.layer.borderWidth = 1.0;
    self.button.layer.borderColor =[UIColor RGBNav].CGColor;
    [self.button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(dissolutionOfExit) forControlEvents:UIControlEventTouchUpInside];
   // [view2 addSubview:self.button];
}

-(void)LiftItem{
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)photoItem{
    _integer=0;
    ZXYAlertView *alert = [ZXYAlertView alertViewDefault];
    alert.title = @"请选择照片";
    alert.buttonArray = @[@"相机",@"相册"];
    alert.delegate = self;
    [alert show];
}
- (void)alertView:(ZXYAlertView *)alertView clickedCustomButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex==0) {
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
 
    }else{
        if (_integer==1) {
            UIImageWriteToSavedPhotosAlbum([[UIImage alloc] init], nil, nil, nil);
            WFPhotosViewController *photosVC = [[WFPhotosViewController alloc] init];
         //   UINavigationController *naviVC = [[UINavigationController alloc] initWithRootViewController:photosVC];
            photosVC.tailoredImage = ^ (UIImage *image){
                NSData *data = UIImageJPEGRepresentation(image,1.0f);
                NSString *encodedImageStr = [data base64EncodedStringWithOptions:0];
               // NSString *encodedImageStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                [USER_DEFAULTS  setObject:encodedImageStr forKey:@"blockImage"];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"changeimage" object:nil userInfo:@{@"blockimage":encodedImageStr,@"groupNum":self.groupNum,@"status":@"1"}];
            };
            [self presentViewController:photosVC animated:YES completion:nil];
        }else{
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
       }
    }
}
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    self.goodPicture = [info objectForKey:UIImagePickerControllerEditedImage];
    [ShareModel shareModel].image = self.goodPicture;
   // [ShareModel shareModel].isGroup = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
//    if (_integer==0) {
//          _background.image=self.goodPicture;
//    }else{
//        //裁剪后的图片
//        [self dismissViewControllerAnimated:YES completion:nil];
//        
//    }
    [self updateGroupImage:self.goodPicture];
}
//退出群组或者解散群组
-(void)dissolutionOfExit
{
    NSString *urlStr =[NSString stringWithFormat:@"%@group/deleteGroupMembers.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSString *userid = [USER_DEFAULTS objectForKey:@"userid"];
    
    NSDictionary *dict = @{@"appkey":appKeyStr,@"usersid":userid,@"groupinformationId":self.dictInfo[@"groupinformationId"],@"groupNumber":self.dictInfo[@"groupNumber"],@"uuid":[USER_DEFAULTS objectForKey:@"uuid"]};
    
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
            [self.navigationController popToRootViewControllerAnimated:YES];
            return ;
        }
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"4444"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"非法请求" andInterval:1.0f];
            return;
        }
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"1001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@" token超时请重新登录" andInterval:1.0f];
            return;
        }
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"1111"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"失败" andInterval:1.0f];
            return;
        }
        
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    self.integer=1;
    if (buttonIndex==1) {
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }else if (buttonIndex==2)
    {
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.sourceType = sourceType;
        picker.allowsEditing = NO;
        [self presentViewController:picker animated:YES completion:nil];
    }
}

#pragma -mark 添加新成员
-(void)addPerson
{
    AddmemberController *controller = [[AddmemberController alloc]init];
    controller.isHaveGroup = YES;
    controller.groupID = self.groupNum;
    controller.groupinformationId = self.groupInformation[@"id"];
    [self.navigationController pushViewController:controller animated:YES];
//    ViewControllerAdd *vc = [[ViewControllerAdd alloc]initWithNibName:@"ViewControllerAdd" bundle:nil];
//    [self.navigationController pushViewController:vc animated:YES];
}

-(void)notimageTap:(UITapGestureRecognizer*)sender{
    
//    UIAlertView *alt = [[UIAlertView alloc]initWithTitle:@"请选择照片" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"相机",@"相册", nil];
//    [alt show];
    
    _integer=1;
    ZXYAlertView *alert = [ZXYAlertView alertViewDefault];
    alert.title = @"请选择照片";
    alert.buttonArray = @[@"相机",@"相册"];
    alert.delegate = self;
    [alert show];
}

-(void)GroupofdetailsTap:(UITapGestureRecognizer*)sender{
    GroupMenberController *controller = [[GroupMenberController alloc]init];
    controller.groupinformation = self.groupInformation;
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)updateGroupImage:(UIImage *)image
{
    NSData *pictureData = UIImagePNGRepresentation(image);
    NSString *urlStr = [NSString stringWithFormat:@"%@group/selectGroupMembersPosition.action", KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"groupinformationId":self.groupInformation[@"id"]};
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
            self.background.image = image;
            
        } else {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"头像上传失败" andInterval:1.0];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];

    
    
}


@end
