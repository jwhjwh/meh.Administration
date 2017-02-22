/***************************************************************************************************
 **  Copyright © 2016年 Jinn Chang. All rights reserved.
 **  Giuhub: https://github.com/jinnchang
 **
 **  FileName: LockSettingViewController.m
 **  Description: 手势、指纹解锁设置页面
 **
 **  History
 **  -----------------------------------------------------------------------------------------------
 **  Author: jinnchang
 **  Date: 16/8/10
 **  Version: 1.0.0
 **  Remark: Create
 **************************************************************************************************/

#import "LockSettingViewController.h"
#import "Masonry.h"
#import "JinnLockViewController.h"

@interface LockSettingViewController () <UITableViewDataSource, UITableViewDelegate, JinnLockViewControllerDelegate>

@property (nonatomic, strong) UITableView *lockSettingTableView;

@end

@implementation LockSettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setup];
    [self createViews];
}

- (void)setup
{
    // ...
}

- (void)createViews
{
    self.title = @"应用加密";
    
    UITableView *lockSettingTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [lockSettingTableView setShowsVerticalScrollIndicator:NO];
    [lockSettingTableView setShowsHorizontalScrollIndicator:NO];
    [lockSettingTableView setDataSource:self];
    [lockSettingTableView setDelegate:self];
    [self.view addSubview:lockSettingTableView];
    [self setLockSettingTableView:lockSettingTableView];
    [lockSettingTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.view);
    }];
}

#pragma mark - Private

- (void)gestureUnLockSwitchChanged:(UISwitch *)sender
{
    if (sender.on)
    {
        JinnLockViewController *lockViewController = [[JinnLockViewController alloc] initWithDelegate:self type:JinnLockTypeCreate appearMode:JinnLockAppearModePush];
        [self.navigationController pushViewController:lockViewController animated:YES];
    }
    else
    {
        JinnLockViewController *lockViewController = [[JinnLockViewController alloc] initWithDelegate:self type:JinnLockTypeRemove appearMode:JinnLockAppearModePush];
        [self.navigationController pushViewController:lockViewController animated:YES];
    }
    
    [self.lockSettingTableView reloadData];
}

- (void)touchIdUnLockSwitchChanged:(UISwitch *)sender
{
    [JinnLockTool setTouchIdUnlockEnabled:sender.on];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (![JinnLockTool isGestureUnlockEnabled])
    {
        return 1;
    }
    else
    {
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else if (![JinnLockTool isTouchIdSupported])
    {
        return 1;
    }
    else if (![JinnLockTool isTouchIdUnlockEnabled])
    {
        return 2;
    }
    else
    {
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *idendifier = @"LockSettingTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idendifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idendifier];
    }
    
    if (indexPath.section == 0)
    {
        UISwitch *gestureUnLockSwitch = [[UISwitch alloc] init];
        [gestureUnLockSwitch setOn:[JinnLockTool isGestureUnlockEnabled]];
        [gestureUnLockSwitch addTarget:self action:@selector(gestureUnLockSwitchChanged:) forControlEvents:UIControlEventValueChanged];
        
        cell.textLabel.text = @"手势解锁";
        cell.accessoryView  = gestureUnLockSwitch;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else if (indexPath.row == 0)
    {
        cell.textLabel.text = @"修改手势密码";
        cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    else if (indexPath.row == 1)
    {
        UISwitch *touchIdUnLockSwitch = [[UISwitch alloc] init];
        [touchIdUnLockSwitch setOn:[JinnLockTool isTouchIdUnlockEnabled]];
        [touchIdUnLockSwitch addTarget:self action:@selector(touchIdUnLockSwitchChanged:) forControlEvents:UIControlEventValueChanged];
        
        cell.textLabel.text = @"用 Touch ID 解锁";
        cell.accessoryView  = touchIdUnLockSwitch;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1 && indexPath.row == 0)
    {
        JinnLockViewController *lockViewController = [[JinnLockViewController alloc] initWithDelegate:self type:JinnLockTypeModify appearMode:JinnLockAppearModePush];
        [self.navigationController pushViewController:lockViewController animated:YES];
    }
}

#pragma mark - JinnLockViewControllerDelegate

- (void)passcodeDidCreate:(NSString *)passcode
{
    [self.lockSettingTableView reloadData];
}

- (void)passcodeDidRemove
{
    [self.lockSettingTableView reloadData];
}

@end