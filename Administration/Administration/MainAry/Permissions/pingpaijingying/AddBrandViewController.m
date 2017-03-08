//
//  AddBrandViewController.m
//  Administration
//
//  Created by zhang on 2017/3/8.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "AddBrandViewController.h"
#import "AlertViewExtension.h"
#import "DongImage.h"
#import "ZXYAlertView.h"
@interface AddBrandViewController ()<UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,ZXYAlertViewDelegate,alertviewExtensionDelegate>
{
    BOOL _isEditing;
    AlertViewExtension *aler;
    BOOL _iswenjian;
    NSDictionary *dic;
    BOOL _isfanhui;
}
@property (nonatomic,retain)UITextField *textField;
@property (nonatomic,retain)UIImageView *imageV;
@property (nonatomic, strong)UIImage *goodPicture;
@property (nonatomic,strong)NSString *string;
@property (nonatomic,strong) NSString *tittle;
@property (nonatomic,retain) NSString *strId;
@property (nonatomic, strong)UIImage *oldPicture;

@end

@implementation AddBrandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"添加品牌";
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(butLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    
    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:(UIBarButtonItemStyleDone) target:self action:@selector(rightItemAction:)];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [rightitem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightitem;
    
    _imageV=[[UIImageView alloc]init];
    _imageV.backgroundColor=GetColor(230, 230, 230, 1);
    _imageV.userInteractionEnabled = YES;
    _imageV.image=[UIImage  imageNamed:@"ph_mt02"];
    [self.view addSubview: _imageV];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(noticeimageTap:)];
    [_imageV addGestureRecognizer:tap];
    _textField=[[UITextField alloc]init];
    _textField.placeholder=@"请输入品牌名称";
    _textField.borderStyle=UITextBorderStyleLine;
    _textField.layer.borderColor = GetColor(230, 230, 230, 1).CGColor;
    _textField.layer.borderWidth = 1.0;
    _textField.delegate = self;
    [_textField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    _textField.textAlignment = NSTextAlignmentCenter;
    _textField.enabled=YES;
    _textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, _textField.frame.size.height)];
    _textField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:_textField];
    [_imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(30);
        make.top.mas_equalTo(self.view.mas_top).offset(80);
        make.right.mas_equalTo(self.view.mas_right).offset(-30);
        make.height.offset(Scree_width-60);
    }];
    
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(-1);
        make.right.mas_equalTo(self.view.mas_right).offset(+1);
        make.top.mas_equalTo(_imageV.mas_bottom).offset(20);
        make.height.offset(30);
    }];
  
}
-(void)rightItemAction:(UIBarButtonItem*)sender{
    if (_string==nil) {
    [ELNAlerTool showAlertMassgeWithController:self andMessage:@"您没有输入内容" andInterval:1.0];
        return;
    }
    if (self.goodPicture==nil) {
        [ELNAlerTool showAlertMassgeWithController:self andMessage:@"您没有选择图片" andInterval:1.0];
        return;
    }
    if(!(_string==nil)&&!(self.goodPicture==nil)){
        _textField.enabled=NO;
        _imageV.userInteractionEnabled = NO;
        _isEditing=YES;
        _iswenjian=NO;
        [self lodataimage];
            return;
        }
    
    if (_isEditing==YES) {
        sender.title=@"编辑";
        _textField.enabled=YES;
        _imageV.userInteractionEnabled = YES;
        _isEditing=NO;
    }else{
        if ([_string isEqualToString:_tittle]&&[[NSString stringWithFormat:@"%@",_oldPicture]isEqualToString:[NSString stringWithFormat:@"%@",_goodPicture]]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"您没有做修改" andInterval:1.0];
        }else if(![_string isEqualToString:_tittle]&&[[NSString stringWithFormat:@"%@",_oldPicture]isEqualToString:[NSString stringWithFormat:@"%@",_goodPicture]]){
               sender.title=@"提交";
             _textField.enabled=NO;
             _imageV.userInteractionEnabled = NO;
            _isEditing=YES;
            [self neirongxiugai];
        }else if([_string isEqualToString:_tittle]&&![[NSString stringWithFormat:@"%@",_oldPicture]isEqualToString:[NSString stringWithFormat:@"%@",_goodPicture]]){
            sender.title=@"提交";
            _textField.enabled=NO;
            _imageV.userInteractionEnabled = NO;
            _isEditing=YES;
            [self lodataimage];
        }else if(![_string isEqualToString:_tittle]&&![[NSString stringWithFormat:@"%@",_oldPicture]isEqualToString:[NSString stringWithFormat:@"%@",_goodPicture]]){
            sender.title=@"提交";
            _textField.enabled=NO;
            _imageV.userInteractionEnabled = NO;
            _isEditing=YES;
            [self lodataimage];
        }
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)butLiftItem{
    if ((!(_string==nil)||!(self.goodPicture==nil))&&![_string isEqualToString:_tittle]) {
        if ( _isfanhui==YES) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            aler =[[AlertViewExtension alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, self.view.frame.size.height)];
            aler.delegate=self;
            [aler setbackviewframeWidth:300 Andheight:150];
            [aler settipeTitleStr:@"退出后，已编辑的内容将会消失确定退出吗？" Andfont:14];
            [self.view addSubview:aler];
        }
        
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
-(void)textFieldChange :(UITextField *)textField{
    _string=textField.text;
}
-(void)noticeimageTap:(UITapGestureRecognizer*)sender{
   
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
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
    }
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    self.goodPicture = [info objectForKey:UIImagePickerControllerEditedImage];
    [self dismissViewControllerAnimated:YES completion:nil];
    _imageV.image=self.goodPicture;
}

