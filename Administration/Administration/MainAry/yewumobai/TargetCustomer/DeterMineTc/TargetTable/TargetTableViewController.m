//
//  TargetTableViewController.m
//  Administration
//
//  Created by 九尾狐 on 2017/10/13.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "TargetTableViewController.h"
#import "TargetModel.h"
#import "CLZoomPickerView.h"
#import "inftionTableViewCell.h"
#import "SelectAlert.h"
#import "targetTextField.h"
#import "TargetViewController.h"
#import "StoreinforViewController.h"
#import "ShareColleagues.h"
#import "SiginViewController.h"//签到
#import "depatementViewController.h"
@interface TargetTableViewController ()<UITableViewDelegate,UITableViewDataSource,CLZoomPickerViewDelegate, CLZoomPickerViewDataSource,UITextFieldDelegate>

@property (nonatomic,strong)CLZoomPickerView *pickerView;
@property (nonatomic,retain)UITableView *tableView;
@property (nonatomic ,retain)NSArray *nameArrs;
@property (nonatomic ,retain)NSArray *placeholdernameArrs;
@property (nonatomic ,retain)NSArray *tagnameArrs;
@property (nonatomic ,retain)NSMutableArray* InterNameAry;
@property (strong,nonatomic) NSIndexPath *index;
@property (strong,nonatomic) NSArray *timeArray;

@property (strong,nonatomic) UIButton *yesbtn;
@property (strong,nonatomic) UIButton *nobtn;
@property (strong,nonatomic) UIButton *QKbtn;
@property (strong,nonatomic) UIButton *FQbtn;
@property (strong,nonatomic) UIButton *QTbtn;



//数据源
@property(strong,nonatomic)NSString *Province;//省
@property(strong,nonatomic)NSString *City;//市
@property(strong,nonatomic)NSString *County;//区
@property(strong,nonatomic)NSString *time;//拜访日期
@property(strong,nonatomic)NSString *meettime;//拜访时间段
@property(strong,nonatomic)NSString *num;//拜访次数
@property(strong,nonatomic)NSString *principal;//店铺负责人
@property(strong,nonatomic)NSString *post;//职务
@property(strong,nonatomic)NSString *iphone;//联系方式
@property(strong,nonatomic)NSString *qcode;//微信
@property(strong,nonatomic)NSString *storelevel;//店规模
@property(strong,nonatomic)NSString *berths;//床位数
@property(strong,nonatomic)NSString *beautician;//美容师人数
@property(strong,nonatomic)NSString *plantingduration;//开店年限
@property(strong,nonatomic)NSString *brandbusiness;//主要经营品牌
@property(strong,nonatomic)NSString *followbrand;//关注品牌
@property(strong,nonatomic)NSString *customernum;//终端顾客总数量
@property(strong,nonatomic)NSString *validnum;//有质量顾客数量
@property(strong,nonatomic)NSString *brandpos;//品牌定位
@property(strong,nonatomic)NSString *otherpos;//品牌定位的其他
@property(strong,nonatomic)NSString *singleprice;// 单品价格
@property(strong,nonatomic)NSString *boxprice;//套盒价格
@property(strong,nonatomic)NSString *cardprice;//卡项价格
@property(strong,nonatomic)NSString *packprice;// 项目套餐
@property(strong,nonatomic)NSString *flag;//本年是否做过大量收现活动
@property(strong,nonatomic)NSString *activename;//活动名称
@property(strong,nonatomic)NSString *dealmoney;//成交金额
@property(strong,nonatomic)NSString *leastmoney;//下限
@property(strong,nonatomic)NSString *dealrate;//成交率
@property(strong,nonatomic)NSString *demand;//运营协助需求
@property(strong,nonatomic)NSString *shopquestion;//店家问题简述
@property(strong,nonatomic)NSString *plans;//品牌介入策略及跟进规划
@property(strong,nonatomic)NSString *requirement;//店家要求事项及解决办法
@property(strong,nonatomic)NSString *notic;//同事协助须知
@property(strong,nonatomic)NSString *partnertime;//店家预定合作时间
@property(strong,nonatomic)NSString *scheme;//执行方案
@property(strong,nonatomic)NSString *amount;//合约金额
@property(strong,nonatomic)NSString *payway;//大款方式
@property(strong,nonatomic)NSString *written;//填表人
@property(strong,nonatomic)NSString *manager;//经理

@property(strong,nonatomic)NSString *StoreName;//店名
@property(strong,nonatomic)NSString *targetVisitId;//目标客户id
@property(strong,nonatomic)NSString *Address;//店铺地址
@property(strong,nonatomic)NSString *state;//是否已经合作

@property(strong,nonatomic)NSString *UserId;//分享同事
@property(strong,nonatomic)NSString *dipatement;//分享部门

@end

