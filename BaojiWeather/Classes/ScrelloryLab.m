//
//  ScrelloryLab.m
//  BaojiWeather
//
//  Created by Tcy on 2017/2/25.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import "ScrelloryLab.h"

@implementation ScrelloryLab

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 初始化设置
        [self setup];
        [self asdTargetGesture];
    }
    return self;
}

- (void)setup {
    CGFloat f;
    f=SCREEN_HEIGHT>600?16:14;
    _icon=[[UIImageView alloc]initWithFrame:CGRectMake(4, 4, self.frame.size.height-8, self.frame.size.height-8)];
    _icon.contentMode = UIViewContentModeScaleAspectFit;
    
    [self addSubview:_icon];
    _lab=[[MagicLabel alloc]initWithFrame:CGRectMake(self.frame.size.height-2, 3,self.frame.size.width-self.frame.size.height-4, self.frame.size.height-6)];
    _lab.font=[UIFont fontWithName:@"ArialMT" size:f];
    _lab.textColor=[UIColor whiteColor];
    _lab.speed=0.7;
    [self addSubview:_lab];
}

- (void)setImage:(UIImage *)image text:(NSString *)text{
    [_icon setImage:image];
    [_lab setText:text];
    
}

- (void)updateText:(NSString *)text{
    [_lab setText:text];
    
}

- (void)asdTargetGesture{

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    tapGesture.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tapGesture];
    
}

-(void)tapGesture:(id)sender{

    
    if(self.action)
    {
        self.action();
    }
    // NSLog(@"xian shi ri li ");
}


@end
