//
//  Lifeview.m
//  BaojiWeather
//
//  Created by Tcy on 2017/2/27.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import "Lifeview.h"

@implementation Lifeview

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 初始化设置
        
        
        
    }
    return self;
}

- (void)drawViewWithImage:(NSString *)image title:(NSString *)title index:(NSString *)index{
    
    CGFloat f,f1,f2,w1,w2;
    f2=SCREEN_HEIGHT>600 ?14:12;
    f1=SCREEN_HEIGHT>600 ?17:14;
    f=SCREEN_HEIGHT>600?16:14;
    w1=SCREEN_HEIGHT>600?18:14;
    w2=SCREEN_HEIGHT>600?14:10;
    
    _iconImage=[[UIImageView alloc]initWithFrame:CGRectMake(10, 13, self.frame.size.height-26, self.frame.size.height-26)];
    [_iconImage setImage:[UIImage imageNamed:image]];
    [self addSubview:_iconImage];
    
    _titleLab=[[UILabel alloc]initWithFrame:CGRectMake(40, 6,self.frame.size.width-45, 20)];
    _titleLab.font=[UIFont fontWithName:@"ArialMT" size:f1];
    _titleLab.textColor=[UIColor whiteColor];
    _titleLab.textAlignment=NSTextAlignmentRight;
    _titleLab.text=index;
    [self addSubview:_titleLab];
    
    _indexLab=[[UILabel alloc]initWithFrame:CGRectMake(50, self.frame.size.height-23,self.frame.size.width-55, 20)];
    _indexLab.font=[UIFont fontWithName:@"ArialMT" size:f2];
    _indexLab.textColor=RGBACOLOR(242, 242, 242, 0.9);
    _indexLab.textAlignment=NSTextAlignmentRight;
    _indexLab.text=title;
    [self addSubview:_indexLab];
    
}
- (void)updateStatuesSting:(NSString *)sta{
    _titleLab.text=sta;
}

@end
