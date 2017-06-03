//
//  SetPosiViewController.m
//  Administration
//
//  Created by 九尾狐 on 2017/4/22.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "SetPosiViewController.h"
#import "SetModel.h"
#import "Attachment.h"
#import "ButtonView.h"
#define  isEq(one) one.image isEqual:[UIImage imageNamed:@"xz_ico1"]
NSUInteger rw;
NSUInteger rsw;



@interface SetPosiViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *infonTableview;
    BOOL YWZJBOOL;//业务总监
    BOOL SCZJBOOL;//市场总监
    BOOL YWJLBOOL;//业务经理
    BOOL SCJLBOOL;//市场经理
    BOOL YWBOOL;//业务
    BOOL MDBOOL;//美导
    BOOL XZGLBOOL;//行政管理
    BOOL WLBOOL;//物流
    BOOL CWZJBOOL;//财务总监
    BOOL KFJLBOOL;//客服经理
    BOOL WLJLBOOL;//物流经理
    BOOL CWJLBOOL;//财务经理
    BOOL KFBOOL;//客服
    BOOL CKBOOL;//仓库
    BOOL KJBOOL;//会计
    BOOL CNBOOL;//出纳
    
}
@property (strong,nonatomic) UITableViewCell *cell;
@property (strong,nonatomic) ButtonView *button;
@property (strong,nonatomic) UILabel  *asklLabel;
@property (strong,nonatomic) UITextField *xgtextFie;

@property (strong,nonatomic) NSMutableArray *imageAry;//对勾数组

@property (strong,nonatomic) NSMutableArray *XZZWArry;//选中的职位
@property (strong,nonatomic) NSMutableArray *XGXZZWArry;//修改后的选中职位
@property (strong,nonatomic) NSMutableArray *ZWNumAry;//选中职位的id

@property (strong,nonatomic) NSMutableArray *lqzwnameAry;
@property (strong,nonatomic) NSMutableArray *lqzwnumAry;

@property (strong,nonatomic) UIView *asdjklView;// 遮挡层
//修改的职位名称
@property (strong,nonatomic) NSString *XGZJLStr;//总经理
@property (strong,nonatomic) NSString *YWZJStr;//业务总监
@property (strong,nonatomic) NSString *YWJLStr;//业务经理
@property (strong,nonatomic) NSString *YWStr;//业务
@property (strong,nonatomic) NSString *SCZJStr;//市场总监
@property (strong,nonatomic) NSString *SCJLStr;//市场经理
@property (strong,nonatomic) NSString *MDStr;//美导
@property (strong,nonatomic) NSString *XZGLLStr;//行政管理
@property (strong,nonatomic) NSString *WLStr;//物流
@property (strong,nonatomic) NSString *CKStr;//仓库

@property (strong,nonatomic) NSString *CWZJStr;//财务总监
@property (strong,nonatomic) NSString *KFJLStr;//客服经理
@property (strong,nonatomic) NSString *WLJLStr;//物流经理
@property (strong,nonatomic) NSString *CWJLStr;//财务经理
@property (strong,nonatomic) NSString *KFStr;//客服
@property (strong,nonatomic) NSString *KJStr;//会计
@property (strong,nonatomic) NSString *CNStr;//出纳


@property (strong,nonatomic)UIView* footerView;
@property (strong,nonatomic) UIView *popFootCellView;
@property (strong,nonatomic) UIButton *footerButton;


@property (strong,nonatomic) NSMutableArray*ywmdAry;



@property (strong,nonatomic) NSMutableArray* kfwlcwAry;

@property (strong,nonatomic) NSMutableArray *buttonAry;



@end

