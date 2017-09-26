//
//  RainView.m
//  CAEmitterLayerView
//
//  Created by tcy on 15/5/14.
//  Copyright (c) 2015年 tcy. All rights reserved.
//

#import "RainView.h"

@implementation RainView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 初始化设置
        [self setup];
    }
    return self;
}

- (void)setup {
    self.emitterLayer.masksToBounds   = YES;
    self.emitterLayer.emitterShape    = kCAEmitterLayerLine;
    self.emitterLayer.emitterMode     = kCAEmitterLayerSurface;
    self.emitterLayer.emitterSize     = self.frame.size;
    self.emitterLayer.emitterPosition = CGPointMake(self.bounds.size.width / 2.f, - 20);
}

- (void)show {
    // 配置
    CAEmitterCell *rainflake  = [CAEmitterCell emitterCell];
    rainflake.birthRate       = 30.f;
    rainflake.speed           = 7.f;
    rainflake.velocity        = 2.f;
    rainflake.velocityRange   = 5.f;
    rainflake.yAcceleration   = 700.f;
    rainflake.contents        = (__bridge id)([UIImage imageNamed:@"rainImage"].CGImage);
    rainflake.color           = [UIColor colorWithRed:237/255.0 green:234/255.0 blue:237/255.0 alpha:1].CGColor;
    rainflake.lifetime        = 10.f;
    rainflake.scale           = 0.13f;
    rainflake.scaleRange      = 0.f;
    
    // 添加动画
    self.emitterLayer.emitterCells = @[rainflake];
}

- (void)hidden{

    self.emitterLayer.emitterCells=nil;
}


@end
