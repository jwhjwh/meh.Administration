//
//  BJZWViewController.m
//  Administration
//
//  Created by 九尾狐 on 2017/6/7.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "BJZWViewController.h"

@interface BJZWViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *infonTableview;
    NSArray *arr;
    UIView *blockView;
    
    
    int b;
}
@property (strong,nonatomic)UIButton *ZWbutton;//职位
@property (strong,nonatomic)UIButton *ZWLBbutton;//职位类别
@property (strong,nonatomic)UIView *view1;//线
@property (strong,nonatomic)UIButton *TJBMButton;//添加部门
@property (strong,nonatomic) UILabel *BMLabel;//部门
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
    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:(UIBarButtonItemStyleDone) target:self action:@selector(masgegeClick)];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [rightitem setTitleTextAttributes:dict forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = rightitem;
    // Do any additional setup after loading the view.
    
    //arr = [[NSArray alloc]initWithObjects:@"职位",@"管理部门",nil];
    
    NSLog(@"标题: %@\n职位：%@\n职位id：%@\n职位类别：%@\n职位类别id：%@\n部门：%@\n部门id：%@",_codeAry,_ZW,_Numm,_ZWLB,_lbNum,_gxbmAry,_gxbmidAry);
   
   
   
    [self tableViewUI];
    
    
}

#pragma mark 完成
-(void)masgegeClick{
    
}
#pragma mark 添加职位
-(void)action_button{

}
#pragma mark 职位按钮
-(void)JsButtonbtn:(UIButton*)btn{
    
}
#pragma mark 职位类别按钮
-(void)JsLBButtonbtn:(UIButton*)btn{
    
}
#pragma mark 点击所属部门
-(void)SSButtonbtn:(UIButton*)btn{
    
}

#pragma mark 点击管辖部门
-(void)TJButtonbtn:(UIButton*)btn{
    
}
#pragma mark cell 点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier =@"Cell";
    //定义cell的复用性当处理大量数据时减少内存开销
    UITableViewCell *cell = [infonTableview  dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell ==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:CellIdentifier];
        if (indexPath.row == 1) {
             cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;//右箭头
        }
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = _codeAry[indexPath.section][indexPath.row];
        
        _ZWbutton = [[UIButton alloc]init];
        _ZWbutton.frame = CGRectMake(120, 1, self.view.bounds.size.width-300, 38);
        [_ZWbutton setTitle:_ZW[indexPath.section][indexPath.row] forState:UIControlStateNormal];
        _ZWbutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _ZWbutton.font = [UIFont boldSystemFontOfSize:kWidth*30];
        [_ZWbutton addTarget:self action:@selector(JsButtonbtn:) forControlEvents:UIControlEventTouchUpInside];
        [_ZWbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        NSString*zwtag = _Numm[indexPath.section][indexPath.row];
        int tag = [zwtag intValue];
        _ZWbutton.tag = tag;
        [cell addSubview:_ZWbutton];
        
        _view1 = [[UIView alloc]init];
        _view1.frame = CGRectMake(self.view.bounds.size.width/2+30, 6, 1, 30);
        
        
        _ZWLBbutton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/2+31, 1, self.view.bounds.size.width-(self.view.bounds.size.width/2+31), 38)];
        _ZWLBbutton.font = [UIFont boldSystemFontOfSize:kWidth*30];
        
        
        [_ZWLBbutton addTarget:self action:@selector(JsLBButtonbtn:) forControlEvents:UIControlEventTouchUpInside];
        
        if ([zwtag isEqual:@"2"]||[zwtag isEqual:@"5"]) {
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
        cell.textLabel.text = _codeAry[indexPath.section][indexPath.row];
        if ([cell.textLabel.text isEqualToString:@"管辖部门"]) {
            UIButton *GXBMbutt = [[UIButton alloc]init];
            GXBMbutt.frame = CGRectMake(120, 1, self.view.bounds.size.width-300, 38);
            [GXBMbutt setTitle:@"添加部门" forState:UIControlStateNormal];
            GXBMbutt.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
             GXBMbutt.font = [UIFont boldSystemFontOfSize:kWidth*30];
            [GXBMbutt addTarget:self action:@selector(TJButtonbtn:) forControlEvents:UIControlEventTouchUpInside];
            [GXBMbutt setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            //   _ZWbutton.tag = ivalue;
            [cell addSubview:GXBMbutt];
        }else{
            UIButton *SSBMbutt = [[UIButton alloc]init];
            SSBMbutt.frame = CGRectMake(120, 1, self.view.bounds.size.width-300, 38);
            [SSBMbutt setTitle:@"添加部门" forState:UIControlStateNormal];
            SSBMbutt.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            SSBMbutt.font = [UIFont boldSystemFontOfSize:kWidth*30];
            [SSBMbutt addTarget:self action:@selector(SSButtonbtn:) forControlEvents:UIControlEventTouchUpInside];
            [SSBMbutt setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            //   _ZWbutton.tag = ivalue;
            [cell addSubview:SSBMbutt];
        }
    }else{
        UILabel *XBTLabel  = [[UILabel alloc]initWithFrame:CGRectMake(120, 1, self.view.bounds.size.width-100, 38)];
        //NSLog(@"%@",_gxbmAry[indexPath.section][indexPath.row-2]);
        XBTLabel.text = _gxbmAry[indexPath.section][indexPath.row-2];
      
        XBTLabel.font = [UIFont boldSystemFontOfSize:kWidth*30];
        [cell addSubview:XBTLabel];
    }
    return cell;
}

#pragma mark UI
-(void)tableViewUI{
    infonTableview= [[UITableView alloc]initWithFrame:CGRectMake(0,5,Scree_width,Scree_height) style:UITableViewStylePlain];
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
    
    UIView *fotView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Scree_width, 60)];
    fotView.backgroundColor = [UIColor whiteColor];
    infonTableview.tableFooterView=fotView;
    
    
    UIButton *tjBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [tjBtn setTitle:@"添加职位" forState:UIControlStateNormal];
    [tjBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [tjBtn addTarget:self action:@selector(action_button) forControlEvents:UIControlEventTouchUpInside];
    [tjBtn setImage:[UIImage imageNamed:@"tj_ico01"] forState:UIControlStateNormal];
    tjBtn.imageEdgeInsets =  UIEdgeInsetsMake(5,30,5,tjBtn.titleLabel.left+30);
    [fotView addSubview:tjBtn];
    [tjBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(fotView.mas_left).offset(80);
        make.right.mas_equalTo(fotView.mas_right).offset(-80);
        make.top.mas_equalTo(fotView.mas_top).offset(3);
        make.height.mas_equalTo(50);
    }];
    UIView *view2 = [[UIView alloc]init];
    view2.backgroundColor = GetColor(201, 201, 201, 1);
    [fotView addSubview:view2];
    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.top.equalTo(tjBtn.mas_bottom).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.height.mas_equalTo(1);
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return _ZW.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 2+[_gxbmAry[section]count];
    /*
     (("\U672a\U5206\U914d",("\U5b9a\U4f4d","\U8272\U5f31\U65e0"),"\U672a\U5206\U914d"))

     */
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
     return 10;;
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