@implementation SetPosiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    YWZJBOOL  = YES;
    SCZJBOOL    = YES;
    YWJLBOOL    = YES;
    SCJLBOOL    = YES;
    YWBOOL  = YES;
    MDBOOL  = YES;
    XZGLBOOL    = YES;
    WLBOOL  = YES;
    CWZJBOOL    = YES;
    KFJLBOOL    = YES;
    WLJLBOOL    = YES;
    CWJLBOOL    = YES;
    KFBOOL  = YES;
    CKBOOL  = YES;
    KJBOOL  = YES;
    CNBOOL  = YES;
    
    
    
    self.title=@"职位结构";
    self.view.backgroundColor = [UIColor whiteColor];
    _XZZWArry = [[NSMutableArray alloc]init];
    _XGXZZWArry = [[NSMutableArray alloc]init];
    _ZWNumAry = [[NSMutableArray alloc]init];
    _lqzwnameAry = [[NSMutableArray alloc]init];
    _lqzwnumAry = [[NSMutableArray alloc]init];
    _ywmdAry = [[NSMutableArray alloc]init];
    _kfwlcwAry = [[NSMutableArray alloc]init];
    _buttonAry = [[NSMutableArray alloc]init];
    
    [_XZZWArry addObject:@"总经理"];
    [_ZWNumAry addObject:@"1"];
    _XGZJLStr = @"总经理";
    _YWJLStr = @"业务经理";
    _YWZJStr = @"业务总监";
    _YWStr = @"业务";
    _SCZJStr = @"市场总监";
    _SCJLStr = @"市场经理";
    _MDStr = @"美导";
    _XZGLLStr = @"行政管理";
    _WLStr = @"物流";
    _CKStr = @"仓库";
    _CWZJStr = @"财务总监";//财务总监
    _KFJLStr = @"客服经理";//客服经理
    _WLJLStr = @"物流经理";//物流经理
    _CWJLStr = @"财务经理";//财务经理
    _KFStr = @"客服";//客服
    _KJStr = @"会计";//会计
    _CNStr = @"出纳";//出纳
    
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]
                                    initWithTitle:@"完成"
                                    style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(masgegeClick)];
    rightButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buttonLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;

    [self ui];
    // Do any additional setup after loading the view.
}
-(void)buttonLiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)masgegeClick{
    [self xgzwmcAryadd];
    NSMutableArray *arr=[NSMutableArray array];
    for (int i =0; _ZWNumAry.count>i; i++) {
        NSMutableDictionary *dic =[NSMutableDictionary dictionary];
        [dic setValue:_ZWNumAry[i] forKey:@"Num"];
        [dic setValue:_XGXZZWArry[i] forKey:@"NewName"];
        [arr addObject:dic];
    }
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonStr=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *urlStr = [NSString stringWithFormat:@"%@manager/updatePositon.action", KURLHeader];
    NSString *companyinfoid = [NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic = [[NSDictionary alloc]init];
    dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"CompanyInfoId":companyinfoid,@"names":jsonStr};
    [ZXDNetworking GET:urlStr parameters:dic success:^(id responseObject) {
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"创建成功" andInterval:1.0];
        } else if ([[responseObject valueForKey:@"status"] isEqualToString:@"1111"]){
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"数据异常，操作失败" andInterval:1.0];
        }else {
            PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"登陆超时请重新登录" sureBtn:@"确认" cancleBtn:nil];
            
            alertView.resultIndex = ^(NSInteger index){
                ViewController *loginVC = [[ViewController alloc] init];
                UINavigationController *loginNavC = [[UINavigationController alloc] initWithRootViewController:loginVC];
                [self presentViewController:loginNavC animated:YES completion:nil];
            };
            [alertView showMKPAlertView];
            
        }
        
        
        
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
    

}
-(void)xgzwmcAryadd{
    
    [_XGXZZWArry removeAllObjects];
    [_ZWNumAry removeAllObjects];
    [_XGXZZWArry addObject:_XGZJLStr];
    [_ZWNumAry addObject:@"1"];
    if (YWZJBOOL == NO) {
        [_XGXZZWArry addObject:_YWZJStr];
        [_ZWNumAry addObject:@"9"];
    }
    if (SCZJBOOL == NO) {
        [_XGXZZWArry addObject:_SCZJStr];
        [_ZWNumAry addObject:@"10"];
    }
    if (YWJLBOOL == NO ) {
        [_XGXZZWArry addObject:_YWJLStr];
        [_ZWNumAry addObject:@"8"];
        [_XGXZZWArry addObject:_YWStr];
        [_ZWNumAry addObject:@"5"];
    }
    if (SCJLBOOL == NO ) {
        [_XGXZZWArry addObject:_SCJLStr];
        [_ZWNumAry addObject:@"6"];
        [_XGXZZWArry addObject:_MDStr];
        [_ZWNumAry addObject:@"2"];
    }if (XZGLBOOL == NO) {
        [_XGXZZWArry addObject:_XZGLLStr];
        [_ZWNumAry addObject:@"7"];
    }if (WLBOOL == NO) {
        [_XGXZZWArry addObject:_WLStr];
        [_ZWNumAry addObject:@"4"];
    }if (KFBOOL == NO) {
        [_XGXZZWArry addObject:_KFStr];
        [_ZWNumAry addObject:@"3"];
    }if (CWZJBOOL==NO) {
        [_XGXZZWArry addObject:_CWZJStr];
        [_ZWNumAry addObject:@"11"];
    }if (KFJLBOOL==NO) {
        [_XGXZZWArry addObject:_KFJLStr];
        [_ZWNumAry addObject:@"12"];
    }if (WLJLBOOL==NO) {
        [_XGXZZWArry addObject:_WLJLStr];
        [_ZWNumAry addObject:@"13"];
    }if (CKBOOL==NO) {
        [_XGXZZWArry addObject:_CKStr];
        [_ZWNumAry addObject:@"14"];
    }if (CWJLBOOL==NO) {
        [_XGXZZWArry addObject:_CWJLStr];
        [_ZWNumAry addObject:@"15"];
    }if (KJBOOL==NO) {
        [_XGXZZWArry addObject:_KJStr];
        [_ZWNumAry addObject:@"16"];
    }if (CNBOOL==NO) {
        [_XGXZZWArry addObject:_CNStr];
        [_ZWNumAry addObject:@"17"];
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    static NSString *CellIdentifier =@"Cell";
    //定义cell的复用性当处理大量数据时减少内存开销
    _cell = [infonTableview  dequeueReusableCellWithIdentifier:CellIdentifier];
    UILabel *asdklLabel = nil;
    _cell.tag = [indexPath row];
    if (_cell ==nil)
    {
        _cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:CellIdentifier];
        _cell.textLabel.text = @"您选择的职位";
        _cell.textLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        _cell.textLabel.textColor = GetColor(117, 117, 117, 1);
    }
    for(_asklLabel in _cell.subviews){
        if([_asklLabel isMemberOfClass:[UILabel class]])
        {
            [_asklLabel removeFromSuperview];
        }
    }
    _asklLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 1, 80, 28)];
    _asklLabel.text = _XZZWArry[indexPath.row];
    _asklLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    _asklLabel.textAlignment = NSTextAlignmentCenter;
    _asklLabel.textColor = [UIColor orangeColor];
    [_asklLabel.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
    [_asklLabel.layer setCornerRadius:3];
    [_asklLabel.layer setBorderWidth:1];//设置边界的宽度
    [_asklLabel.layer setBorderColor:([UIColor lightGrayColor].CGColor)];
    [_cell addSubview:_asklLabel];
    
    asdklLabel = [[UILabel alloc]initWithFrame:CGRectMake(190, 1, 40, 28)];
    asdklLabel.text = @"修改为";
    asdklLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    asdklLabel.textColor = GetColor(117, 117, 117, 1);
    [_cell addSubview:asdklLabel];
    
    for(_xgtextFie in _cell.subviews){
        if([_xgtextFie isKindOfClass:[UITextField class]])
        {
            [_xgtextFie removeFromSuperview];
        }
    }
    _xgtextFie = [[UITextField alloc]initWithFrame:CGRectMake(240, 1, self.view.bounds.size.width-242, 28)];
    _xgtextFie.textColor = [UIColor orangeColor];
    
    if (_lqzwnameAry.count>0) {
        if (_lqzwnumAry.count == _XZZWArry.count) {
            _xgtextFie.text = _lqzwnameAry[indexPath.row];
        }
    }
    _xgtextFie.placeholder =_XZZWArry[indexPath.row];
        placeholder(self.xgtextFie);
    _xgtextFie.font = [UIFont boldSystemFontOfSize:13.0f];
    [_xgtextFie.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
    [_xgtextFie.layer setCornerRadius:3];
    [_xgtextFie.layer setBorderWidth:1];//设置边界的宽度
    [_xgtextFie.layer setBorderColor:([UIColor lightGrayColor].CGColor)];
    _xgtextFie.tag = row;
    [_xgtextFie addTarget:self action:@selector(idNoFieldText:) forControlEvents:UIControlEventEditingChanged];
    [_cell addSubview:_xgtextFie];
    
    
    return _cell;
}

-(void)idNofield:(UITextField *)fieldtext{
    if ([fieldtext.placeholder isEqualToString:@"业务经理"]) {
        if (fieldtext.text.length>0) {
            _YWJLStr = fieldtext.text;
        }else{
            _YWJLStr = @"业务经理";
        }
    }else if ([fieldtext.placeholder isEqualToString:@"业务总监"]){
        if (fieldtext.text.length>0) {
            _YWZJStr = fieldtext.text;
        }else{
            _YWZJStr = @"业务总监";
        }
    }else if ([fieldtext.placeholder isEqualToString:@"业务"]){
        if (fieldtext.text.length>0) {
            _YWStr = fieldtext.text;
        }else{
            _YWStr = @"业务";
        }
    }else if ([fieldtext.placeholder isEqualToString:@"市场总监"]){
        if (fieldtext.text.length>0) {
            _SCZJStr = fieldtext.text;
        }else{
            _SCZJStr = @"市场总监";
        }
    }
    else if ([fieldtext.placeholder isEqualToString:@"市场经理"]){
        if (fieldtext.text.length>0) {
            _SCJLStr = fieldtext.text;
        }else{
            _SCJLStr = @"市场经理";
        }
    }
    else if ([fieldtext.placeholder isEqualToString:@"美导"]){
        if (fieldtext.text.length>0) {
            _MDStr = fieldtext.text;
        }else{
            _MDStr = @"美导";
        }
    }else if ([fieldtext.placeholder isEqualToString:@"行政管理"]){
        if (fieldtext.text.length>0) {
            _XZGLLStr = fieldtext.text;
        }else{
            _XZGLLStr = @"行政管理";
        }
    }else if ([fieldtext.placeholder isEqualToString:@"物流"]){
        if (fieldtext.text.length>0) {
            _WLStr = fieldtext.text;
        }else{
            _WLStr = @"物流";
        }
    }
    else if ([fieldtext.placeholder isEqualToString:@"仓库"]){
        if (fieldtext.text.length>0) {
            _CKStr = fieldtext.text;
        }else{
            _CKStr = @"仓库";
        }
    }else if ([fieldtext.placeholder isEqualToString:@"财务总监"]){
        if (fieldtext.text.length>0) {
            _CWZJStr = fieldtext.text;
        }else{
            _CWZJStr = @"财务总监";
        }
    }else if ([fieldtext.placeholder isEqualToString:@"客服经理"]){
        if (fieldtext.text.length>0) {
            _KFJLStr = fieldtext.text;
        }else{
            _KFJLStr = @"客服经理";
        }
    }else if ([fieldtext.placeholder isEqualToString:@"物流经理"]){
        if (fieldtext.text.length>0) {
            _WLJLStr = fieldtext.text;
        }else{
            _WLJLStr = @"物流经理";
        }
    }else if ([fieldtext.placeholder isEqualToString:@"财务经理"]){
        if (fieldtext.text.length>0) {
            _CWJLStr = fieldtext.text;
        }else{
            _CWJLStr = @"财务经理";
        }
    }else if ([fieldtext.placeholder isEqualToString:@"客服"]){
        if (fieldtext.text.length>0) {
            _KFStr = fieldtext.text;
        }else{
            _KFStr = @"客服";
        }
    }else if ([fieldtext.placeholder isEqualToString:@"会计"]){
        if (fieldtext.text.length>0) {
            _KJStr = fieldtext.text;
        }else{
            _KJStr = @"会计";
        }
    }else if ([fieldtext.placeholder isEqualToString:@"出纳"]){
        if (fieldtext.text.length>0) {
            _CNStr = fieldtext.text;
        }else{
            _CNStr = @"出纳";
        }
    }


}
-(void)idNoFieldText:(UITextField *)textField{
    switch (textField.tag) {
        case 0:
            if (textField.text.length==0) {
                _XGZJLStr = @"总经理";
            }else{
                _XGZJLStr = textField.text;
            }
            break;
        case 1:
            [self idNofield:textField];
            break;
        case 2:
            [self idNofield:textField];
            break;
        case 3:
            [self idNofield:textField];
            break;
        case 4:
            [self idNofield:textField];
            break;
        case 5:
            [self idNofield:textField];
            break;
        case 6:
            [self idNofield:textField];
            break;
        case 7:
            [self idNofield:textField];
            break;
        case 8:
            [self idNofield:textField];
            break;
        case 9:
            [self idNofield:textField];
            break;
        case 10:
            [self idNofield:textField];
            break;
        case 11:
            [self idNofield:textField];
            break;
        case 12:
            [self idNofield:textField];
            break;
        case 13:
            [self idNofield:textField];
            break;
        case 14:
            [self idNofield:textField];
            break;
        case 15:
            [self idNofield:textField];
            break;
        case 16:
            [self idNofield:textField];
            break;
        case 17:
            [self idNofield:textField];
            break;
        
        default:
            break;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _XZZWArry.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 20;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
-(void)addtableViewCellZWUI{
    
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rw inSection:0];
    [indexPaths addObject: indexPath];
    [infonTableview beginUpdates];
    [infonTableview insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationLeft];
    [infonTableview endUpdates];
    
}

-(void)dimissTabelCellZWUI{
    NSArray *_tempIndexPathArr = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:rsw inSection:0]];
    [infonTableview beginUpdates];
    [infonTableview deleteRowsAtIndexPaths:_tempIndexPathArr withRowAnimation:UITableViewRowAnimationFade];
    [infonTableview endUpdates];
}
-(void)ui{
     _imageAry = [[NSMutableArray  alloc]init];
    infonTableview= [[UITableView alloc]init];
    infonTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    infonTableview.dataSource=self;
    infonTableview.delegate =self;
    [self.view addSubview:infonTableview];
    [infonTableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(0);
        make.left.mas_equalTo(self.view.mas_left).offset(0);
        make.right.mas_equalTo(self.view.mas_right).offset(0);
        make.bottom.mas_equalTo(self.view.bottom).offset(0);
    }];
   UIView* topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Scree_width, kHeight*770)];
    topView.backgroundColor = [UIColor whiteColor];
    infonTableview.tableHeaderView=topView;
    
   _footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Scree_width, kHeight*970)];
    _footerView.backgroundColor = [UIColor whiteColor];
    infonTableview.tableFooterView=_footerView;
    
   _footerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _footerButton.layer.cornerRadius = 5;
    [_footerButton setTitle:@"预览" forState:UIControlStateNormal];
    [_footerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _footerButton.titleLabel.font =[UIFont systemFontOfSize: 14.0];
    [_footerButton.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
    [_footerButton.layer setCornerRadius:3];
    [_footerButton.layer setBorderWidth:1];//设置边界的宽度
    [_footerButton.layer setBorderColor:([UIColor lightGrayColor].CGColor)];
    [_footerButton addTarget:self action:@selector(footerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_footerView addSubview:_footerButton];
    [_footerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_footerView.mas_top).offset(40);
        make.centerX.mas_equalTo(_footerView.mas_centerX).offset(0);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(kWidth*200);
    }];
    UILabel *gouxuanLabel = [[UILabel alloc]init];
    gouxuanLabel.frame = CGRectMake(kHeight*20, kHeight*20, Scree_width, kHeight*40);
    gouxuanLabel.text = @"请勾选您公司的职位";
    gouxuanLabel.font = [UIFont systemFontOfSize:kWidth*30];
    gouxuanLabel.textColor = [UIColor lightGrayColor];
    [topView addSubview:gouxuanLabel];
    
    
    UILabel *zjlLabel = [[UILabel alloc]init];
    zjlLabel.frame = CGRectMake((Scree_width/2)-(kWidth*45)/2, kHeight*60, kWidth*45, kHeight*120);
    zjlLabel.text = @"总经理";
    zjlLabel.font = [UIFont systemFontOfSize:kHeight*25];
    zjlLabel.textColor = [UIColor blackColor];
    zjlLabel.numberOfLines = 0;
    zjlLabel.textAlignment = NSTextAlignmentCenter;
    [zjlLabel.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
    [zjlLabel.layer setCornerRadius:2];
    [zjlLabel.layer setBorderWidth:1];//设置边界的宽度
    [zjlLabel.layer setBorderColor:([UIColor orangeColor].CGColor)];
    [topView addSubview:zjlLabel];


    NSArray *oneAry= [[NSArray alloc]initWithObjects:@"9",@"10",@"11",@"7", nil];
    NSArray *oneLabelAry = [[NSArray alloc]initWithObjects:@"业务总监",@"市场总监",@"财务总监",@"行政管理", nil];
    
    Attachment*attView = [[Attachment alloc]initWithFrame:CGRectMake((Scree_width/2)-(Scree_width-kWidth*160)/2, zjlLabel.bottom, Scree_width-kWidth*160, kHeight*25) ];
    [topView addSubview:attView];
    for (int i = 0; i<oneAry.count; i++) {
        NSString *str = [[NSString alloc]init];
        str = oneAry[i];
        int tagi = [str intValue];
        if (i == 1) {
            _button = [[ButtonView alloc]initWithFrame:CGRectMake((Scree_width/2)-(Scree_width-kWidth*160)/2+(Scree_width-kWidth*160)/3*i-(kWidth*45)/2-kWidth*70, attView.bottom, kWidth*45, kHeight*170) height:kHeight*30];
        }else{
        _button = [[ButtonView alloc]initWithFrame:CGRectMake((Scree_width/2)-(Scree_width-kWidth*160)/2+(Scree_width-kWidth*160)/3*i-(kWidth*45)/2, attView.bottom, kWidth*45, kHeight*170) height:kHeight*30 ];
        }
         [_button.ZWbutton addTarget:self action:@selector(qdbtnClick:)forControlEvents:UIControlEventTouchUpInside];
        [_button.ZWbutton setTitle:oneLabelAry[i] forState:UIControlStateNormal];
        _button.ZWbutton.tag = tagi;
        [_imageAry addObject:_button.ZWimage];
        [_buttonAry addObject:_button.ZWbutton];
        [topView addSubview:_button];
    }


    NSArray *twoary = [[NSArray alloc]initWithObjects:@"8",@"6", nil];
    NSArray*twoLabelAry =[[NSArray alloc]initWithObjects:@"业务经理",@"市场经理", nil];
    
    for (int j = 0; j<twoary.count; j++) {
        NSString *str = [[NSString alloc]init];
        str = twoary[j];
        int tagi = [str intValue];
        if (j == 1) {
            _button = [[ButtonView alloc]initWithFrame:CGRectMake((Scree_width/2)-(Scree_width-kWidth*160)/2+(Scree_width-kWidth*160)/3*j-(kWidth*45)/2-kWidth*70, attView.bottom+kHeight*170, kWidth*45, kHeight*210) height:kHeight*70];
        }else{
        _button = [[ButtonView alloc]initWithFrame:CGRectMake((Scree_width/2)-(Scree_width-kWidth*160)/2+(Scree_width-kWidth*160)/3*j-(kWidth*45)/2, attView.bottom+kHeight*170, kWidth*45, kHeight*210) height:kHeight*70 ];
        }
        [_button.ZWbutton setTitle:twoLabelAry[j] forState:UIControlStateNormal];
         [_button.ZWbutton addTarget:self action:@selector(qdbtnClick:)forControlEvents:UIControlEventTouchUpInside];
        _button.ZWbutton.tag = tagi;
        [_imageAry addObject:_button.ZWimage];
        [_ywmdAry addObject:_button.ZWbutton];
        [_buttonAry addObject:_button.ZWbutton];
        [topView addSubview:_button];
    }

    NSArray *leftthreeAry =[[NSArray alloc]initWithObjects:@"5",@"2", nil];
    NSArray *leftthteeLalelAry = [[NSArray alloc]initWithObjects:@"业务",@"美导", nil];
    for (int k = 0 ; k<leftthreeAry.count; k++) {
        NSString *str = [[NSString alloc]init];
        str = leftthreeAry[k];
        int tagi = [str intValue];
        if (k == 1) {
            _button = [[ButtonView alloc]initWithFrame:CGRectMake((Scree_width/2)-(Scree_width-kWidth*160)/2+(Scree_width-kWidth*160)/3*k-(kWidth*45)/2-kWidth*70, attView.bottom+kHeight*170+kHeight*210, kWidth*45, kHeight*180) height:kHeight*70];
        }else{
            _button = [[ButtonView alloc]initWithFrame:CGRectMake((Scree_width/2)-(Scree_width-kWidth*160)/2+(Scree_width-kWidth*160)/3*k-(kWidth*45)/2, attView.bottom+kHeight*170+kHeight*210, kWidth*45, kHeight*180) height:kHeight*70 ];
        }
        [_button.ZWbutton setTitle:leftthteeLalelAry[k] forState:UIControlStateNormal];
         [_button.ZWbutton addTarget:self action:@selector(qdbtnClick:)forControlEvents:UIControlEventTouchUpInside];
        _button.ZWbutton.tag = tagi;
        [_imageAry addObject:_button.ZWimage];
        [_ywmdAry addObject:_button.ZWbutton];
        [_buttonAry addObject:_button.ZWbutton];
        [topView addSubview:_button];
    }
    Attachment *attView1 = [[Attachment alloc]initWithFrame:CGRectMake(((Scree_width/2)-(Scree_width-kWidth*160)/2+(Scree_width-kWidth*160)/3*2)-(kWidth*260)/2, attView.bottom+kHeight*170, kWidth*280, kHeight*25) ];
    [topView addSubview:attView1];
    NSArray *rightThreeLabelAry = [[NSArray alloc]initWithObjects:@"客服经理",@"物流经理",@"财务经理", nil];
    NSArray *rightThreeAry = [[NSArray alloc]initWithObjects:@"12",@"13",@"15", nil];
    
    for (int h = 0; h<rightThreeAry.count; h++) {
        NSString *str = [[NSString alloc]init];
        str = rightThreeAry[h];
        int tagi = [str intValue];
        if (h == 1) {
            _button = [[ButtonView alloc]initWithFrame:CGRectMake(attView1.left-(kWidth*45)/2+(attView1.width/2)*h-kWidth*15, attView1.bottom, kWidth*45, kHeight*185) height:kHeight*45];
        }else{
        _button = [[ButtonView alloc]initWithFrame:CGRectMake(attView1.left-(kWidth*45)/2+(attView1.width/2)*h, attView1.bottom, kWidth*45, kHeight*185) height:kHeight*45];
        }
        
        [_button.ZWbutton setTitle:rightThreeLabelAry[h] forState:UIControlStateNormal];
         [_button.ZWbutton addTarget:self action:@selector(qdbtnClick:)forControlEvents:UIControlEventTouchUpInside];
        _button.ZWbutton.tag = tagi;
        [_imageAry addObject:_button.ZWimage];
        [_buttonAry addObject:_button.ZWbutton];
        [topView addSubview:_button];
    }
    _button = [[ButtonView alloc]initWithFrame:CGRectMake(attView1.left-(kWidth*45)/2, attView1.bottom+kHeight*185, kWidth*45, kHeight*180) height:kHeight*70];
    [_button.ZWbutton setTitle:@"客服" forState:UIControlStateNormal];
    _button.ZWbutton.tag = 3;
    [_button.ZWbutton addTarget:self action:@selector(qdbtnClick:)forControlEvents:UIControlEventTouchUpInside];
    [_imageAry addObject:_button.ZWimage];
    [_buttonAry addObject:_button.ZWbutton];
    [topView addSubview:_button];
    
    Attachment *attView2 = [[Attachment alloc]initWithFrame:CGRectMake(attView1.left-(kWidth*40)/2+(attView1.width/2)*1-kWidth*15-(kWidth*40)/2, attView1.bottom+kHeight*185, kWidth*80, kHeight*25)];
    [topView addSubview:attView2];
    
    NSArray *fourArry = [[NSArray alloc]initWithObjects:@"4",@"14", nil];
    NSArray *fourLabelArry = [[NSArray alloc]initWithObjects:@"物流",@"仓库", nil];
    for (int y = 0; y<fourArry.count; y++) {
        NSString *str = [[NSString alloc]init];
        str = fourArry[y];
        int tagi = [str intValue];
        _button = [[ButtonView alloc]initWithFrame:CGRectMake(attView2.left-(kWidth*45)/2+(attView2.width/1)*y, attView2.bottom, kWidth*45, kHeight*155) height:kHeight*45];
        [_button.ZWbutton setTitle:fourLabelArry[y] forState:UIControlStateNormal];
         [_button.ZWbutton addTarget:self action:@selector(qdbtnClick:)forControlEvents:UIControlEventTouchUpInside];
         _button.ZWbutton.tag = tagi;
        [_imageAry addObject:_button.ZWimage];
        [_buttonAry addObject:_button.ZWbutton];
        [topView addSubview:_button];
    }
    Attachment *attView3 = [[Attachment alloc]initWithFrame:CGRectMake(attView1.right-(kWidth*80)/2, attView1.bottom+kHeight*185, kWidth*80, kHeight*25)];
    [topView addSubview:attView3];
    
    NSArray *fiveArry = [[NSArray alloc]initWithObjects:@"16",@"17", nil];
    NSArray *fiveLabelAry =[[NSArray alloc]initWithObjects:@"会计",@"出纳", nil];
    for (int u = 0; u<fiveArry.count; u++) {
        NSString *str = [[NSString alloc]init];
        str = fiveArry[u];
        int tagi = [str intValue];
        _button = [[ButtonView alloc]initWithFrame:CGRectMake(attView3.left-(kWidth*45)/2+(attView2.width/1)*u, attView2.bottom, kWidth*45, kHeight*155) height:kHeight*45];
        [_button.ZWbutton setTitle:fiveLabelAry[u] forState:UIControlStateNormal];
         [_button.ZWbutton addTarget:self action:@selector(qdbtnClick:)forControlEvents:UIControlEventTouchUpInside];
        _button.ZWbutton.tag = tagi;
       // _button.ZWimage.image = [UIImage imageNamed:@"xz_ico1"];
        [_imageAry addObject:_button.ZWimage];
        [_buttonAry addObject:_button.ZWbutton];
        [topView addSubview:_button];
    }
    [self asklfjlw];
}
-(void)asklfjlw{
    NSString *urlStr = [NSString stringWithFormat:@"%@manager/queryPosition", KURLHeader];
    NSString *companyinfoid = [NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic = [[NSDictionary alloc]init];
    dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"CompanyInfoId":companyinfoid};
    [ZXDNetworking GET:urlStr parameters:dic success:^(id responseObject) {
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
             NSArray *array=[responseObject valueForKey:@"roleSetList"];
            for (NSDictionary *dic in array) {
                SetModel *model=[[SetModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [_lqzwnameAry addObject:model.NewName];
                [_lqzwnumAry addObject:model.num];
                int a = [model.num intValue];
                switch (a) {
                    case 2:
                        [self btnColorImage:_buttonAry[7] buttonImage:_imageAry[7]];
                        _button.ZWbutton = _buttonAry[7];
                        _button.ZWbutton.enabled = NO;
                        MDBOOL=NO;
                        break;
                    case 3:
                        [self btnColorImage:_buttonAry[11] buttonImage:_imageAry[11]];
                        _button.ZWbutton = _buttonAry[11];
                        _button.ZWbutton.enabled = NO;
                        KFBOOL=NO;
                        break;
                    case 4:
                        [self btnColorImage:_buttonAry[12] buttonImage:_imageAry[12]];
                          _button.ZWbutton = _buttonAry[12];
                        _button.ZWbutton.enabled = NO;
                        WLBOOL=NO;
                        break;
                    case 5:
                        [self btnColorImage:_buttonAry[6] buttonImage:_imageAry[6]];
                        _button.ZWbutton = _buttonAry[6];
                        _button.ZWbutton.enabled = NO;
                        YWBOOL=NO;
                        break;
                    case 6:
                        [self btnColorImage:_buttonAry[5] buttonImage:_imageAry[5]];
                        _button.ZWbutton = _buttonAry[5];
                        _button.ZWbutton.enabled = NO;
                        SCJLBOOL=NO;
                        break;
                    case 7:
                        [self btnColorImage:_buttonAry[3] buttonImage:_imageAry[3]];
                        _button.ZWbutton = _buttonAry[3];
                        _button.ZWbutton.enabled = NO;
                        XZGLBOOL=NO;
                        break;
                    case 8:
                        [self btnColorImage:_buttonAry[4] buttonImage:_imageAry[4]];
                        _button.ZWbutton = _buttonAry[4];
                        _button.ZWbutton.enabled = NO;
                        YWJLBOOL=NO;
                        break;
                    case 9:
                        [self btnColorImage:_buttonAry[0] buttonImage:_imageAry[0]];
                        _button.ZWbutton = _buttonAry[0];
                        _button.ZWbutton.enabled = NO;
                        YWZJBOOL=NO;
                        break;
                    case 10:
                        [self btnColorImage:_buttonAry[1] buttonImage:_imageAry[1]];
                        _button.ZWbutton = _buttonAry[1];
                        _button.ZWbutton.enabled = NO;
                        SCZJBOOL=NO;
                        break;
                    case 11:
                        [self btnColorImage:_buttonAry[2] buttonImage:_imageAry[2]];
                        _button.ZWbutton = _buttonAry[2];
                        _button.ZWbutton.enabled = NO;
                        CWZJBOOL=NO;
                        break;
                    case 12:
                        [self btnColorImage:_buttonAry[8] buttonImage:_imageAry[8]];
                        _button.ZWbutton = _buttonAry[8];
                        _button.ZWbutton.enabled = NO;
                        KFJLBOOL=NO;
                        break;
                    case 13:
                        [self btnColorImage:_buttonAry[9] buttonImage:_imageAry[9]];
                        _button.ZWbutton = _buttonAry[9];
                        _button.ZWbutton.enabled = NO;
                        WLJLBOOL=NO;
                        break;
                    case 14:
                        [self btnColorImage:_buttonAry[13] buttonImage:_imageAry[13]];
                        _button.ZWbutton = _buttonAry[13];
                        _button.ZWbutton.enabled = NO;
                        CKBOOL=NO;
                        break;
                    case 15:
                        [self btnColorImage:_buttonAry[10] buttonImage:_imageAry[10]];
                        _button.ZWbutton = _buttonAry[10];
                        _button.ZWbutton.enabled = NO;
                        CWJLBOOL=NO;
                        break;
                    case 16:
                        [self btnColorImage:_buttonAry[14] buttonImage:_imageAry[14]];
                        _button.ZWbutton = _buttonAry[14];
                        _button.ZWbutton.enabled = NO;
                        KJBOOL=NO;
                        break;
                    case 17:
                        [self btnColorImage:_buttonAry[15] buttonImage:_imageAry[15]];
                        _button.ZWbutton = _buttonAry[15];
                        _button.ZWbutton.enabled = NO;
                        CNBOOL=NO;
                        break;
                        
                        
                    default:
                        break;
                }
            }
        }else if ([[responseObject valueForKey:@"status"] isEqualToString:@"1111"]){
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"数据异常，操作失败" andInterval:1.0];
        }else {
            PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"登陆超时请重新登录" sureBtn:@"确认" cancleBtn:nil];
            
            alertView.resultIndex = ^(NSInteger index){
                ViewController *loginVC = [[ViewController alloc] init];
                UINavigationController *loginNavC = [[UINavigationController alloc] initWithRootViewController:loginVC];
                [self presentViewController:loginNavC animated:YES completion:nil];
            };
            [alertView showMKPAlertView];
            
        }

        
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}
-(void)qdbtnClick:(UIButton *)btn{
    switch (btn.tag) {
        case 2:
            //美导
            _button.ZWimage = _imageAry[7];
            [self btnColorImage:btn buttonImage:_button.ZWimage ];
            [self btnColorImage:_ywmdAry[1] buttonImage:_imageAry[5] ];
            if (MDBOOL == YES) {
                MDBOOL = NO;
                SCJLBOOL = NO;
            }else{
                MDBOOL = YES;
                SCJLBOOL = YES;
            }
            break;
        case 3:
            //客服
            _button.ZWimage = _imageAry[11];
            [self btnColorImage:btn buttonImage:_button.ZWimage ];
            if (KFBOOL == YES) {
                KFBOOL = NO;
                [_kfwlcwAry addObject:@"客服"];
            }else{
                KFBOOL = YES;
                [_kfwlcwAry removeObject:@"客服"];
            }
            break;
        case 4:
            //物流
            _button.ZWimage = _imageAry[12];
            [self btnColorImage:btn buttonImage:_button.ZWimage ];
            if (WLBOOL == YES) {
                WLBOOL = NO;
                [_kfwlcwAry addObject:@"物流"];
            }else{
                WLBOOL = YES;
                [_kfwlcwAry removeObject:@"物流"];
            }
            break;
        case 5:
            //业务
            _button.ZWimage = _imageAry[6];
            [self btnColorImage:btn buttonImage:_button.ZWimage ];
            [self btnColorImage:_ywmdAry[0] buttonImage:_imageAry[4] ];
            if (YWBOOL == YES) {
                YWBOOL = NO;
                YWJLBOOL = NO;
            }else{
                YWBOOL = YES;
                YWJLBOOL =YES;
            }
            break;
        case 6:
            //品牌经理
            _button.ZWimage = _imageAry[5];
            [self btnColorImage:btn buttonImage:_button.ZWimage ];
           [self btnColorImage:_ywmdAry[3] buttonImage:_imageAry[7] ];
            if (SCJLBOOL == YES) {
                SCJLBOOL = NO;
                MDBOOL = NO;
            }else{
                SCJLBOOL = YES;
                MDBOOL = YES;
            }
            break;
        case 7:
            //行政管理
            _button.ZWimage = _imageAry[3];
            [self btnColorImage:btn buttonImage:_button.ZWimage ];
            if (XZGLBOOL == YES) {
                XZGLBOOL = NO;
            }else{
                XZGLBOOL = YES;
            }
            break;
        case 8:
            //业务经理
            _button.ZWimage = _imageAry[4];
            [self btnColorImage:btn buttonImage:_button.ZWimage ];
            [self btnColorImage:_ywmdAry[2] buttonImage:_imageAry[6] ];
            if (YWJLBOOL == YES) {
                YWJLBOOL = NO;
                YWBOOL = NO;
            }else{
                YWJLBOOL = YES;
                YWBOOL = YES;
            }
            break;
        case 9:
            //业务总监
            _button.ZWimage = _imageAry[0];
            [self btnColorImage:btn buttonImage:_button.ZWimage ];
            if (YWZJBOOL == YES) {
                YWZJBOOL = NO;
            }else{
                YWZJBOOL = YES;
            }
            break;
        case 10:
            //市场总监
            _button.ZWimage = _imageAry[1];
            [self btnColorImage:btn buttonImage:_button.ZWimage ];
            if (SCZJBOOL == YES) {
                SCZJBOOL = NO;
            }else{
                SCZJBOOL = YES;
            }
            break;
        case 11:
            //财务总监
            _button.ZWimage = _imageAry[2];
            [self btnColorImage:btn buttonImage:_button.ZWimage ];
            if (CWZJBOOL == YES) {
                CWZJBOOL = NO;
            }else{
                CWZJBOOL = YES;
            }
            break;
        case 12:
            //客服经理
            _button.ZWimage = _imageAry[8];
            [self btnColorImage:btn buttonImage:_button.ZWimage ];
            if (KFJLBOOL == YES) {
                KFJLBOOL = NO;
                [_kfwlcwAry addObject:@"客服经理"];
            }else{
                KFJLBOOL = YES;
                [_kfwlcwAry removeObject:@"客服经理"];
            }
            break;
        case 13:
            //物流经理
            _button.ZWimage = _imageAry[9];
            [self btnColorImage:btn buttonImage:_button.ZWimage ];
            if (WLJLBOOL == YES) {
                WLJLBOOL = NO;
                [_kfwlcwAry addObject:@"物流经理"];
                
            }else{
                WLJLBOOL = YES;
               
                [_kfwlcwAry removeObject:@"物流经理"];
            }
            break;
        case 14:
            //仓库
            _button.ZWimage = _imageAry[13];
            [self btnColorImage:btn buttonImage:_button.ZWimage ];
            if (CKBOOL == YES) {
                CKBOOL = NO;
                [_kfwlcwAry addObject:@"仓库"];
            }else{
                CKBOOL = YES;
                [_kfwlcwAry removeObject:@"仓库"];
            }

            break;
        case 15:
            //财务经理
            _button.ZWimage = _imageAry[10];
            [self btnColorImage:btn buttonImage:_button.ZWimage ];
            if (CWJLBOOL == YES) {
                CWJLBOOL = NO;
                [_kfwlcwAry addObject:@"财务经理"];
            }else{
                CWJLBOOL = YES;
                [_kfwlcwAry removeObject:@"财务经理"];
            }
            break;
        case 16:
            //会计
            _button.ZWimage = _imageAry[14];
            [self btnColorImage:btn buttonImage:_button.ZWimage ];
            if (KJBOOL == YES) {
                KJBOOL = NO;
                [_kfwlcwAry addObject:@"会计"];
            }else{
                KJBOOL = YES;
                [_kfwlcwAry removeObject:@"会计"];
            }
            break;
        case 17:
            //出纳
            _button.ZWimage = _imageAry[15];
            [self btnColorImage:btn buttonImage:_button.ZWimage ];
            if (CNBOOL == YES) {
                CNBOOL = NO;
                [_kfwlcwAry addObject:@"出纳"];
            }else{
                CNBOOL = YES;
                [_kfwlcwAry removeObject:@"出纳"];
            }
            break;
        default:
            break;
    }
}
-(void)btnColorImage:(UIButton*)btn buttonImage:(UIImageView*)backImage
{

        if ([backImage.image isEqual:[UIImage imageNamed:@"xz_ico1"]]) {
            backImage.image = [UIImage imageNamed:@""];
            btn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
            for (int i = 0;i<_XZZWArry.count;i++)
            {
                if ([_XZZWArry[i]isEqualToString:btn.titleLabel.text]){
                    [_XZZWArry removeObject: _XZZWArry[i]];
                    
                    rsw = i;
                    break;//一定要有break，否则会出错的。
                }
            }
            
            [self dimissTabelCellZWUI];
            
        }else{
            backImage.image = [UIImage imageNamed:@"xz_ico1"];
            btn.layer.borderColor = [[UIColor orangeColor] CGColor];
            [_XZZWArry addObject:btn.titleLabel.text];
            for (int i = 0;i<_XZZWArry.count;i++)
            {
                if ([_XZZWArry[i]isEqualToString:btn.titleLabel.text]){
                    rw = i;
                    break;//一定要有break，否则会出错的。
                }
            }
            
            [self addtableViewCellZWUI];
            
            
        }
}
-(void)footerButtonClick:(UIButton *)btn{
    if ([btn.titleLabel.text isEqualToString:@"预览"]) {
        [btn setTitle:@"确定" forState:UIControlStateNormal];
        _asdjklView = [[UIView alloc]init];
        _asdjklView.backgroundColor  = [UIColor clearColor];
        [infonTableview addSubview:_asdjklView];
        [_asdjklView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view.mas_left).offset(0);
            make.top.mas_equalTo(self.view.mas_top).offset(64);
            make.right.mas_equalTo(self.view.mas_right).offset(0);
            make.bottom.mas_equalTo(infonTableview.tableFooterView.mas_top).offset(0);
        }];
        
    }else{
        [btn setTitle:@"预览" forState:UIControlStateNormal];
        [_asdjklView removeFromSuperview];
        [self.view endEditing:YES];
    }
    [self yulanUI];
}
-(void)yulanUI{
     if ([_footerButton.titleLabel.text isEqualToString:@"确定"]) {
         _popFootCellView = [[UIView alloc]init];
         _popFootCellView.backgroundColor = [UIColor whiteColor];
         [_footerView addSubview:_popFootCellView];
         [_popFootCellView mas_makeConstraints:^(MASConstraintMaker *make) {
             make.top.mas_equalTo(_footerButton.mas_bottom).offset(10);
             make.left.mas_equalTo(self.view.mas_left).offset(0);
             make.right.mas_equalTo(self.view.mas_right).offset(0);
             make.height.mas_offset(kHeight*770);
         }];
#define 总经理
         ButtonView *zjlLabel = [[ButtonView alloc]initWithFrame:CGRectZero height:kHeight*0];
         [zjlLabel.ZWbutton setTitle:_XGZJLStr forState:UIControlStateNormal];
         [_popFootCellView addSubview:zjlLabel];
         [zjlLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_popFootCellView.mas_top).offset(0);
            make.centerX.mas_equalTo(_popFootCellView.mas_centerX).offset(0);
             make.height.mas_equalTo(kHeight*120);
             make.width.mas_equalTo(kWidth*45);
         }];
