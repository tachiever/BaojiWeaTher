//
//  MagicLabel.h
//  MagicLabel
//
//  Created by tcy on 15/8/26.
//  Copyright (c) 2015年 tcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MagicLabel : UIView

@property(nonatomic, copy) NSString* text;
@property(nonatomic, strong) UIColor* textColor;
@property(nonatomic, strong) UIFont* font;
@property(nonatomic, assign) CGFloat speed;
@end
