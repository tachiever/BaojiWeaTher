//
//  animationImageView.m
//  Donni
//
//  Created by Tcy on 16/9/8.
//  Copyright © 2016年 Wang Shou. All rights reserved.
//

#import "AnimationImageView.h"

@implementation AnimationImageView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self createImageView];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)createImageView{
    UIImageView *aniImageView=[[UIImageView alloc]init];
    [self addSubview:aniImageView];

}
- (void)createRect:(CGRect)rect
          imageNum:(NSInteger)num
             name:(NSString *)str
          duration:(NSTimeInterval)time{
    
    aniImageView =[[UIImageView alloc]initWithFrame:rect];
    NSMutableArray
    * animateArray
    = [[NSMutableArray alloc]initWithCapacity:num];
    for (int i=0; i<num; i++) {
            [animateArray addObject:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@%d.png",str,i] ofType:nil]]];
        
    }
    
    aniImageView.animationImages = animateArray;
    aniImageView.animationDuration =time;
    aniImageView.animationRepeatCount = 0;
    [aniImageView startAnimating];
    [self addSubview:aniImageView];
}


- (void)createRect:(CGRect)rect
          imageNum:(NSInteger)num
             jpg1:(NSString *)str1
             jpg2:(NSString *)str2
             jpg3:(NSString *)str3
          duration:(NSTimeInterval)time{
    
    aniImageView =[[UIImageView alloc]initWithFrame:rect];
    NSMutableArray
    * animateArray
    = [[NSMutableArray alloc]initWithCapacity:num];
    for (int i=0; i<num; i++) {
        if (i<10) {
            [animateArray addObject:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@%d.jpg",str1,i] ofType:nil]]];
            
        }
        if (i>=10&&i<100) {
            
            [animateArray addObject:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@%d.jpg",str2,i] ofType:nil]]];
            
        }
        if (i>=100) {
            [animateArray addObject:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@%d.jpg",str3,i] ofType:nil]]];
            
        }
    }
    
    aniImageView.animationImages = animateArray;
    aniImageView.animationDuration =time;
    aniImageView.animationRepeatCount = 0;
    [aniImageView startAnimating];
    [self addSubview:aniImageView];
    
    
}





- (void)stopAni{
    [aniImageView stopAnimating];
}

- (void)startAni{

    [aniImageView startAnimating];

}

- (void)createRect:(CGRect)rect
        imageArray:(NSMutableArray *)imageArray
          duration:(NSTimeInterval)time{
    
    aniImageView =[[UIImageView alloc]initWithFrame:rect];
    aniImageView.animationImages = imageArray;
    aniImageView.animationDuration =time;
    aniImageView.animationRepeatCount = 0;
    [aniImageView startAnimating];
    [self addSubview:aniImageView];
    
    
}

- (void)changeImageArray:(NSMutableArray *)array duration:(NSTimeInterval)time{
    [aniImageView stopAnimating];

    aniImageView.animationImages = array;
    aniImageView.animationDuration =time;
    aniImageView.animationRepeatCount = 0;
    [aniImageView startAnimating];
    [self addSubview:aniImageView];

}

@end