#define 分叉线1
        Attachment *attView = [[Attachment alloc]initWithFrame:CGRectZero ];
        [_popFootCellView addSubview:attView];
             [attView mas_makeConstraints:^(MASConstraintMaker *make) {
                if (_XZZWArry.count==2){
                        make.width.mas_offset(1);
                        make.height.mas_offset(1);
                        make.top.mas_equalTo(zjlLabel.mas_bottom).offset(0);
                        make.centerX.mas_equalTo(zjlLabel.mas_centerX).offset(0);
                 }else if(XZGLBOOL == NO){
                     if(XZGLBOOL == NO&&CWZJBOOL == NO&&SCZJBOOL == YES&&SCJLBOOL ==YES&&YWZJBOOL == YES&&YWJLBOOL == YES){
                         make.width.mas_offset(kWidth*300);
                         make.height.mas_offset(kHeight*25);
                         make.top.mas_equalTo(zjlLabel.mas_bottom).offset(0);
                         make.centerX.mas_equalTo(zjlLabel.mas_centerX).offset(0);
                     }else if(YWZJBOOL==YES&&SCZJBOOL==YES&&YWJLBOOL==YES&&SCJLBOOL==YES){
                         make.width.mas_offset(kWidth*300);
                         make.height.mas_offset(kHeight*25);
                         make.top.mas_equalTo(zjlLabel.mas_bottom).offset(0);
                         make.centerX.mas_equalTo(zjlLabel.mas_centerX).offset(0);
                     }else{
                         make.left.mas_equalTo(self.view.mas_left).offset(kWidth*80);
                         make.right.mas_equalTo(self.view.mas_right).offset(-kWidth*80);
                         make.top.mas_equalTo(zjlLabel.mas_bottom).offset(0);
                         make.height.mas_offset(kHeight*25);
                     }
                     
                 }else if(_XZZWArry.count == 3){
                     if ((YWJLBOOL == NO &&YWBOOL == NO)||(SCJLBOOL == NO&& MDBOOL == NO)||(CWZJBOOL == NO&&KFJLBOOL == NO)||(CWZJBOOL == NO&&KFBOOL == NO)||(CWZJBOOL == NO&&WLJLBOOL == NO)||(CWZJBOOL == NO&&WLBOOL == NO)||(CWZJBOOL ==NO&&CKBOOL == NO)||(CWZJBOOL == NO&&CWJLBOOL == NO)||(CWZJBOOL == NO&&KJBOOL == NO)||(CWZJBOOL == NO&&CNBOOL == NO)||(KFJLBOOL == NO&&KFBOOL ==NO)||(WLJLBOOL == NO&&WLBOOL == NO)||(WLJLBOOL == NO &&CKBOOL==NO)||(CWJLBOOL == NO&&KJBOOL == NO)||(CWJLBOOL == NO&&CNBOOL == NO)||(WLBOOL==NO&&CKBOOL==NO)||(KJBOOL==NO&&CNBOOL==NO)||(YWJLBOOL==YES&&YWZJBOOL==YES&&SCZJBOOL==YES&&SCJLBOOL==YES&&XZGLBOOL==YES)) {
                         make.width.mas_offset(1);//
                         make.height.mas_offset(1);
                         make.top.mas_equalTo(zjlLabel.mas_bottom).offset(0);
                         make.centerX.mas_equalTo(zjlLabel.mas_centerX).offset(0);
                     }else{
                         make.width.mas_offset(kWidth*260);
                         make.height.mas_offset(kHeight*25);
                         make.top.mas_equalTo(zjlLabel.mas_bottom).offset(0);
                         make.centerX.mas_equalTo(zjlLabel.mas_centerX).offset(0);
                     }
                 } else if (_XZZWArry.count == 4){
                     if ((CWZJBOOL==NO&&((KFJLBOOL==NO&&KFBOOL==NO)||
                                         (WLJLBOOL==NO&&WLBOOL==NO)||
                                         (WLJLBOOL==NO&&CKBOOL==NO)||
                                         (CWJLBOOL==NO&&KJBOOL==NO)||
                                         (CWJLBOOL==NO&&CNBOOL==NO)))||(YWZJBOOL==NO&&YWJLBOOL==NO)||(SCZJBOOL==NO&&SCJLBOOL==NO)||
                         (YWJLBOOL==NO&&YWZJBOOL==NO&&YWBOOL==NO)||(SCZJBOOL==NO&&SCJLBOOL==NO&&MDBOOL==NO)) {
                         make.width.mas_offset(1);
                         make.height.mas_offset(1);
                         make.top.mas_equalTo(zjlLabel.mas_bottom).offset(0);
                         make.centerX.mas_equalTo(zjlLabel.mas_centerX).offset(0);
                     }else if(YWZJBOOL==YES&&SCZJBOOL==YES&&YWJLBOOL==YES&&YWBOOL==YES&&SCJLBOOL==YES&&MDBOOL==YES&&XZGLBOOL==YES){
                         make.width.mas_offset(kWidth*1);
                         make.height.mas_offset(kHeight*1);
                         make.top.mas_equalTo(zjlLabel.mas_bottom).offset(0);
                         make.centerX.mas_equalTo(zjlLabel.mas_centerX).offset(0);
                         
                     }else{
                         make.width.mas_offset(kWidth*300);
                         make.height.mas_offset(kHeight*25);
                         make.top.mas_equalTo(zjlLabel.mas_bottom).offset(0);
                         make.centerX.mas_equalTo(zjlLabel.mas_centerX).offset(0);
                     }
                 }else if(YWZJBOOL==YES&&SCZJBOOL==YES&&YWJLBOOL==YES&&YWBOOL==YES&&SCJLBOOL==YES&&MDBOOL==YES&&XZGLBOOL==YES){
                     make.width.mas_offset(kWidth*1);
                     make.height.mas_offset(kHeight*1);
                     make.top.mas_equalTo(zjlLabel.mas_bottom).offset(0);
                     make.centerX.mas_equalTo(zjlLabel.mas_centerX).offset(0);
                     
                 }
                 else{
                     make.width.mas_offset(kWidth*300);
                     make.height.mas_offset(kHeight*25);
                     make.top.mas_equalTo(zjlLabel.mas_bottom).offset(0);
                     make.centerX.mas_equalTo(zjlLabel.mas_centerX).offset(0);
                 }
                 
             }];
