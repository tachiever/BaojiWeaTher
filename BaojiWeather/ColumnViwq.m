//
//  ColumnViwq.m
//  BaojiWeather
//
//  Created by Tcy on 2017/3/16.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import "ColumnViwq.h"


//#define margin      30
#define viewWidth     self.frame.size.width
#define viewHeight    self.frame.size.height


@implementation ColumnViwq
- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        
    }
    
    return self;
}

//画坐标轴
- (void)drawZuoBiaoXi:(NSArray *)x_itemArr yLine:(NSArray *)y_itemArray{
     CGFloat maxValue = [[y_itemArray valueForKeyPath:@"@max.floatValue"] floatValue];
    int num=maxValue/_yPerVal;
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    //坐标轴原点
    CGPoint rPoint = CGPointMake(_zerolenth, viewHeight-_zerolenth);
    
    //画y轴
    [path moveToPoint:rPoint];
    [path addLineToPoint:CGPointMake(_zerolenth, 1.8*_zerolenth)];
    
    //画x轴
    [path moveToPoint:rPoint];
    [path addLineToPoint:CGPointMake(viewWidth, viewHeight-_zerolenth)];
    
     _xwidth=(viewWidth-_zerolenth)/((x_itemArr.count+1)*1.5-0.5);
    //画x轴上的标度
    for (int i=0; i<x_itemArr.count; i++) {
        [path moveToPoint:CGPointMake(_zerolenth+_xwidth*(i*1.5+1.25), viewHeight-_zerolenth)];
        [path addLineToPoint:CGPointMake(_zerolenth+_xwidth*(i*1.5+1.25), viewHeight-_zerolenth-3)];
    }
    
    
    
    //画y轴上的标度
    for (int i=1; i<num+1; i++) {
        
        [path moveToPoint:CGPointMake(_zerolenth, viewHeight-_zerolenth-((viewHeight-3*_zerolenth)/maxValue)*i*_yPerVal)];
        [path addLineToPoint:CGPointMake(_zerolenth+3, viewHeight-_zerolenth-((viewHeight-3*_zerolenth)/maxValue)*i*_yPerVal)];
    }
    
    layer.path = path.CGPath;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = [UIColor whiteColor].CGColor;
    layer.lineWidth = _xYLineWidth;
    [self.layer addSublayer:layer];
    
    CAShapeLayer *layer2 = [CAShapeLayer layer];
    UIBezierPath *path2 = [UIBezierPath bezierPath];
    for (int i=0; i<num+1; i++) {
        
        [path2 moveToPoint:CGPointMake(_zerolenth, viewHeight-_zerolenth-((viewHeight-3*_zerolenth)/maxValue)*i*_yPerVal)];
        [path2 addLineToPoint:CGPointMake(viewWidth, viewHeight-_zerolenth-((viewHeight-3*_zerolenth)/maxValue)*i*_yPerVal)];
    }
    
    layer2.path = path2.CGPath;
    layer2.fillColor = [UIColor clearColor].CGColor;
    layer2.strokeColor = RGBACOLOR(255, 255, 255, 0.7).CGColor;
    layer2.lineWidth = 0.5;
    [self.layer addSublayer:layer2];
    
    
    
    //给y轴加标注
    for (int i=0; i<num+1; i++) {
        int l=_yPerVal*i;
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, (viewHeight-_zerolenth-((viewHeight-3*_zerolenth)/maxValue)*i*_yPerVal)-10, _zerolenth, 20)];
        lab.text = [NSString stringWithFormat:@"%d", l];
        lab.textColor = [UIColor whiteColor];
        lab.font = [UIFont boldSystemFontOfSize:10];
        lab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:lab];
    }

}

//画柱状图
- (void)drawZhuZhuangTu:(NSArray *)x_itemArr and:(NSArray *)y_itemArr{
    [self initDrawView];
    //建立坐标轴
    [self drawZuoBiaoXi:x_itemArr yLine:y_itemArr];
    CGFloat maxValue = [[y_itemArr valueForKeyPath:@"@max.floatValue"] floatValue];

//    //画柱状图
    for (int i=0; i<x_itemArr.count; i++) {
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(_zerolenth+_xwidth*0.15+_xwidth*(i*1.5+0.5), viewHeight-_zerolenth-((viewHeight-3*_zerolenth)/maxValue)*[y_itemArr[i] floatValue], _xwidth*0.7 , ((viewHeight-3*_zerolenth)/maxValue)*[y_itemArr[i] floatValue])];
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.path = path.CGPath;
        layer.fillColor = [self backColorWithInteger:[y_itemArr[i] integerValue]].CGColor;
        layer.strokeColor = [UIColor clearColor].CGColor;
        [self.layer addSublayer:layer];
        
        
        
        UILabel *labv = [[UILabel alloc] initWithFrame:CGRectMake(_zerolenth+_xwidth*(i*1.5+0.25),  viewHeight-_zerolenth-((viewHeight-3*_zerolenth)/maxValue)*[y_itemArr[i] floatValue]-20, _xwidth*1.5, 20)];
        
        labv.text =[NSString stringWithFormat:@"%@",y_itemArr[i]] ;
        labv.textColor =[UIColor whiteColor];
        labv.font = [UIFont boldSystemFontOfSize:_yValfont];
        labv.textAlignment = NSTextAlignmentCenter;
        [self addSubview:labv];
        
        
    }
    //给x轴加标注
    for (int i=0; i<x_itemArr.count; i++) {
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(_zerolenth+_xwidth*(i*1.5+0.35)+(_xwidth-(300-_zerolenth)/((x_itemArr.count+1)*1.5-0.5))/2, viewHeight-_zerolenth, (300-_zerolenth)/((x_itemArr.count+1)*1.5-0.5)*1.3, _zerolenth)];
        lab.text = [NSString stringWithFormat:@"%@",x_itemArr[i]];
        lab.textColor =[UIColor whiteColor];
        lab.numberOfLines=0;
        lab.font = [UIFont boldSystemFontOfSize:_xfont];
        lab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:lab];
    }
}
- (void)initDrawView{
    
        [self.layer removeAllAnimations];
        [self.layer removeFromSuperlayer];
    
    
        [self removeFromSuperview];
    
    
    //[self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    
    //    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
}



- (UIColor *)backColorWithInteger:(NSInteger)inte{
    UIColor *cor;
    if (inte<=50) {
        cor=RGBACOLOR(0, 247, 106, 1);
    }else if (inte>50&&inte<=100){
        cor=RGBACOLOR(255, 244, 0, 1);
    }else if (inte>100&&inte<=150){
        cor=RGBACOLOR(255, 147, 0, 1);
    }else if (inte>150&&inte<=200){
        cor=RGBACOLOR(255,0, 0, 1);
    }else if (inte>100&&inte<=300){
        cor=RGBACOLOR(188, 0, 29, 1);
    }else if (inte>300){
        cor=RGBACOLOR(112, 0, 8, 1);
    }
    return cor;
}
@end
