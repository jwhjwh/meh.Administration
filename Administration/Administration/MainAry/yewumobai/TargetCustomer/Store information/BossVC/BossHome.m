//
//  BossHome.m
//  Administration
//
//  Created by 九尾狐 on 2017/11/18.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "BossHome.h"
#import "ZZYPhotoHelper.h"
#import "DongImage.h"
@interface BossHome ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (nonatomic,retain)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *leftary;

@property (nonatomic,strong)NSMutableArray *ligary;
@property (nonatomic,strong) UIButton *bjbtn;//编辑按钮
@property (strong,nonatomic)UIButton *tjBtn;//添加按钮
@property (strong,nonatomic)UIButton *scBtn;//删除按钮

@property (nonatomic,strong) NSMutableArray *bjbtnname;
@property (nonatomic, strong) NSMutableArray *bjbuttonAry;//编辑按钮
@property (nonatomic, strong) NSMutableArray *bjBtnAry;//编辑按钮id


@property (strong,nonatomic) UIImageView *TXImage;
@property (nonatomic,strong)NSString *logImage;
@property (nonatomic,strong)UIView *ThereisnoView;

@property (nonatomic, strong) NSMutableArray *nameAry;//姓名数组
@property (nonatomic, strong) NSMutableArray *RelationshipAry;//关系数组
@property (nonatomic, strong) NSMutableArray *ageAry;//年龄数组
@property (nonatomic, strong) NSMutableArray *ImageAry;//照片数组
@property (nonatomic, strong) NSMutableArray *BossFLid;//bossid

@property (nonatomic, strong)NSString *nameStr;//姓名
@property (nonatomic, strong)NSString *RelationshipStr;//关系
@property (nonatomic, strong)NSString *ageStr;//年龄
@property (nonatomic, strong)NSString *ImageStr;//照片

@property (nonatomic, strong) NSMutableArray *bossimageary;//bossid

@property(nonatomic,strong)UIImageView *twoimage;

@end