#define 业务总监
        ButtonView * ywzjbutton = [[ButtonView alloc]initWithFrame:CGRectZero height:kHeight*25];
             [_popFootCellView addSubview:ywzjbutton];
            [ywzjbutton.ZWbutton setTitle:_YWZJStr forState:UIControlStateNormal];
          if (YWZJBOOL == NO) {//选中
             [ywzjbutton mas_makeConstraints:^(MASConstraintMaker *make) {
                
                     if (SCZJBOOL == NO ||SCJLBOOL == NO ||CWZJBOOL == NO|| XZGLBOOL == NO||KFJLBOOL == NO||WLJLBOOL == NO ||CWJLBOOL == NO ||KFBOOL == NO||WLBOOL == NO || CKBOOL == NO||KJBOOL == NO||CNBOOL == NO) {
                         make.top.mas_equalTo(attView.mas_bottom).offset(0);
                         make.centerX.mas_equalTo(attView.mas_left).offset(0);
                     }else{
                         make.top.mas_equalTo(attView.mas_bottom).offset(0);
                         make.centerX.mas_equalTo(attView.mas_centerX).offset(0);
                     }
                     make.width.mas_equalTo(kWidth*45);
                     make.height.mas_equalTo(kHeight*160);
                 
             }];
          }else{
              //没选中
              [ywzjbutton removeFromSuperview];
          }
