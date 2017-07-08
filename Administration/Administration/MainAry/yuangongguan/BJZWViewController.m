//
//  BJZWViewController.m
//  Administration
//
//  Created by 九尾狐 on 2017/6/7.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "BJZWViewController.h"
#import "inftionTableViewCell.h"
#import "SelectAlert.h"
@interface BJZWViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *infonTableview;
    NSArray *arr;
    UIView *blockView;
    
    NSMutableArray *titles;
    NSMutableArray *numBS;
    int b;
}
@property (strong,nonatomic)UIButton *ZWbutton;//职位
@property (strong,nonatomic)UIButton *ZWLBbutton;//职位类别
@property (strong,nonatomic)UIView *view1;//线
@property (strong,nonatomic)UIButton *TJBMButton;//添加部门
@property (strong,nonatomic) UILabel *BMLabel;//部门
@property (strong,nonatomic)UIButton *scBtnnnnn;//删除部门按钮
@property (strong,nonatomic) NSMutableArray *scBtnAry;//删除部门按钮数组1
@property (strong,nonatomic) NSMutableArray *scBtnAry2;//删除部门按钮数组2

@property (strong,nonatomic) NSMutableArray *bjBtnAry;//编辑部门按钮数组

@property (strong,nonatomic) NSMutableArray *sctagAry;//编辑部门tag按钮数组
@property (strong,nonatomic) NSMutableArray *sctagAry2;//编辑部门tag按钮数组

@property (strong,nonatomic)UIButton *tjBtn;//添加职位按钮
@property (strong,nonatomic)UIButton *scBtn;//删除职位按钮
@property (strong,nonatomic)UIButton *bjbtn;//编辑职位按钮
@end

@implementation BJZWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"编辑职位";
    b=0;
    [self setExtraCellLineHidden:infonTableview];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buttonLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    NSLog(@"标题: %@\n职位：%@\n职位id：%@\n职位类别：%@\n职位类别id：%@\n部门：%@\n部门id：%@",_codeAry,_ZW,_Numm,_ZWLB,_lbNum,_gxbmAry,_gxbmidAry);
    
    
    [self tableViewUI];
    [self addalloc];
}
-(void)addalloc{
    _scBtnAry = [[NSMutableArray alloc]init];
    _bjBtnAry = [[NSMutableArray alloc]init];
    _scBtnAry2 = [[NSMutableArray alloc]init];
    _sctagAry = [[NSMutableArray alloc]init];
    _sctagAry2 = [[NSMutableArray alloc]init];
    [self ZwNetWork];
}
#pragma mark  请求角色
-(void)ZwNetWork{
    NSString *urlStr = [NSString stringWithFormat:@"%@user/queryUserCreate.action", KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic = [[NSDictionary alloc]init];
    NSString *companyinfoid = [NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *RoleId=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"roleId"]];
    dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"CompanyInfoId":companyinfoid,@"RoleId":RoleId};
    [ZXDNetworking GET:urlStr parameters:dic success:^(id responseObject) {
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"])
        {
            NSArray *arr= [responseObject valueForKey:@"list"];
            titles = [[NSMutableArray alloc]init];
            numBS = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in arr) {
                NSString *strr = [NSString stringWithFormat:@"%@",[dic valueForKey:@"num"]];
                if ([strr isEqualToString:@"1"]) {
                }else{
                    [numBS  addObject:[dic valueForKey:@"num"]];
                    [titles addObject:[dic valueForKey:@"newName"]];
                }
            }
        }else if([[responseObject valueForKey:@"status"]isEqualToString:@"4444"]){
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"非法请求" andInterval:1.0];
        }else if([[responseObject valueForKey:@"status"]isEqualToString:@"1001"]){
            [USER_DEFAULTS  setObject:@"" forKey:@"token"];
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请求超时，请重新登录" andInterval:1.0];
        }else{ 
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"网络超时" andInterval:1.0];
        }
        
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}