-(void)lodataimage{
    NSData *pictureData = UIImagePNGRepresentation(self.goodPicture);
    NSString *urlStr = [NSString stringWithFormat:@"%@upload/file.action", KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    if (_iswenjian==YES) {
        dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"code":@"2",@"finskid":_strId};
    }else{
        dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"code":@"2",@"str":_string};
    }
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
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSUTF8StringEncoding error:nil];
        NSString *status =  [NSString stringWithFormat:@"%@",[dict valueForKey:@"status"]];
        NSLog(@"%@",dict);
        if ([status isEqualToString:@"0000"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"保存图片成功" andInterval:1.0];
            _isfanhui=YES;
            _tittle=_string;
            _oldPicture=_goodPicture;
            _strId=[NSString stringWithFormat:@"%@",[responseObject valueForKey:@"brandId"]];
//            self.blcokStr(self.goodPicture,_string);
        } else {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"图片上传失败" andInterval:1.0];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
-(void)neirongxiugai{
    NSString *uStr =[NSString stringWithFormat:@"%@brand/addbrand.action",KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dict=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"finsk":_string,@"finskid":_strId};
    [ZXDNetworking GET:uStr parameters:dict success:^(id responseObject) {
        
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"修改成功" andInterval:1.0];
            _isfanhui=YES;
            self.blcokStr(self.goodPicture,_string);
        } else  if ([[responseObject valueForKey:@"status"]isEqualToString:@"0001"]){
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"修改信息失败" andInterval:1.0];
        } else  if ([[responseObject valueForKey:@"status"]isEqualToString:@"1000"]){
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"空数据" andInterval:1.0];
        } else  if ([[responseObject valueForKey:@"status"]isEqualToString:@"0003"]){
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"改品牌名已存在" andInterval:1.0];
        } else if ([[responseObject valueForKey:@"status"]isEqualToString:@"4444"]||[[responseObject valueForKey:@"status"]isEqualToString:@"1001"]) {
            PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"登陆超时请重新登录" sureBtn:@"确认" cancleBtn:nil];
            alertView.resultIndex = ^(NSInteger index){
                ViewController *loginVC = [[ViewController alloc] init];
                UINavigationController *loginNavC = [[UINavigationController alloc] initWithRootViewController:loginVC];
                [self presentViewController:loginNavC animated:YES completion:nil];
            };
            [alertView showMKPAlertView];
        }
        
    }failure:^(NSError *error) {
    }view:self.view MBPro:YES];
    
    
}


@end
