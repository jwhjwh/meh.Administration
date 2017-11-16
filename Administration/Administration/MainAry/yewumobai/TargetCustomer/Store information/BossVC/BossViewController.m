//
//  BossViewController.m
//  Administration
//
//  Created by 九尾狐 on 2017/11/15.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "BossViewController.h"
#import "ZZYPhotoHelper.h"
@interface BossViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (nonatomic,retain)UITableView *tableView;
@property (nonatomic,strong) NSString *logImage;//头像地址

@property (nonatomic,strong)NSMutableArray *leftary;
@property (nonatomic,strong)NSMutableArray *ligary;
@property (nonatomic,strong)NSMutableArray *texttagary;
@property (nonatomic,strong)NSString *Name;
@property (nonatomic,strong)NSString *Phone;
@property (nonatomic,strong)NSString *QCode;
@property (nonatomic,strong)NSString *WCode;
@property (nonatomic,strong)NSString *Age;
@property (nonatomic,strong)NSString *Birthday;
@property (nonatomic,strong)NSString *Hobby;
@property (nonatomic,strong)NSString *OverallMerit;
@property (nonatomic,strong)NSString *ReviewsProposal;

@property (nonatomic,strong)UIImageView *TXImage;
@property (nonatomic,strong)NSMutableArray *iphoneAry;

@end

