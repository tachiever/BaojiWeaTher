//
//  CityButton.m
//  BaojiWeather
//
//  Created by Tcy on 2017/3/23.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import "CityButton.h"

@implementation CityButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 初始化设置
        
        [self setup];
        
    }
    return self;
}

-(void)setup{

    [self setBackgroundColor:RGBCOLOR(243, 244, 246)];
//    self.layer.masksToBounds=YES;
//    self.layer.cornerRadius=3;
    self.layer.borderWidth=1;
    self.layer.borderColor=[UIColor lightGrayColor].CGColor;
    [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    if (SCREEN_HEIGHT>600) {
        self.titleLabel.font=[UIFont systemFontOfSize:18];
    }else{
        self.titleLabel.font=[UIFont systemFontOfSize:16];

    }
}

@end
