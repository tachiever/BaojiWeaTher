//
//  animationImageView.h
//  Donni
//
//  Created by Tcy on 16/9/8.
//  Copyright © 2016年 Wang Shou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnimationImageView : UIView{

    UIImageView *aniImageView;

}

- (void)createRect:(CGRect)rect
          imageNum:(NSInteger)num
              jpg1:(NSString *)str1
              jpg2:(NSString *)str2
              jpg3:(NSString *)str3
          duration:(NSTimeInterval)time;

- (void)createRect:(CGRect)rect
               imageNum:(NSInteger)num
                  name:(NSString *)str
               duration:(NSTimeInterval)time;

- (void)createRect:(CGRect)rect
        imageArray:(NSMutableArray *)imageArray
          duration:(NSTimeInterval)time;

- (void)changeImageArray:(NSMutableArray *)array duration:(NSTimeInterval)time;


- (void)startAni;
- (void)stopAni;
@end
