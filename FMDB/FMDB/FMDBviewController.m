//
//  FMDBviewController.m
//  FMDB
//
//  Created by 余亮 on 16/2/23.
//  Copyright © 2016年 余亮. All rights reserved.
//


/**
         该控制器里面用的FMDB框架
 */

#import "FMDBviewController.h"
#import <FMDB.h>
#import "shopTool.h"

@interface FMDBviewController ()
@property(nonatomic,strong) FMDatabase * db ;
@end

@implementation FMDBviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    [self.db executeUpdate:@"DELETE FROM t_shop WHERE price < 500"];
//    [self query];
    
    NSArray * shops = [shopTool shops];
    for (shop * sp in shops) {
        NSLog(@"%@  -  %@",sp.name,sp.price);
    }
}



- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
