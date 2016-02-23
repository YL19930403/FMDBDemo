//
//  ViewController.m
//  FMDB
//
//  Created by 余亮 on 16/2/23.
//  Copyright © 2016年 余亮. All rights reserved.
//


/**
 *
         该控制器里面都是用的SQLite3原生的语句

 */

#define WIDTH [UIScreen mainScreen].bounds.size.width

#import "ViewController.h"
#import <sqlite3.h>
#import "shop.h"
#import "YLSearchBar.h"
#import "FMDBviewController.h"



@interface ViewController ()<UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *ShopTextV;
@property (weak, nonatomic) IBOutlet UITextField *ShopPriceTextV;
@property (weak, nonatomic) IBOutlet UITableView *tableV;

@property(nonatomic,strong)NSMutableArray * shops ;

//数据库对象实例
@property(nonatomic,assign) sqlite3 * db  ;

@end

@implementation ViewController

- (NSMutableArray *)shops
{
    if (!_shops) {
        _shops = [NSMutableArray array];
    }
    return _shops ;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //设置TableViewHeader
    YLSearchBar * searchBar = [YLSearchBar searchBar];
    searchBar.frame = CGRectMake(0, 0, WIDTH, 30);
    searchBar.delegate = self ;
    [searchBar addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    self.tableV.tableHeaderView = searchBar ;
    
    //初始化数据库
    [self initDataBase];
    
    //查询数据   （需要返回结果）
    [self setUpDataBase];

}

//查询数据
- (void) setUpDataBase
{
    const char * sql = "SELECT name ,price FROM t_shop ; ";
    sqlite3_stmt * stmt = NULL ;  //用来取查询结果
       //写-1 会自动帮我们计算sql语句的长度
   int status = sqlite3_prepare_v2(self.db, sql, -1, &stmt, NULL) ;
    if (status == SQLITE_OK) {    //准备成功，sql语句正确
        while(sqlite3_step(stmt) == SQLITE_ROW) {  //成功指向一条数据
            const  char * name = (const  char *) sqlite3_column_text(stmt, 0) ;
            const  char * price = (const  char *)sqlite3_column_text(stmt, 1) ;

            shop * sp = [shop defaultshop];
//            shop * sp = [[shop alloc] init];
            sp.name = [NSString stringWithUTF8String:name ];
            sp.price = [NSString stringWithUTF8String:price] ;
            [self.shops addObject:sp];
        }
    }
}

- (void) initDataBase
{
    //打开数据库
    NSString * fileName = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingString:@"shop.sqlite"];
    //如果数据可文件不存在，系统会自动创建文件自动初始化数据库
    int status = sqlite3_open(fileName.UTF8String, &_db);   //UTF8String 将OC的字符串转化为C字符串
    if (status == SQLITE_OK) {   //打开成功
        NSLog(@"打开数据库成功");
        
        //创表
        const char * sql = "CREATE TABLE IF NOT EXISTS t_shop(id integer PRIMARY KEY , name text NOT NULL, price real) ; " ;
        char * errorMsg = NULL ;
        //只执行语句，不用返回结果，就用sqlite3_exec这个函数
        sqlite3_exec(self.db, sql, NULL, NULL, &errorMsg) ;
        if (errorMsg) {
            NSLog(@"创表失败-- %s",errorMsg);   //打印C字符串用s
        }
    }else{   //打开失败
        NSLog(@"打开数据库失败") ;
    }

}

- (IBAction)insert {
    NSString * sql = [NSString stringWithFormat:@"INSERT INTO  t_shop(name, price) VALUES('%@',%f);",self.ShopTextV.text,self.ShopPriceTextV.text.doubleValue];
    sqlite3_exec(self.db, sql.UTF8String, NULL, NULL, NULL) ;
    
    //刷新表格
    shop * sp = [shop defaultshop];
    sp.name = self.ShopTextV.text ;
    sp.price = self.ShopPriceTextV.text ;
    [self.shops addObject:sp] ;
    [self.tableV reloadData];
    
}
- (IBAction)jump:(id)sender {
    FMDBviewController * fmdbVC = [[FMDBviewController alloc] init];
    
    [self presentViewController:fmdbVC animated:YES completion:nil];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.shops.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   static  NSString * ID = @"tableCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell  alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    cell.backgroundColor = [UIColor lightGrayColor];
    
    shop * shop = self.shops[indexPath.row];
    cell.textLabel.text = shop.name ;
    cell.detailTextLabel.text = shop.price ;
    
    return cell ;
    
}


#pragma  mark  -  UITextFieldDelegate

//这里只能拿到单次输入的字符
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"%@",string) ;
    return YES ;
}

//通过拿到UITextField，以及设置它的状态，则可以拿到所有输入完毕的字符
- (void) textFieldEditChanged:(UITextField *)textField
{
//    NSLog(@"%@",textField.text);
    [self.shops removeAllObjects];
    
    NSString * sql = [NSString stringWithFormat:@"SELECT name, price FROM t_shop WHERE name LIKE  '%%%@%%' OR price LIKE '%%%@%%'; ",textField.text,textField.text];
    
    sqlite3_stmt * stmt = NULL ;  //用来取查询结果
    //写-1 会自动帮我们计算sql语句的长度
    int status = sqlite3_prepare_v2(self.db, sql.UTF8String, -1, &stmt, NULL) ;
    if (status == SQLITE_OK) {    //准备成功，sql语句正确
        while(sqlite3_step(stmt) == SQLITE_ROW) {  //成功指向一条数据
            const  char * name = (const  char *) sqlite3_column_text(stmt, 0) ;
            const  char * price = (const  char *)sqlite3_column_text(stmt, 1) ;
            
            //            shop * sp = [shop defaultshop];
            shop * sp = [shop defaultshop];
            sp.name = [NSString stringWithUTF8String:name ];
            sp.price = [NSString stringWithUTF8String:price] ;
            [self.shops addObject:sp];
        }
    }
    //重新刷新
    [self.tableV reloadData];
}


@end





























