//
//  TrackAddTrack.m
//  Administration
//
//  Created by zhang on 2017/12/11.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "TrackAddTrack.h"
#import "CellTrack2.h"
#import "ViewDatePick.h"
@interface TrackAddTrack ()<UITableViewDataSource,UITableViewDelegate,ViewDatePickerDelegate,UITextViewDelegate>

@property (nonatomic,strong)NSString *string1;
@property (nonatomic,strong)NSString *string2;
@property (nonatomic,strong)NSString *string3;
@property (nonatomic,strong)NSString *string4;
@property (nonatomic,strong)NSString *string5;
@property (nonatomic,strong)NSString *string6;
@property (nonatomic,strong)NSString *startDate;
@property (nonatomic,strong)NSString *endDate;
@property (nonatomic,strong)NSArray *arrayTitle;
@property (nonatomic,strong)NSArray *arrayPlace;
@property (nonatomic,assign)NSUInteger buttonTag;

@property (nonatomic,weak)UIButton *buttonStart;
@property (nonatomic,weak)UIButton *buttonEnd;
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,weak)ViewDatePick *datePick;

@end

@implementation TrackAddTrack

-(void)setUI
{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [button setImage:[UIImage imageNamed:@"submit_ico01"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(submitDate) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIView *viewTop = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Scree_width, 135)];
    viewTop.backgroundColor = GetColor(234, 235, 236, 1);
    [self.view addSubview:viewTop];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 44)];
    label.backgroundColor = [UIColor whiteColor];
    label.text = @"  日期";
    [viewTop addSubview:label];
    
    UIButton *buttonStart = [[UIButton alloc]initWithFrame:CGRectMake(80, 0, 120, 44)];
    buttonStart.tag = 10;
    [buttonStart setBackgroundColor:[UIColor whiteColor]];
    [buttonStart setTitle:@"选择开始日期" forState:UIControlStateNormal];
    [buttonStart setTitleColor:GetColor(234, 235, 236, 1) forState:UIControlStateNormal];
    [buttonStart addTarget:self action:@selector(showDatePick:) forControlEvents:UIControlEventTouchUpInside];
    [viewTop addSubview:buttonStart];
    self.buttonStart = buttonStart;
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(200, 0, 20, 44)];
    label2.text = @"至";
    label2.backgroundColor = [UIColor whiteColor];
    [viewTop addSubview:label2];
    
    UIButton *buttonEnd = [[UIButton alloc]initWithFrame:CGRectMake(220, 0, 170, 44)];
    buttonEnd.tag = 10;
    [buttonEnd setBackgroundColor:[UIColor whiteColor]];
    [buttonEnd setTitle:@"选择结束日期" forState:UIControlStateNormal];
    [buttonEnd setTitleColor:GetColor(234, 235, 236, 1) forState:UIControlStateNormal];
    [buttonEnd addTarget:self action:@selector(showDatePick:) forControlEvents:UIControlEventTouchUpInside];
    [viewTop addSubview:buttonEnd];
    self.buttonEnd = buttonEnd;
    
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(0, 45, Scree_width, 44)];
    label3.text = @"  执行人";
    label3.backgroundColor = [UIColor whiteColor];
    [viewTop addSubview:label3];
    
    UITextField *textF = [[UITextField alloc]initWithFrame:CGRectMake(0, 89, Scree_width, 44)];
    textF.placeholder = @"  填写执行人";
    textF.backgroundColor = [UIColor whiteColor];
    [viewTop addSubview:textF];
    
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Scree_width, Scree_height)];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableHeaderView = viewTop;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 44;
    [tableView registerClass:[CellTrack2 class] forCellReuseIdentifier:@"cell1"];
    [ZXDNetworking setExtraCellLineHidden:tableView];
    [self.view addSubview:tableView];
    
}

-(void)submitDate
{
    
}

-(void)showDatePick:(UIButton *)button
{
    ViewDatePick *datePick = [[ViewDatePick alloc]initWithFrame:CGRectMake(0, 0, Scree_width, Scree_height)];
    datePick.delegate = self;
    [self.view endEditing:YES];
    self.buttonTag = button.tag;
    [self.view addSubview:datePick];
    self.datePick = datePick;
}

#pragma -mark viewdatePick

-(void)getDate
{
    NSDate *date = self.datePick.datePick.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *stringDate = [formatter stringFromDate:date];
    if (self.buttonTag==10) {
        [self.buttonStart setTitle:stringDate forState:UIControlStateNormal];
    }else
    {
        [self.buttonEnd setTitle:stringDate forState:UIControlStateNormal];
    }
}

#pragma -mark tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayTitle.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row<2) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.textLabel.text = self.arrayTitle[indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }else
    {
        CellTrack2 *cell = [[CellTrack2 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        if (!cell) {
            cell = [[CellTrack2 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        }
        cell.labelTitle.text = self.arrayTitle[indexPath.row];
        cell.textView.placeholder = self.arrayPlace[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        switch (indexPath.row) {
            case 2:
                cell.textView.text = self.string1;
                break;
            case 3:
                cell.textView.text = self.string2;
                break;
            case 4:
                cell.textView.text = self.string3;
                break;
            case 5:
                cell.textView.text = self.string4;
                break;
            case 6:
                cell.textView.text = self.string5;
                break;
            case 7:
                cell.textView.text = self.string6;
                break;
                
            default:
                break;
        }
        return cell;
    }
}

#pragma -mark textView

-(void)textViewDidChange:(UITextView *)textView
{
    CellTrack2 *cell = (CellTrack2 *)[textView superview].superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    switch (indexPath.row) {
        case 2:
            self.string1 = textView.text;
            break;
        case 3:
            self.string2 = textView.text;
            break;
        case 4:
            self.string3 = textView.text;
            break;
        case 5:
            self.string4 = textView.text;
            break;
        case 6:
            self.string5 = textView.text;
            break;
        case 7:
            self.string6 = textView.text;
            break;
            
        default:
            break;
    }
    CGRect frame = textView.frame;
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [textView sizeThatFits:constraintSize];
    if (size.height<=frame.size.height) {
        size.height=frame.size.height;
    }
    cell.textView.frame = CGRectMake(frame.origin.x, frame.origin.y,cell.contentView.frame.size.width, size.height);
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}
#pragma -mark system
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"添加店家";
    [self setUI];
    self.arrayTitle = @[@"执行区域",@"执行店家",@"具体的时间规划",@"预期达成的时间",@"可能遇到的问题与困难",@"销售业绩",@"特殊情况",@"总结结论"];
    self.arrayPlace = @[@"",@"",@"填写具体的时间规划",@"填写预期达成的时间",@"填写可能遇到的问题与困难",@"填写销售业绩",@"填写特殊情况",@"填写总结结论"];
    self.string1 = @"";
    self.string2 = @"";
    self.string3 = @"";
    self.string4 = @"";
    self.string5 = @"";
    self.string6 = @"";
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
