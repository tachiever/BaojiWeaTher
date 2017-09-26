//
//  TableHeadView.m
//  BaojiWeather
//
//  Created by Tcy on 2017/2/27.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import "TableHeadView.h"

@implementation TableHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 初始化设置
        
        [self setup];
        
    }
    return self;
}

- (void)setup {
    
    _bgView=[[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-190, 20, 180, 34)];
    _bgView.backgroundColor=RGBACOLOR(156, 147, 72, 0.6);
    _bgView.layer.masksToBounds=YES;
    _bgView.layer.cornerRadius=16;
    [self addSubview:_bgView];
    
    _infoLab=[[UILabel alloc]initWithFrame:CGRectMake(_bgView.frame.size.width-30-110, 0, 110, 34)];
    _infoLab.text=@"暴雪蓝色预警";
    _infoLab.font=[UIFont fontWithName:@"ArialMT" size:17];
    _infoLab.textColor=[UIColor whiteColor];
    [_bgView addSubview:_infoLab];
    
    
    _countLab =[[UILabel alloc]initWithFrame:CGRectMake(150, 6, 22, 22)];
    _countLab.text=@"0";
    _countLab.backgroundColor=[UIColor redColor];
    _countLab.layer.masksToBounds=YES;
    _countLab.layer.cornerRadius=11;
    _countLab.textAlignment=NSTextAlignmentCenter;
    _countLab.font=[UIFont fontWithName:@"ArialMT" size:14];
    _countLab.textColor=[UIColor whiteColor];
    [_bgView addSubview:_countLab];
    
    _iconBgimage =[[UIImageView alloc]initWithFrame:CGRectMake(4, 4, 26, 26)];
    [_bgView addSubview:_iconBgimage];
    
    _iconImageView =[[UIImageView alloc]initWithFrame:CGRectMake(4, 4, 26, 26)];
    [_bgView addSubview:_iconImageView];
    
    NSDictionary *attrs = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:17]};
    CGSize size=[_infoLab.text sizeWithAttributes:attrs];
    
    _bgView.frame=CGRectMake(SCREEN_WIDTH-70-size.width-10, 20, 70+size.width, 34);
    _infoLab.frame=CGRectMake(35, 0, size.width, 34);
    _countLab.frame= CGRectMake(size.width+40, 6, 22, 22);
    _bgView.hidden=YES;
    
    
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDetailInformation:)];
    tapGesture1.numberOfTapsRequired = 1;
    [_bgView addGestureRecognizer:tapGesture1];
    
    
    
    
}

- (void)showDetailInformation:(id)sender{
    if(self.actionShow)
    {
        self.actionShow();
    }
}
- (void)updateHeaderWithDic:(NSDictionary *)dic{
    
    NSLog(@"预警数量：%ld",[dic[@"wr_count"] integerValue]);
    if([dic[@"wr_count"] integerValue]>0){
        _bgView.hidden=NO;
        
        _infoLab.text=dic[@"short_name"];
        _countLab.text=[NSString stringWithFormat:@"%@",dic[@"wr_count"]];
        
        
        NSString *ico=dic[@"type"];
        
        NSInteger  a= [[ico substringWithRange:NSMakeRange(0,2)] integerValue];
        NSInteger b = [[ico substringWithRange:NSMakeRange(2,1)] integerValue];

        _iconBgimage.image=[UIImage imageNamed:[self getBgColorImage:b]];
        _iconImageView.image=[UIImage imageNamed:[self getImageName:a]];
        NSDictionary *attrs = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:17]};
        CGSize size=[_infoLab.text sizeWithAttributes:attrs];
        
        _bgView.frame=CGRectMake(SCREEN_WIDTH-70-size.width-10, 20, 70+size.width, 34);
        _iconImageView.frame=CGRectMake(2, 2, 30, 30);
        _infoLab.frame=CGRectMake(35, 0, size.width, 34);
        _countLab.frame= CGRectMake(size.width+40, 6, 22, 22);
    }
    if([dic[@"wr_count"] integerValue]==0){
        _bgView.hidden=YES;
    }
}

- (NSString *)getImageName:(NSInteger )img{
    NSString *drawable;
    if (img==1){
        drawable=@"w_baoyu";
        
    }else if (img==2) {
        drawable=@"w_baoxue";
        
    }else if (img==3) {
        drawable=@"w_leidian";
        
    }else if (img==4) {
        drawable=@"w_bingbao";
        
        
    }else if (img==5) {
        drawable=@"w_dafeng";
        
    }else if (img==6) {
        drawable=@"w_daolujiebing";
        
        
    }else if (img==7) {
        drawable=@"w_dawu";
        
        
    }else if (img==8) {
        drawable=@"w_ganhan";
        
    }else if (img==9) {
        drawable=@"w_gaowen";
        
    }else if (img==10) {
        drawable=@"w_hanchao";
        
    }else if (img==11) {
        drawable=@"w_huaponishiliu";
        
    }else if (img==12) {
        drawable=@"w_senlinghuozai";
        
    }else if (img==13) {
        drawable=@"w_leiyudafeng";
        
        
    }else if (img==14) {
        drawable=@"w_mai";
        
        
    }else if (img==15) {
        drawable=@"w_shachengbao";
        
        
    }else if (img==16) {
        drawable=@"w_shuangdong";
        
    }else if (img==17) {
        drawable=@"w_shuizai";
        
        
    }else if (img==18) {
        drawable=@"w_taifeng";
        
    }else if (img==19) {
        drawable=@"zytq";
        
        
    }else if (img==20) {
        drawable=@"dltq";
    }
    return drawable;
}

- (NSString *)getBgColorImage:(NSInteger )color{
    
    NSString *drawable;
    
    if (color==1){
        drawable=@"alert_bg_blue01";
        
    }else if (color==2){
        drawable=@"alert_bg_yellow01";
        
    }
    else if (color==3){
        drawable=@"alert_bg_orange01";
        
    }
    else if(color==4){
        drawable=@"alert_bg_red01";
    }
    return drawable;
}

@end
