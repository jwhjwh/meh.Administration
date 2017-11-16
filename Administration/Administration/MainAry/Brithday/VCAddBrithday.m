//
//  VCAddBrithday.m
//  Administration
//
//  Created by zhang on 2017/11/1.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCAddBrithday.h"
#import "CellSetBrithday.h"
#import "ViewChooseDay.h"
#import "VCSendMessage.h"
@interface VCAddBrithday ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,ViewChooseDayDelegate>

@property (nonatomic,strong)NSArray *arrayTitle;
@property (nonatomic,strong)NSArray *arrayImage;
@property (nonatomic,strong)NSArray *array;
@property (nonatomic,strong)NSString *describ;

@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,weak)UIButton *buttonSure;
@property (nonatomic,weak)ViewChooseDay *chooseDay;

@end

@implementation VCAddBrithday

#pragma -mark custem

-(void)submitData
{
    
}

-(void)setUI
{
    
    UIView *viewBottom = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Scree_width, 44)];
    [self.view addSubview:viewBottom];
    
    
    UIButton *buttonSure = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, Scree_width-20, 44)];
    [buttonSure setTitle:@"确定" forState:UIControlStateNormal];
    [buttonSure setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [buttonSure addTarget:self action:@selector(submitData) forControlEvents:UIControlEventTouchUpInside];
    buttonSure.layer.borderColor = GetColor(234, 235, 236, 1).CGColor;
    buttonSure.layer.borderWidth = 1.0f;
    [viewBottom addSubview:buttonSure];
    self.buttonSure = buttonSure;
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Scree_width, Scree_height) style:UITableViewStylePlain];
    tableView.scrollEnabled = NO;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 100;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = viewBottom;
    [tableView registerClass:[CellSetBrithday class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

-(void)showChooseDay
{
    ViewChooseDay *view = [[ViewChooseDay alloc]initWithFrame:self.view.bounds];
    view.delegate =self;
    [self.view.window addSubview:view];
    
    self.chooseDay = view;
}

#pragma -mark viewChooseDayDelegate

-(void)getSelect
{
    self.array = self.chooseDay.arraySelect;
    
    
}

#pragma -mark tableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellSetBrithday *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[CellSetBrithday alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textView.delegate = self;
    cell.imageViewHead.image = [UIImage imageNamed:self.arrayImage[indexPath.row]];
    cell.textView.text = self.arrayTitle[indexPath.row];
    
    if (indexPath.row==0) {
        UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(Scree_width-48, 2, 40, 40)];
        imageView1.layer.cornerRadius = 20;
        imageView1.layer.masksToBounds = YES;
        [imageView1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURLHeader,self.dictInfo[@"icon"]]] placeholderImage:[UIImage imageNamed:@"banben100"]];
        [cell.contentView addSubview:imageView1];
    }
    
    if (indexPath.row==2) {
        UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(Scree_width-38, 10, 30, 21)];
        imageView1.image = [UIImage imageNamed:@"down"];
        [cell.contentView addSubview:imageView1];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showChooseDay)];
        [cell.textView addGestureRecognizer:tap];
    }
    
    if(indexPath.row==3)
    {
        cell.textView.editable = YES;
    }
    
    if (indexPath.row>2) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 30;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==4) {
        VCSendMessage *vc = [[VCSendMessage alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma -mark textView
-(void)textViewDidChange:(UITextView *)textView
{
    CellSetBrithday *cell = (CellSetBrithday *)[textView superview].superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    self.describ = textView.text;
    CGRect frame = textView.frame;
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [textView sizeThatFits:constraintSize];
    if (size.height<=frame.size.height) {
        size.height=frame.size.height;
    }
    cell.textView.frame = CGRectMake(frame.origin.x, frame.origin.y,textView.frame.size.width, size.height);
    
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}


#pragma -mark system

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"添加提醒";
    
    [self setUI];
    
    self.array = [NSArray array];
    
    NSString *brithday; ;
    
    if (self.dictInfo[@"birthday"]) {
        brithday = [self.dictInfo[@"birthday"] substringToIndex:10];
    }
    
    self.arrayImage = @[@"yh_ico",@"rl_ico",@"nz_ico",@"ms",@"dx_ico"];
    self.arrayTitle = @[self.dictInfo[@"name"],brithday,@"提醒天数",@"",@"送出祝福"];
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