//
//  shopAssModel.h
//  Administration
//
//  Created by 九尾狐 on 2017/12/4.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface shopAssModel : NSObject
@property (nonatomic,strong)NSString *age;//年龄
@property (nonatomic,strong)NSString *name;//名字
@property (nonatomic,strong)NSString *flag;//阴历---阳历----判断。 1.农历2.阳历
@property (nonatomic,strong)NSString *lunarBirthday;//农历生日
@property (nonatomic,strong)NSString *solarBirthday;//阳历生日
@property (nonatomic,strong)NSString *phone;//手机号
@property (nonatomic,strong)NSString *AssustantId;//店员id
@end
