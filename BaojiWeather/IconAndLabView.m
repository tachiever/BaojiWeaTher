//
//  IconAndLabView.m
//  BaojiWeather
//
//  Created by Tcy on 2017/2/24.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import "IconAndLabView.h"


@interface IconAndLabView ()

@end
@implementation IconAndLabView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 初始化设置
        [self setup];
    }
    return self;
}

- (void)setup {
    CGFloat f;
    f=SCREEN_HEIGHT>600?16:14;
    _icon=[[UIImageView alloc]initWithFrame:CGRectMake(4, 4, self.frame.size.height-8, self.frame.size.height-8)];
    _icon.contentMode = UIViewContentModeScaleAspectFit;

    [self addSubview:_icon];
    _lab=[[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.height-2, 3,self.frame.size.width-self.frame.size.height-4, self.frame.size.height-6)];
    _lab.font=[UIFont fontWithName:@"ArialMT" size:f];
    _lab.textColor=[UIColor whiteColor];
    _lab.textAlignment=NSTextAlignmentLeft;
    [self addSubview:_lab];
}

- (void)setImage:(UIImage *)image text:(NSString *)text{
    [_icon setImage:image];
    [_lab setText:text];

}

- (void)updateText:(NSString *)text{
    [_lab setText:text];

}

- (void)setTextFont:(CGFloat)font{
    [_lab setFont:[UIFont systemFontOfSize:font]];
}

@end
