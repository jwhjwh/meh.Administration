//
//  ZXDNetworking.m
//  Administration
//
//  Created by zhang on 2017/2/14.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "ZXDNetworking.h"
#import "MBProgressHUD.h"
#import <CommonCrypto/CommonCrypto.h>
#ifdef DEBUG
#define PPLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define PPLog(...)
#endif
static ZXDNetworking *zxdworking=nil;
@implementation ZXDNetworking
/**
 *  声明单例方法
 */
+(instancetype)shareManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       zxdworking= [[ZXDNetworking alloc]init];
    
    });
    return zxdworking;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        zxdworking = [super allocWithZone:zone];
    });
    return zxdworking;
}
- (void)GET:(NSString *)URLString parameters:(NSDictionary *)parameters success:(Success)success failure:(Failure)failure{
     [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
     AFHTTPSessionManager *manager = [self createAFHTTPSessionManager];
    [manager GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        success(responseObject);
        PPLog(@"responseObject = %@",responseObject);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        failure ? failure(error) : nil;
        PPLog(@"error = %@",error);
    }];
}


- (void)POST:(NSString *)URLString parameters:(NSDictionary *)parameters success:(Success)success failure:(Failure)failure view:(UIView*)view{
    // [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
     [MBProgressHUD showHUDAddedTo:view animated:YES];
     AFHTTPSessionManager *manager = [self createAFHTTPSessionManager];
    [manager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
      //  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [MBProgressHUD hideHUDForView: view animated:YES];

        success(responseObject);
        PPLog(@"responseObject = %@",responseObject);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        failure ? failure(error) : nil;
        PPLog(@"error = %@",error);
    }];
}

#pragma mark - 设置AFHTTPSessionManager相关属性

-(AFHTTPSessionManager *)createAFHTTPSessionManager
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
    
    const char *fooData = [inputStr UTF8String];
    
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(fooData,(unsigned int)strlen(fooData),result);
    
    NSMutableString *saveResult = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    
    for(int i = 0;i<CC_MD5_DIGEST_LENGTH;i++){
        
        [saveResult appendFormat:@"%02X",result[i]];//注意：这边如果是x则输出32位小写加密字符串，如果是X则输出32位大写字符串
        
    }
    
    return saveResult;
    
}
@end
