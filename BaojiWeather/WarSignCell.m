//
//  WarSignCell.m
//  BaojiWeather
//
//  Created by Tcy on 2017/3/24.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import "WarSignCell.h"

@implementation WarSignCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    CGFloat f1,f2;
    f1=SCREEN_WIDTH>320?15:13;
    f2=SCREEN_WIDTH>320?14:13;
    
    _nameLab.font=[UIFont systemFontOfSize:f1];
    _dateLab.font=[UIFont systemFontOfSize:f2];
    
    _bgview.layer.masksToBounds=YES;
    _bgview.layer.cornerRadius=5;
    _bgview.layer.borderWidth=1;
    _bgview.layer.borderColor=RGBCOLOR(6, 170, 243).CGColor;
    
    _detailLab.layer.masksToBounds=YES;
    _detailLab.layer.cornerRadius=5;
    _detailLab.layer.borderWidth=1;
    _detailLab.layer.borderColor=RGBCOLOR(6, 170, 243).CGColor;
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGuesture:)];
    [self.contentView addGestureRecognizer:longPress];

    
}

- (void)handleLongPressGuesture:(UILongPressGestureRecognizer *)guesture {
    
    if(self.delateAction)
    {
        self.delateAction();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
