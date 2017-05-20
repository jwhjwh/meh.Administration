//
//  USFmdbTool.h
//  Administration
//
//  Created by zhang on 2017/5/20.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@class Userpas;
@interface USFmdbTool : NSObject
// 插入模型数据
+ (BOOL)insertModel:(Userpas*)model;

/** 查询数据,如果 传空 默认会查询表中所有数据 */
+ (NSArray *)queryData:(NSString *)querySql;

/** 删除数据,如果 传空 默认会删除表中所有数据 */
+ (BOOL)deleteData:(NSString *)deleteSql;

/** 修改数据 */
+ (BOOL)modifyData:(NSString *)modifySql;

@end
