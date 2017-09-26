//
//  MindDetailCell.m
//  BaojiWeather
//
//  Created by Tcy on 2017/3/6.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import "MindDetailCell.h"

@implementation MindDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _bgView.layer.masksToBounds=YES;
    _bgView.layer.cornerRadius=5;
    CGFloat f1,f2;
    f1=SCREEN_WIDTH>320?15:12;
    f2=SCREEN_WIDTH>320?12:9;
    
    _remindName.font=[UIFont systemFontOfSize:f1];
    _timeLab.font=[UIFont systemFontOfSize:f2];
    

    
}

- (void)setValueFor:(NSDictionary *)dic{
    NSString *ico=dic[@"type"];
    NSInteger  a= [[ico substringWithRange:NSMakeRange(0,2)] integerValue];
    NSInteger b = [[ico substringWithRange:NSMakeRange(2,1)] integerValue];
    _bgImage.image=[UIImage imageNamed:[self getBgColorImage:b]];
    _iconImage.image=[UIImage imageNamed:[self getImageName:a]];
    _detailLab.text=dic[@"diteals"];
    _cityLab.text=dic[@"name"];
    _remindName.text=dic[@"short_name"];
    _timeLab.text=[NSString stringWithFormat:@"%@发布",dic[@"publish_time"]];

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
