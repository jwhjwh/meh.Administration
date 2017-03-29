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

@interface GroupdetailController ()<ZXYAlertViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong)UIImage *goodPicture;

@property (strong, nonatomic) EMGroup *chatGroup;

@property (strong,nonatomic) UIImageView  *background;
@property (assign,nonatomic) NSInteger integer;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"群资料";
    NSLog(@"====----%@",_chatGroup.owner);
    self.view.backgroundColor=GetColor(216, 216, 216, 1);
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(10, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(LiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    _background=[[UIImageView alloc]initWithFrame:CGRectMake(0,64,Scree_width, 230)];
    _background.userInteractionEnabled = YES;
    UserCacheInfo * userInfo = [UserCacheManager getById:_chatGroup.groupId];
    [_background sd_setImageWithURL:[NSURL URLWithString: userInfo.AvatarUrl] placeholderImage:[UIImage imageNamed:@""]];
    [self.view addSubview:_background];
    
    UIButton *butn = [UIButton buttonWithType:UIButtonTypeCustom];
    butn.frame = CGRectMake(_background.center.x-60, 115, 120, 20);
    [butn setTitle: @"点击更换头像" forState:UIControlStateNormal];
    [butn addTarget: self action: @selector(photoItem) forControlEvents: UIControlEventTouchUpInside];
    [_background addSubview:butn];
    UILabel *labeltitle=[[UILabel alloc]initWithFrame:CGRectMake(10, 165,160, 20)];
    labeltitle.textColor=[UIColor whiteColor];
    labeltitle.text =_chatGroup.subject;
    [_background addSubview:labeltitle];
    UILabel *labelid=[[UILabel alloc]initWithFrame:CGRectMake(10, 190,160, 20)];
    labelid.textColor=[UIColor whiteColor];
    labelid.text = _chatGroup.groupId;
    [_background addSubview:labelid];
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0,_background.bottom,Scree_width ,50)];
    view.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:view];
    
    UIImageView *logImage=[[UIImageView alloc]initWithFrame:CGRectMake(10, 8, 50, 34)];
    UITapGestureRecognizer *logtap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(GroupofdetailsTap:)];
    [view addGestureRecognizer:logtap];
    logImage.image=[UIImage imageNamed:@"yq_ico"];
    [view addSubview:logImage];
    UIImageView *gousImage=[[UIImageView alloc]initWithFrame:CGRectMake(logImage.right+5, 8, 34, 34)];
    gousImage.backgroundColor = GetColor(216, 216, 216, 1);
    gousImage.image=[UIImage imageNamed:@""];
    gousImage.layer.cornerRadius=17.0f;
    gousImage.layer.masksToBounds = YES;
    [view addSubview:gousImage];
    UIImageView *erImage=[[UIImageView alloc]initWithFrame:CGRectMake(gousImage.right+5,8, 34, 34)];
    erImage.backgroundColor =GetColor(216, 216, 216, 1);
    erImage.image=[UIImage imageNamed:@""];
    erImage.layer.cornerRadius=17.0f;
    erImage.layer.masksToBounds = YES;
    [view addSubview:erImage];
    UIImageView *jiao=[[UIImageView alloc]initWithFrame:CGRectMake(Scree_width-20, 15,14,20)];
    jiao.image=[UIImage imageNamed:@"jiantou_03"];
    [view addSubview:jiao];
    UILabel *number=[[UILabel alloc]initWithFrame:CGRectMake(Scree_width-110,15,80, 20)];
    number.text=[NSString stringWithFormat:@"%ld名成员",(long)_chatGroup.occupantsCount];
    [view addSubview:number];
    UIButton *addbutn = [UIButton buttonWithType:UIButtonTypeCustom];
    addbutn.frame = CGRectMake(Scree_width-160,8, 34, 34);
    [addbutn setBackgroundImage: [UIImage imageNamed:@"ass_ico"] forState:UIControlStateNormal];
    [view addSubview:addbutn];
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
    UILabel * Introduction = [[UILabel alloc]initWithFrame:CGRectMake(10, 45, Scree_width, 30)];
    NSLog(@"%@",_chatGroup.description);
    Introduction.text =_chatGroup.description;
    Introduction.font = [UIFont systemFontOfSize:15];
    Introduction.textColor =[UIColor lightGrayColor];
    [view2 addSubview:Introduction];
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
            UINavigationController *naviVC = [[UINavigationController alloc] initWithRootViewController:photosVC];
            photosVC.tailoredImage = ^ (UIImage *image){
                NSData *data = UIImageJPEGRepresentation(image,1.0f);
                NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                [USER_DEFAULTS  setObject:encodedImageStr forKey:@"blockImage"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"changeimage" object:nil userInfo:@{@"blockimage":encodedImageStr}];
            };
            [self presentViewController:naviVC animated:YES completion:nil];
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
    [self dismissViewControllerAnimated:YES completion:nil];
    if (_integer==0) {
          _background.image=self.goodPicture;
    }else{
        //裁剪后的图片
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
     
      
        [self dismissViewControllerAnimated:YES completion:nil];
  

    }
   
}

-(void)notimageTap:(UITapGestureRecognizer*)sender{
    _integer=1;
    ZXYAlertView *alert = [ZXYAlertView alertViewDefault];
    alert.title = @"请选择照片";
    alert.buttonArray = @[@"相机",@"相册"];
    alert.delegate = self;
    [alert show];
}
-(void)GroupofdetailsTap:(UITapGestureRecognizer*)sender{

}


@end
