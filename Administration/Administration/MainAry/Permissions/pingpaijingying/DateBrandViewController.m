//
//  DateBrandViewController.m
//  Administration
//
//  Created by 九尾狐 on 2018/1/10.
//  Copyright © 2018年 九尾狐. All rights reserved.
//

#import "DateBrandViewController.h"
#import "AlertViewExtension.h"
#import "DongImage.h"
#import "ZXYAlertView.h"
@interface DateBrandViewController ()<UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,ZXYAlertViewDelegate,alertviewExtensionDelegate>
{
    
    AlertViewExtension *aler;
    
    NSDictionary *dic;
    BOOL _issure;
}
@property (nonatomic,retain)UITextField *textField;
@property (nonatomic,retain)UIImageView *imageV;
@property (nonatomic, strong)UIImage *goodPicture;
@property (nonatomic,strong)NSString *string;

@end

@implementation DateBrandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"品牌详情";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(butLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    
    if ([self.yesorno isEqualToString:@"1"]) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30,30)];
        button.titleLabel.font = [UIFont systemFontOfSize:20];
        [button setTitle:@"完成" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(gotoAdd:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:button];
        self.navigationItem.rightBarButtonItem = rightItem;
        _issure=YES;
    }else{
        _issure = NO;
    }
    [self getuI];
}
-(void)getuI{
    _imageV=[[UIImageView alloc]init];
    _imageV.backgroundColor=GetColor(230, 230, 230, 1);
    
     NSString *imageStr = [NSString stringWithFormat:@"%@%@",KURLHeader,self.dateDic[@"brandLogo"]];
    
    [_imageV sd_setImageWithURL:[NSURL URLWithString:imageStr]placeholderImage:[UIImage imageNamed:@"ph_mt02"]];
    [self.view addSubview: _imageV];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(noticeimageTap:)];
    [_imageV addGestureRecognizer:tap];
    _imageV.userInteractionEnabled=_issure;
    
    self.goodPicture = _imageV.image;
    
    _textField=[[UITextField alloc]init];
    _textField.placeholder=@"请输入品牌名称";
    _textField.text = self.dateDic[@"finsk"];
    _string = _textField.text;
    placeholder(_textField);
    _textField.borderStyle=UITextBorderStyleLine;
    _textField.layer.borderColor = GetColor(230, 230, 230, 1).CGColor;
    _textField.layer.borderWidth = 1.0;
    _textField.delegate = self;
    [_textField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    _textField.textAlignment = NSTextAlignmentCenter;
    _textField.enabled=_issure;
    _textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, _textField.frame.size.height)];
    _textField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:_textField];
    [_imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(30);
        make.top.mas_equalTo(self.view.mas_top).offset(90);
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
        picker.view.backgroundColor=[UIColor whiteColor];
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
-(void)gotoAdd:(UIBarButtonItem*)sender{
    //finskid
    NSData *pictureData = UIImagePNGRepresentation(self.goodPicture);
    NSString *urlStr = [NSString stringWithFormat:@"%@upload/file.action", KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    
    dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"code":@"2",@"str":_string,@"finskid":self.dateDic[@"id"]};
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
        if ([status isEqualToString:@"0000"]) {
           [ELNAlerTool showAlertMassgeWithController:self andMessage:@"修改成功" andInterval:1.0];
            
        } else {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"图片上传失败" andInterval:1.0];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)butLiftItem{
    
        [self.navigationController popViewControllerAnimated:YES];
    
}

@end