@implementation TargetTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"目标客户确立表";
    if (self.stringTitle) {
        self.title = @"目标客户";
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    _nameArrs = @[@[@"签到"],@[@"拜访日期",@"拜访时间段",@"拜访次数"],@[@"店名",@"地址",@"负责人",@"职务",@"固话/手机",@"微信号"],@[@"店规模",@"床位",@"美容师人数",@"开店年限",@"主要经营品牌",@"关注品牌"],@[@"目前了解信息:"],@[@"店家问题简述",@"品牌介入策略及跟进规划",@"店家要求事项及解决办法",@"同事协助须知"],@[@"店家预合作时间:",@"执行方案:",@"合约金额:"],@[@"打款方式"]];
    _placeholdernameArrs = @[@[],@[@"选择日期",@"如:10:00点-12:30分",@"选择拜访次数"],@[@"填写店名",@"填写店铺地址",@"填写负责人",@"填写职务",@"填写联系方式",@"填写微信号"],@[@"选择店规模",@"选择床位",@"选择美容师人数",@"选择开店年限",@"填写主要经营品牌",@"填写关注品牌"]];
    _tagnameArrs =@[@[],@[@"",@"12",@""],@[@"21",@"22",@"23",@"24",@"25",@"26"],@[@"31",@"32",@"33",@"34",@"35",@"36"]];
    [self targettableui];
    [self selectTargetVisit];
    NSMutableArray *array=[NSMutableArray array];
    for (int i=1; i<101; i++) {
        [array addObject:[NSString stringWithFormat:@"%d",i]];
    }
    _timeArray=[NSArray arrayWithArray:array];
}
-(void)targettableui{
    self.tableView= [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
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
    
    TargetModel *model=[[TargetModel alloc]init];
    model = _InterNameAry[0];
    if(indexPath.section <4){
        inftionTableViewCell *cell = [[inftionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bcCell"];
      
        
        if (cell ==nil)
        {
            cell = [[inftionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bcCell"];
        }
        if (indexPath.section ==0) {
             cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIImageView *qdimage = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width/2)-30, 10, 30, 30)];
            qdimage.image = [UIImage imageNamed:@"qd_ico"];
            [cell addSubview:qdimage];
            
            UILabel *qdlabel = [[UILabel alloc]initWithFrame:CGRectMake(((self.view.frame.size.width/2)-30)+30, 10, 50, 30)];
            qdlabel.text = _nameArrs[indexPath.section][indexPath.row];
            [cell addSubview:qdlabel];
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;//右箭头
        }else if(indexPath.section == 1){
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.mingLabel.text =_nameArrs[indexPath.section][indexPath.row];
            if (indexPath.row==0) {
                 cell.userInteractionEnabled = _cellend;
                if (model.Time ==nil) {
                    
                    cell.xingLabel.textColor = [UIColor lightGrayColor];
                    cell.xingLabel.text =_placeholdernameArrs[indexPath.section][indexPath.row];
                }else{
                    NSString *xxsj =  [[NSString alloc]initWithFormat:@"%@", [model.Time substringWithRange:NSMakeRange(0, 10)]];
                    cell.xingLabel.text = xxsj;
                }
                
                
            }else if (indexPath.row == 1){
                UITextField *sjduan = [[UITextField alloc]initWithFrame:CGRectMake(120, 10, cell.width-120, 30)];
                //----------------------------------------------
                [sjduan addTarget:self action:@selector(FieldText:) forControlEvents:UIControlEventEditingChanged];
                sjduan.placeholder = _placeholdernameArrs[indexPath.section][indexPath.row];
                NSInteger k = [_tagnameArrs[indexPath.section][indexPath.row] integerValue];
                sjduan.tag = k;
                if (![_meettime isEqualToString:@""]) {
                    sjduan.text = _meettime;
                }
                [cell addSubview:sjduan];
                 cell.userInteractionEnabled = _cellend;
            }else{
                if ([_num isEqualToString:@""]) {
                    cell.xingLabel.textColor = [UIColor lightGrayColor];
                    cell.xingLabel.text =_placeholdernameArrs[indexPath.section][indexPath.row];
                }else{
                    cell.xingLabel.textColor = [UIColor blackColor];
                    cell.xingLabel.text =_num;
                }
                 cell.userInteractionEnabled = _cellend;
            }
            
        }else if(indexPath.section == 2){
             cell.userInteractionEnabled = _cellend;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.mingLabel.text =_nameArrs[indexPath.section][indexPath.row];
            UITextField *section2 = [[UITextField alloc]initWithFrame:CGRectMake(120, 10, cell.width-120, 30)];
         [section2 addTarget:self action:@selector(FieldText:) forControlEvents:UIControlEventEditingChanged];
            section2.placeholder = _placeholdernameArrs[indexPath.section][indexPath.row];
            NSInteger k = [_tagnameArrs[indexPath.section][indexPath.row] integerValue];
            section2.tag = k;
            if (indexPath.row == 0) {
                //店名StoreName
                section2.text = _StoreName;
            }else if (indexPath.row == 1) {
                //店铺地址
                section2.text = _Address;
            }else if (indexPath.row == 2) {
                //负责人
                if (![_principal isEqualToString:@""]) {
                    section2.text = _principal;
                }
            }else if (indexPath.row == 3) {
                //职务
                if (![_post isEqualToString:@""]) {
                    section2.text = _post;
                }
            }else if (indexPath.row == 4) {
                //联系方式
                if (![_iphone isEqualToString:@""]) {
                    section2.text = _iphone;
                }
            }else if (indexPath.row == 5) {
                //微信
                if (![_qcode isEqualToString:@""]) {
                    section2.text = _qcode;
                }
            }
            
            [cell addSubview:section2];
            
            
        }else if(indexPath.section == 3){
             cell.userInteractionEnabled = _cellend;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.mingLabel.text =_nameArrs[indexPath.section][indexPath.row];
            if (indexPath.row==4) {
                cell.mingLabel.font = [UIFont systemFontOfSize:14];
            }
            if (indexPath.row == 0) {
                if (![_storelevel isEqualToString:@""]) {
                    cell.xingLabel.text = _storelevel;
                }else{
                    cell.xingLabel.text =_placeholdernameArrs[indexPath.section][indexPath.row];
                    cell.xingLabel.textColor = [UIColor lightGrayColor];
                }
            }else if(indexPath.row==1){
                if (![_berths isEqualToString:@""]) {
                    cell.xingLabel.text = _berths;
                }else{
                    cell.xingLabel.text =_placeholdernameArrs[indexPath.section][indexPath.row];
                    cell.xingLabel.textColor = [UIColor lightGrayColor];
                }
            }else if(indexPath.row==2){
                if (![_beautician isEqualToString:@""]) {
                    cell.xingLabel.text = _beautician;
                }else{
                    cell.xingLabel.text =_placeholdernameArrs[indexPath.section][indexPath.row];
                    cell.xingLabel.textColor = [UIColor lightGrayColor];
                }
            }else if(indexPath.row==3){
                if (![_plantingduration isEqualToString:@""]) {
                    cell.xingLabel.text = _plantingduration;
                }else{
                    cell.xingLabel.text =_placeholdernameArrs[indexPath.section][indexPath.row];
                    cell.xingLabel.textColor = [UIColor lightGrayColor];
                }
            }else{
                UITextField *section3 = [[UITextField alloc]initWithFrame:CGRectMake(120, 10, cell.width-120, 30)];
              [section3 addTarget:self action:@selector(FieldText:) forControlEvents:UIControlEventEditingChanged];
                section3.placeholder = _placeholdernameArrs[indexPath.section][indexPath.row];
                NSInteger k = [_tagnameArrs[indexPath.section][indexPath.row] integerValue];
                section3.tag = k;
                
                if (indexPath.row ==4) {
                    if (![_brandbusiness isEqualToString:@""]) {
                        section3.text = _brandbusiness;
                    }
                }else if (indexPath.row ==5){
                    if (![_followbrand isEqualToString:@""]) {
                        section3.text = _followbrand;
                    }
                }
                [cell addSubview:section3];
            }
        }
         return cell;
    }else{
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bcCell"];
        if (cell ==nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bcCell"];
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if(indexPath.section == 4){
             cell.userInteractionEnabled = _cellend;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel *tlelabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 120, 30)];
            tlelabel.text = _nameArrs[indexPath.section][indexPath.row];
            tlelabel.font = [UIFont systemFontOfSize:14];
            [cell addSubview:tlelabel];
            
            UILabel *zdsllabel =[[UILabel alloc]initWithFrame:CGRectMake(10, 40, 120, 30)];
            zdsllabel.text = @"1.终端顾客总数量：";
            zdsllabel.font = [UIFont systemFontOfSize:13];
            [cell addSubview:zdsllabel];
            targetTextField *zdsltextfield =[[targetTextField alloc]initWithFrame:CGRectMake(130, 40, 70, 30)];
            zdsltextfield.font= [UIFont systemFontOfSize:13];
            zdsltextfield.keyboardType = UIKeyboardTypeNumberPad;
            [zdsltextfield addTarget:self action:@selector(FieldText:) forControlEvents:UIControlEventEditingChanged];
            zdsltextfield.tag = 41;
            zdsltextfield.delegate = self;
            if (![_customernum isEqualToString:@""]) {
                zdsltextfield.text = _customernum;
            }
            [cell addSubview:zdsltextfield];
            UILabel *renlabel = [[UILabel alloc]initWithFrame:CGRectMake(200, 40, 40, 30)];
            renlabel.text = @"人,";
            renlabel.font = [UIFont systemFontOfSize:13];
            [cell addSubview:renlabel];
            
            UILabel *zlsllabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 70, 100, 30)];
            zlsllabel.text = @"有质量顾客数量:";
            zlsllabel.font = [UIFont systemFontOfSize:13];
            [cell addSubview:zlsllabel];
            targetTextField *zlsltextfield =[[targetTextField alloc]initWithFrame:CGRectMake(110, 70, 70, 30)];
            zlsltextfield.font= [UIFont systemFontOfSize:13];
            zlsltextfield.keyboardType = UIKeyboardTypeNumberPad;
            [zlsltextfield addTarget:self action:@selector(FieldText:) forControlEvents:UIControlEventEditingChanged];
            zlsltextfield.tag = 42;
            zlsltextfield.delegate = self;
            if (![_validnum isEqualToString:@""]) {
                zlsltextfield.text = _validnum;
            }
            [cell addSubview:zlsltextfield];
            UILabel *renlabel1 = [[UILabel alloc]initWithFrame:CGRectMake(180, 70, 40, 30)];
            renlabel1.text = @"人,";
            renlabel1.font = [UIFont systemFontOfSize:13];
            [cell addSubview:renlabel1];
            
            UILabel *xqdwlabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 110, 100, 30)];
            xqdwlabel.text = @"2.需求品牌定位:";
            xqdwlabel.font = [UIFont systemFontOfSize:13];
            [cell addSubview:xqdwlabel];
            
            UIButton *xqdwbtn = [[UIButton alloc]initWithFrame:CGRectMake(110, 110, 70, 28)];
            xqdwbtn.titleLabel.font = [UIFont systemFontOfSize:13];
            [xqdwbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [xqdwbtn addTarget:self action:@selector(xqdwtextField:)forControlEvents: UIControlEventTouchUpInside];
            [cell.contentView addSubview:xqdwbtn];
            UIView *btnview = [[UIView alloc]initWithFrame:CGRectMake(110, 138, 70, 1)];
            btnview.backgroundColor = [UIColor blackColor];
            [cell addSubview:btnview];
            

            
            
            UILabel *renlabel2 = [[UILabel alloc]initWithFrame:CGRectMake(180, 110, 40, 30)];
            renlabel2.text = @",";
            renlabel2.font = [UIFont systemFontOfSize:13];
            [cell addSubview:renlabel2];
            
            UILabel *qtlabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 150, 110, 30)];
            qtlabel.text = @"其他:";
            qtlabel.font = [UIFont systemFontOfSize:13];
            [cell addSubview:qtlabel];
            targetTextField *qttextfield =[[targetTextField alloc]initWithFrame:CGRectMake(10, 180, cell.width-30, 30)];
            //UIKeyboardTypeDefault
           
            qttextfield.font= [UIFont systemFontOfSize:13];
            [qttextfield addTarget:self action:@selector(FieldText:) forControlEvents:UIControlEventEditingChanged];
            qttextfield.tag = 44;
            if (_otherpos.length>0) {
                qttextfield.text = _otherpos;
            }
            [cell addSubview:qttextfield];
            
            UILabel *zdgklabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 210, 150, 30)];
            zdgklabel.text = @"3.终端顾客消费能力:";
            zdgklabel.font = [UIFont systemFontOfSize:13];
            [cell addSubview:zdgklabel];
            
            UILabel *renlabel3 = [[UILabel alloc]initWithFrame:CGRectMake(10, 240, 40, 30)];
            renlabel3.text = @"单品约";
            renlabel3.font = [UIFont systemFontOfSize:13];
            [cell addSubview:renlabel3];
            targetTextField *zdgktextfield =[[targetTextField alloc]initWithFrame:CGRectMake(50, 240, 70, 30)];
            zdgktextfield.font= [UIFont systemFontOfSize:13];
            zdgktextfield.keyboardType = UIKeyboardTypeNumberPad;
            [zdgktextfield addTarget:self action:@selector(FieldText:) forControlEvents:UIControlEventEditingChanged];
            zdgktextfield.tag = 45;
            if (_singleprice.length>0) {
                zdgktextfield.text = _singleprice;
            }
            [cell addSubview:zdgktextfield];
            UILabel *renlabel4 = [[UILabel alloc]initWithFrame:CGRectMake(120, 240, 60, 30)];
            renlabel4.text = @"元,套盒约";
            renlabel4.font = [UIFont systemFontOfSize:13];
            [cell addSubview:renlabel4];
            targetTextField *thytextfield =[[targetTextField alloc]initWithFrame:CGRectMake(180, 240, 70, 30)];
            thytextfield.font= [UIFont systemFontOfSize:13];
            thytextfield.keyboardType = UIKeyboardTypeNumberPad;
            [thytextfield addTarget:self action:@selector(FieldText:) forControlEvents:UIControlEventEditingChanged];
            thytextfield.tag = 46;
            if (_boxprice.length>0) {
                thytextfield.text = _boxprice;
            }
            [cell addSubview:thytextfield];
            UILabel *renlabel5 = [[UILabel alloc]initWithFrame:CGRectMake(250, 240,40, 30)];
            renlabel5.text = @"元,";
            renlabel5.font = [UIFont systemFontOfSize:13];
            [cell addSubview:renlabel5];
            
            UILabel *renlabel6 = [[UILabel alloc]initWithFrame:CGRectMake(10, 270, 40, 30)];
            renlabel6.text = @"卡项约";
            renlabel6.font = [UIFont systemFontOfSize:13];
            [cell addSubview:renlabel6];
            targetTextField *kxytextfield =[[targetTextField alloc]initWithFrame:CGRectMake(50, 270, 70, 30)];
            kxytextfield.font= [UIFont systemFontOfSize:13];
             kxytextfield.keyboardType = UIKeyboardTypeNumberPad;
            [kxytextfield addTarget:self action:@selector(FieldText:) forControlEvents:UIControlEventEditingChanged];
            kxytextfield.tag = 47;
            if (_cardprice.length>0) {
                kxytextfield.text = _cardprice;
            }
            [cell addSubview:kxytextfield];
            UILabel *renlabel7 = [[UILabel alloc]initWithFrame:CGRectMake(120, 270, 80, 30)];
            renlabel7.text = @"元,项目套餐";
            renlabel7.font = [UIFont systemFontOfSize:13];
            [cell addSubview:renlabel7];
            targetTextField *xmtctextfield =[[targetTextField alloc]initWithFrame:CGRectMake(200, 270, 70, 30)];
            xmtctextfield.font= [UIFont systemFontOfSize:13];
             xmtctextfield.keyboardType = UIKeyboardTypeNumberPad;
            [xmtctextfield addTarget:self action:@selector(FieldText:) forControlEvents:UIControlEventEditingChanged];
            xmtctextfield.tag = 48;
            if (_packprice.length>0) {
                xmtctextfield.text = _packprice;
            }
            [cell addSubview:xmtctextfield];
            UILabel *renlabel8 = [[UILabel alloc]initWithFrame:CGRectMake(270, 270, 40, 30)];
            renlabel8.text = @"元;";
            renlabel8.font = [UIFont systemFontOfSize:13];
            [cell addSubview:renlabel8];
            
            UILabel *renlabel9 = [[UILabel alloc]initWithFrame:CGRectMake(10, 300, 50, 30)];
            renlabel9.text = @"4.本年[";
            renlabel9.font = [UIFont systemFontOfSize:13];
            [cell addSubview:renlabel9];
            
           
            _yesbtn = [[UIButton alloc]initWithFrame:CGRectMake(60, 300, 40, 30)];
            if ([_flag isEqualToString:@"1"]) {
                [_yesbtn setImage:[UIImage imageNamed:@"xk_ico02"] forState:UIControlStateNormal];
                [_yesbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }else{
                 [_yesbtn setImage:[UIImage imageNamed:@"xk_ico01"] forState:UIControlStateNormal];
                [_yesbtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            }
           
            [_yesbtn setTitle:@"是" forState:UIControlStateNormal];
            _yesbtn.tag = 49;
            _yesbtn.titleLabel.font = [UIFont systemFontOfSize:13];
            
            [_yesbtn addTarget:self action:@selector(buttonNotPresss:)forControlEvents: UIControlEventTouchUpInside];
            [cell.contentView addSubview:_yesbtn];
            
            _nobtn = [[UIButton alloc]initWithFrame:CGRectMake(100, 300, 40, 30)];
            if ([_flag isEqualToString:@"2"]) {
                [_nobtn setImage:[UIImage imageNamed:@"xk_ico02"] forState:UIControlStateNormal];
                [_nobtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }else{
                [_nobtn setImage:[UIImage imageNamed:@"xk_ico01"] forState:UIControlStateNormal];
                [_nobtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            }
            
            [_nobtn setTitle:@"否" forState:UIControlStateNormal];
            _nobtn.tag = 50;
            _nobtn.titleLabel.font = [UIFont systemFontOfSize:13];
            
            [_nobtn addTarget:self action:@selector(buttonNotPresss:)forControlEvents: UIControlEventTouchUpInside];
            [cell.contentView addSubview:_nobtn];
            
            UILabel *renlabel10 = [[UILabel alloc]initWithFrame:CGRectMake(140, 300, 120, 30)];
            renlabel10.text = @"]做过大量收现活动,";
            renlabel10.font = [UIFont systemFontOfSize:13];
            [cell addSubview:renlabel10];
            
            UILabel *yyxzlabel = [[UILabel alloc]init];
            targetTextField *yyxztextfield =[[targetTextField alloc]init];
            yyxzlabel.text = @"5.运营协助需求:";
            yyxzlabel.font = [UIFont systemFontOfSize:13];
            yyxztextfield.font = [UIFont systemFontOfSize:13];
            [yyxztextfield addTarget:self action:@selector(FieldText:) forControlEvents:UIControlEventEditingChanged];
            yyxztextfield.tag = 55;
            if (_demand.length>0) {
                yyxztextfield.text = _demand;
            }
            
            if ([_flag isEqualToString:@"1"]) {
                //是
                UILabel *hdmclabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 330, 75, 30)];
                hdmclabel.text = @"活动名称为:";
                hdmclabel.font = [UIFont systemFontOfSize:13];
                [cell addSubview:hdmclabel];
                
                targetTextField *hdmctextfield = [[targetTextField alloc]initWithFrame:CGRectMake(80, 330, 110, 30)];
                hdmctextfield.font = [UIFont systemFontOfSize:13];
                
                [hdmctextfield addTarget:self action:@selector(FieldText:) forControlEvents:UIControlEventEditingChanged];
                hdmctextfield.tag = 51;
                if (_activename.length>0) {
                    hdmctextfield.text = _activename;
                }
                [cell addSubview:hdmctextfield];
                
                UILabel *hdmclabel1 = [[UILabel alloc]initWithFrame:CGRectMake(190, 330, 35, 30)];
                hdmclabel1.text = @",成交";
                hdmclabel1.font = [UIFont systemFontOfSize:13];
                [cell addSubview:hdmclabel1];
                
                targetTextField *hdmctextfield1 = [[targetTextField alloc]initWithFrame:CGRectMake(225, 330, 70, 30)];
                hdmctextfield1.font = [UIFont systemFontOfSize:13];
                hdmctextfield1.keyboardType = UIKeyboardTypeNumberPad;
                [hdmctextfield1 addTarget:self action:@selector(FieldText:) forControlEvents:UIControlEventEditingChanged];
                hdmctextfield1.tag = 52;
                if (_dealmoney.length>0) {
                    hdmctextfield1.text = _dealmoney;
                }
                [cell addSubview:hdmctextfield1];
                
                UILabel *wylabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 360, 90, 30)];
                wylabel.text = @"万元,套餐下限";
                wylabel.font = [UIFont systemFontOfSize:13];
                [cell addSubview:wylabel];
                
                targetTextField *tcxxtextfield1 = [[targetTextField alloc]initWithFrame:CGRectMake(100, 360, 70, 30)];
                tcxxtextfield1.font = [UIFont systemFontOfSize:13];
                  tcxxtextfield1.keyboardType = UIKeyboardTypeNumberPad;
                [tcxxtextfield1 addTarget:self action:@selector(FieldText:) forControlEvents:UIControlEventEditingChanged];
                tcxxtextfield1.tag = 53;
                if (_leastmoney.length>0) {
                    tcxxtextfield1.text = _leastmoney;
                }
                [cell addSubview:tcxxtextfield1];
                
                UILabel *wylabel1 = [[UILabel alloc]initWithFrame:CGRectMake(170, 360, 30, 30)];
                wylabel1.text = @"元,";
                wylabel1.font = [UIFont systemFontOfSize:13];
                [cell addSubview:wylabel1];
                
                UILabel *cjllabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 390, 60, 30)];
                cjllabel.text = @"成交率约";
                cjllabel.font = [UIFont systemFontOfSize:13];
                [cell addSubview:cjllabel];
                
                targetTextField *cjltextfield1 = [[targetTextField alloc]initWithFrame:CGRectMake(70, 390, 70, 30)];
                cjltextfield1.font = [UIFont systemFontOfSize:13];
                cjltextfield1.keyboardType = UIKeyboardTypeNumberPad;
                [cjltextfield1 addTarget:self action:@selector(FieldText:) forControlEvents:UIControlEventEditingChanged];
                cjltextfield1.tag = 54;
                if (_dealrate.length>0) {
                    cjltextfield1.text = _dealrate;
                }
                [cell addSubview:cjltextfield1];
                
                UILabel *bfblabel = [[UILabel alloc]initWithFrame:CGRectMake(140, 390, 30, 30)];
                bfblabel.text = @"%;";
                bfblabel.font = [UIFont systemFontOfSize:13];
                [cell addSubview:bfblabel];
                
                yyxzlabel.frame = CGRectMake(10, 420, 120, 30);
                yyxztextfield.frame = CGRectMake(10, 450, cell.width-20, 30);
                
            }else{
                //否
                yyxzlabel.frame = CGRectMake(10, 330, 120, 30);
                yyxztextfield.frame = CGRectMake(10, 360, cell.width-20, 30);
            }
            [cell addSubview:yyxzlabel];
            [cell addSubview:yyxztextfield];
            
            
        }else if(indexPath.section == 5){
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;//右箭头
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel *tlelabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, cell.width, 30)];
            tlelabel.text = _nameArrs[indexPath.section][indexPath.row];
            [cell addSubview:tlelabel];
            
        }else if(indexPath.section == 6){
             cell.userInteractionEnabled = _cellend;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel *tlelabel = [[UILabel alloc]init];
            tlelabel.text = _nameArrs[indexPath.section][indexPath.row];
            [cell addSubview:tlelabel];
            
            targetTextField *djhztextfield = [[targetTextField alloc]init];
            djhztextfield.font = [UIFont systemFontOfSize:13];
            [djhztextfield addTarget:self action:@selector(FieldText:) forControlEvents:UIControlEventEditingChanged];
            [cell addSubview:djhztextfield];
            if (indexPath.row == 0) {
                tlelabel.frame =CGRectMake(10, 10, 140, 30);
                djhztextfield.frame =CGRectMake(140, 10, cell.width-140, 30);
                djhztextfield.tag = 61;
                if (_partnertime.length>0) {
                    djhztextfield.text = _partnertime;
                }
            }else if(indexPath.row == 1){
                tlelabel.frame =CGRectMake(10, 10, 100, 30);
                djhztextfield.frame =CGRectMake(100, 10, cell.width-100, 30);
                djhztextfield.tag = 62;
                if (_scheme.length>0) {
                    djhztextfield.text = _scheme;
                }
            }else if(indexPath.row == 2){
                tlelabel.frame =CGRectMake(10, 10, 100, 30);
                djhztextfield.frame =CGRectMake(100, 10, cell.width-100, 30);
                djhztextfield.tag = 63;
                if (_amount.length>0) {
                    djhztextfield.text = _amount;
                }
            }
            
            
        }else if(indexPath.section == 7){
             cell.userInteractionEnabled = _cellend;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel *tlelabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, cell.width, 30)];
            tlelabel.text = _nameArrs[indexPath.section][indexPath.row];
            [cell addSubview:tlelabel];
            
            _QKbtn = [[UIButton alloc]init];
            _QKbtn.frame = CGRectMake(10, 50, 50, 30);
            [_QKbtn setTitle:@"全款" forState:UIControlStateNormal];
            _QKbtn.tag = 73;
            _QKbtn.titleLabel.font = [UIFont systemFontOfSize:15];
            [_QKbtn addTarget:self action:@selector(buttonNotPresss:)forControlEvents: UIControlEventTouchUpInside];
            if ([_payway isEqualToString:@"1"]) {
                [_QKbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }else{
                [_QKbtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            }
            
            [cell addSubview:_QKbtn];
            
            _FQbtn = [[UIButton alloc]init];
            _FQbtn.frame = CGRectMake(80, 50, 50, 30);
            _FQbtn.tag = 74;
            [_FQbtn setTitle:@"分期" forState:UIControlStateNormal];
            _FQbtn.titleLabel.font = [UIFont systemFontOfSize:15];
            [_FQbtn addTarget:self action:@selector(buttonNotPresss:)forControlEvents: UIControlEventTouchUpInside];
            if ([_payway isEqualToString:@"2"]) {
                [_FQbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }else{
                [_FQbtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            }
            [cell addSubview:_FQbtn];
           
            _QTbtn = [[UIButton alloc]init];
            _QTbtn.frame = CGRectMake(150, 50, 120, 30);
            _QTbtn.tag = 75;
            [_QTbtn setTitle:@"其它方式" forState:UIControlStateNormal];
            _QTbtn.titleLabel.font = [UIFont systemFontOfSize:15];
            [_QTbtn addTarget:self action:@selector(buttonNotPresss:)forControlEvents: UIControlEventTouchUpInside];
            if ([_payway isEqualToString:@"3"]) {
                [_QTbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }else{
                [_QTbtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            }
            
            [cell addSubview:_QTbtn];
            
            UILabel *tbrlabel = [[UILabel alloc]init];
            tbrlabel.frame = CGRectMake(10, 100, 80, 30);
            tbrlabel.text = @"填表人:";
            [cell addSubview:tbrlabel];
            
            targetTextField *tbrtextfield = [[targetTextField alloc]init];
            tbrtextfield.frame = CGRectMake(100, 100, cell.width-100, 30);
            [tbrtextfield addTarget:self action:@selector(FieldText:) forControlEvents:UIControlEventEditingChanged];
            tbrtextfield.tag = 71;
            if (_written.length>0) {
                tbrtextfield.text = _written;
            }
            [cell addSubview:tbrtextfield];
            
            UILabel *zgjllabel = [[UILabel alloc]init];
            zgjllabel.frame = CGRectMake(10, 140, 80, 30);
            zgjllabel.text = @"主管经理:";
            [cell addSubview:zgjllabel];
            
            targetTextField *zgjltextfield = [[targetTextField alloc]init];
            zgjltextfield.frame = CGRectMake(100, 140, cell.width-100, 30);
            [zgjltextfield addTarget:self action:@selector(FieldText:) forControlEvents:UIControlEventEditingChanged];
            zgjltextfield.tag = 72;
            if (_manager.length>0) {
                zgjltextfield.text = _manager;
            }
            [cell addSubview:zgjltextfield];
            
        }else if(indexPath.section ==8){
            if (_cellend ==NO) {
                UILabel *dangqian = [[UILabel alloc]init];
                UIImageView *tongs = [[UIImageView alloc]init];
                UILabel *fents = [[UILabel alloc]init];
                UIImageView *fenbm = [[UIImageView alloc]init];
                fenbm.image = [UIImage imageNamed:@"fx_icof"];
                [cell addSubview:fenbm];
                UILabel *fenbmlabel = [[UILabel alloc]init];
                fenbmlabel.text = @"已分享部门";
                fenbmlabel.font = [UIFont systemFontOfSize:11];
                fenbmlabel.textColor = GetColor(113, 180, 114, 1);
                [cell addSubview:fenbmlabel];
                UIImageView *yishengji = [[UIImageView alloc]init];
                UILabel *yisj = [[UILabel alloc]init];
                dangqian.text = _nameArrs[indexPath.section][indexPath.row];
                dangqian.font = [UIFont systemFontOfSize:12];
                [cell addSubview:dangqian];
                tongs.image = [UIImage imageNamed:@"fx_ico"];
                [cell addSubview:tongs];
                fents.text = @"已分享同事";
                fents.font = [UIFont systemFontOfSize:11];
                fents.textColor = GetColor(230, 165, 108, 1);
                [cell addSubview:fents];
                yishengji.image = [UIImage imageNamed:@"tj__ico01"];
                [cell addSubview:yishengji];
                yisj.text = @"以升级目标客户";
                yisj.font = [UIFont systemFontOfSize:11];
                yisj.textColor =  GetColor(158, 91, 185, 1);
                [cell addSubview:yisj];
                if ([_UserId isEqualToString:@"<null>"]) {
                    if ([_dipatement isEqualToString:@"<null>"]) {
                        if ([_state isEqualToString:@"<null>"]) {
                        }else{
                            dangqian.frame = CGRectMake(10, 10, 70, 30);
                            yishengji.frame =CGRectMake(80, 17.5, 15, 15);
                            yisj.frame = CGRectMake(100, 10, 90, 30);
                        }
                    }else{
                        dangqian.frame = CGRectMake(10, 10, 70, 30);
                        fenbm.frame = CGRectMake(80, 17.5, 15, 15);
                        fenbmlabel.frame = CGRectMake(100, 10, 70, 30);
                        if ([_state isEqualToString:@"<null>"]) {
                        }else{
                            yishengji.frame =CGRectMake(170, 17.5, 15, 15);
                            yisj.frame = CGRectMake(190, 10, 90, 30);
                        }
                    }
                }else{
                    dangqian.frame = CGRectMake(10, 10, 70, 30);
                    tongs.frame =CGRectMake(80, 17.5, 15, 15);
                    fents.frame = CGRectMake(100, 10, 70, 30);
                    if ([_dipatement isEqualToString:@"<null>"]) {
                        if ([_state isEqualToString:@"<null>"]) {
                        }else{
                            yishengji.frame =CGRectMake(170, 17.5, 15, 15);
                            yisj.frame = CGRectMake(190, 10, 90, 30);
                        }
                    }else{
                        fenbm.frame = CGRectMake(170, 17.5, 15, 15);
                        fenbmlabel.frame = CGRectMake(190, 10, 70, 30);
                        if ([_state isEqualToString:@"<null>"]) {
                        }else{
                            yishengji.frame =CGRectMake(260, 17.5, 15, 15);
                            yisj.frame = CGRectMake(280, 10, 90, 30);
                        }
                    }
                }
            }
        }
         return cell;
    }
}
-(void)xqdwtextField:(UIButton *)textfield{
    NSArray *zwlbAry = [[NSArray alloc]init];
    zwlbAry = @[@"保养",@"功效",@"修复",@"美容"];
    [SelectAlert showWithTitle:@"选择类型" titles:zwlbAry selectIndex:^(NSInteger selectIndex) {
        
        int count=(int)selectIndex + 1;
        _brandpos = [NSString stringWithFormat:@"%d",count];
    } selectValue:^(NSString *selectValue) {
        [textfield setTitle:selectValue forState:UIControlStateNormal];
        
        
    } showCloseButton:NO];
}
-(void)buttonNotPresss:(UIButton *)btn{
    // 全款 分期 其他方式
    //是否做过大量收现活动
    if (btn.tag == 49) {
        if ([_flag isEqualToString:@"2"]) {
            _flag = @"1";
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"xk_ico02"] forState:UIControlStateNormal];
            [_nobtn setImage:[UIImage imageNamed:@"xk_ico01"] forState:UIControlStateNormal];
            [_nobtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:4];
            [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }else if (btn.tag == 50){
        if ([_flag isEqualToString:@"1"]) {
            [_yesbtn setImage:[UIImage imageNamed:@"xk_ico01"] forState:UIControlStateNormal];
            [_yesbtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            _flag = @"2";
            [btn setImage:[UIImage imageNamed:@"xk_ico02"] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:4];
            [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }else if (btn.tag == 73){
        _payway = @"1";
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_FQbtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_QTbtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }else if (btn.tag == 74){
        _payway = @"2";
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_QKbtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_QTbtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }else if (btn.tag == 75){
        _payway = @"3";
        [_QKbtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_FQbtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
    }
    
}
-(void)FieldText:(UITextField *)textfield{
    switch (textfield.tag) {
        case 12:
            _meettime = textfield.text;//拜访时间段
            break;
        case 21:
            _StoreName=textfield.text;//店名
            break;
        case 22:
            _Address=textfield.text;//店铺地址
            break;
        case 23:
             _principal=textfield.text;//负责人
            break;
        case 24:
            _post = textfield.text;//职务
            break;
        case 25:
            _iphone = textfield.text;//联系方式
            break;
        case 26:
            _qcode = textfield.text;//微信号
            break;
        case 35:
            _brandbusiness = textfield.text;//主要经营品牌
            NSLog(@"%@--%@",textfield.text,_brandbusiness);
            break;
        case 36:
            _followbrand = textfield.text;//关注品牌
            break;
        case 41:
            _customernum = textfield.text;//终端顾客总数量
            break;
        case 42:
           _validnum = textfield.text;//有质量顾客数量
            break;
        
        case 44:
           _otherpos = textfield.text;//品牌定位的其他
            break;
        case 45:
            _singleprice = textfield.text;// 单品价格
            break;
        case 46:
            _boxprice = textfield.text;//套盒价格
            break;
        case 47:
            _cardprice = textfield.text;//卡项价格
            break;
        case 48:
            _packprice = textfield.text;// 项目套餐
            break;
        case 51:
            _activename = textfield.text;//活动名称
            break;
        case 52:
            _dealmoney = textfield.text;//成交金额
            break;
        case 53:
            _leastmoney = textfield.text;//下限
            break;
        case 54:
            _dealrate = textfield.text;//成交率
            break;
        case 55:
            _demand = textfield.text;//运营协助需求
            break;
        case 61:
            _partnertime = textfield.text;//店家预定合作时间
            break;
        case 62:
            _scheme =textfield.text;//执行方案
            break;
        case 63:
            _amount = textfield.text; //合约金额
            break;
        case 71:
            _written = textfield.text;//填表人
            break;
        case 72:
            _manager = textfield.text;//主管经理
            break;
        default:
            break;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        SiginViewController *siginVC = [[SiginViewController alloc]init];
        
        siginVC.shopid =_shopid;
        siginVC.Address = [NSString stringWithFormat:@"%@%@%@",_Province,_City,_County];
        siginVC.Types = @"3";
        
        [self.navigationController pushViewController:siginVC animated:YES];
    }
    
    
    if (indexPath.section ==1) {
        if (indexPath.row==2) {
            _index=indexPath;
            [self lodapickerView:@"拜访次数"];
        }
    }else if(indexPath.section==3){
        if (indexPath.row==0) {
                [SelectAlert showWithTitle:@"选择店规模" titles:@[@"高",@"中",@"低"] selectIndex:^(NSInteger selectIndex) {
                    
                } selectValue:^(NSString *selectValue) {
                    
                    inftionTableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
                    cell.xingLabel.text=selectValue;
                    cell.xingLabel.textColor = [UIColor blackColor];
                    _storelevel = selectValue;
                    
                } showCloseButton:NO];
        }else if (indexPath.row==1){
            _index = indexPath;
            [self lodapickerView:@"选择床位"];
        }else if (indexPath.row==2){
            _index = indexPath;
            [self lodapickerView:@"选择美容师人数"];
        }else if (indexPath.row==3){
            _index = indexPath;
            [self lodapickerView:@"选择开店年限"];
        }
    }else if (indexPath.section == 5){
        if (indexPath.row ==0) {
            TargetViewController *targetVC=[[TargetViewController alloc]init];
            targetVC.number=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
            targetVC.dateStr = _shopquestion;
            targetVC.modifi = _cellend;
            targetVC.blcokStr=^(NSString *content,int num){
                if (num==0) {
                    if (_cellend == YES) {
                        _shopquestion = content;
                    }
                    //店家问题简述
                    
                }
            };
            [self.navigationController pushViewController:targetVC animated:YES];
        }else if (indexPath.row == 1){
            TargetViewController *targetVC=[[TargetViewController alloc]init];
            targetVC.number=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
            targetVC.dateStr = _plans;
            targetVC.modifi = _cellend;
            targetVC.blcokStr=^(NSString *content,int num){
                if (num==1) {
                    if (_cellend == YES) {
                        _plans = content;
                    }
                    //品牌介入策略及跟进规划
                    
                }
            };
            [self.navigationController pushViewController:targetVC animated:YES];
            
        }else if (indexPath.row == 2){
            TargetViewController *targetVC=[[TargetViewController alloc]init];
            targetVC.number=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
            targetVC.dateStr = _requirement;
            targetVC.modifi = _cellend;
            targetVC.blcokStr=^(NSString *content,int num){
                if (num==2) {
                      if (_cellend == YES) {
                          _requirement = content;
                      }
                    //店家要求事项及解决办法
                    
                }
            };
            [self.navigationController pushViewController:targetVC animated:YES];
            
        }else if (indexPath.row == 3){
            TargetViewController *targetVC=[[TargetViewController alloc]init];
            targetVC.number=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
            targetVC.dateStr = _notic;
            targetVC.modifi = _cellend;
            targetVC.blcokStr=^(NSString *content,int num){
                if (num==3) {
                    if (_cellend == YES) {
                   _notic = content;
                             }
                    //同事协助须知
                    
                }
            };
            [self.navigationController pushViewController:targetVC animated:YES];
            
        }
    }
    
}
-(void)rightItemAction:(UIBarButtonItem*)sender{
    //点击右上角
    if (_cellend == NO) {
        NSArray *zwlbAry = [[NSArray alloc]init];
        if ([_state intValue] ==4) {
            zwlbAry = @[@"分享给同事",@"分享到部门",@"删除"];
        }else{
            zwlbAry = @[@"编辑",@"确定合作",@"分享给同事",@"分享到部门",@"删除"];
        }
        
        [SelectAlert showWithTitle:nil titles:zwlbAry selectIndex:^(NSInteger selectIndex) {
            if ([_state intValue] ==4) {
                if (selectIndex ==0) {//分享给同事
                    ShareColleagues *SCVC = [[ShareColleagues alloc]init];
                    SCVC.shopip = _shopid;
                    SCVC.yiandmu = @"1";
                    SCVC.targetvisitid = _targetVisitId;
                    [self.navigationController pushViewController:SCVC animated:YES];
                }else if(selectIndex ==1){//分享给部门
                    depatementViewController *dptmVC = [[depatementViewController alloc]init];
                    //depaid  shopid  _targetVisitId
                    dptmVC.shopid = _shopid;
                    dptmVC.intendedId = _targetVisitId;
                    dptmVC.tarAndInter = @"2";
                    
                    [self.navigationController pushViewController:dptmVC animated:YES];
                }else{//删除
                    PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"温馨提示" message:@"是否删除？" sureBtn:@"确认" cancleBtn:@"取消"];
                    alertView.resultIndex = ^(NSInteger index){
                        NSLog(@"%ld",index);
                        if(index == 2){
                            NSString *uStr =[NSString stringWithFormat:@"%@shop/deleteShop.action",KURLHeader];
                            NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
                            NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
                            NSDictionary *dic = [[NSDictionary alloc]init];
                            dic = @{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS objectForKey:@"userid"],@"id":self.OldTargetVisitId,@"shopId":_shopid,@"Types":@"3",@"Draft":@"2"};
                            [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
                                if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
                                    PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"删除成功" sureBtn:@"确认" cancleBtn:nil];
                                    alertView.resultIndex = ^(NSInteger index){
                                        [self.navigationController popViewControllerAnimated:YES];
                                    };
                                    [alertView showMKPAlertView];
                                }else if ([[responseObject valueForKey:@"status"]isEqualToString:@"4444"]) {
                                    [ELNAlerTool showAlertMassgeWithController:self andMessage:@"删除失败" andInterval:1.0];
                                }else if ([[responseObject valueForKey:@"status"]isEqualToString:@"0001"]) {
                                    [ELNAlerTool showAlertMassgeWithController:self andMessage:@"删除失败" andInterval:1.0];
                                }else if ([[responseObject valueForKey:@"status"]isEqualToString:@"1001"]) {
                                    PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"异地登陆,请重新登录" sureBtn:@"确认" cancleBtn:nil];
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
                    };
                    [alertView showMKPAlertView];
                }
            }else{
                if (selectIndex == 0) {
                    _cellend = YES;
                    [self.tableView reloadData];
                    
                }else if(selectIndex == 1){
                    PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"温馨提示" message:@"是否升级为合作用户" sureBtn:@"确认" cancleBtn:@"取消"];
                    alertView.resultIndex = ^(NSInteger index){
                        NSLog(@"%ld",index);
                        if(index == 2){
                            //跳界面
                            //shopid 门店id
                            if([_state isEqualToString:@"4"]){
                                PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"温馨提示" message:@"已经升级为合作客户,不可再次升级" sureBtn:@"确认" cancleBtn:@"取消"];
                                alertView.resultIndex = ^(NSInteger index){
                                    
                                };
                                [alertView showMKPAlertView];
                            }else{
                                NSString *uStr =[NSString stringWithFormat:@"%@shop/insertStore.action",KURLHeader];
                                NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
                                NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
                                //NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
                                NSDictionary *dic = [[NSDictionary alloc]init];
                                dic = @{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS objectForKey:@"userid"],@"shopId":self.shopid};
                                [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
                                    if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
                                        PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"提交成功" sureBtn:@"确认" cancleBtn:nil];
                                        alertView.resultIndex = ^(NSInteger index){
                                            [self.navigationController popViewControllerAnimated:YES];
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
                            
                        }
                    };
                    [alertView showMKPAlertView];
                }else if(selectIndex == 2){
                    //分享给同事
                    ShareColleagues *SCVC = [[ShareColleagues alloc]init];
                    SCVC.shopip = _shopid;
                    SCVC.yiandmu = @"1";
                    SCVC.targetvisitid = _targetVisitId;
                    [self.navigationController pushViewController:SCVC animated:YES];
                    
                }else if(selectIndex == 3){
                    //分享给部门
                    depatementViewController *dptmVC = [[depatementViewController alloc]init];
                    //depaid  shopid  _targetVisitId
                    dptmVC.shopid = _shopid;
                    dptmVC.intendedId = _targetVisitId;
                    dptmVC.tarAndInter = @"2";
                    
                    [self.navigationController pushViewController:dptmVC animated:YES];
                    
                }else{
                    PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"温馨提示" message:@"是否删除？" sureBtn:@"确认" cancleBtn:@"取消"];
                    alertView.resultIndex = ^(NSInteger index){
                        NSLog(@"%ld",index);
                        if(index == 2){
                            NSString *uStr =[NSString stringWithFormat:@"%@shop/deleteShop.action",KURLHeader];
                            NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
                            NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
                            NSDictionary *dic = [[NSDictionary alloc]init];
                            dic = @{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS objectForKey:@"userid"],@"id":self.OldTargetVisitId,@"shopId":_shopid,@"Types":@"3",@"Draft":@"2"};
                            [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
                                if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
                                    PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"删除成功" sureBtn:@"确认" cancleBtn:nil];
                                    alertView.resultIndex = ^(NSInteger index){
                                        [self.navigationController popViewControllerAnimated:YES];
                                    };
                                    [alertView showMKPAlertView];
                                }else if ([[responseObject valueForKey:@"status"]isEqualToString:@"4444"]) {
                                    [ELNAlerTool showAlertMassgeWithController:self andMessage:@"删除失败" andInterval:1.0];
                                }else if ([[responseObject valueForKey:@"status"]isEqualToString:@"0001"]) {
                                    [ELNAlerTool showAlertMassgeWithController:self andMessage:@"删除失败" andInterval:1.0];
                                }else if ([[responseObject valueForKey:@"status"]isEqualToString:@"1001"]) {
                                    PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"异地登陆,请重新登录" sureBtn:@"确认" cancleBtn:nil];
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
                    };
                    [alertView showMKPAlertView];
                }
            }
            
            
           
        } selectValue:^(NSString *selectValue) {
            
        } showCloseButton:NO];
    }else{
        NSArray *zwlbAry = [[NSArray alloc]init];
        zwlbAry = @[@"提交到上级"];
        [SelectAlert showWithTitle:nil titles:zwlbAry  selectIndex:^(NSInteger selectIndex) {
                PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"温馨提示" message:@"内容已修改，提交将覆盖是否提交？" sureBtn:@"确认" cancleBtn:@"取消"];
                alertView.resultIndex = ^(NSInteger index){
                    NSLog(@"%ld",index);
                    if(index == 2){
                        
                        [self upadatetarget];
                    }
                };
                [alertView showMKPAlertView];
            
        } selectValue:^(NSString *selectValue) {
            
        } showCloseButton:NO];
    }
}
-(void)selectTargetVisit{
    //数据请求
    if (self.isofyou ==NO) {
        NSString *uStr =[[NSString alloc]init];
        NSDictionary *dic = [[NSDictionary alloc]init];
        NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
        NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
        NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
        
        if ([self.oneStore isEqualToString:@"1"]) {
            uStr =[NSString stringWithFormat:@"%@shop/getShop.action",KURLHeader];
            dic = @{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS objectForKey:@"userid"],@"shopId":self.shopid,@"Types":@"3"};
        }else{
            uStr =[NSString stringWithFormat:@"%@shop/selectTargetVisit.action",KURLHeader];
            dic = @{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS objectForKey:@"userid"],@"TargetVisitId":self.OldTargetVisitId,@"RoleId":self.strId};
        }
        
        [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
            if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
                NSArray *array=[responseObject valueForKey:@"list"];
                _InterNameAry = [[NSMutableArray alloc]init];
                _state = [[NSString alloc]init];
                _dipatement = [[NSString alloc]init];
                _UserId = [[NSString alloc]init];
                for (NSDictionary *dic in array) {
                    TargetModel *model=[[TargetModel alloc]init];
                    [model setValuesForKeysWithDictionary:dic];
                    [_InterNameAry addObject:model];
                    _state = [NSString stringWithFormat:@"%@",[dic valueForKey:@"state"]];
                    NSLog(@"0-----%@",_state);
                    _dipatement = [NSString stringWithFormat:@"%@",[dic valueForKey:@"departmentId"]];
                    _UserId = [NSString stringWithFormat:@"%@",[dic valueForKey:@"userId"]];
                    [self nstingallocinit:model];
                    if ([_UserId isEqualToString:@"<null>"]) {
                        if ([_dipatement isEqualToString:@"<null>"]) {
                            if ([_state isEqualToString:@"<null>"]) {
                            }else{
                                _nameArrs = @[@[@"签到"],@[@"拜访日期",@"拜访时间段",@"拜访次数"],@[@"店名",@"地址",@"负责人",@"职务",@"固话/手机",@"微信号"],@[@"店规模",@"床位",@"美容师人数",@"开店年限",@"主要经营品牌",@"关注品牌"],@[@"目前了解信息:"],@[@"店家问题简述",@"品牌介入策略及跟进规划",@"店家要求事项及解决办法",@"同事协助须知"],@[@"店家预合作时间:",@"执行方案:",@"合约金额:"],@[@"打款方式"],@[@"当前状态"]];
                            }
                        }else{
                            _nameArrs = @[@[@"签到"],@[@"拜访日期",@"拜访时间段",@"拜访次数"],@[@"店名",@"地址",@"负责人",@"职务",@"固话/手机",@"微信号"],@[@"店规模",@"床位",@"美容师人数",@"开店年限",@"主要经营品牌",@"关注品牌"],@[@"目前了解信息:"],@[@"店家问题简述",@"品牌介入策略及跟进规划",@"店家要求事项及解决办法",@"同事协助须知"],@[@"店家预合作时间:",@"执行方案:",@"合约金额:"],@[@"打款方式"],@[@"当前状态"]];
                        }
                    }else{
                        _nameArrs = @[@[@"签到"],@[@"拜访日期",@"拜访时间段",@"拜访次数"],@[@"店名",@"地址",@"负责人",@"职务",@"固话/手机",@"微信号"],@[@"店规模",@"床位",@"美容师人数",@"开店年限",@"主要经营品牌",@"关注品牌"],@[@"目前了解信息:"],@[@"店家问题简述",@"品牌介入策略及跟进规划",@"店家要求事项及解决办法",@"同事协助须知"],@[@"店家预合作时间:",@"执行方案:",@"合约金额:"],@[@"打款方式"],@[@"当前状态"]];
                        
                    }
                    
                }
                [_tableView reloadData];
                if([self.oneStore isEqualToString:@"1"] ){
                    
                }else{
                    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc] initWithTitle:@"···" style:(UIBarButtonItemStyleDone) target:self action:@selector(rightItemAction:)];
                    NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
                    [rightitem setTitleTextAttributes:dict forState:UIControlStateNormal];
                    self.navigationItem.rightBarButtonItem = rightitem;
                }
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
                [_tableView addEmptyViewWithImageName:@"" title:@"网络出错了!" Size:20.0];
                _tableView.emptyView.hidden = NO;
            }
        } failure:^(NSError *error) {
            
        } view:self.view MBPro:YES];
    }
}
-(void)lodapickerView:(NSString *)labelstr{
    self.pickerView=[[CLZoomPickerView alloc]initWithFrame:CGRectMake(0, 0, Scree_width, Scree_height)];
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    self.pickerView.labelStr=labelstr;
    self.pickerView.topRowCount = 1;
    self.pickerView.bottomRowCount = 1;
    self.pickerView.selectedRow = 1;
    self.pickerView.rowHeight = 40;
    self.pickerView.selectedRowFont = [UIFont fontWithName:@"DIN Condensed" size:35];
    self.pickerView.textColor = [UIColor lightGrayColor];
    self.pickerView.unselectedRowScale = 0.5;
    [self.view addSubview:self.pickerView];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==4) {
        if ([_flag isEqualToString:@"1"]) {
             return 500;
        }else{
            return 400;
        }
       
    }else if(indexPath.section ==7){
        return 250;
    }else{
        return 50;
    }
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [_nameArrs[section]count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _nameArrs.count;
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
// CLZoomPickerView 代理，当前项改变后调用此方法
- (void)pickerView:(CLZoomPickerView *)pickerView changedIndex:(NSUInteger)indexPath
{
    
    inftionTableViewCell *cell = [_tableView cellForRowAtIndexPath:_index];
    cell.xingLabel.text=_timeArray[indexPath];
    NSLog(@"%@,%@",_timeArray[indexPath],cell.xingLabel.text);
    cell.xingLabel.textColor = [UIColor blackColor];
   
    switch (_index.section) {
        case 1:
            switch (_index.row) {
                case 2:
                    _num =_timeArray[indexPath];
                    NSLog(@"%@---%@",_timeArray[indexPath],_num)
                    break;
                    
                default:
                    break;
            }
            break;
        case 3:
            switch (_index.row) {
                case 1:
                    _berths = _timeArray[indexPath];
                    NSLog(@"%@---%@",_timeArray[indexPath],_berths)
                    break;
                case 2:
                    _beautician = _timeArray[indexPath];
                    NSLog(@"%@---%@",_timeArray[indexPath],_beautician)
                    break;
                case 3:
                    _plantingduration = _timeArray[indexPath];
                    NSLog(@"%@---%@",_timeArray[indexPath],_plantingduration)
                    break;
                default:
                    break;
            }
            
            break;
        default:
            break;
    }
}


// CLZoomPickerView 代理，返回数据行数
- (NSInteger)pickerView:(CLZoomPickerView *)pickerView
{
    return _timeArray.count;
}

// CLZoomPickerView 代理，返回指定行显示的字符串
- (NSString *)pickerView:(CLZoomPickerView *)pickerView titleForRow:(NSUInteger)indexPath
{
    return _timeArray[indexPath];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        UIEdgeInsets UIEgde = UIEdgeInsetsMake(0, 15, 0, 15);
        [cell setSeparatorInset:UIEgde];
    }else{
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
    }
}
-(void)nstingallocinit:(TargetModel*)model{
    _time= [[NSString alloc]init];//拜访日期
    _time = model.Time;
    _Address = [[NSString alloc]init];
    _Address = model.Address;//店铺地址
    _Province = [[NSString alloc]init];
    _Province = model.Province;//省
    _City = [[NSString alloc]init];
    _City= model.City;//市
    _County = [[NSString alloc]init];
    _County = model.County;//区
    _Address = [[NSString alloc]init];
    _Address = model.Address;//详细地址
    _StoreName = [[NSString alloc]init];
    _StoreName = model.StoreName;//店名
    _meettime= [[NSString alloc]init];//拜访时间段
    if (model.MeetTime == nil) {
        _meettime = @"";
    }else{
        _meettime = model.MeetTime;
    }
    _num= [[NSString alloc]init];//拜访次数
    if (model.Num == nil) {
        _num = @"";
    }else{
        
        _num = [[NSString alloc] initWithFormat:@"%@",model.Num];
    }
    _principal= [[NSString alloc]init];//店铺负责人
    if (model.Principal == nil) {
        _principal = @"";
    }else{
        _principal = model.Principal;
    }
    _post= [[NSString alloc]init];//职务
    if (model.Post == nil) {
        _post = @"";
        
    }else{
        _post = model.Post;
    }
    _iphone= [[NSString alloc]init];//联系方式
    if (model.Iphone == nil) {
        _iphone = @"";
    }else{
        _iphone = model.Iphone;
    }
    _qcode= [[NSString alloc]init];//微信
    if (model.Qcode == nil) {
        _qcode = @"";
    }else{
        _qcode = model.Qcode;
    }
    _storelevel= [[NSString alloc]init];//店规模
    if (model.StoreLevel == nil) {
        _storelevel = @"";
    }else{
        _storelevel = model.StoreLevel;
    }
    _berths= [[NSString alloc]init];//床位数
    if (model.Berths == nil) {
        _berths = @""; //
    }else{
        _berths =[[NSString alloc] initWithFormat:@"%@",model.Berths];
    }
    _beautician= [[NSString alloc]init];//美容师人数
    if (model.Beautician == nil) {
        _beautician = @"";
    }else{
        _beautician =[[NSString alloc] initWithFormat:@"%@",model.Beautician];
    }
    _plantingduration= [[NSString alloc]init];//开店年限
    if (model.PlantingDuration == nil) {
        _plantingduration = @"";
    }else{
        _plantingduration =[[NSString alloc] initWithFormat:@"%@",model.PlantingDuration];
    }
    _brandbusiness= [[NSString alloc]init];//主要经营品牌
    if (model.BrandBusiness == nil) {
        _brandbusiness = @"";
    }else{
        _brandbusiness = model.BrandBusiness;
    }
    _followbrand= [[NSString alloc]init];//关注品牌
    if (model.FollowBrand == nil) {
        _followbrand = @"";
    }else{
        _followbrand = model.FollowBrand;
    }
    _customernum= [[NSString alloc]init];//终端顾客总数量
    if (model.CustomerNum == nil) {
        _customernum = @"";
    }else{
        _customernum = [[NSString alloc] initWithFormat:@"%@",model.CustomerNum];
    }
    _validnum= [[NSString alloc]init];//有质量顾客数量
    if (model.ValidNum == nil) {
        _validnum = @"";
    }else{
        _validnum = [[NSString alloc] initWithFormat:@"%@",model.ValidNum];
    }
    _brandpos= [[NSString alloc]init];//品牌定位
    if (model.BrandPos == nil) {
        _brandpos = @"";
    }else{
        _brandpos = [[NSString alloc] initWithFormat:@"%@",model.BrandPos];
    }
    _otherpos= [[NSString alloc]init];//品牌定位的其他
    if (model.OtherPos == nil) {
        _otherpos = @"";
    }else{
        _otherpos = model.OtherPos;
    }
    _singleprice= [[NSString alloc]init];// 单品价格
    if (model.SinglePrice == nil) {
        _singleprice = @"";
    }else{
        _singleprice = [[NSString alloc] initWithFormat:@"%@",model.SinglePrice];
    }
    _boxprice= [[NSString alloc]init];//套盒价格
    if (model.BoxPrice == nil) {
        _boxprice = @"";
    }else{
        _boxprice = [[NSString alloc] initWithFormat:@"%@",model.BoxPrice];
    }
    _cardprice= [[NSString alloc]init];//卡项价格
    if (model.CardPrice == nil) {
        _cardprice = @"";
    }else{
        _cardprice = [[NSString alloc] initWithFormat:@"%@",model.CardPrice];
    }
    _packprice= [[NSString alloc]init];// 项目套餐
    if (model.PackPrice == nil) {
        _packprice = @"";
    }else{
        _packprice = [[NSString alloc] initWithFormat:@"%@",model.PackPrice];
    }
    _flag= [[NSString alloc]init];//本年是否做过大量收现活动
    if (model.Flag == nil) {
        _flag = @"2";
    }else{
        _flag = model.Flag;
    }
    _activename= [[NSString alloc]init];//活动名称
    if (model.ActiveName == nil) {
        _activename = @"";
    }else{
        _activename = model.ActiveName;
    }
    _dealmoney= [[NSString alloc]init];//成交金额
    if (model.DealMoney == nil) {
        _dealmoney = @"";
    }else{
        _dealmoney = [[NSString alloc] initWithFormat:@"%@",model.DealMoney];
    }
    _leastmoney= [[NSString alloc]init];//下限
    if (model.LeastMoney == nil) {
        _leastmoney = @"";
    }else{
        _leastmoney = [[NSString alloc] initWithFormat:@"%@",model.LeastMoney];
    }
    _dealrate= [[NSString alloc]init];//成交率
    if (model.DealRate == nil) {
        _dealrate = @"";
    }else{
        _dealrate = [[NSString alloc] initWithFormat:@"%@",model.DealRate];
    }
    _demand= [[NSString alloc]init];//运营协助需求
    if (model.Demand == nil) {
        _demand = @"";
    }else{
        _demand = model.Demand;
    }
    _shopquestion= [[NSString alloc]init];//店家问题简述
    if (model.ShopQuestion == nil) {
        _shopquestion = @"";
    }else{
        _shopquestion = model.ShopQuestion;
    }
    _plans= [[NSString alloc]init];//品牌介入策略及跟进规划
    if (model.Plans == nil) {
        _plans = @"";
    }else{
        _plans = model.Plans;
    }
    _requirement= [[NSString alloc]init];//店家要求事项及解决办法
    if (model.Requirement == nil) {
        _requirement = @"";
    }else{
        _requirement = model.Requirement;
    }
    _notic= [[NSString alloc]init];//同事协助须知
    if (model.Notic == nil) {
        _notic = @"";
    }else{
        _notic = model.Notic;
    }
    _partnertime= [[NSString alloc]init];//店家预定合作时间
    if (model.PartnerTime == nil) {
        _partnertime = @"";
    }else{
        _partnertime = model.PartnerTime;
    }
    _scheme= [[NSString alloc]init];//执行方案
    if (model.Scheme == nil) {
        _scheme = @"";
    }else{
        _scheme = model.Scheme;
    }
    _amount= [[NSString alloc]init];//合约金额
    if (model.Amount == nil) {
        _amount = @"";
    }else{
        _amount = model.Amount;
    }
    _payway= [[NSString alloc]init];//大款方式
    if (model.PayWay == nil) {
        _payway = @"";
    }else{
        _payway = model.PayWay;
    }
    _written= [[NSString alloc]init];//填表人
    if (model.Written == nil) {
        _written = @"";
    }else{
        _written = model.Written;
    }
    _manager= [[NSString alloc]init];//经理
    if (model.Manager == nil) {
        _manager = @"";
    }else{
        _manager = model.Manager;
    }
    _shopid= [[NSString alloc]init];//店铺id
    if (model.ShopId == nil) {
        _shopid = @"";
    }else{
        _shopid = model.ShopId;
    }
    _StoreName= [[NSString alloc]init];//店名
    if (model.StoreName == nil) {
        _StoreName = @"";
    }else{
        _StoreName = model.StoreName;
    }
    _targetVisitId= [[NSString alloc]init];//目标客户id
    if (model.Id == nil) {
        _targetVisitId = @"";
    }else{
        _targetVisitId = model.Id;
    }
}
//修改目标客户
-(void)upadatetarget{
    NSString *uStr =[NSString stringWithFormat:@"%@shop/UpdateTargetVisit.action",KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic = [[NSDictionary alloc]init];
    dic = @{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS objectForKey:@"userid"],@"TargetVisitId":_targetVisitId,@"Time":_time,@"MeetTime":_meettime,@"Num":_num,@"Principal":_principal,@"Post":_post,@"Iphone":_iphone,@"Qcode":_qcode,@"StoreLevel":_storelevel,@"Berths":_berths,@"Beautician":_beautician,@"PlantingDuration":_plantingduration,@"BrandBusiness":_brandbusiness,@"FollowBrand":_followbrand,@"CustomerNum":_customernum,@"ValidNum":_validnum,@"BrandPos":_brandpos,@"OtherPos":_otherpos,@"SinglePrice":_singleprice,@"BoxPrice":_boxprice,@"CardPrice":_cardprice,@"PackPrice":_packprice,@"Flag":_flag,@"ActiveName":_activename,@"DealMoney":_dealmoney,@"LeastMoney":_leastmoney,@"DealRate":_dealmoney,@"Demand":_demand,@"ShopQuestion":_shopquestion,@"Plans":_plans,@"Requirement":_requirement,@"Notic":_notic,@"PartnerTime":_partnertime,@"Scheme":_scheme,@"Amount":_amount,@"PayWay":_payway,@"written":_written,@"Manager":_manager,@"ShopId":_shopid,@"UsersID":[USER_DEFAULTS objectForKey:@"userid"],@"Province":_Province,@"City":_City,@"County":_County,@"StoreName":_StoreName,@"Address":_Address};
    [ZXDNetworking POST:uStr parameters:dic success:^(id responseObject) {
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
            PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"提交成功!" sureBtn:@"确认" cancleBtn:nil];
            alertView.resultIndex = ^(NSInteger index){
                _cellend = YES;
                //
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
        
    } view:self.view];
}
@end
