//
//  MySubmittedViewController.m
//  Administration
//
//  Created by 九尾狐 on 2017/3/8.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "MySubmittedViewController.h"
#import "PW_DatePickerView.h"
#import "SubmittedViewController.h"
#import "RectordViewController.h"
#import<BaiduMapAPI_Map/BMKMapView.h>

#import<BaiduMapAPI_Location/BMKLocationService.h>

#import<BaiduMapAPI_Search/BMKGeocodeSearch.h>

#import<BaiduMapAPI_Map/BMKMapComponent.h>

#import<BaiduMapAPI_Search/BMKPoiSearchType.h>
@interface MySubmittedViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,PW_DatePickerViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
{
   
    BMKLocationService *_locService;  //定位
    
    BMKGeoCodeSearch *_geocodesearch; //地理编码主类，用来查询、返回结果信息
}

//列表
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataLabel;
@property (nonatomic,strong) NSMutableArray *ligdataLabel;
@property (nonatomic,strong) NSMutableArray *ligLabelAry;


@property (strong,nonatomic) UILabel *ligLabel;
@property (strong, nonatomic)  UIImageView *dateImage;//图片
@property (strong,nonatomic) UIButton *submittedBtn;//报岗记录按钮
@property (strong,nonatomic) UILabel *subDayLabel; // 时间
@property (strong,nonatomic) UITextField *DiDTextView;//地点

@property (nonatomic,strong) PW_DatePickerView *PWpickerView;
@property (nonatomic, strong)UIImage *goodPicture;

@property (nonatomic,strong) NSString *Age;


@property (nonatomic,strong) NSString *Wcode;
@property (nonatomic,strong) NSString *Qcode;
@property (nonatomic,strong) NSString *address;
//DateTimes
@property (nonatomic,strong) NSString *DateTimes;

@property (nonatomic,strong) NSString *cityy;
@end