#define 业务经理
      ButtonView*   ywjlbutton = [[ButtonView alloc]initWithFrame:CGRectZero height:kHeight*70];
         [_popFootCellView addSubview:ywjlbutton];
         [ywjlbutton.ZWbutton setTitle:_YWJLStr forState:UIControlStateNormal];
         if (YWJLBOOL == NO) {
             [ywjlbutton mas_makeConstraints:^(MASConstraintMaker *make) {
                 if (YWZJBOOL == NO) {
                     make.top.mas_equalTo(ywzjbutton.mas_bottom).offset(0);
                     make.centerX.mas_equalTo(ywzjbutton.mas_centerX).offset(0);
                 }else if(_XZZWArry.count==3){
                     make.top.mas_equalTo(attView.mas_bottom).offset(0);
                     make.centerX.mas_equalTo(attView.mas_centerX).offset(0);
                 }else{
                     make.top.mas_equalTo(attView.mas_bottom).offset(0);
                     make.centerX.mas_equalTo(attView.mas_left).offset(0);
                }
                 make.width.mas_offset(kWidth*45);
                 make.height.mas_offset(kHeight*210);
             }];
             
         }else{
             [ywjlbutton removeFromSuperview];
         }
#define 业务
         ButtonView *ywbutton =[[ButtonView alloc]initWithFrame:CGRectZero height:kHeight*70];
         [_popFootCellView addSubview:ywbutton];
         [ywbutton.ZWbutton setTitle:_YWStr forState:UIControlStateNormal];
         if (YWBOOL == NO) {
             [ywbutton mas_makeConstraints:^(MASConstraintMaker *make) {
                 make.top.mas_equalTo(ywjlbutton.mas_bottom).offset(0);
                 make.left.mas_equalTo(ywjlbutton.mas_left).offset(0);
                 make.right.mas_equalTo(ywjlbutton.mas_right).offset(0);
                 make.height.mas_offset(kHeight*180);
             }];
         }else{
             [ywbutton removeFromSuperview];
         }