@implementation BossViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"老板信息";
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:(UIBarButtonItemStyleDone) target:self action:@selector(rightItemAction:)];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [rightitem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightitem;
    _leftary = [[NSMutableArray alloc]initWithObjects:@[@"照片"],@[@"老板姓名",@"老板电话",@"QQ",@"微信",@"年龄",@"生日",@"身份证",@"家庭情况",@"爱好",@"点评建议"], nil];
    _ligary = [[NSMutableArray alloc]initWithObjects:@[@""],@[@"填写老板姓名",@"",@"填写QQ号",@"填写微信",@"填写年龄",@"选择生日",@"填写身份证号",@"",@"填写爱好",@""], nil];
    _texttagary = [[NSMutableArray alloc]initWithObjects:@[@""],@[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"], nil];
    [self addViewremind];
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
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifi = @"gameCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifi];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifi];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
     cell.backgroundColor = [UIColor clearColor];
    UILabel *tlelabel = [[UILabel alloc]init];
    if (indexPath.section == 0) {
        tlelabel.frame = CGRectMake(10, 25, 50, 30);
    }else{
         tlelabel.frame = CGRectMake(10, 10, 110, 30);
    }
    tlelabel.text = _leftary[indexPath.section][indexPath.row];
    tlelabel.font = [UIFont systemFontOfSize:15.0f];
    [cell addSubview:tlelabel];
    
    if (indexPath.section == 0) {
        _TXImage = [[UIImageView alloc]initWithFrame:CGRectMake(120, 15, 50, 50)];
        if (_logImage.length<1) {
            _TXImage.image = [UIImage imageNamed:@"tjtx"];
        }else{
            [_TXImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURLHeader,_logImage]] placeholderImage:[UIImage  imageNamed:@"hp_ico"]];
        }
        _TXImage.backgroundColor = [UIColor whiteColor];
        _TXImage.layer.masksToBounds = YES;
        _TXImage.layer.cornerRadius = 25.0;//设置圆角
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPage3:)];
        [_TXImage addGestureRecognizer:tapGesturRecognizer];
        _TXImage.userInteractionEnabled = YES;
        [cell addSubview:_TXImage];
    }else{
        if (indexPath.row == 0) {
            //老板姓名
            UITextField *bossname = [[UITextField alloc]initWithFrame:CGRectMake(120, 10, cell.width-120, 30)];
            bossname.placeholder = _ligary[indexPath.section][indexPath.row];
            bossname.font = [UIFont systemFontOfSize:14.0f];
            placeholder(bossname);
            bossname.tag = 1;
            bossname.delegate = self;
            [bossname addTarget:self action:@selector(PersonFieldText:) forControlEvents:UIControlEventEditingChanged];
            [cell addSubview:bossname];
        }else if (indexPath.row == 1){
            //老板电话
            if (_iphoneAry.count>1) {
                for (int i= 0; i<_iphoneAry.count; i++) {
                    UILabel *iphonelabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 5+(i*20), cell.width-120-80, 19)];
                    iphonelabel.text = [NSString stringWithFormat:@"电话%d %@",i+1,_iphoneAry[i]];
                    iphonelabel.font = [UIFont systemFontOfSize:14];
                    [cell addSubview:iphonelabel];
                    UIView *whiview =[[UIView alloc]initWithFrame:CGRectMake(120, 5+((i-1)*19), cell.width-120-80, 1)];
                    whiview.backgroundColor = [UIColor lightGrayColor];
                    [cell addSubview:whiview];
                    
                    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(Scree_width-80, 5+(i*20), 30, 30)];
                    [button setImage:[UIImage imageNamed:@"xx_ico02"] forState:UIControlStateNormal];
                    [cell.contentView addSubview:button];
                }
            }else{
                    UILabel *iphonelabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 10, cell.width-120-80, 30)];
                    iphonelabel.text = [NSString stringWithFormat:@"电话 %@",_iphoneAry[0]];
                    iphonelabel.font = [UIFont systemFontOfSize:14];
                    [cell addSubview:iphonelabel];
                UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(Scree_width-100, 10, 30, 30)];
                [button setImage:[UIImage imageNamed:@"xx_ico02"] forState:UIControlStateNormal];
                [cell.contentView addSubview:button];
            }
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-40, (cell.height/2)-15, 30, 30)];
            [btn setImage:[UIImage imageNamed:@"tjdh"] forState:UIControlStateNormal];
            
            [btn addTarget: self action: @selector(addiphone) forControlEvents: UIControlEventTouchUpInside];
            [cell addSubview:btn];
        }else if(indexPath.row<7){
            
            UITextField *bossname = [[UITextField alloc]initWithFrame:CGRectMake(120, 10, cell.width-120, 30)];
            bossname.placeholder = _ligary[indexPath.section][indexPath.row];
            bossname.font = [UIFont systemFontOfSize:14.0f];
            placeholder(bossname);
            NSInteger k = [_texttagary[indexPath.section][indexPath.row] integerValue];
            bossname.tag = k;
            bossname.delegate = self;
            [bossname addTarget:self action:@selector(PersonFieldText:) forControlEvents:UIControlEventEditingChanged];
            [cell addSubview:bossname];
        }else if (indexPath.row ==8){
            //老板爱好
            UILabel *levelabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 10, cell.width-120, 30)];
            levelabel.font = [UIFont systemFontOfSize:14];
            levelabel.text = _ligary[indexPath.section][indexPath.row];
            levelabel.textColor = [UIColor lightGrayColor];
            [cell addSubview:levelabel];
        }else{
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;//右箭头
        }
    }
    return cell;
}
-(void)addiphone{
    
}
- (void)PersonFieldText:(UITextField *)textField{
    NSLog(@"%ld",(long)textField.tag);
}

-(void)tapPage3:(UITapGestureRecognizer*)sender
{
    
            [[ZZYPhotoHelper shareHelper] showImageViewSelcteWithResultBlock:^(id data) {
                _TXImage.image = (UIImage *)data;
                
            }];
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 80.0f;
    }else{
        return 50.0f;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_leftary[section]count];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _leftary.count;
}
-(void)rightItemAction:(UIBarButtonItem*)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)buLiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 补全分隔线左侧缺失
- (void)viewDidLayoutSubviews {
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    
    view.tintColor = GetColor(230,230,230,1);
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.textColor = [UIColor grayColor];
    header.textLabel.font = [UIFont systemFontOfSize:14.0f];
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0;
    }else{
        return 10;
    }
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString * str = [NSString stringWithFormat:@"  "];
    return str;
}
@end
