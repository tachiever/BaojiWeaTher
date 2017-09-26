//
//  NBTransition.m
//  UI_01导航控制器
//
//  Created by tcy on 16/8/26.
//  Copyright (c) 2016年 tcy. All rights reserved.
//

#import "MyTransition.h"

@implementation MyTransition

+ (void)setNavigationControllerTransitionAnimation:(UINavigationController *)nc type:(NSString *)animationType direction:(NSString *)animationDirection state:(NSString *)animationState duration:(NSTimeInterval)animationDuration {
    // 首先创建一个转场动画对象
    CATransition *animation = [CATransition animation];
    // 设置动画类型
    animation.type = animationType;
    // 设置动画方向
    animation.subtype = animationDirection;
    // 设置动画的节奏
    animation.timingFunction = [CAMediaTimingFunction functionWithName:animationState];
    // 设置动画时间
    animation.duration = animationDuration;
    // 把这个转场动画对象添加到一个视图的layer层
    // 把这个转场动画对象添加到导航控制器的view的layer层
    // 这个转场动画 执行完之后 会自动的把这个动画删除
    [nc.view.layer addAnimation:animation forKey:nil];
}

+ (void)setViewTransitionAnimation:(UIView *)view type:(NSString *)animationType direction:(NSString *)animationDirection state:(NSString *)animationState duration:(NSTimeInterval)animationDuration {
    // 首先创建一个转场动画对象
    CATransition *animation = [CATransition animation];
    animation.type = animationType;
    // 设置动画方向
    animation.subtype = animationDirection;
    // 设置动画的节奏
    animation.timingFunction = [CAMediaTimingFunction functionWithName:animationState];
    // 设置动画时间
    animation.duration = animationDuration;
    // 把这个转场动画对象添加到一个视图的layer层
    // 把这个转场动画对象添加到导航控制器的view的layer层
    // 这个转场动画 执行完之后 会自动的把这个动画删除
    [view.layer addAnimation:animation forKey:nil];
}

@end
