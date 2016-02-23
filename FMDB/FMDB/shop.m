//
//  shop.m
//  FMDB
//
//  Created by 余亮 on 16/2/23.
//  Copyright © 2016年 余亮. All rights reserved.
//

#import "shop.h"

@implementation shop

- (instancetype) initshop{
    if (self == [super init]) {

    }
    return self ;
}


+ (instancetype)defaultshop
{
    return [[self alloc] initshop];
}
@end