@implementation MySubmittedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self startLocation];
    self.title = @"图片报岗";
    _Qcode = [[NSString alloc]init];
    _Age = [[NSString alloc]init];
    _ligLabelAry = [[NSMutableArray alloc]init];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    btn.autoresizesSubviews=NO;
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
   
   // self.automaticallyAdjustsScrollViewInsets = NO;
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]
                                    initWithTitle:@"提交"
                                    style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(masgegeClick)];
    rightButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    self.dataLabel =[NSMutableArray arrayWithObjects:@"时间",@"地点",@"事务概述",@"进展程度", nil];
    self.ligdataLabel =[NSMutableArray arrayWithObjects:@"选择时间",@"填写地点",@"填写事务概述",@"填写进展程度", nil];
    [self mySubmittedUI];
}
-(void)buiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)masgegeClick
{
    //1501010   //150222222232
    //picreport/queryPic.action  pageNo
    if (self.goodPicture == nil || _Wcode == nil||[_Wcode isEqualToString:@""]||_Age == nil||_Qcode == nil||_DateTimes == nil) {
        [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请填写内容" andInterval:1.0];
    }else{
    NSData *pictureData = UIImagePNGRepresentation(self.goodPicture);
    NSString *urlStr = [NSString stringWithFormat:@"%@upload/file.action", KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
        NSDictionary* dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"code":@"4",@"str":_Wcode,@"DateTimes":_DateTimes,@"Progress":_Qcode,@"Locations":_Age};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"image/jpeg",@"image/png",@"image/gif",@"image/tiff",@"application/octet-stream",@"text/json",nil];
    [manager POST:urlStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyMMddHHmm";
        NSString *fileName = [formatter stringFromDate:[NSDate date]];
        NSString *nameStr = @"file";
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [formData appendPartWithFileData:pictureData name:nameStr fileName:[NSString stringWithFormat:@"%@.png", fileName] mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView: self.view animated:NO];
        NSString *response = [[NSString alloc] initWithData:(NSData *)responseObject encoding:NSUTF8StringEncoding];
        NSData* jsonData = [response dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSUTF8StringEncoding error:nil];
        NSString *status =  [NSString stringWithFormat:@"%@",[dict valueForKey:@"status"]];
        
        if ([status isEqualToString:@"0000"]) {
           // [self dismissViewControllerAnimated:YES completion:nil];
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"上传成功" andInterval:1.0];
            dispatch_time_t timer = dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC);
            dispatch_after(timer, dispatch_get_main_queue(), ^(void){
                [self.navigationController popViewControllerAnimated:YES];
               
            });
        } else {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"图片上传失败" andInterval:1.0];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];

    }
    
}
-(void)mySubmittedUI{
    _submittedBtn = [[UIButton alloc]init];
    [_submittedBtn setBackgroundImage:[UIImage imageNamed:@"wdbg.png"] forState:UIControlStateNormal];
    [self.view addSubview:_submittedBtn];
    [_submittedBtn addTarget:self action:@selector(mySubMittedBtn) forControlEvents:UIControlEventTouchUpInside];
    self.submittedBtn.adjustsImageWhenHighlighted = NO;
    [_submittedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo (self.view.mas_bottom).offset(0);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.height.mas_equalTo(kHeight*140);
    }];
    NSString* phoneModel = [UIDevice devicePlatForm];
    
    self.tableView = [[UITableView alloc]init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    if ([phoneModel isEqualToString:@"iPhone Simulator"]||[phoneModel isEqualToString:@"iPhone X"]) {
        self.tableView.scrollEnabled = NO;
    }else{
        self.tableView.scrollEnabled = YES;
    }
    [self setExtraCellLineHidden:self.tableView];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        if ([phoneModel isEqualToString:@"iPhone Simulator"]||[phoneModel isEqualToString:@"iPhone X"]) {
            make.top.equalTo (self.view.mas_top).offset(90);
        }else{
            make.top.equalTo (self.view.mas_top).offset(70);
        }
        make.left.equalTo (self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.bottom.equalTo(_submittedBtn.mas_top).offset(0);
    }];

}
-(void)mySubMittedBtn
{
    
    RectordViewController *rectVC = [[RectordViewController alloc]init];
    [self.navigationController showViewController:rectVC sender:nil];

    

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    static NSString *CellIdentifier =@"Cell";
    //定义cell的复用性当处理大量数据时减少内存开销
    UITableViewCell *cell = [self.tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell ==nil)
    {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:CellIdentifier];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = _dataLabel[indexPath.row];
    CGRect labelRect2 = CGRectMake(100, 1, self.view.bounds.size.width-100, 48);
    if ([cell.textLabel.text isEqualToString:@"时间"]) {
        _subDayLabel = [[UILabel alloc]initWithFrame:labelRect2];
        [cell addSubview:_subDayLabel];
    }else {
        _DiDTextView =[[UITextField alloc]initWithFrame:labelRect2];
        _DiDTextView.backgroundColor=[UIColor whiteColor];
        _DiDTextView.font = [UIFont boldSystemFontOfSize:13.0f];
        _DiDTextView.tag = row;
        _DiDTextView.placeholder = _ligdataLabel[indexPath.row];
        [cell addSubview:_DiDTextView];
        [_DiDTextView addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return cell;
}
- (void)textFieldDidChange :(UITextField *)textField
{
    switch (textField.tag) {
        case 1:
            //地点
            NSLog(@"dd:%@",textField.text);
            _Age = textField.text;
            break;
        case 2:
            //事务概述
            _Wcode = textField.text;
            NSLog(@"Age%@",textField.text);
            
            break;
        case 3:
            //进展程度
            _Qcode = textField.text;
            NSLog(@"IdNo:%@,",textField.text);
            
            break;
        default:
            break;
    }

    
    
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
     NSString* phoneModel = [UIDevice devicePlatForm];
    
    UIView *view = [[UIView alloc]init];
    
    if ([phoneModel isEqualToString:@"iPhone Simulator"]||[phoneModel isEqualToString:@"iPhone X"]) {
    view.frame =CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-(50*4)-140-88);
    
    }else{
        view.frame =CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-(50*4)-64-80);
    }
    
        _dateImage = [[UIImageView alloc]init];
        _dateImage.image = [UIImage imageNamed:@"ph_mt02"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doTap:)];
    // 允许用户交互
    _dateImage.userInteractionEnabled = YES;
    
    [_dateImage addGestureRecognizer:tap];
        [view addSubview:_dateImage];
        [_dateImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo (view.mas_top).offset(0);
            make.left.equalTo(view.mas_left).offset(15);
            make.right.equalTo(view.mas_right).offset(-15);
            if ([phoneModel isEqualToString:@"iPhone Simulator"]||[phoneModel isEqualToString:@"iPhone X"]) {
                make.height.mas_equalTo(self.view.bounds.size.height-(50*4)-140-88);
            }else{
               make.height.mas_equalTo(self.view.bounds.size.height-(50*4)-64-80);
            }
            
        }];
    
    [tableView addSubview:view];
    return view;
}
- (void)doTap:(UITapGestureRecognizer*)sender{

    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = sourceType;
    [self presentViewController:picker animated:YES completion:nil];
    
}
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
   
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd hh:mm"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    if (!(_address==nil)) {
        
        self.goodPicture = [ZxdObject  text:[NSString stringWithFormat:@"%@  %@",_address,dateString] city:_cityy  addToView: [info objectForKey:UIImagePickerControllerEditedImage]];
    }else{
        self.goodPicture = [ZxdObject  text:dateString city:_cityy   addToView: [info objectForKey:UIImagePickerControllerEditedImage]];
    }
   
    [self dismissViewControllerAnimated:YES completion:nil];
    _dateImage.image=self.goodPicture;

}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    NSString* phoneModel = [UIDevice devicePlatForm];
    if ([phoneModel isEqualToString:@"iPhone Simulator"]||[phoneModel isEqualToString:@"iPhone X"]) {
        return self.view.bounds.size.height-(50*4)-140-88;
    }else{
       return self.view.bounds.size.height-(50*4)-64-80;
    }
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat sectionHeaderHeight = 240;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }
    else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        self.PWpickerView = [[PW_DatePickerView alloc] initDatePickerWithDefaultDate:nil andDatePickerMode:UIDatePickerModeDate];
        self.PWpickerView.delegate = self;
        [self.PWpickerView show];
    }
}
- (void)pickerView:(PW_DatePickerView *)pickerView didSelectDateString:(NSString *)dateString type:(DateType)type;
{
    _subDayLabel.text  = dateString;
    _DateTimes = [[NSString alloc]init];
    _DateTimes = _subDayLabel.text;
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

-(void)startLocation

{
    
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    
    _locService.delegate = self;
    
    _locService.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    
    //启动LocationService
    
    [_locService startUserLocationService];
    _geocodesearch = [[BMKGeoCodeSearch alloc] init];
    
    _geocodesearch.delegate = self;
}
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation

{
    
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    //地理反编码
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    
    reverseGeocodeSearchOption.reverseGeoPoint = userLocation.location.coordinate;
    
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count>0) {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
            if (placemark != nil) {
                
                NSString *city = placemark.locality;
                NSString *XIAN = placemark.administrativeArea;
                NSString*shequ = placemark.subLocality;
                
                _cityy = [NSString stringWithFormat:@"%@%@%@",XIAN,city,shequ];
                
                NSLog(@"%@",_cityy);
                //县区-城市-社区-
                //[_locService stopUserLocationService];
            }
        }
    }];
    
}
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    
    NSLog(@"address:%@----%@",result.addressDetail,result.address);
    _address=result.address;

    //addressDetail:     层次化地址信息
    
    //address:    地址名称
    
    //businessCircle:  商圈名称
    
    // location:  地址坐标
    
    //  poiList:   地址周边POI信息，成员类型为BMKPoiInfo
    
}
@end
