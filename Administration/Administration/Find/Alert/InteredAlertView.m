//
//  InteredAlertView.m
//  Administration
//
//  Created by 九尾狐 on 2017/9/30.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "InteredAlertView.h"
@interface InteredAlertCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic,strong) UIImageView *imagerView;


@end

@implementation InteredAlertCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubview:self.titleLabel];
        [self addSubview:self.imagerView];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithRed:0 green:127/255.0 blue:1 alpha:1];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor blueColor];
    }
    return _titleLabel;
}
- (UIImageView *)imagerView {
    if (!_imagerView) {
        _imagerView = [[UIImageView alloc] init];
        _imagerView.backgroundColor = [UIColor whiteColor];
        
        
    }
    return _imagerView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _titleLabel.frame = CGRectMake((([UIScreen mainScreen].bounds.size.width-100)/2)-30 , 5, 60, 30);
    _imagerView.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-100)-40, 5, 30, 30);
}

@end


@interface InteredAlertView ()


@property (nonatomic, strong) UIView *alertView;//弹框视图
@property (nonatomic, strong) UITableView *selectTableView;//选择列表

@end
@implementation InteredAlertView
{
    float alertHeight;//弹框整体高度，默认250
    float buttonHeight;//按钮高度，默认40
}
+ (InteredAlertView *)showWithTitle:(NSString *)title
                        titles:(NSArray *)titles
                               isof:(NSArray *)isofary
                   selectIndex:(InteredAlert)selectIndex
               {
    InteredAlertView *alert = [[InteredAlertView alloc] initWithTitle:title titles:titles selectIndex:selectIndex isof:isofary ];
    return alert;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:17];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIView *)alertView {
    if (!_alertView) {
        _alertView = [[UIView alloc] init];
        _alertView.backgroundColor = [UIColor whiteColor];
        //_alertView.layer.cornerRadius = 8;
        _alertView.layer.masksToBounds = YES;
    }
    return _alertView;
}
- (UITableView *)selectTableView {
    if (!_selectTableView) {
        _selectTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _selectTableView.delegate = self;
        _selectTableView.dataSource = self;
    }
     _selectTableView.scrollEnabled = NO;
    return _selectTableView;
}
- (instancetype)initWithTitle:(NSString *)title titles:(NSArray *)titles selectIndex:(InteredAlert)selectIndex isof:(NSArray *)isofary  {
    if (self = [super init]) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
        if (titles.count<6) {
            alertHeight = 40*(titles.count+1);
        }else{
            alertHeight = 320;
        }
        
        buttonHeight = 40;
        
        self.titleLabel.text = title;
        _titles = titles;
        _isofary = isofary;
        _selectIndex = [selectIndex copy];
       
        
        [self addSubview:self.alertView];
        if (title == nil) {
            
        }else{
            [self.alertView addSubview:self.titleLabel];
        }
        [self.alertView addSubview:self.selectTableView];
        
        [self initUI];
        
        [self show];
    }
    return self;
}
- (void)show {
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    self.alertView.alpha = 0.0;
    [UIView animateWithDuration:0.05 animations:^{
        self.alertView.alpha = 1;
    }];
}
- (void)initUI {
    if (self.titleLabel.text == nil) {
        self.alertView.frame = CGRectMake(50, ([UIScreen mainScreen].bounds.size.height-alertHeight)/2.0, [UIScreen mainScreen].bounds.size.width-100, alertHeight-buttonHeight);
    }else{
        self.alertView.frame = CGRectMake(50, ([UIScreen mainScreen].bounds.size.height-alertHeight)/2.0, [UIScreen mainScreen].bounds.size.width-100, alertHeight);
    }
    
    
    self.titleLabel.frame = CGRectMake(0, 0, _alertView.frame.size.width, buttonHeight);
    
    if (self.titleLabel.text ==nil) {
        self.selectTableView.frame = CGRectMake(0, 0, _alertView.frame.size.width, _alertView.frame.size.height);
        _selectTableView.estimatedRowHeight=0;
        _selectTableView.estimatedSectionFooterHeight=0;
        _selectTableView.estimatedSectionHeaderHeight=0;
    }else{
        self.selectTableView.frame = CGRectMake(0, 40, _alertView.frame.size.width, _alertView.frame.size.height);
        _selectTableView.estimatedRowHeight=0;
        _selectTableView.estimatedSectionFooterHeight=0;
        _selectTableView.estimatedSectionHeaderHeight=0;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titles.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.000001;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    InteredAlertCell *cell = [tableView dequeueReusableCellWithIdentifier:@"selectcell"];
    if (!cell) {
        cell = [[InteredAlertCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"selectcell"];
    }

    
    cell.titleLabel.text = _titles[indexPath.row];
    
    NSLog(@"%@\n%@",_titles,_isofary);
    for (int i =0; i<_titles.count; i++) {
        NSString *titstr = [NSString stringWithFormat:@"%@",_titles[i]];
        for (int y = 0; y<_isofary.count; y++) {
            NSString *isofstr =[NSString stringWithFormat:@"%@",_isofary[y]];
            NSString *strUrl = [isofstr stringByReplacingOccurrencesOfString:@" " withString:@""];
            if ([titstr isEqualToString:strUrl]) {
                NSInteger index = [_titles indexOfObject:strUrl];
                NSLog(@"-1---%ld---",index);
                if (indexPath.row == index) {
                    
                  cell.imagerView.image = [UIImage imageNamed:@"xuanzezhanghao"];
                }
            }
        }
        
    }

    
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (self.selectIndex) {
        self.selectIndex(_titles[indexPath.row]);
    }

    
    [self closeAction];
}

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
#pragma mark - 补全分隔线左侧缺失
- (void)viewDidLayoutSubviews {
    if ([_selectTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_selectTableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([_selectTableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [_selectTableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}
@end

