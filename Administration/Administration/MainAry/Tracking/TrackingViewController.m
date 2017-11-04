//
//  TrackingViewController.m
//  Administration
//
//  Created by 九尾狐 on 2017/3/23.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "TrackingViewController.h"
#import "GSPickerView.h"
#import "CItyViewController.h"

int str;
@interface TrackingViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UITableView *infonTableview;
    
}

@property (strong,nonatomic) NSArray *dateAry;

@property (strong,nonatomic) UIButton *qishiBtn;
@property (strong,nonatomic) UIButton *jieshuBtn;
@property (strong,nonatomic) UILabel* zhiLabel;
@property (nonatomic,strong) GSPickerView *pickerView;
@property (nonatomic,strong) NSString *qishiStr;
@property (nonatomic,strong) NSString *jieshuStr;
@property (strong,nonatomic) UILabel* dateLabel;
@property (nonatomic,strong) UITextField *codeField;



@property (nonatomic,strong) NSString *zxrStr;//执行人
@property (nonatomic,strong) NSString *zxppStr;
@property (nonatomic,strong) NSString *zxqyStr;
@property (nonatomic,strong) NSString *jtsjStr;
@property (nonatomic,strong) NSString *yqdcStr;
@property (nonatomic,strong) NSString *ydwtStr;
@property (nonatomic,strong) NSString *xsyjStr;
@property (nonatomic,strong) NSString *tsqkStr;
@property (nonatomic,strong) NSString *zjjlStr;


@end

