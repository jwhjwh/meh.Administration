//
//  GBAlertView.m
//  测试demo
//
//  Created by mac on 2017/1/17.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "GBAlertView.h"



#define GBDefaultCellHeight 60
#define GBAlertCellHeight 0
@interface GBAlertView ()
@property (nonatomic, strong) UIView *alertView;//弹框视图
@property (nonatomic, strong) UITableView *selectTableView;//选择列表
@end

static NSString *const GBAlertCellID = @"GBAlertCell";
@implementation GBAlertView
{
    float alertHeight;//弹框整体高度，默认250
}
#pragma mark -- 创建alertView
+ (GBAlertView *)showWithtTtles:(NSArray *)titles
                   itemIndex:(itemClickAtIndex)itemIndex{
    GBAlertView *alert = [[GBAlertView alloc] initWithTitles:titles itemIndex:itemIndex];
    return alert;
}
#pragma mark -- 初始化alertView
- (UIView *)alertView {
    if (!_alertView) {
        _alertView = [[UIView alloc] init];
        _alertView.backgroundColor = [UIColor whiteColor];
        _alertView.layer.cornerRadius = 8;
        _alertView.layer.masksToBounds = YES;
    
    }
    return _alertView;
}
#pragma mark -- 初始化selectTableView
- (UITableView *)selectTableView {
    if (!_selectTableView) {
        _selectTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _selectTableView.delegate = self;
        _selectTableView.dataSource = self;
        _selectTableView.scrollEnabled = NO;
        
        [_selectTableView registerNib:[UINib nibWithNibName:GBAlertCellID bundle:[NSBundle mainBundle]] forCellReuseIdentifier:GBAlertCellID];
    }
    return _selectTableView;
}
- (instancetype)initWithTitles:(NSArray *)titles itemIndex:(itemClickAtIndex)itemIndex{
    if (self = [super init]) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
        alertHeight = 120;
        
        _titles = titles;
        _itemIndex = [itemIndex copy];

        [self addSubview:self.alertView];
        [self.alertView addSubview:self.selectTableView];
        [self initUI];
        
        [self show];
    }
    return self;
}
- (void)initUI {
    self.alertView.frame = CGRectMake(50, ([UIScreen mainScreen].bounds.size.height-alertHeight)/2.0, [UIScreen mainScreen].bounds.size.width-100, alertHeight);
    self.selectTableView.frame = CGRectMake(0, 0, _alertView.frame.size.width, _alertView.frame.size.height);
}
#pragma mark -- 弹出视图
- (void)show {
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    self.alertView.alpha = 0.0;
    [UIView animateWithDuration:0.05 animations:^{
        self.alertView.alpha = 1;
    }];
}
#pragma UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titles.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {
        return GBAlertCellHeight;
    }
    return GBDefaultCellHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.000001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.000001;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   

    
        static NSString *const baseCellID = @"baseCellID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:baseCellID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:baseCellID];
        }
        cell.textLabel.text = _titles[indexPath.row];
        return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.itemIndex) {
        self.itemIndex(indexPath.row);
    }
    
    [self closeAction];
}
#pragma mark -- 关闭视图
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint pt = [touch locationInView:self];
    if (!CGRectContainsPoint([self.alertView frame], pt)) {
        [self closeAction];
    }
}
- (void)closeAction {
    [UIView animateWithDuration:0.1 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end
