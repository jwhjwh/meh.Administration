//
//  EditbrandController.m
//  Administration
//
//  Created by zhang on 2017/3/7.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "EditbrandController.h"
#import "DongImage.h"
#import "ZXYAlertView.h"
@interface EditbrandController ()<UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,ZXYAlertViewDelegate>
{
    BOOL _isEditing;
}
@property (nonatomic,retain)UITextField *textField;
@property (nonatomic,retain)UIImageView *imageV;

@property (nonatomic, strong)UIImage *goodPicture;
@property (nonatomic,strong)NSString *string;
@end

@implementation EditbrandController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"品牌介绍";
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(butLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
   
    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:(UIBarButtonItemStyleDone) target:self action:@selector(rightItemAction:)];
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [rightitem setTitleTextAttributes:dic forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightitem;
    
    _imageV=[[UIImageView alloc]init];
    _imageV.userInteractionEnabled = YES;
    [_imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURLHeader,_imageStr]] placeholderImage:[UIImage  imageNamed:@"tx23"]];
    [self.view addSubview: _imageV];
   
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(noticeimageTap:)];
    [_imageV addGestureRecognizer:tap];

    _textField=[[UITextField alloc]init];
    _textField.placeholder=@"请输入品牌名称";
    _textField.borderStyle=UITextBorderStyleLine;
    _textField.layer.borderColor = GetColor(230, 230, 230, 1).CGColor;
    _textField.layer.borderWidth = 1.0;
    _textField.text=_tittle;
    _textField.delegate = self;
    [_textField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    _textField.textAlignment = NSTextAlignmentCenter;
    _textField.enabled=NO;
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
 _isEditing=YES;
}
-(void)rightItemAction:(UIBarButtonItem*)sender{
    if (_isEditing==YES) {
        //改变item的title
        sender.title=@"完成";
        _isEditing=NO;
        _textField.enabled=YES;
    }else{
        //改变item的title
        if (![_string isEqualToString:_tittle]||!(self.goodPicture==nil)) {
            sender.title=@"编辑";
            _isEditing=YES;
            _textField.enabled=NO;
            [self lodataimage];
            [self neirongxiugai];
        }else if ([_string isEqualToString:_tittle]||!(self.goodPicture==nil)) {
            sender.title=@"编辑";
            _isEditing=YES;
            _textField.enabled=NO;
            [self lodataimage];
        }else if (![_string isEqualToString:_tittle]||self.goodPicture==nil) {
            sender.title=@"编辑";
            _isEditing=YES;
            _textField.enabled=NO;
            [self neirongxiugai];
        }else{
            
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"您没有修改内容" andInterval:1.0];
        }
        
    }
}
-(void)butLiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)textFieldChange :(UITextField *)textField{
     _string=textField.text;
}
-(void)moreConfig{
    
}
-(void)noticeimageTap:(UITapGestureRecognizer*)sender{
    if (_isEditing==YES) {
       [DongImage showImage:_imageV];
    }else{
        ZXYAlertView *alert = [ZXYAlertView alertViewDefault];
        alert.title = @"请选择照片";
        alert.buttonArray = @[@"相机",@"相册"];
        alert.delegate = self;
        [alert show];
    }
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)lodataimage{
        NSData *pictureData = UIImagePNGRepresentation(self.goodPicture);
        NSString *urlStr = [NSString stringWithFormat:@"%@upload/file.action", KURLHeader];
        NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
        NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
        NSDictionary *dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"code":@"2",@"finskid":_strId};
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
                [ELNAlerTool showAlertMassgeWithController:self andMessage:@"保存头像成功" andInterval:1.0];
            } else {
                [ELNAlerTool showAlertMassgeWithController:self andMessage:@"头像上传失败" andInterval:1.0];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
}
-(void)neirongxiugai{
    NSString *uStr =[NSString stringWithFormat:@"%@brand/querybrand.action",KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    
    NSDictionary *dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"finskid":_strId,@"brand":_string};
    [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
       
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
         [ELNAlerTool showAlertMassgeWithController:self andMessage:@"修改成功" andInterval:1.0];
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