#pragma mark 编辑--完成
-(void)button1BackGroundNormal:(UIButton *)btn{
    if ([btn.titleLabel.text isEqualToString:@"编辑"]) {
         [btn setTitle:@"完成" forState:UIControlStateNormal];
        NSSet *set = [NSSet setWithArray:_bjBtnAry];
        
        
        //NSArray * bjset = [set allObjects];
        for (int u = 0; u<set.count; u++) {
            NSString *stt = [NSString stringWithFormat:@"%ld",(long)btn.tag];
            if ([stt isEqualToString: _bjBtnAry[u]]) {
                NSArray *scbtnary = _scBtnAry[u];
                for (int a = 0; a<scbtnary.count; a++) {
                    _scBtnnnnn = scbtnary[a];
                    [_scBtnnnnn setImage:[UIImage imageNamed:@"xx_ico01"] forState:UIControlStateNormal];
                    [_scBtnnnnn setImage:[UIImage imageNamed:@"xx_ico02"] forState:UIControlStateSelected];
                    _scBtnnnnn.enabled = YES;
                }
                [_tjBtn setImage:[UIImage imageNamed:@"tj_ico02"] forState:UIControlStateNormal];
                [_tjBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                _tjBtn.enabled = NO;
                
                [_scBtn setImage:[UIImage imageNamed:@"sc_ico02"] forState:UIControlStateNormal];
                [_scBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                _scBtn.enabled = NO;
            }
        }
        
        
       
        
    }else if([btn.titleLabel.text isEqualToString:@"完成"]){
        [btn setTitle:@"编辑" forState:UIControlStateNormal];
        NSSet *set = [NSSet setWithArray:_bjBtnAry];
       
        for (int u = 0; u<set.count; u++) {
            NSString *stt = [NSString stringWithFormat:@"%ld",(long)btn.tag];
            if ([stt isEqualToString: _bjBtnAry[u]]) {
                NSArray *scbtnary = _scBtnAry[u];
                for (int a = 0; a<scbtnary.count; a++) {
                    _scBtnnnnn = scbtnary[a];
                    [_scBtnnnnn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                    [_scBtnnnnn setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
                    _scBtnnnnn.enabled = YES;
                }
                [_tjBtn setImage:[UIImage imageNamed:@"tj_ico01"] forState:UIControlStateNormal];
                [_tjBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                _tjBtn.enabled = NO;
                
                [_scBtn setImage:[UIImage imageNamed:@"sc_ico01"] forState:UIControlStateNormal];
                [_scBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                _scBtn.enabled = NO;
            }
        }

    }
}
#pragma mark 添加职位
-(void)tjaction_button:(UIButton *)btn{
    NSLog(@"添加职位");
}
#pragma mark 删除职位
-(void)scaction_button:(UIButton *)btn{
    NSLog(@"删除职位");
}
#pragma mark 删除部门
-(void)scbmbtn:(UIButton *)btn{
    NSLog(@"删除部门");
}

#pragma mark 职位按钮
-(void)JsButtonbtn:(UIButton*)btn{
    [self showAlert:titles button:btn];
}
-(void)showAlert :(NSArray *)arrr button:(UIButton*)bbtn{
    
    [SelectAlert showWithTitle:@"选择职位" titles:arrr selectIndex:^(NSInteger selectIndex) {
        NSLog(@"选择了第%ld个",(long)selectIndex);
        NSString *tagg = numBS[selectIndex];
        
        NSMutableArray *isbol = [[NSMutableArray alloc]init];
        for (int i = 0; i<_Numm.count; i++) {
            NSArray *num = _Numm[i];
            BOOL isbool = [num containsObject: tagg];
            if (isbool == 1) {
                [isbol addObject:@"1"];
            }
        }
        BOOL yesor = [isbol containsObject:@"1"];
        if (yesor == 1) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"不能重复选择职位哦" andInterval:1.0];
        }else{
            int taa = [tagg intValue];
            bbtn.tag = taa;
            
        }
        
    } selectValue:^(NSString *selectValue) {
//        for (int i = 0; i<_ZW.count; i++) {
//            NSArray *zwwar = _ZW[i];
//            for (int y = 0; y<zwwar.count; y++) {
//                NSString *zww  =zwwar[y];
//                if ([zww isEqualToString:selectValue]) {
//                [ELNAlerTool showAlertMassgeWithController:self andMessage:@"不能重复选择职位哦" andInterval:1.0];
//                }else{
//                    if ([zww isEqualToString:bbtn.titleLabel.text]) {
//                        [bbtn setTitle:selectValue forState:UIControlStateNormal];
//                        [_ZW[i] insertObject:selectValue atIndex:y];
//                        NSLog(@"%@",bbtn.titleLabel.text);
//                        NSLog(@"%@",_ZW);
//                    }
//
//                }
//            }
//        }
    } showCloseButton:NO];
}
#pragma mark 职位类别按钮
-(void)JsLBButtonbtn:(UIButton*)btn{
    NSLog(@"职位类别按钮");
}
#pragma mark 点击所属部门
-(void)SSButtonbtn:(UIButton*)btn{
  
    NSLog(@"%@%ld",btn.titleLabel.text,(long)btn.tag);
}
#pragma mark cell 点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)indexPath.row);
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   // inftionTableViewCell *cell = [[inftionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bcCell"];
    inftionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bcCell"];
    if (!cell) {
        //cell = [[inftionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bcCell"];
         cell = [[inftionTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"bcCell"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    int tag = 0;
    
    
    if (indexPath.row == 0) {
        cell.textLabel.text = _codeAry[indexPath.section][indexPath.row];
        for(_ZWbutton in cell.subviews){
            if([_ZWbutton isMemberOfClass:[UIButton class]])
            {
                [_ZWbutton removeFromSuperview];
            }
        }
        _ZWbutton = [[UIButton alloc]init];
        _ZWbutton.frame = CGRectMake(120, 1, self.view.bounds.size.width-300, 38);
        [_ZWbutton setTitle:_ZW[indexPath.section][indexPath.row] forState:UIControlStateNormal];
        _ZWbutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _ZWbutton.font = [UIFont boldSystemFontOfSize:kWidth*30];
        [_ZWbutton addTarget:self action:@selector(JsButtonbtn:) forControlEvents:UIControlEventTouchUpInside];
        [_ZWbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        NSString*zwtag = _Numm[indexPath.section][indexPath.row];
        tag = [zwtag intValue];
        _ZWbutton.tag = tag;
        [cell addSubview:_ZWbutton];
        
        _view1 = [[UIView alloc]init];
        _view1.frame = CGRectMake(self.view.bounds.size.width/2+30, 6, 1, 30);
        
        _ZWLBbutton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/2+31, 1, self.view.bounds.size.width-(self.view.bounds.size.width/2+31), 38)];
        _ZWLBbutton.font = [UIFont boldSystemFontOfSize:kWidth*30];
        
        [_ZWLBbutton addTarget:self action:@selector(JsLBButtonbtn:) forControlEvents:UIControlEventTouchUpInside];
        if (tag ==2||tag ==5) {
            [_ZWLBbutton setTitleColor:GetColor(199, 199, 205, 1) forState:UIControlStateNormal];
            _view1.backgroundColor = [UIColor lightGrayColor];
            [_ZWLBbutton setTitle:_ZWLB[indexPath.section][indexPath.row] forState:UIControlStateNormal];
            _ZWLBbutton.enabled = YES;
        }else{
            [_ZWLBbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _view1.backgroundColor = [UIColor whiteColor];
            _ZWLBbutton.enabled = NO;
        }
        
        [cell addSubview:_view1];
        [cell addSubview:_ZWLBbutton];
    }else if(indexPath.row ==1){
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;//右箭头
        cell.textLabel.text = _codeAry[indexPath.section][indexPath.row];
        NSString*zwtag = _Numm[indexPath.section][0];
        tag = [zwtag intValue];
        
            UIButton *SSBMbutt = [[UIButton alloc]init];
            SSBMbutt.frame = CGRectMake(120, 1, self.view.bounds.size.width-100, 38);
            if (tag == 2|| tag == 5) {
                [SSBMbutt setTitle:@"添加所属部门" forState:UIControlStateNormal];
            }else{
                [SSBMbutt setTitle:@"添加管辖部门" forState:UIControlStateNormal];
            }
            SSBMbutt.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            SSBMbutt.font = [UIFont boldSystemFontOfSize:kWidth*30];
            [SSBMbutt addTarget:self action:@selector(SSButtonbtn:) forControlEvents:UIControlEventTouchUpInside];
            [SSBMbutt setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            //NSInteger section  = indexPath.section;
             SSBMbutt.tag= indexPath.section;
            [cell addSubview:SSBMbutt];
        
        
    }else{
        UILabel *XBTLabel  = [[UILabel alloc]initWithFrame:CGRectMake(120, 1, self.view.bounds.size.width-160, 38)];
        //NSLog(@"%@",_gxbmAry[indexPath.section][indexPath.row-2]);
        XBTLabel.text = _gxbmAry[indexPath.section][indexPath.row-2];
        XBTLabel.font = [UIFont boldSystemFontOfSize:kWidth*30];
        [cell addSubview:XBTLabel];
        
        _scBtnnnnn= [[UIButton alloc]initWithFrame:CGRectMake(120+self.view.bounds.size.width-160, 1, 40, 38)];
        [cell addSubview:_scBtnnnnn];
        [_scBtnnnnn addTarget:self action:@selector(scbmbtn:) forControlEvents:UIControlEventTouchUpInside];
        _scBtnnnnn.enabled = NO;
        NSString*zwtag = _Numm[indexPath.section][0];
        NSArray *bmary = _gxbmAry[indexPath.section];
        tag = [zwtag intValue];
        
        NSArray *sxtag = [[NSArray alloc]init];
        sxtag = _gxbmidAry[indexPath.section];
        NSInteger row = indexPath.row-2;
        NSInteger section  = indexPath.section;
        NSString *uu= [NSString stringWithFormat:@"%ld%ld",(long)section,(long)row];
       
        NSLog(@"%@",uu);
        int taa = [uu intValue ];
        _scBtnnnnn.tag = taa;
       
        
        if (tag == 2|| tag == 5) {
             NSArray *ssbm = [[NSArray alloc]initWithObjects:_scBtnnnnn, nil];
            NSArray *tagary = [[NSArray alloc]initWithObjects:uu, nil];
            if (_scBtnAry.count == _gxbmAry.count) {
                for (int e= 0; e<_sctagAry.count; e++) {
                    NSArray *taf = _sctagAry[e];
                    for (int w = 0 ; w<taf.count; w++) {
                        if ([uu isEqualToString:taf[w]]) {
                            [_scBtnAry replaceObjectAtIndex:e withObject:ssbm];
                            _scBtnAry2 = [[NSMutableArray alloc]init];
                            _sctagAry2 = [[NSMutableArray alloc]init];
                        }
                    }
                }
            }else{
                _scBtnAry2 = [[NSMutableArray alloc]init];
                _sctagAry2 = [[NSMutableArray alloc]init];
                [_sctagAry addObject:tagary];
                [_scBtnAry addObject:ssbm];
                
            }
        }else{
            [_scBtnAry2 addObject:_scBtnnnnn];
            [_sctagAry2 addObject:uu];
            if (bmary.count ==_scBtnAry2.count){
                if (_scBtnAry.count == _gxbmAry.count) {
                    for (int e= 0; e<_sctagAry.count; e++) {
                        NSArray *taf = _sctagAry[e];
                        for (int w = 0 ; w<taf.count; w++) {
                            if ([uu isEqualToString:taf[w]]) {
                                [_scBtnAry replaceObjectAtIndex:e withObject:_scBtnAry2];
                                _scBtnAry2 = [[NSMutableArray alloc]init];
                                _sctagAry2 = [[NSMutableArray alloc]init];
                            }
                        }
                    }

                }else{
                    [_scBtnAry addObject:_scBtnAry2];
                    [_sctagAry addObject:_sctagAry2];
                     _scBtnAry2 = [[NSMutableArray alloc]init];
                     _sctagAry2 = [[NSMutableArray alloc]init];
                }
            }
        }

        NSLog(@"%@",_scBtnAry);
    }
    
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
        UIView *headV = [[UIView alloc] initWithFrame:CGRectMake(0, 0,Scree_width, 30)];
        headV.backgroundColor = GetColor(238, 238, 238, 1);
        UIButton *bjbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        bjbtn.frame =CGRectMake(Scree_width-60,0,50,30);//0 129 238
        [bjbtn setTitle:@"编辑" forState:UIControlStateNormal];
        [bjbtn addTarget:self action:@selector(button1BackGroundNormal:) forControlEvents:UIControlEventTouchUpInside];
        [bjbtn setTitleColor:GetColor(0, 129, 238, 1) forState:UIControlStateNormal];
        bjbtn.font = [UIFont boldSystemFontOfSize:kWidth*30];
        bjbtn.tag = section;
        [headV addSubview:bjbtn];
        NSString *sttt = [NSString stringWithFormat:@"%ld",(long)bjbtn.tag];
        [_bjBtnAry addObject:sttt];
        return headV;
       
}
#pragma mark UI
-(void)tableViewUI{
   
    infonTableview= [[UITableView alloc]initWithFrame:CGRectMake(0,0,self.view.bounds.size.width,self.view.bounds.size.height+50) style:UITableViewStyleGrouped];
    infonTableview.dataSource=self;
    infonTableview.delegate =self;
    [self.view addSubview:infonTableview];
    
    
    UIView *view1 = [[UIView alloc]init];
    view1.backgroundColor = GetColor(201, 201, 201, 1);
    [infonTableview addSubview:view1];
    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.bottom.equalTo(infonTableview.mas_top).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.height.mas_equalTo(1);
    }];
    
    UIView *fotView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Scree_width, 80)];
    fotView.backgroundColor = [UIColor whiteColor];
    infonTableview.tableFooterView=fotView;
    
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
    [_tjBtn setTitle:@"添加职位" forState:UIControlStateNormal];
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
    [_scBtn setTitle:@"删除职位" forState:UIControlStateNormal];
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

-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return _ZW.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 2+[_gxbmAry[section]count];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
     return 0.001;//不能为0，否则为默认高度
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0;
}

-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}
-(void)buttonLiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 补全分隔线左侧缺失
- (void)viewDidLayoutSubviews {
    if ([infonTableview respondsToSelector:@selector(setSeparatorInset:)]) {
        [infonTableview setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([infonTableview respondsToSelector:@selector(setLayoutMargins:)])  {
        [infonTableview setLayoutMargins:UIEdgeInsetsZero];
    }
    
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
