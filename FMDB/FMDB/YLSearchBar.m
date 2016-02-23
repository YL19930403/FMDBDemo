//
//  YLSearchBar.m
//  YLWeiBo
//
//  Created by 余亮 on 15/8/23.
//  Copyright (c) 2015年 余亮. All rights reserved.


//自己决定搜索框的宽度,定义为宏
#define SearchBarWidth  30

#import "YLSearchBar.h"

@implementation YLSearchBar
//提供一个快速创建YLSearchBar的类方法
+ (instancetype) searchBar
{
    return [[self alloc] init ];
}

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //封装一个搜索框
        self.background = [YLSearchBar resizedImageWithName:@"searchbar_textfield_background"];
        //设置放大镜图片
        UIImageView * imgV = [[UIImageView  alloc] initWithImage:[UIImage imageNamed:@"searchbar_textfield_search_icon"]];
//        设置尺寸
//        imgV.frame = CGRectMake(0, 0, 30, 30);
        //原本放大镜是挨着最左边的，但我们对imgV设置了尺寸之后，再让其居中模式，就会好看许多
        imgV.contentMode = UIViewContentModeCenter;
        self.leftView = imgV ;
        self.leftViewMode = UITextFieldViewModeAlways;
        self.clearButtonMode = UITextFieldViewModeAlways ;
        
        //设置字体
        NSMutableDictionary * mut = [NSMutableDictionary dictionary];
        mut[NSForegroundColorAttributeName] = [UIColor grayColor];
        mut[NSFontAttributeName] = [UIFont systemFontOfSize:15];
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索" attributes:mut];
    }
    return self;
}

//这个方法不用看
+ (UIImage *) resizedImageWithName:(NSString *)name
{
    UIImage * image = [UIImage  imageNamed:name ];
    return [image stretchableImageWithLeftCapWidth:image.size.width*0.5 topCapHeight:image.size.height*0.5];
    
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    //设置左边图标的frame
    self.leftView.frame = CGRectMake(0, 0, SearchBarWidth, self.frame.size.height);
}

@end
