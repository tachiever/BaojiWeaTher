//
//  MyTransition.h
//
//  Created by tcy on 16/8/26.
//  Copyright (c) 2016年 tcy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// 注意，此方法执行完成后，会自动移除。
@interface MyTransition : NSObject

/* type:  动画类型
 全局变量形式:                            字符串常量形式:
 kCATransitionFade   交叉淡化过渡                @"fade"
 kCATransitionMoveIn 新视图移到旧视图上面         @"moveIn"
 kCATransitionPush   新视图把旧视图推出去         @"push"
 kCATransitionReveal 将旧视图移开,显示下面的新视图  @"reveal"
                     向上翻一页                  @"pageCurl"
                     向下翻一页                  @"pageUnCurl"
                     滴水效果                   @"rippleEffect"
                     收缩效果,如一块布被抽走      @"suckEffect"
                     立方体效果                 @"cube"
                     左右翻转效果                @"oglFlip"
 */
/* direction:  动画方向
 全局变量形式                       字符串常量形式：
 kCATransitionFromBottom          @"fromLeft"
 kCATransitionFromLeft            @"fromRight"
 kCATransitionFromRight           @"fromTop"
 kCATransitionFromTop             @"fromBottom"
 */
/* state:      动画节奏
 kCAMediaTimingFunctionLinear 线性（匀速）
 kCAMediaTimingFunctionEaseIn 先慢
 kCAMediaTimingFunctionEaseOut 后慢
 kCAMediaTimingFunctionEaseInEaseOut 先慢 后慢 中间快
 kCAMediaTimingFunctionDefault 默认
 */
/* duration:  动画持续时间
 */

+ (void)setNavigationControllerTransitionAnimation:(UINavigationController *)nc type:(NSString *)animationType direction:(NSString *)animationDirection state:(NSString *)animationState duration:(NSTimeInterval)animationDuration;

+ (void)setViewTransitionAnimation:(UIView *)view type:(NSString *)animationType direction:(NSString *)animationDirection state:(NSString *)animationState duration:(NSTimeInterval)animationDuration;

@end