#define 市场总监
         ButtonView *sczjButton = [[ButtonView alloc]initWithFrame:CGRectZero height:kHeight*25];
         [_popFootCellView addSubview:sczjButton];
         [sczjButton.ZWbutton setTitle:_SCZJStr forState:UIControlStateNormal];
         if (SCZJBOOL == NO) {
             [sczjButton mas_makeConstraints:^(MASConstraintMaker *make) {
                 make.top.mas_equalTo(attView.mas_bottom).offset(0);
                 make.height.mas_offset(kHeight*160);
                 make.width.mas_offset(kWidth*45);
                 if (YWZJBOOL == YES&&YWJLBOOL == YES) {
                     make.centerX.mas_equalTo(attView.mas_left).offset(0);
                 }else if (CWZJBOOL==YES&&KFJLBOOL==YES&&WLJLBOOL==YES&&CWJLBOOL==YES&&KFBOOL==YES&&WLBOOL==YES&&CKBOOL==YES&&KJBOOL==YES&&CNBOOL==YES&&XZGLBOOL==YES){
                     make.centerX.mas_equalTo(attView.mas_right).offset(0);
                 }
                 else{
                     make.left.mas_equalTo(attView.mas_left).offset(kWidth*70);
                 }
             }];
         }else{
             [sczjButton removeFromSuperview];
         }
#define 市场经理
         ButtonView *scjlButton = [[ButtonView alloc]initWithFrame:CGRectZero height:kHeight*70];
         [_popFootCellView addSubview:scjlButton];
         [scjlButton.ZWbutton setTitle:_SCJLStr forState:UIControlStateNormal];
         if (SCJLBOOL == NO) {
             [scjlButton mas_makeConstraints:^(MASConstraintMaker *make) {
                 if (SCZJBOOL == NO) {
                     make.top.mas_equalTo(sczjButton.mas_bottom).offset(0);
                     make.centerX.mas_equalTo(sczjButton.mas_centerX).offset(0);
                 }else if(SCZJBOOL == YES && YWZJBOOL == YES && YWJLBOOL == YES){
                     make.top.mas_equalTo(attView.mas_bottom).offset(0);
                     make.centerX.mas_equalTo(attView.mas_left).offset(0);
                 }else if ((YWZJBOOL == NO || YWJLBOOL == NO)&&SCZJBOOL&&(CWZJBOOL==NO||KFJLBOOL==NO||WLJLBOOL==NO||CWJLBOOL==NO||KFBOOL==NO||WLBOOL==NO||CKBOOL==NO||KJBOOL==NO||CNBOOL==NO||XZGLBOOL==NO)) {
                     make.top.mas_equalTo(attView.mas_bottom).offset(0);
                     make.left.mas_equalTo(attView.mas_left).offset(kWidth*70);
                 }else if (CWZJBOOL==YES&&KFJLBOOL==YES&&WLJLBOOL==YES&&CWJLBOOL==YES&&KFBOOL==YES&&WLBOOL==YES&&CKBOOL==YES&&KJBOOL==YES&&CNBOOL==YES&&XZGLBOOL==YES){
                     make.top.mas_equalTo(attView.mas_bottom).offset(0);
                     make.centerX.mas_equalTo(attView.mas_right).offset(0);
                 }
                 make.height.mas_offset(kHeight*210);
                 make.width.mas_offset(kWidth*45);
             }];
         }else{
             [scjlButton removeFromSuperview];
         }
#define 美导
         ButtonView *mdButton =[[ButtonView alloc]initWithFrame:CGRectZero height:kHeight*70];
         [_popFootCellView addSubview:mdButton];
         [mdButton.ZWbutton setTitle:_MDStr forState:UIControlStateNormal];
         if (MDBOOL == NO) {
             [mdButton mas_makeConstraints:^(MASConstraintMaker *make) {
                 make.top.mas_equalTo(scjlButton.mas_bottom).offset(0);
                 make.left.mas_equalTo(scjlButton.mas_left).offset(0);
                 make.height.mas_offset(kHeight*180);
                 make.width.mas_equalTo(kWidth*45);
             }];
         }else{
             [mdButton removeFromSuperview];
         }