@implementation TrackingViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden=YES;
}
- (GSPickerView *)pickerView{
    if (!_pickerView) {
        _pickerView = [[GSPickerView alloc]initWithFrame:self.view.bounds];
    }
    return _pickerView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"店家跟踪";
    str = [[USER_DEFAULTS objectForKey:@"roleId"]intValue];
    switch (str) {
            case 1:
            //总监
            _dateAry = [[NSArray alloc]initWithObjects:@"日期",@"执行人",@"执行品牌",@"执行区域",@"具体的时间规划",@"预期达成的时间",@"可能遇到的问题与困难",@"销售业绩",@"特殊情况",@"总结结论",nil];
            break;
        default:
             _dateAry = [[NSArray alloc]initWithObjects:@"日期",@"执行人",@"执行区域",@"执行店家",@"具体的时间规划",@"预期达成的时间",@"可能遇到的问题与困难",@"销售业绩",@"特殊情况",@"总结结论",nil];
            break;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buttonLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]
                                    initWithTitle:@"完成"
                                    style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(masgegeClick)];
    rightButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightButton;
    // Do any additional setup after loading the view.
    [self TrackingVCUI];
}
-(void)buttonLiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)masgegeClick{
    
}
-(void)TrackingVCUI{
    infonTableview= [[UITableView alloc]initWithFrame:CGRectMake(0, 64,kScreenWidth,kScreenHeight) style:UITableViewStylePlain];
    infonTableview.separatorStyle= UITableViewCellSeparatorStyleSingleLine;
    infonTableview.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    infonTableview.scrollEnabled =NO;
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    infonTableview.dataSource=self;
    infonTableview.delegate =self;
    [self.view addSubview:infonTableview];
    _qishiBtn = [[UIButton alloc]init];
    [_qishiBtn setTitle:@"起始日期" forState:UIControlStateNormal];
    _qishiBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [_qishiBtn setTitleColor:GetColor(96, 96, 96, 1) forState:UIControlStateNormal];
    [_qishiBtn addTarget:self action:@selector(qishiBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _jieshuBtn = [[UIButton alloc]init];
    [_jieshuBtn setTitle:@"结束日期" forState:UIControlStateNormal];
    _jieshuBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [_jieshuBtn setTitleColor:GetColor(96, 96, 96, 1) forState:UIControlStateNormal];
    [_jieshuBtn addTarget:self action:@selector(jieshuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _zhiLabel = [[UILabel alloc]init];
    _zhiLabel.text = @"至";
    _zhiLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    _zhiLabel.textColor = GetColor(96, 96, 96, 1);
    
    
    
    
    [self setExtraCellLineHidden:infonTableview];
}
-(void)qishiBtnClick:(UIButton *)btn
{
    NSString *str = @"2017年01月01日";
    if ([btn.titleLabel.text containsString:@"年"]) {
        str = btn.titleLabel.text;
    }
    [self.pickerView appearWithTitle:@"年月日" pickerType:GSPickerTypeDatePicker subTitles:nil selectedStr:str sureAction:^(NSInteger path, NSString *pathStr) {
        
        [btn setTitle:pathStr forState:UIControlStateNormal];
    } cancleAction:^{
        
    }];
    
}
-(void)jieshuBtnClick:(UIButton *)btn
{
    NSString *str = @"2017年01月01日";
    if ([btn.titleLabel.text containsString:@"年"]) {
        str = btn.titleLabel.text;
    }
    [self.pickerView appearWithTitle:@"年月日" pickerType:GSPickerTypeDatePicker subTitles:nil selectedStr:str sureAction:^(NSInteger path, NSString *pathStr) {
        
        [btn setTitle:pathStr forState:UIControlStateNormal];
    } cancleAction:^{
        
    }];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _dateAry.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 30;
    }
    switch (str) {
        case 1:
            if (indexPath.row == 3) {
                return 30;
            }
            break;
        default:
            if (indexPath.row == 2 ) {
                return 30;
            }else if (indexPath.row == 3){
                return 30;
            }
            break;
    }

    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     NSInteger row = [indexPath row];
    static NSString *CellIdentifier =@"Cell";
    //定义cell的复用性当处理大量数据时减少内存开销
    UITableViewCell *cell = [infonTableview  dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell ==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:CellIdentifier];
        if (indexPath.row != 3) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
    }
    if (indexPath.row == 0) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"日期";
         cell.textLabel.font=[UIFont systemFontOfSize:14];
         cell.textLabel.textColor = GetColor(96, 96, 96, 1);
        [cell addSubview:_zhiLabel];
        [_zhiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(cell.mas_centerY).offset(0);
            make.centerX.mas_equalTo(cell.mas_centerX).offset(0);
            make.width.mas_offset(20);
            make.height.mas_offset(30);
        }];
        [cell addSubview:_qishiBtn];
        [_qishiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(cell.mas_centerY).offset(0);
            make.left.mas_equalTo(cell.textLabel.mas_right).offset(10);
            make.right.mas_equalTo(_zhiLabel.mas_left).offset(-5);
            make.height.mas_offset(30);
        }];
        [cell addSubview:_jieshuBtn];
        [_jieshuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(cell.mas_centerY).offset(0);
            make.width.mas_equalTo(_qishiBtn.mas_width).offset(0);
            make.left.mas_equalTo(_zhiLabel.mas_right).offset(5);
            make.height.mas_offset(30);
        }];
    }else{
        _dateLabel = [[UILabel alloc]init];
        _dateLabel.font=[UIFont systemFontOfSize:14];
        _dateLabel.textColor = GetColor(96, 96, 96, 1);
        _dateLabel.text = _dateAry[indexPath.row];
        [cell addSubview:_dateLabel];
        _codeField = [[UITextField alloc]init];
        _codeField.font = [UIFont systemFontOfSize:14.0f];
        _codeField.placeholder = @"请输入内容";
           placeholder(_codeField);
        _codeField.tag = row;
         _codeField.delegate = self;
        [_codeField addTarget:self action:@selector(PersonFieldText:) forControlEvents:UIControlEventEditingChanged];
        [cell addSubview:_codeField];
            switch (str) {
            case 1:
                    if (indexPath.row == 1) {
                        [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.width.mas_equalTo(cell.mas_width).offset(-15);
                            make.height.mas_offset(cell.frame.size.height/2);
                            make.left.mas_equalTo(cell.mas_left).offset(15);
                            make.top.mas_equalTo(cell.mas_top).offset(0);
                        }];
                        [_codeField mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.top.mas_equalTo(_dateLabel.mas_bottom).offset(0);
                            make.bottom.mas_equalTo(cell.mas_bottom).offset(0);
                            make.left.mas_equalTo(cell.mas_left).offset(15);
                            make.right.mas_equalTo(cell.right).offset(0);
                        }];

                    }else if (indexPath.row == 3) {
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.width.mas_equalTo(cell.mas_width).offset(-15);
                        make.height.mas_offset(cell.frame.size.height/2);
                        make.left.mas_equalTo(cell.mas_left).offset(15);
                        make.centerY.mas_equalTo(cell.mas_centerY).offset(0);
                    }];
                }
                else{
                    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.width.mas_equalTo(cell.mas_width).offset(-15);
                        make.height.mas_offset(cell.frame.size.height/2);
                        make.left.mas_equalTo(cell.mas_left).offset(15);
                        make.top.mas_equalTo(cell.mas_top).offset(0);
                    }];
                    
                    [_codeField mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.mas_equalTo(_dateLabel.mas_bottom).offset(0);
                        make.bottom.mas_equalTo(cell.mas_bottom).offset(0);
                        make.left.mas_equalTo(cell.mas_left).offset(15);
                        make.right.mas_equalTo(cell.right).offset(0);
                    }];


                }
                break;
            default:
                    if (indexPath.row == 1) {
                        [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.width.mas_equalTo(cell.mas_width).offset(-15);
                            make.height.mas_offset(cell.frame.size.height/2);
                            make.left.mas_equalTo(cell.mas_left).offset(15);
                            make.top.mas_equalTo(cell.mas_top).offset(0);
                        }];
                        _codeField = [[UITextField alloc]init];
                        _codeField.font = [UIFont systemFontOfSize:14.0f];
                        _codeField.placeholder = @"请输入内容";
                                 placeholder(_codeField);
                        [cell addSubview:_codeField];
                        [_codeField mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.top.mas_equalTo(_dateLabel.mas_bottom).offset(0);
                            make.bottom.mas_equalTo(cell.mas_bottom).offset(0);
                            make.left.mas_equalTo(cell.mas_left).offset(15);
                            make.right.mas_equalTo(cell.right).offset(0);
                        }];
                        
                    }else if (indexPath.row == 3 ) {
                           cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                           [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                               make.width.mas_equalTo(cell.mas_width).offset(-15);
                               make.height.mas_offset(cell.frame.size.height/2);
                               make.left.mas_equalTo(cell.mas_left).offset(15);
                               make.centerY.mas_equalTo(cell.mas_centerY).offset(0);
                           }];
                       }
                       else if (indexPath.row ==2){
                           cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                           [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                               make.width.mas_equalTo(cell.mas_width).offset(-15);
                               make.height.mas_offset(cell.frame.size.height/2);
                               make.left.mas_equalTo(cell.mas_left).offset(15);
                               make.centerY.mas_equalTo(cell.mas_centerY).offset(0);
                           }];
                       }
                       else{
                           [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                               make.width.mas_equalTo(cell.mas_width).offset(-15);
                               make.height.mas_offset(cell.frame.size.height/2);
                               make.left.mas_equalTo(cell.mas_left).offset(15);
                               make.top.mas_equalTo(cell.mas_top).offset(0);
                           }];
                           
                       }
                break;
               }
        }

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (str) {
        case 1:
            if (indexPath.row == 3) {
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
                CItyViewController *cityVC = [[CItyViewController alloc]init];
                [cityVC returnText:^(NSString *showText) {
                    NSLog(@"showtext:%@",showText);
                                        //代码块中没有第二个视图控制器，所以不会造成循环引用
                }];
                [self.navigationController showViewController:cityVC sender:nil];
            }
            break;
        default:
            if (indexPath.row == 2) {
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
                CItyViewController *cityVC = [[CItyViewController alloc]init];
                [cityVC returnText:^(NSString *showText) {
                    NSLog(@"showtext:%@",showText);
                                        //代码块中没有第二个视图控制器，所以不会造成循环引用
                }];
                [self.navigationController showViewController:cityVC sender:nil];
            }else if (indexPath.row == 3) {
                
                NSLog(@"执行店家");
            }
            break; 
    }
    

}
- (void)PersonFieldText:(UITextField *)textField{
    NSLog(@"%ld",(long)textField.tag);
    switch (textField.tag) {
        case 1:
            if (textField.text.length>0) {
                NSLog(@"%@",textField.text);
                _zxrStr = textField.text;
            }
            break;
        case 2:
            if (textField.text.length>0) {
                _zxppStr = textField.text;
            }
            break;
        case 4:
            if (textField.text.length>0) {
                _jtsjStr = textField.text;
            }
            break;
        case 5:
            if (textField.text.length>0) {
                _yqdcStr = textField.text;
            }
            break;
        case 6:
            if (textField.text.length>0) {
                _ydwtStr = textField.text;
            }
            break;
        case 7:
            if (textField.text.length>0) {
                _xsyjStr = textField.text;
            }
            break;
        case 8:
            if (textField.text.length>0) {
                _tsqkStr = textField.text;
            }
            break;
        case 9:
            if (textField.text.length>0) {
                _zjjlStr = textField.text;
            }
            break;
            
        default:
            break;
    }
    

}
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
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
