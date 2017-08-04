//
//  ZXDChineseString.h
//  Administration
//
//  Created by zhang on 2017/3/7.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "pinyin.h"
@interface ZXDChineseString : NSObject
@property(strong,nonatomic)NSString *string;
@property(strong,nonatomic)NSString *pinYin;
//-----  返回tableview右方indexArray
+(NSMutableArray*)IndexArray:(NSArray*)stringArr;

//-----  返回联系人
+(NSMutableArray*)LetterSortArray:(NSArray*)stringArr;

///----------------------
//返回一组字母排序数组(中英混排)
+(NSMutableArray*)SortArray:(NSArray*)stringArr;

+(NSMutableArray*)ReturnSortChineseArrar:(NSArray*)stringArr;

@end
