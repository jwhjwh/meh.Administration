//
//  BuildViewController.m
//  Administration
//
//  Created by zhang on 2017/3/15.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "BuildViewController.h"
#import "AddmemberController.h"
#import "ZXYAlertView.h"

@interface BuildViewController ()<UITextFieldDelegate,ZXYAlertViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong,nonatomic) UITextField *textFleid;
@property (strong,nonatomic) UIImageView *HeadView;//头像
@property (nonatomic, strong)UIImage *goodPicture;
@end

@implementation BuildViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden=YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title=@"创建群";
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buttonLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:(UIBarButtonItemStyleDone) target:self action:@selector(rightItem)];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];  
    [rightitem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightitem;
    _HeadView = [[UIImageView alloc]init];
    _HeadView.userInteractionEnabled = YES;
    [_HeadView setImage:[UIImage imageNamed:@"tjtx_mt.png"]];
    _HeadView.backgroundColor = [UIColor whiteColor];
    _HeadView.layer.masksToBounds = YES;
    _HeadView.layer.cornerRadius =80;//设置圆角
    [self.view addSubview:_HeadView];
    UITapGestureRecognizer *taposition = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(SpositionTap:)];
    [_HeadView addGestureRecognizer:taposition];
    [_HeadView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(100);
        make.left.equalTo(self.view.mas_centerX).offset(-80);
        make.right.equalTo(self.view.mas_centerX).offset(80);
        make.size.mas_equalTo(CGSizeMake(160,160));
    }];
   _textFleid=[[UITextField alloc]init];
    _textFleid.delegate = self;
    _textFleid.textAlignment = NSTextAlignmentCenter;
    _textFleid.placeholder=@"填写群名称";
     placeholder(_textFleid);
    [self.view addSubview:_textFleid];
    [_textFleid  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_HeadView.mas_bottom).offset(60);
        make.left.equalTo(self.view.mas_centerX).offset(-80);
        make.right.equalTo(self.view.mas_centerX).offset(80);
        make.size.mas_equalTo(CGSizeMake(160,30));
    }];
    UIView *view=[[UIView alloc]init];
    view.backgroundColor=GetColor(216, 216, 216, 1);
    [self.view addSubview:view];
    [view  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_textFleid.mas_bottom);
        make.left.equalTo(self.view.mas_centerX).offset(-80);
        make.right.equalTo(self.view.mas_centerX).offset(80);
        make.size.mas_equalTo(CGSizeMake(160,1));
    }];
}
-(void)buttonLiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightItem{
    if (self.textFleid.text.length==0) {
      [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请输入群名" andInterval:1.0];
    }else if (self.goodPicture==nil) {
        [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请添加群名图片" andInterval:1.0];
    }else{
        AddmemberController *addmenVC=[[AddmemberController alloc]init];
        addmenVC.goursIamge=self.goodPicture;
        addmenVC.textStr = self.textFleid.text;
        [self.navigationController pushViewController:addmenVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}
-(void)SpositionTap:(UIGestureRecognizer*)sender{
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
    _HeadView.image=self.goodPicture;
}
@end
 
