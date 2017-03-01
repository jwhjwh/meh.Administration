//
//  ZXDNetworking.m
//  Administration
//
//  Created by zhang on 2017/2/14.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "ZXDNetworking.h"
#import <CommonCrypto/CommonCrypto.h>
#ifdef DEBUG
#define PPLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define PPLog(...)
#endif
static ZXDNetworking *zxdworking=nil;
//原始尺寸
static CGRect oldframe;
@implementation ZXDNetworking
/**
 *  声明单例方法
 */
//+(instancetype)shareManager{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//       zxdworking= [[ZXDNetworking alloc]init];
//    
//    });
//    return zxdworking;
//}
//
//+ (instancetype)allocWithZone:(struct _NSZone *)zone {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        zxdworking = [super allocWithZone:zone];
//    });
//    return zxdworking;
//}
+ (void)GET:(NSString *)URLString parameters:(NSDictionary *)parameters success:(Success)success failure:(Failure)failure view:(UIView*)view MBPro:(BOOL)MBPor{
    if (MBPor==YES) {
        [MBProgressHUD showHUDAddedTo:view animated:YES];
    }
  
     AFHTTPSessionManager *manager = [self createAFHTTPSessionManager];
    [manager GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView: view animated:NO];
        success(responseObject);
        PPLog(@"responseObject ++++= %@",responseObject);
   
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [MBProgressHUD hideHUDForView: view animated:NO];
        PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"网络不给力，请检查网络！" sureBtn:@"好的" cancleBtn:nil];
        alertView.resultIndex = ^(NSInteger index){
            
        };
        [alertView showMKPAlertView];
        failure ? failure(error) : nil;
        PPLog(@"error ----= %@",error);
    }];
}


+(void)POST:(NSString *)URLString parameters:(NSDictionary *)parameters success:(Success)success failure:(Failure)failure view:(UIView*)view{
  
     [MBProgressHUD showHUDAddedTo:view animated:YES];
     AFHTTPSessionManager *manager = [self createAFHTTPSessionManager];
    [manager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
      
        [MBProgressHUD hideHUDForView: view animated:NO];

        success(responseObject);
        PPLog(@"responseObject --=++ %@",responseObject);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView: view animated:NO];  PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"网络不给力，请检查网络！" sureBtn:@"好的" cancleBtn:nil];
        alertView.resultIndex = ^(NSInteger index){
            
        };
        [alertView showMKPAlertView];
        failure ? failure(error) : nil;
        PPLog(@"error =+++++++88 %@",error);
    }];
}

#pragma mark - 设置AFHTTPSessionManager相关属性

+(AFHTTPSessionManager *)createAFHTTPSessionManager
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置请求参数的类型:HTTP (AFJSONRequestSerializer,AFHTTPRequestSerializer)
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //设置请求的超时时间
    manager.requestSerializer.timeoutInterval = 30.f;
    //设置服务器返回结果的类型:JSON (AFJSONResponseSerializer,AFHTTPResponseSerializer)
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    
    return manager;
}

+(NSString *)encryptStringWithMD5:(NSString *)inputStr{
    
//    const char *fooData = [inputStr UTF8String];
//    
//    unsigned char result[CC_MD5_DIGEST_LENGTH];
//    
//    CC_MD5(fooData,(unsigned int)strlen(fooData),result);
//    
//    NSMutableString *saveResult = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
//    
//    for(int i = 0;i<CC_MD5_DIGEST_LENGTH;i++){
//        
//        [saveResult appendFormat:@"%02X",result[i]];//注意：这边如果是x则输出32位小写加密字符串，如果是X则输出32位大写字符串
//        
//    }
//    
//    return saveResult;
    NSString *input=[self substringToIndexString:inputStr];
    const char *cStr = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), result);
    
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
    
}
+(NSString*)substringToIndexString:(NSString*)string{
   return  [string stringByAppendingString:[string substringToIndex:5]];
}
//  去除Cell多余的线
+(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    
}

@end