#define 财务总监
         ButtonView *cwzjbutton = [[ButtonView alloc]initWithFrame:CGRectZero height:kHeight*25];
         [_popFootCellView addSubview:cwzjbutton];
         [cwzjbutton.ZWbutton setTitle:_CWZJStr forState:UIControlStateNormal];
         if (CWZJBOOL == NO) {
             [cwzjbutton mas_makeConstraints:^(MASConstraintMaker *make) {
                 make.top.mas_equalTo(attView.mas_bottom).offset(0);
                 make.width.mas_offset(kWidth*45);
                 make.height.mas_offset(kHeight*160);//
                 if ((XZGLBOOL == YES&&YWZJBOOL == NO&&SCZJBOOL == NO)||
                     (XZGLBOOL == YES&&YWZJBOOL == NO&&SCZJBOOL == YES&&YWJLBOOL == NO&&SCJLBOOL == NO) ||
                     (XZGLBOOL == YES&&YWZJBOOL == NO&&SCZJBOOL == YES&&YWJLBOOL == YES&&SCJLBOOL == NO)||
                     (XZGLBOOL == YES&&YWZJBOOL == NO&&SCZJBOOL == YES&&YWJLBOOL == NO&&SCJLBOOL == YES)||
                     (XZGLBOOL == YES&&YWZJBOOL == NO&&SCZJBOOL == YES&&YWJLBOOL == YES&&SCJLBOOL == YES)||
                     (XZGLBOOL == YES&&YWZJBOOL == YES&&SCZJBOOL == YES&&YWJLBOOL == NO&&SCJLBOOL == NO)||
                     (XZGLBOOL == YES&&YWZJBOOL == YES&&SCZJBOOL == YES&&YWJLBOOL == NO&&SCJLBOOL == YES)||
                     (XZGLBOOL == YES&&YWZJBOOL == YES&&SCZJBOOL == YES&&YWJLBOOL == YES&&SCJLBOOL == NO)||

                     (XZGLBOOL == YES&&YWZJBOOL == YES&&SCZJBOOL == NO&&YWJLBOOL == NO&&SCJLBOOL == NO)||
                     (XZGLBOOL == YES&&YWZJBOOL == YES&&SCZJBOOL == NO&&YWJLBOOL == YES&&SCJLBOOL == NO)||
                     (XZGLBOOL == YES&&YWZJBOOL == YES&&SCZJBOOL == NO&&YWJLBOOL == NO&&SCJLBOOL == YES)||
                     (XZGLBOOL == YES&&YWZJBOOL == YES&&SCZJBOOL == NO&&YWJLBOOL == YES&&SCJLBOOL == YES)
                     ) {
                     make.centerX.mas_equalTo(attView.mas_right).offset(0);
                 }else if(YWZJBOOL == YES&&YWJLBOOL == YES&&SCZJBOOL == YES&& SCJLBOOL == YES &&XZGLBOOL == NO){
                     make.centerX.mas_equalTo(attView.mas_left).offset(0);
                 }else if((XZGLBOOL == NO&&YWZJBOOL == NO&&SCZJBOOL ==NO)||
                          (XZGLBOOL == NO&&YWZJBOOL == NO&&SCZJBOOL ==YES&&SCJLBOOL == NO)||
                          (XZGLBOOL == NO&&YWZJBOOL ==YES&&SCZJBOOL ==NO&&YWJLBOOL == NO)||
                          (XZGLBOOL == NO&&YWZJBOOL ==YES&&SCZJBOOL ==YES&&YWJLBOOL ==NO&&SCJLBOOL==NO)){
                     make.centerX.mas_equalTo(attView.mas_right).offset(-(Scree_width-kWidth*160)/3);
                 }else if((XZGLBOOL == NO&&YWZJBOOL == NO&&YWJLBOOL == NO&&SCZJBOOL == YES &&SCJLBOOL ==YES)||
                          (XZGLBOOL == NO&&YWZJBOOL==YES&&YWJLBOOL == NO&&SCZJBOOL == YES&& SCJLBOOL == YES)||
                          (XZGLBOOL == NO&&YWZJBOOL==NO&&YWJLBOOL == YES&&SCZJBOOL == YES&& SCJLBOOL == YES)||
                          (XZGLBOOL == NO&&YWZJBOOL == YES&&YWJLBOOL == YES&& SCZJBOOL == NO&&SCJLBOOL == YES)||
                          (XZGLBOOL == NO&&YWZJBOOL == YES&&YWJLBOOL == YES&& SCZJBOOL == NO&&SCJLBOOL == NO)||
                          (XZGLBOOL == NO&&YWZJBOOL == YES&&YWJLBOOL == YES&& SCZJBOOL == YES&&SCJLBOOL== NO)){
                     make.centerX.mas_equalTo(attView.mas_centerX).offset(0);
                 }else if ((_XZZWArry.count ==2)||(YWZJBOOL==YES&&SCZJBOOL==YES&&YWJLBOOL==YES&&SCJLBOOL==YES&&XZGLBOOL==YES)){
                     make.centerX.mas_equalTo(zjlLabel.mas_centerX).offset(0);
                 }
             }];
         }else{
             [cwzjbutton removeFromSuperview];
         }
#define 行政管理
         ButtonView *xzglButton = [[ButtonView alloc]initWithFrame:CGRectZero height:kHeight*25];
         [_popFootCellView addSubview:xzglButton];
         [xzglButton.ZWbutton setTitle:_XZGLLStr forState:UIControlStateNormal];
         if (XZGLBOOL == NO) {
             [xzglButton mas_makeConstraints:^(MASConstraintMaker *make) {
                 make.top.mas_equalTo(attView.mas_bottom).offset(0);
                 
                 make.height.mas_offset(kHeight*160);
                 make.width.mas_offset(kWidth*45);
                 if (_XZZWArry.count == 2) {
                     make.centerX.mas_equalTo(attView.mas_centerX).offset(0);
                 }
                 else{
                     make.centerX.mas_equalTo(attView.mas_right).offset(0);
                 }
             }];
         }else{
             [xzglButton removeFromSuperview];
         }
#define 分叉线2
         Attachment *attachView = [[Attachment alloc]initWithFrame:CGRectZero];
         [_popFootCellView addSubview:attachView];
         [attachView mas_makeConstraints:^(MASConstraintMaker *make) {
             if (CWZJBOOL==NO) {
                 make.top.mas_equalTo(cwzjbutton.mas_bottom).offset(0);
                 make.centerX.mas_equalTo(cwzjbutton.mas_centerX).offset(0);
             }else if ((YWZJBOOL==NO||YWJLBOOL==NO)&&(SCZJBOOL==NO||SCJLBOOL==NO)&&XZGLBOOL==NO){
                 make.top.mas_equalTo(attView.mas_bottom).offset(0);
                 make.centerX.mas_equalTo(attView.mas_centerX).offset(kWidth*70);
             }else if (XZGLBOOL==YES){
                 if ((YWZJBOOL==NO||YWJLBOOL==NO)||(SCZJBOOL==NO||SCJLBOOL==NO)) {
                     make.top.mas_equalTo(attView.mas_bottom).offset(0);
                     make.centerX.mas_equalTo(attView.mas_right).offset(0);
                 }else{
                     make.top.mas_equalTo(attView.mas_bottom).offset(0);
                     make.centerX.mas_equalTo(zjlLabel.mas_centerX).offset(0);
                 }
             }else if (XZGLBOOL==NO&&(YWZJBOOL==NO||SCZJBOOL==NO||YWJLBOOL==NO||SCJLBOOL==NO)){
                 make.top.mas_equalTo(attView.mas_bottom).offset(0);
                 make.centerX.mas_equalTo(attView.mas_centerX).offset(0);
             }else if(XZGLBOOL==NO&&YWZJBOOL==YES&&YWJLBOOL==YES&&SCZJBOOL==YES&&SCJLBOOL==YES){
                 make.top.mas_equalTo(attView.mas_bottom).offset(0);
                 make.centerX.mas_equalTo(attView.mas_left).offset(0);
             }
             if (_kfwlcwAry.count==1) {
                 make.width.mas_offset(1);
                 make.height.mas_offset(1);
             }else if (_kfwlcwAry.count==2){
                 if ((KFBOOL==NO&&KFJLBOOL==NO)||(WLJLBOOL==NO&&WLBOOL==NO)||(WLJLBOOL==NO&&CKBOOL==NO)||(CWJLBOOL==NO&&KJBOOL==NO)||(CWJLBOOL==NO&&CNBOOL==NO)) {
                     make.width.mas_offset(1);
                     make.height.mas_offset(1);
                 }else if(KFJLBOOL==YES&&WLJLBOOL==YES&&CWJLBOOL==YES&&KFBOOL==YES&&((WLBOOL==NO&&CKBOOL==NO)||(KJBOOL==NO&&CNBOOL==NO))){
                     make.width.mas_offset(1);
                     make.height.mas_offset(1);
                 }else{
                     make.width.mas_offset(kWidth*260);
                     make.height.mas_offset(kHeight*25);
                 }
                 
             }else if ((KFJLBOOL==NO||KFBOOL==NO)&&(WLJLBOOL==NO||WLBOOL==NO||CKBOOL==NO)&&(CWJLBOOL==NO||KJBOOL==NO||CNBOOL==NO)){
                 make.width.mas_offset(kWidth*260);
                 make.height.mas_offset(kHeight*25);
             }else  if(_kfwlcwAry.count>=4){
                 make.width.mas_offset(kWidth*260);
                 make.height.mas_offset(kHeight*25);
             }else if(_kfwlcwAry.count==3){
                 if((WLJLBOOL==NO&&WLBOOL==NO&&CKBOOL==NO)||(CWJLBOOL==NO&&KJBOOL==NO&&CNBOOL==NO)){
                     make.width.mas_offset(kWidth*1);
                     make.height.mas_offset(kHeight*1);
                 }else{
                     make.width.mas_offset(kWidth*260);
                     make.height.mas_offset(kHeight*25);
                 }
                 
             }
         }];
#define  客服经理
         ButtonView *kfjlButton=[[ButtonView alloc]initWithFrame:CGRectZero height:kHeight*45];
         [_popFootCellView addSubview:kfjlButton];
         [kfjlButton.ZWbutton setTitle:_KFJLStr forState:UIControlStateNormal];
         if (KFJLBOOL==NO) {
             [kfjlButton mas_makeConstraints:^(MASConstraintMaker *make) {
                 make.top.mas_equalTo(attachView.mas_bottom).offset(0);
                 if (WLJLBOOL==YES&&WLBOOL==YES&&CKBOOL==YES&&CWJLBOOL==YES&&KJBOOL==YES&&CNBOOL==YES) {
                      make.centerX.mas_equalTo(attachView.mas_centerX).offset(0);
                 }else{
                  make.centerX.mas_equalTo(attachView.mas_left).offset(0);
                 }
                
                 make.height.mas_equalTo(kHeight*185);
                 make.width.mas_equalTo(kWidth*45);
             }];
            
         }else{
             [kfjlButton removeFromSuperview];
         }
#define 客服
         ButtonView*kfButton = [[ButtonView alloc]initWithFrame:CGRectZero height:kHeight*70];
         [_popFootCellView addSubview:kfButton];
         [kfButton.ZWbutton setTitle:_KFStr forState:UIControlStateNormal];
         if (KFBOOL == NO) {
             [kfButton mas_makeConstraints:^(MASConstraintMaker *make) {
                 if (KFJLBOOL==NO) {
                     make.top.mas_equalTo(kfjlButton.mas_bottom).offset(0);
                     make.centerX.mas_equalTo(kfjlButton.mas_centerX).offset(0);
                 }else{
                     make.top.mas_equalTo(attachView.mas_bottom).offset(0);
                     make.centerX.mas_equalTo(attachView.mas_left).offset(0);
                 }
                 make.width.mas_offset(kWidth*45);
                 make.height.mas_offset(kHeight*180);
                 
             }];
         }else{
             [kfButton removeFromSuperview];
         }