@implementation BossHome

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"家庭情况";
    //self.isend = NO;
    if ([self.shopname isEqualToString:@"1"]) {
        self.isend = NO;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    _bjbuttonAry = [[NSMutableArray alloc]init];
    
    _bossimageary = [[NSMutableArray alloc]init];
    
    _bjBtnAry =[[NSMutableArray alloc]init];
    
    _nameAry =[[NSMutableArray alloc]init];
    _RelationshipAry =[[NSMutableArray alloc]init];
    _ageAry =[[NSMutableArray alloc]init];
    _ImageAry =[[NSMutableArray alloc]init];
    [self selectfamilienstand];
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
    
    UIView *view1 = [[UIView alloc]init];
    view1.backgroundColor = GetColor(201, 201, 201, 1);
    [self.tableView addSubview:view1];
    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.bottom.equalTo(self.tableView.mas_top).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.height.mas_equalTo(1);
    }];
    
    UIView *fotView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Scree_width, 150)];
    fotView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView=fotView;
    
    UIView *toppView = [[UIView alloc]init];
    toppView.backgroundColor = GetColor(238, 238, 238, 1);
    [fotView addSubview:toppView];
    [toppView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(fotView.mas_left).offset(0);
        make.right.mas_equalTo(fotView.mas_right).offset(0);
        make.top.mas_equalTo(fotView.mas_top).offset(0);
        make.height.mas_equalTo(20);
    }];
    
    
    _tjBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _tjBtn.enabled = _isend;
    [_tjBtn setTitle:@"添加" forState:UIControlStateNormal];
    [_tjBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_tjBtn addTarget:self action:@selector(tjaction_button:) forControlEvents:UIControlEventTouchUpInside];
    [_tjBtn setImage:[UIImage imageNamed:@"tj_ico01"] forState:UIControlStateNormal];
    _tjBtn.imageEdgeInsets =  UIEdgeInsetsMake(5,30,5,_tjBtn.titleLabel.left+40);
    [fotView addSubview:_tjBtn];
    [_tjBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(fotView.mas_left).offset(10);
        make.right.mas_equalTo(fotView.mas_centerX).offset(-2);
        make.top.mas_equalTo(fotView.mas_top).offset(23);
        make.height.mas_equalTo(50);
    }];
    UIView *view2 = [[UIView alloc]init];
    view2.backgroundColor = GetColor(201, 201, 201, 1);
    [fotView addSubview:view2];
    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.top.equalTo(_tjBtn.mas_bottom).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.height.mas_equalTo(1);
    }];
    UIView *view3 = [[UIView alloc]init];
    view3.backgroundColor = [UIColor lightGrayColor];
    [fotView addSubview:view3];
    [view3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_tjBtn.mas_right).offset(2);
        make.top.equalTo(fotView.mas_top).offset(30);
        make.bottom.equalTo(view2.mas_top).offset(-10);
        make.width.offset(1);
    }];
    
    _scBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _scBtn.enabled = _isend;
    [_scBtn setTitle:@"删除" forState:UIControlStateNormal];
    [_scBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_scBtn addTarget:self action:@selector(scaction_button:) forControlEvents:UIControlEventTouchUpInside];
    [_scBtn setImage:[UIImage imageNamed:@"sc_ico01"] forState:UIControlStateNormal];
    _scBtn.imageEdgeInsets =  UIEdgeInsetsMake(5,30,5,_scBtn.titleLabel.left+30);
    [fotView addSubview:_scBtn];
    [_scBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view3.mas_right).offset(2);
        make.right.mas_equalTo(fotView.mas_right).offset(-2);
        make.top.mas_equalTo(fotView.mas_top).offset(23);
        make.height.mas_equalTo(50);
    }];
    
}
-(void)tjaction_button:(UIButton *)bbtn{
    //添加家属
    _nameStr = [[NSString alloc]init];
    _RelationshipStr = [[NSString alloc]init];
    _ageStr = [[NSString alloc]init];
    _ImageStr = [[NSString alloc]init];
    
    NSArray *tjjsary = [[NSArray alloc]init];
    tjjsary = @[@"家属姓名",@"关系",@"年龄",@"照片"];
    [_leftary addObject:tjjsary];
    //_ligary
    NSArray *tjjsary1 = [[NSArray alloc]init];
    tjjsary1 = @[@"填写家属姓名",@"与家属关系",@"年龄"];
     [_ligary addObject:tjjsary1];
    [_bjbtnname addObject:@"添加"];
    [_nameAry addObject:@""];
    [_RelationshipAry addObject:@""];
    [_ageAry addObject:@""];
    [_ImageAry addObject:@""];
    [bbtn setImage:[UIImage imageNamed:@"tj_ico02"] forState:UIControlStateNormal];
    [bbtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    bbtn.enabled = NO;
    
    [_scBtn setImage:[UIImage imageNamed:@"sc_ico02"] forState:UIControlStateNormal];
    [_scBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _scBtn.enabled = NO;
    [self.tableView reloadData];
}
-(void)scaction_button:(UIButton *)bbtn{
    //删除家属
    if ([bbtn.titleLabel.text isEqualToString:@"删除"]) {
         [bbtn setTitle:@"取消删除" forState:UIControlStateNormal];
        [_tjBtn setImage:[UIImage imageNamed:@"tj_ico02"] forState:UIControlStateNormal];
        [_tjBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _tjBtn.enabled = NO;
        for (int i = 0; i<_bjBtnAry.count; i++) {
            _bjbtn = _bjbuttonAry[i];
            NSString *bjbtn = @"删除";
            [_bjbtnname replaceObjectAtIndex:i withObject:bjbtn];
            [_bjbtn setTitle:@"删除" forState:UIControlStateNormal];
        }
    }else{
         [bbtn setTitle:@"删除" forState:UIControlStateNormal];
        [_tjBtn setImage:[UIImage imageNamed:@"tj_ico01"] forState:UIControlStateNormal];
        [_tjBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _tjBtn.enabled = YES;
        for (int i = 0; i<_bjBtnAry.count; i++) {
            _bjbtn = _bjbuttonAry[i];
            NSString *bjbtn = @"编辑";
            [_bjbtnname replaceObjectAtIndex:i withObject:bjbtn];
            [_bjbtn setTitle:@"编辑" forState:UIControlStateNormal];
        }
    }
   
}

-(void)button1BackGroundNormal:(UIButton *)bbtn{
    //编辑家属
    NSLog(@"%ld",bbtn.tag);
    if ([bbtn.titleLabel.text isEqualToString:@"添加"]) {
       
        
        NSLog(@"添加");
        [_bjbtnname replaceObjectAtIndex:bbtn.tag withObject:@"编辑"];
        [bbtn setTitle:@"编辑" forState:UIControlStateNormal];
        
        [self addbossFamily];
        NSLog(@"网络请求--添加家属完成/n---%@/n---%@/n---%@",_bjbuttonAry,_bjBtnAry,_bjbtnname);
        
        
    }else if ([bbtn.titleLabel.text isEqualToString:@"编辑"]){
        NSLog(@"编辑");
        _nameStr = [[NSString alloc]init];
        _RelationshipStr = [[NSString alloc]init];
        _ageStr = [[NSString alloc]init];
        _ImageStr = [[NSString alloc]init];
        
        _nameStr = _nameAry[bbtn.tag];
        _RelationshipStr = _RelationshipAry[bbtn.tag];
        _ageStr = _ageAry[bbtn.tag];
        _logImage = _ImageAry[bbtn.tag];
        _twoimage = [[UIImageView alloc]init];
       [_twoimage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURLImage,_logImage]] placeholderImage:[UIImage  imageNamed:@"hp_ico"]];
      
        
        [_tjBtn setImage:[UIImage imageNamed:@"tj_ico02"] forState:UIControlStateNormal];
        [_tjBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _tjBtn.enabled = NO;
        
        [_scBtn setImage:[UIImage imageNamed:@"sc_ico02"] forState:UIControlStateNormal];
        [_scBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _scBtn.enabled = NO;
        for (int i = 0; i<_bjbuttonAry.count-1; i++) {
            _bjbtn = _bjbuttonAry[i];
            _bjbtn.enabled = NO;
            [_bjbtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }
        NSString *bjbtn = @"完成";
        [_bjbtnname replaceObjectAtIndex:bbtn.tag withObject:bjbtn];
        
        bbtn.enabled = YES;
        [bbtn setTitleColor:GetColor(0, 129, 238, 1) forState:UIControlStateNormal];
        [bbtn setTitle:@"完成" forState:UIControlStateNormal];
         [self.tableView reloadData];
    }else if ([bbtn.titleLabel.text isEqualToString:@"完成"]){
//        NSLog(@"完成");
//        [bbtn setTitle:@"编辑" forState:UIControlStateNormal];
//      [_bjbtnname replaceObjectAtIndex:bbtn.tag withObject:@"编辑"];
//        [_tjBtn setImage:[UIImage imageNamed:@"tj_ico01"] forState:UIControlStateNormal];
//        [_tjBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        _tjBtn.enabled = YES;
//
//        [_scBtn setImage:[UIImage imageNamed:@"sc_ico01"] forState:UIControlStateNormal];
//        [_scBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        _scBtn.enabled = YES;
//         [self.tableView reloadData];
        [self updateFamilienstand: bbtn];
    }else{
        [self updateFamilienstandid:bbtn];
    }
}
-(void)updateFamilienstand:(UIButton *)bbret{
    NSString *uStr =[NSString stringWithFormat:@"%@shop/updateFamilienstand.action",KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic = [[NSDictionary alloc]init];
    dic = @{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS objectForKey:@"userid"],@"StoreBossid":self.bossid,@"id":_BossFLid[bbret.tag],@"RoleId":self.strId,@"Name":_nameAry[bbret.tag],@"Relationship":_RelationshipAry[bbret.tag],@"Age":_ageAry[bbret.tag]};
    NSData *pictureData = UIImagePNGRepresentation(self.twoimage.image);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"image/jpeg",@"image/png",@"image/gif",@"image/tiff",@"application/octet-stream",@"text/json",nil];
    [manager POST:uStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
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
            
            PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"修改成功" sureBtn:@"确认" cancleBtn:nil];
            alertView.resultIndex = ^(NSInteger index){
                [bbret setTitle:@"编辑" forState:UIControlStateNormal];
                [_bjbtnname replaceObjectAtIndex:bbret.tag withObject:@"编辑"];
                [self selectfamilienstand];
                [_tjBtn setImage:[UIImage imageNamed:@"tj_ico01"] forState:UIControlStateNormal];
                [_tjBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                _tjBtn.enabled = YES;
                
                [_scBtn setImage:[UIImage imageNamed:@"sc_ico01"] forState:UIControlStateNormal];
                [_scBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                _scBtn.enabled = YES;
                [self.tableView reloadData];
                
                
            };
            [alertView showMKPAlertView];
            
            
         }else if ([[responseObject valueForKey:@"status"]isEqualToString:@"4444"]) {
            PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"异地登陆,请重新登录" sureBtn:@"确认" cancleBtn:nil];
            alertView.resultIndex = ^(NSInteger index){
                [USER_DEFAULTS  setObject:@"" forKey:@"token"];
                ViewController *loginVC = [[ViewController alloc] init];
                UINavigationController *loginNavC = [[UINavigationController alloc] initWithRootViewController:loginVC];
                [self presentViewController:loginNavC animated:YES completion:nil];
            };
            [alertView showMKPAlertView];
        }else if([[responseObject valueForKey:@"status"]isEqualToString:@"1001"]){
            PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"登录超时,请重新登录" sureBtn:@"确认" cancleBtn:nil];
            alertView.resultIndex = ^(NSInteger index){
                [USER_DEFAULTS  setObject:@"" forKey:@"token"];
                ViewController *loginVC = [[ViewController alloc] init];
                UINavigationController *loginNavC = [[UINavigationController alloc] initWithRootViewController:loginVC];
                [self presentViewController:loginNavC animated:YES completion:nil];
            };
            [alertView showMKPAlertView];
        }
     
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

-(void)updateFamilienstandid:(UIButton*)nntm{
    NSString *uStr =[NSString stringWithFormat:@"%@shop/updateFamilienstandid.action",KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic = [[NSDictionary alloc]init];
    dic = @{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS objectForKey:@"userid"],@"StoreBossid":self.bossid,@"id":_BossFLid[nntm.tag],@"RoleId":self.strId};
    [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
         if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
             PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"删除成功" sureBtn:@"确认" cancleBtn:nil];
             alertView.resultIndex = ^(NSInteger index){
                 [_leftary removeObjectAtIndex:nntm.tag];
                 [_ligary removeObjectAtIndex:nntm.tag];
                 [_bjbtnname removeObjectAtIndex:nntm.tag];
                 [_nameAry removeObjectAtIndex:nntm.tag];
                 [_RelationshipAry removeObjectAtIndex:nntm.tag];
                 [_ageAry removeObjectAtIndex:nntm.tag];
                 [_ImageAry removeObjectAtIndex:nntm.tag];
                 [_bjbuttonAry removeObjectAtIndex:nntm.tag];
                 [_bjBtnAry removeObjectAtIndex:nntm.tag];
                 [self.tableView reloadData];
             };
             [alertView showMKPAlertView];
 
    }else if ([[responseObject valueForKey:@"status"]isEqualToString:@"4444"]) {
        PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"异地登陆,请重新登录" sureBtn:@"确认" cancleBtn:nil];
        alertView.resultIndex = ^(NSInteger index){
            [USER_DEFAULTS  setObject:@"" forKey:@"token"];
            ViewController *loginVC = [[ViewController alloc] init];
            UINavigationController *loginNavC = [[UINavigationController alloc] initWithRootViewController:loginVC];
            [self presentViewController:loginNavC animated:YES completion:nil];
        };
        [alertView showMKPAlertView];
    }else if([[responseObject valueForKey:@"status"]isEqualToString:@"1001"]){
        PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"登录超时,请重新登录" sureBtn:@"确认" cancleBtn:nil];
        alertView.resultIndex = ^(NSInteger index){
            [USER_DEFAULTS  setObject:@"" forKey:@"token"];
            ViewController *loginVC = [[ViewController alloc] init];
            UINavigationController *loginNavC = [[UINavigationController alloc] initWithRootViewController:loginVC];
            [self presentViewController:loginNavC animated:YES completion:nil];
        };
        [alertView showMKPAlertView];
    }
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}
-(void)PersonFieldText:(UITextField*)textfield{
    switch (textfield.tag) {
        case 0:
            _nameStr = textfield.text;
            
            break;
        case 1:
            _RelationshipStr= textfield.text;
            break;
        case 2:
            _ageStr = textfield.text;
            break;
        
        default:
            break;
    }
}
-(void)tapPage3:(UITapGestureRecognizer*)sender
{
    CGPoint point = [sender locationInView:self.tableView];
    NSIndexPath * aasdsa= [self.tableView indexPathForRowAtPoint:point];
    
    if ([_bjbtnname[aasdsa.section] isEqualToString:@"编辑"]) {
        [DongImage showImage:_TXImage];
    }else if ([_bjbtnname[aasdsa.section] isEqualToString:@"删除"]){
        [DongImage showImage:_TXImage];
        
    }else{
        [[ZZYPhotoHelper shareHelper] showImageViewSelcteWithResultBlock:^(id data) {
            _TXImage.image = (UIImage *)data;
            _twoimage.image = (UIImage *)data;
        }];
    }
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
    tlelabel.frame = CGRectMake(10, 10, 110, 30);
    tlelabel.text = _leftary[indexPath.section][indexPath.row];
    tlelabel.font = [UIFont systemFontOfSize:15.0f];
    [cell addSubview:tlelabel];
    if (indexPath.row<3) {
        UITextField *bossname = [[UITextField alloc]initWithFrame:CGRectMake(120, 10, cell.width-120, 30)];
        bossname.placeholder = _ligary[indexPath.section][indexPath.row];
        bossname.font = [UIFont systemFontOfSize:14.0f];
        placeholder(bossname);
        bossname.tag = indexPath.row;
        bossname.delegate = self;
        [bossname addTarget:self action:@selector(PersonFieldText:) forControlEvents:UIControlEventEditingChanged];
       
            switch (indexPath.row) {
                case 0:
                    if ([_nameAry[indexPath.section] isEqualToString:@""]) {
                        
                    }else{
                        bossname.text = _nameAry[indexPath.section];
                    }
                    
                    break;
                case 1:
                    if ([_RelationshipAry[indexPath.section] isEqualToString:@""]) {
                        
                    }else{
                        bossname.text = _RelationshipAry[indexPath.section];
                    }
                    
                    break;
                case 2:
                    if ([_ageAry[indexPath.section] isEqualToString:@"<null>"]) {
                        
                    }else{
                         bossname.text = _ageAry[indexPath.section];
                    }
                   
                    break;
                    
                default:
                    break;
            }
        
        
    if([_bjbtnname[indexPath.section]isEqualToString:@"完成"]||[_bjbtnname[indexPath.section]isEqualToString:@"添加"]){
        
         bossname.enabled = YES;
    }else{
       
         bossname.enabled = NO;
    }
       
        [cell addSubview:bossname];
    }else{
        _TXImage = [[UIImageView alloc]initWithFrame:CGRectMake(120, 15, 50, 50)];
        if (_ImageAry.count>0) {
             _logImage = _ImageAry[indexPath.section];
        }
       
        if (_logImage.length<1) {
            _TXImage.image = [UIImage imageNamed:@"tjtx"];
        }else{
            [_TXImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURLImage,_logImage]] placeholderImage:[UIImage  imageNamed:@"hp_ico"]];
        }
        _TXImage.backgroundColor = [UIColor whiteColor];
       
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPage3:)];
        [_TXImage addGestureRecognizer:tapGesturRecognizer];
        _TXImage.userInteractionEnabled = _isend;
        
        [cell addSubview:_TXImage];
    }
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headV = [[UIView alloc] initWithFrame:CGRectMake(0, 0,Scree_width, 30)];
    headV.backgroundColor = GetColor(238, 238, 238, 1);
    _bjbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _bjbtn.frame =CGRectMake(Scree_width-60,0,50,30);//0 129 238
    
    [_bjbtn setTitle:_bjbtnname[section] forState:UIControlStateNormal];
    
    
    [_bjbtn addTarget:self action:@selector(button1BackGroundNormal:) forControlEvents:UIControlEventTouchUpInside];
    NSString *bjname = @"完成";
    NSString *scbjname = @"添加";
    BOOL ifsc = [_bjbtnname containsObject:scbjname];
    BOOL yesor = [_bjbtnname containsObject: bjname];
    if (yesor == 1) {
        if ([_bjbtn.titleLabel.text isEqualToString:@"完成"]) {
            [_bjbtn setTitleColor:GetColor(0, 129, 238, 1) forState:UIControlStateNormal];
            _bjbtn.enabled = YES;
        }else{
            [_bjbtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            _bjbtn.enabled = NO;
        }
    }else{
        if (ifsc ==1) {
            if([_bjbtn.titleLabel.text isEqualToString:@"添加"]){
                [_bjbtn setTitleColor:GetColor(0, 129, 238, 1) forState:UIControlStateNormal];
                _bjbtn.enabled = YES;
            }else{
                [_bjbtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                _bjbtn.enabled = NO;
            }
            
        }else{
            [_bjbtn setTitleColor:GetColor(0, 129, 238, 1) forState:UIControlStateNormal];
        }
        
    }
    _bjbtn.titleLabel.font = [UIFont boldSystemFontOfSize:kWidth*30];
    _bjbtn.tag = section;
    [headV addSubview:_bjbtn];
   NSString *sttt = [NSString stringWithFormat:@"%ld",section];
    NSLog(@"------()%@",sttt);
    if (_bjBtnAry.count == _leftary.count) {
               [_bjBtnAry replaceObjectAtIndex:section withObject:sttt];
               [_bjbuttonAry replaceObjectAtIndex:section withObject:_bjbtn];
    }else{
        [_bjBtnAry addObject:sttt];
        [_bjbuttonAry addObject:_bjbtn];
    }
    if ([self.shopname isEqualToString:@"1"]) {
        return nil;
    }else{
        return headV;
    }
    
}
-(void)buLiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row ==3){
        return 80;
    }else{
         return 50.0f;
    }
   
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_leftary[section]count];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _leftary.count;
}
- (void)viewDidLayoutSubviews {
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}
-(void)addbossFamily{
    NSString *uStr =[NSString stringWithFormat:@"%@shop/insertFamilienstand.action",KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic = [[NSDictionary alloc]init];
    dic = @{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS objectForKey:@"userid"],@"StoreBossid":self.bossid,@"Name":_nameStr,@"Relationship":_RelationshipStr,@"Age":_ageStr};
    
    NSData *pictureData = UIImagePNGRepresentation(self.TXImage.image);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"image/jpeg",@"image/png",@"image/gif",@"image/tiff",@"application/octet-stream",@"text/json",nil];
    [manager POST:uStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
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
            // [self dismissViewControllerAnimated:YES completion:nil];
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"上传成功" andInterval:1.0];
            [self selectfamilienstand];
            [_tjBtn setImage:[UIImage imageNamed:@"tj_ico01"] forState:UIControlStateNormal];
            [_tjBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            _tjBtn.enabled = YES;
            
            [_scBtn setImage:[UIImage imageNamed:@"sc_ico01"] forState:UIControlStateNormal];
            [_scBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            _scBtn.enabled = YES;
            [self.tableView reloadData];
            
        } else {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"图片上传失败" andInterval:1.0];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)selectfamilienstand{
    NSString *uStr =[NSString stringWithFormat:@"%@shop/selectFamilienstand.action",KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic = [[NSDictionary alloc]init];
    dic = @{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS objectForKey:@"userid"],@"StoreBossid":self.bossid};
    [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
          if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
              NSArray *array=[responseObject valueForKey:@"list"];
              _leftary = [[NSMutableArray alloc]init];
              _ligary= [[NSMutableArray alloc]init];
              _bjbtnname = [[NSMutableArray alloc]init];
              _BossFLid = [[NSMutableArray alloc]init];
               _ImageAry = [[NSMutableArray alloc]init];
              for (NSDictionary *dic in array) {
              [ _ageAry addObject: [NSString stringWithFormat:@"%@",dic[@"age"]]];
              [ _nameAry addObject: [NSString stringWithFormat:@"%@",dic[@"name"]]];
              [ _RelationshipAry addObject: [NSString stringWithFormat:@"%@",dic[@"relationship"]]];
              [ _ImageAry addObject: [NSString stringWithFormat:@"%@",dic[@"photo"]]];
              [ _BossFLid addObject: [NSString stringWithFormat:@"%@",dic[@"id"]]];
                  NSArray *left = [[NSArray alloc]initWithObjects:@"家属姓名",@"关系",@"年龄",@"照片", nil];
                  [_leftary addObject:left];
                  NSArray *liga = [[NSArray alloc]initWithObjects:@"填写家属姓名",@"与家属关系",@"年龄", nil];
                  [_ligary addObject:liga];
                  [_bjbtnname addObject:@"编辑"];
              }
              
             
              [self addViewremind];
              [self.tableView reloadData];
          }else if ([[responseObject valueForKey:@"status"]isEqualToString:@"4444"]) {
              PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"异地登陆,请重新登录" sureBtn:@"确认" cancleBtn:nil];
              alertView.resultIndex = ^(NSInteger index){
                  [USER_DEFAULTS  setObject:@"" forKey:@"token"];
                  ViewController *loginVC = [[ViewController alloc] init];
                  UINavigationController *loginNavC = [[UINavigationController alloc] initWithRootViewController:loginVC];
                  [self presentViewController:loginNavC animated:YES completion:nil];
              };
              [alertView showMKPAlertView];
          }else if([[responseObject valueForKey:@"status"]isEqualToString:@"1001"]){
              PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"登录超时,请重新登录" sureBtn:@"确认" cancleBtn:nil];
              alertView.resultIndex = ^(NSInteger index){
                  [USER_DEFAULTS  setObject:@"" forKey:@"token"];
                  ViewController *loginVC = [[ViewController alloc] init];
                  UINavigationController *loginNavC = [[UINavigationController alloc] initWithRootViewController:loginVC];
                  [self presentViewController:loginNavC animated:YES completion:nil];
              };
              [alertView showMKPAlertView];
          }else if([[responseObject valueForKey:@"status"]isEqualToString:@"5000"]){
              [self Thereisno];
          }
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}
-(void)Thereisno{
    _ThereisnoView = [[UIView alloc]init];
    _ThereisnoView.backgroundColor = [UIColor whiteColor];
    NSString* phoneModel = [UIDevice devicePlatForm];
    
    [self.view addSubview:_ThereisnoView];
    [_ThereisnoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(0);
        make.right.mas_equalTo(self.view.mas_right).offset(0);
        if ([phoneModel isEqualToString:@"iPhone Simulator"]||[phoneModel isEqualToString:@"iPhone X"]) {
            make.top.mas_equalTo(self.view.mas_top).offset(88);
        }else{
             make.top.mas_equalTo(self.view.mas_top).offset(65);
        }
        make.height.mas_offset(80);
    }];
    
   UIButton *  __tjBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [__tjBtn setTitle:@"添加" forState:UIControlStateNormal];
    [__tjBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [__tjBtn addTarget:self action:@selector(__tjBtn_button:) forControlEvents:UIControlEventTouchUpInside];
    [__tjBtn setImage:[UIImage imageNamed:@"tj_ico01"] forState:UIControlStateNormal];
    __tjBtn.imageEdgeInsets =  UIEdgeInsetsMake(5,30,5,_tjBtn.titleLabel.left+40);
    [_ThereisnoView addSubview:__tjBtn];
    [__tjBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_ThereisnoView.mas_left).offset(10);
        make.right.mas_equalTo(_ThereisnoView.mas_right).offset(-10);
        make.top.mas_equalTo(_ThereisnoView.mas_top).offset(23);
        make.height.mas_offset(50);
    }];
    UIView *view1 = [[UIView alloc]init];
    view1.backgroundColor = [UIColor lightGrayColor];
    [_ThereisnoView addSubview:view1];
    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_ThereisnoView.mas_left).offset(0);
        make.right.mas_equalTo(_ThereisnoView.mas_right).offset(0);
        make.top.mas_equalTo(__tjBtn.mas_bottom).offset(0);
        make.height.mas_offset(1);
    }];
}
-(void)__tjBtn_button:(UIButton *)bbtn{
    
    _bjbtnname = [[NSMutableArray alloc]initWithObjects:@"添加", nil];//编辑按钮名字
    _leftary = [[NSMutableArray alloc]initWithObjects:@[@"家属姓名",@"关系",@"年龄",@"照片"], nil];
    _ligary = [[NSMutableArray alloc]initWithObjects:@[@"填写家属姓名",@"与家属关系",@"年龄"], nil];

    [self.view didAddSubview:_ThereisnoView];
    
    [self addViewremind];
    [_tjBtn setImage:[UIImage imageNamed:@"tj_ico02"] forState:UIControlStateNormal];
    [_tjBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _tjBtn.enabled = NO;
    
    [_scBtn setImage:[UIImage imageNamed:@"sc_ico02"] forState:UIControlStateNormal];
    [_scBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _scBtn.enabled = NO;
}

@end
