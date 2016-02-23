//
//  shop.h
//  FMDB
//
//  Created by 余亮 on 16/2/23.
//  Copyright © 2016年 余亮. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface shop : NSObject

@property(nonatomic,copy) NSString * name  ;

@property(nonatomic,copy) NSString * price ;

//@property(nonatomic,assign)double price2 ;

- (instancetype) initshop ;

+ (instancetype) defaultshop ;
@end
