//
//  ContactsController.m
//  Administration
//
//  Created by 九尾狐 on 2017/2/14.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "ContactsController.h"
#define Start_X 10.0f           // 第一个按钮的X坐标
#define Start_Y 50.0f           // 第一个按钮的Y坐标
#define Width_Space 20.0f        // 2个按钮之间的横间距
#define Height_Space 20.0f      // 竖间距
#define Button_Height 65.0f    // 高
#define Button_Width 55.0f      // 宽
@interface ContactsController ()<UITabBarDelegate,UITableViewDelegate,UITableViewDataSource>
@property (strong,nonatomic) UIButton *sousuoBtn;//搜索框
@property (strong,nonatomic) UIView *view1;//第一条线
@property (strong,nonatomic) UILabel * lxLabel;//最近联系人Label
@property (strong,nonatomic) UITableView *ZJLXTable;//最近联系人列表
@property (nonatomic,strong)NSMutableArray *dataArray;//数据源


@end

@implementation ContactsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"通讯录";
    
    [self UIBtn];
}
-(void)UIBtn{
    //搜索按钮
    _sousuoBtn = [[UIButton alloc]init];
    UIImage *imageBtn = [UIImage imageNamed:@"ss_ico"];
    [_sousuoBtn setBackgroundImage:imageBtn forState:UIControlStateNormal];
    _sousuoBtn.layer.masksToBounds = YES;
    _sousuoBtn.layer.cornerRadius = 5.0;
    [_sousuoBtn addTarget:self action:@selector(Touchsearch)forControlEvents: UIControlEventTouchDragInside];
    [self.view addSubview:_sousuoBtn];
    [_sousuoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo (self.view.mas_left).offset(10);
        make.right.mas_equalTo(self.view.mas_right).offset(-10);
        make.top.mas_equalTo(self.view.mas_top).offset(70);
        make.height.mas_equalTo(40);
    }];
    //各部门按钮
    for (int i = 0 ; i < 4; i++) {
        NSInteger index = i % 4;
        NSInteger page = i / 4;
        UIButton *aBt = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        aBt.backgroundColor = [UIColor redColor];
        aBt.frame = CGRectMake(index * (Scree_width/4)+Height_Space, page  * (Button_Height + Height_Space)+Start_Y+70, Button_Width, Button_Height);
        [self.view addSubview:aBt];
    }
    //分割线
    _view1 = [[UIView alloc]init];
    _view1.backgroundColor = [UIColor colorWithRed:(188/255.0) green:(176/255.0) blue:(195/255.0) alpha:1];
    [self.view addSubview:_view1];
    [_view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.top.equalTo(_sousuoBtn.mas_bottom).offset(78);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.height.mas_equalTo(2);
    }];
    //最近联系人
    _lxLabel = [[UILabel alloc]init];
    _lxLabel.text= @"最近联系人";
    _lxLabel.textColor = [UIColor colorWithRed:(188/255.0) green:(176/255.0) blue:(195/255.0) alpha:1];
    _lxLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_lxLabel];
    [_lxLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(10);
        make.top.mas_equalTo(_view1.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    //最近联系人列表
    _ZJLXTable = [[UITableView alloc]init];
    _ZJLXTable.backgroundColor = [UIColor whiteColor];
    _ZJLXTable.separatorStyle = UITableViewCellSelectionStyleNone;
    _ZJLXTable.delegate = self;
    _ZJLXTable.dataSource = self;
    [self.view addSubview:_ZJLXTable];
    [_ZJLXTable registerNib:[UINib nibWithNibName:@"ZJLXRTableViewCell" bundle:nil] forCellReuseIdentifier:@"BASE"];
    [_ZJLXTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_lxLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(self.view.mas_left).offset(0);
        make.right.mas_equalTo(self.view.mas_right).offset(0);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-49);
    }];

}
-(void)Touchsearch{

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZJLXRTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BASE"forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:(242/255.0f) green:(242/255.0f) blue:(242/255.0f) alpha:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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