#define 物流经理
         ButtonView *wljlButton =[[ButtonView alloc]initWithFrame:CGRectZero height:kHeight*45];
         [_popFootCellView addSubview:wljlButton];
         [wljlButton.ZWbutton setTitle:_WLJLStr forState:UIControlStateNormal];
         if (WLJLBOOL==NO) {
             [wljlButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(attachView.mas_bottom).offset(0);
                 if ((KFJLBOOL==YES&&KFBOOL==YES)&&(CWJLBOOL==NO||KJBOOL==NO||CNBOOL==NO)) {
                     make.centerX.mas_equalTo(attachView.mas_left).offset(0);
                 }else if((KFJLBOOL==NO||KFBOOL==NO)&&(CWJLBOOL==NO||KJBOOL==NO||CNBOOL==NO)){
                     make.centerX.mas_equalTo(attachView.mas_centerX).offset(-kWidth*30);
                 }else if((KFJLBOOL==NO||KFBOOL==NO)&&(CWJLBOOL==YES&&KJBOOL==YES&&CNBOOL==YES)){
                     make.centerX.mas_equalTo(attachView.mas_right).offset(0);
                 }else if (KFJLBOOL==YES&&KFBOOL==YES&&CWJLBOOL==YES&&KJBOOL==YES&&CNBOOL==YES){
                     make.centerX.mas_equalTo(attachView.mas_centerX).offset(0);
                 }
                 make.width.mas_offset(kWidth*45);
                 make.height.mas_offset(kHeight*185);
             }];

         }else{
             [wljlButton removeFromSuperview];
         }
#define 分叉3
         Attachment *attView3 = [[Attachment alloc]initWithFrame:CGRectZero];
         [_popFootCellView addSubview:attView3];
         [attView3 mas_makeConstraints:^(MASConstraintMaker *make) {
             if (WLJLBOOL==NO) {
                 make.top.mas_equalTo(wljlButton.mas_bottom).offset(0);
                 make.centerX.mas_equalTo(wljlButton.mas_centerX).offset(0);
             }else{
                 make.top.mas_equalTo(attachView.mas_bottom).offset(0);
                 if ((KFJLBOOL==NO||KFBOOL==NO)&&(CWJLBOOL==NO||KJBOOL==NO||CNBOOL==NO)) {
                     make.centerX.mas_equalTo(attachView.mas_centerX).offset(-kWidth*30);
                 }else if((KFJLBOOL==YES&&KFBOOL==YES)&&(CWJLBOOL==NO||KJBOOL==NO||CNBOOL==NO)){
                     make.centerX.mas_equalTo(attachView.mas_left).offset(kWidth*0);
                 }else if((KFJLBOOL==NO||KFBOOL==NO)&&(CWJLBOOL==YES&&KJBOOL==YES&&CNBOOL==YES)){
                     make.centerX.mas_equalTo(attachView.mas_right).offset(kWidth*0);
                 }else if((KFJLBOOL==YES&&KFBOOL==YES&&CWJLBOOL==YES&&KJBOOL==YES&&CNBOOL==YES)){
                     make.centerX.mas_equalTo(attachView.mas_centerX).offset(0);
                 }
             }
             if (WLBOOL==NO&&CKBOOL==NO) {
                 make.width.mas_offset(kWidth*80);
                 make.height.mas_offset(kHeight*25);
             }else if(WLBOOL==YES&&CKBOOL==YES){
                 make.width.mas_offset(0);
                 make.height.mas_offset(0);
             }else{
                 make.width.mas_offset(1);
                 make.height.mas_offset(1);
             }
         }];
#define 物流
         ButtonView*wlButton =[[ButtonView alloc]initWithFrame:CGRectZero height:kHeight*45];
         [_popFootCellView addSubview:wlButton];
         [wlButton.ZWbutton setTitle:_WLStr forState:UIControlStateNormal];
         if (WLBOOL==NO) {
             [wlButton mas_makeConstraints:^(MASConstraintMaker *make) {
                 make.top.mas_equalTo(attView3.mas_bottom).offset(0);
                 if (CKBOOL==NO) {
                     make.centerX.mas_equalTo(attView3.mas_left).offset(0);
                 }else{
                     make.centerX.mas_equalTo(attView3.mas_centerX).offset(0);
                 }
                 make.width.mas_offset(kWidth*45);
                 make.height.mas_offset(kHeight*155);
             }];
         }else{
             [wlButton removeFromSuperview];
         }
#define 仓库
         ButtonView *ckButton = [[ButtonView alloc]initWithFrame:CGRectZero height:kHeight*45];
         [_popFootCellView addSubview:ckButton];
         [ckButton.ZWbutton setTitle:_CKStr forState:UIControlStateNormal];
         if (CKBOOL==NO) {
             [ckButton mas_makeConstraints:^(MASConstraintMaker *make) {
                 make.top.mas_equalTo(attView3.mas_bottom).offset(0);
                 if (WLBOOL==NO) {
                     make.centerX.mas_equalTo(attView3.mas_right).offset(0);
                 }else{
                     make.centerX.mas_equalTo(attView3.mas_centerX).offset(0);
                     
                 }
                 make.width.mas_offset(kWidth*45);
                 make.height.mas_offset(kHeight*155);
             }];
         }else{
             [ckButton removeFromSuperview];
         }
         
#define 财务经理
         ButtonView *cwjlButton = [[ButtonView alloc]initWithFrame:CGRectZero height:kHeight*45];
         [_popFootCellView addSubview:cwjlButton];
         [cwjlButton.ZWbutton setTitle:_CWJLStr forState:UIControlStateNormal];
         if (CWJLBOOL == NO) {
             [cwjlButton mas_makeConstraints:^(MASConstraintMaker *make) {
                 make.top.mas_equalTo(attachView.mas_bottom).offset(0);
                 if (WLJLBOOL==YES&&WLBOOL==YES&&CKBOOL==YES&&KFJLBOOL==YES&&KFBOOL==YES) {
                     make.centerX.mas_equalTo(attachView.mas_centerX).offset(0);
                 }else{
                     make.centerX.mas_equalTo(attachView.mas_right).offset(0);
                 }
                 make.width.mas_offset(kWidth*45);
                 make.height.mas_offset(kHeight*185);
             }];
         }else{
             [cwjlButton removeFromSuperview];
         }
#define 分叉4
         Attachment *attView4 = [[Attachment alloc]initWithFrame:CGRectZero];
         [_popFootCellView addSubview:attView4];
         [attView4 mas_makeConstraints:^(MASConstraintMaker *make) {
             if (CWJLBOOL==NO) {
                 make.top.mas_equalTo(cwjlButton.mas_bottom).offset(0);
                 make.centerX.mas_equalTo(cwjlButton.mas_centerX).offset(0);
             }else if (KFJLBOOL==NO||KFBOOL==NO||WLJLBOOL==NO||WLBOOL==NO||CKBOOL==NO){
                 make.top.mas_equalTo(attachView.mas_bottom).offset(0);
                 make.centerX.mas_equalTo(attachView.mas_right).offset(0);
             }else if(KFJLBOOL==YES&&KFBOOL==YES&&WLJLBOOL==YES&&WLBOOL==YES&&CKBOOL==YES){
                 make.top.mas_equalTo(attachView.mas_bottom).offset(0);
                 make.centerX.mas_equalTo(attachView.mas_centerX).offset(0);
             }
             if (KJBOOL==NO&&CNBOOL==NO) {
                 make.width.mas_offset(kWidth*80);
                 make.height.mas_offset(kHeight*25);
             }else if((KJBOOL==NO&&CNBOOL==YES)||(KJBOOL==YES&&CNBOOL==NO)||(KJBOOL==YES&&CNBOOL==YES)){
                 make.width.mas_offset(1);
                 make.height.mas_offset(1);
             }
         }];
#define 会计
         ButtonView *kjButton = [[ButtonView alloc]initWithFrame:CGRectZero height:kHeight*45];
         [_popFootCellView addSubview:kjButton];
         [kjButton.ZWbutton setTitle:_KJStr forState:UIControlStateNormal];
         if (KJBOOL==NO) {
             [kjButton mas_makeConstraints:^(MASConstraintMaker *make) {
                 make.top.mas_equalTo(attView4.mas_bottom).offset(0);
                 if (CNBOOL==NO) {
                     make.centerX.mas_equalTo(attView4.mas_left).offset(0);
                 }else{
                     make.centerX.mas_equalTo(attView4.mas_centerX).offset(0);
                 }
                 make.width.mas_offset(kWidth*45);
                 make.height.mas_offset(kHeight*155);
             }];
         }else{
             [kjButton removeFromSuperview];
         }
#define 出纳
         ButtonView*cnButton = [[ButtonView alloc]initWithFrame:CGRectZero height:kHeight*45];
         [_popFootCellView addSubview:cnButton];
         [cnButton.ZWbutton setTitle:_CNStr forState:UIControlStateNormal];
         if (CNBOOL==NO) {
             [cnButton mas_makeConstraints:^(MASConstraintMaker *make) {
                 make.top.mas_equalTo(attView4.mas_bottom).offset(0);
                 if (KJBOOL==NO) {
                     make.centerX.mas_equalTo(attView4.mas_right).offset(0);
                 }else{
                     make.centerX.mas_equalTo(attView4.mas_centerX).offset(0);
                 }
                 make.width.mas_offset(kWidth*45);
                 make.height.mas_offset(kHeight*155);
             }];
         }else{
             [cnButton removeFromSuperview];
         }
     }else{
         [_popFootCellView removeFromSuperview];
     }
}
-(void)addBUtton:(ButtonView *)buttonview nameStr:(NSString *)nameStr uiview:(UIView*)uiview button:(ButtonView*)button hei:(CGFloat)hei wid:(CGFloat)wid biaoshi:(int)biaoshi {

    
    [buttonview.ZWbutton setTitle:nameStr forState:UIControlStateNormal];
    [_popFootCellView addSubview:buttonview];
    [buttonview mas_makeConstraints:^(MASConstraintMaker *make) {
        if (biaoshi == 1) {
            make.top.mas_equalTo(button.mas_bottom).offset(0);
            make.centerX.mas_equalTo(button.mas_centerX).offset(0);
        }else{
            make.top.mas_equalTo(uiview.mas_bottom).offset(0);
            make.centerX.mas_equalTo(uiview.mas_centerX).offset(0);
        }
        
        make.height.mas_equalTo(hei);
        make.width.mas_equalTo(wid);
    }];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
