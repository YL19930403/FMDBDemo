//
//  shopTool.m
//  FMDB
//
//  Created by 余亮 on 16/2/23.
//  Copyright © 2016年 余亮. All rights reserved.
//

#import "shopTool.h"
#import <FMDB.h>
#import "shop.h"

@implementation shopTool

static FMDatabase *_db ;

+(void) initialize
{
    //1.打开数据库
    NSString * fileName = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingString:@"shop.sqlite"];
    _db = [FMDatabase databaseWithPath:fileName];
    [_db open];
    
    //2.创表
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_shop(id integer PRIMARY KEY , name text NOT NULL, price real) ; "];
    
    //executeQuery:查询数据
    //    [self.db executeQuery:<#(NSString *), ...#>];
    
    //executeUpdate:除了查询数据以外的其他操作
    //    [self.db executeUpdate:<#(NSString *), ...#>];

}

+ (void)addshop:(shop *)shop
{
    [_db  executeUpdateWithFormat:@"INSERT INTO t_shop(name, price) VALUES (%@, %@);",shop.name ,shop.price];
    
}

+ (NSArray *)shops
{
    //得到结果集
    FMResultSet * set = [_db executeQuery:@"SELECT * FROM t_shop ;"];
    
    //不断往下取数据
    NSMutableArray * shops = [NSMutableArray array];
    while (set.next) {
        //获得当前所指向的数据
        shop * sp = [shop defaultshop];
        sp.name = [set stringForColumn:@"name"];
        sp.price = [set stringForColumn:@"price"];
        [shops addObject:sp];
    }
    return shops ;
}



@end
















