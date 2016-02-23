//
//  shopTool.h
//  FMDB
//
//  Created by 余亮 on 16/2/23.
//  Copyright © 2016年 余亮. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "shop.h"

@interface shopTool : NSObject

+(NSArray *)shops ;

+(void) addshop:(shop *)shop ;

@end
