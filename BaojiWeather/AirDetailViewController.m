//
//  AirDetailViewController.m
//  BaojiWeather
//
//  Created by Tcy on 2017/3/15.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import "AirDetailViewController.h"
#import "MagicLabel.h"
#import "ColumnViwq.h"

@interface AirDetailViewController ()<UIScrollViewDelegate>{
    NSMutableArray *xArray;
    NSMutableArray *aqiValArray;
    NSMutableArray *pm2_5Array;

}
@property (weak, nonatomic) IBOutlet UIImageView *imageBg;
@property (nonatomic)UIScrollView *scrollBgView;
@property (strong, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UILabel *positionLab;
@property (weak, nonatomic) IBOutlet UILabel *aqiCountLab;
@property (weak, nonatomic) IBOutlet UIImageView *aqiStaImage;
@property (weak, nonatomic) IBOutlet UILabel *aqiStaLab;
@property (weak, nonatomic) IBOutlet UIImageView *aqiFace;
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UILabel *aqisign;
@property (weak, nonatomic) IBOutlet UILabel *pm2_5sign;
@property (strong, nonatomic) IBOutlet UIView *header2;

@property (nonatomic)MagicLabel *lab1;
@property (nonatomic)MagicLabel *lab2;

@property (nonatomic)ColumnViwq *columnAQI;
@property (nonatomic)ColumnViwq *columnPM2_5;




@end

@implementation AirDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"空气质量详情";
    xArray=[[NSMutableArray alloc]init];
    aqiValArray=[[NSMutableArray alloc]init];
    pm2_5Array=[[NSMutableArray alloc]init];
    self.view.backgroundColor=[UIColor whiteColor];
    NSLog(@"%d",self.infoDic);
    [self stupNav];
    [self createScrollerView];
    [self setInformWith:[_infoDic[@"aqi"] integerValue]];

    [self getData];

    
}

- (void)stupNav{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
    [[UINavigationBar appearance] setBarTintColor:RGBACOLOR(20, 37, 83, 0.1)];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    self.navigationItem.backBarButtonItem = item;
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
}
- (void)back:(id)btn{
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)getData{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"1" forKey:@"type"];
    [dict setObject:self.infoDic[@"position_name"] forKey:@"position_name"];
    
    [NBRequest postWithURL:AirQualityDetail type:RequestRefresh dic:dict success:^(NSData *requestData) {
 
        [xArray removeAllObjects];
        [aqiValArray removeAllObjects];
        [pm2_5Array removeAllObjects];
        //  NSArray *array = [NSJSONSerialization JSONObjectWithData:requestData options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:requestData options:NSJSONReadingMutableContainers error:nil];
        NSArray *array=dict[@"list"];

        for (NSDictionary *dic in array) {
            [xArray addObject:dic[@"hours"]];
            [aqiValArray addObject:dic[@"aqi"]];
            [pm2_5Array addObject:dic[@"id"]];
            
        }
        [self createColumnViewXarray:xArray aqiArray:aqiValArray pmArray:pm2_5Array];
       // [self updateColumnViewXarray:xArray aqiArray:aqiValArray pmArray:pm2_5Array];
        NSLog(@"%@",dict);
        

    } failed:^(NSError *error) {

    }];
}

- (void)createScrollerView{
    CGFloat h,h1,f1,h3;
    f1=SCREEN_HEIGHT>600 ?(SCREEN_WIDTH>400?10:10):10;
    h=SCREEN_HEIGHT>600 ?(SCREEN_WIDTH>400?260:240):220;
    h1=SCREEN_HEIGHT>600 ?(SCREEN_WIDTH>400?260:240):230;
    h3=SCREEN_HEIGHT>600 ?(SCREEN_WIDTH>400?1125:1085):1045;
    
    _imageBg.userInteractionEnabled=YES;
    _scrollBgView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _scrollBgView.directionalLockEnabled = YES; //只能一个方向滑动
    _scrollBgView.pagingEnabled = NO; //是否翻页
    _scrollBgView.backgroundColor = [UIColor clearColor];
    _scrollBgView.showsVerticalScrollIndicator =NO;
    _scrollBgView.showsHorizontalScrollIndicator =NO;
    _scrollBgView.bounces = YES;
    _scrollBgView.delegate = self;
    _scrollBgView.contentSize = CGSizeMake(0,h3);
    [_imageBg addSubview:_scrollBgView];

    _headView.frame=CGRectMake(0, 0, SCREEN_WIDTH, 470);
    [_scrollBgView addSubview:_headView];
    if ([_infoDic[@"position_name"] isEqualToString:@"全市"]) {
            _positionLab.text=[NSString stringWithFormat:@"监测点: 宝鸡市"];
    }else{
    
        _positionLab.text=[NSString stringWithFormat:@"监测点: %@",_infoDic[@"position_name"]];
    }
    _aqiCountLab.text=[NSString stringWithFormat:@"%@",_infoDic[@"aqi"]];
    
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-100, 40, 85, 60)];
    bgView.backgroundColor=RGBACOLOR(15, 35, 114,0.5);
    [_headView addSubview:bgView];
    
    UILabel *mindLab=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-100, 40, 85, 30)];
    mindLab.textAlignment=NSTextAlignmentCenter;
    mindLab.textColor=RGBACOLOR(244, 244, 244,0.9);
    mindLab.font=[UIFont systemFontOfSize:18];
    mindLab.text=[NSString stringWithFormat:@"排名:%ld",_num];
    [_headView addSubview:mindLab];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-100, 70, 85, 1)];
    lineView.backgroundColor=RGBACOLOR(1, 1, 1,0.5);
    [_headView addSubview:lineView];
    
    
    _lab1=[[MagicLabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-100, 77, 85, 30)];
    _lab1.font=[UIFont fontWithName:@"ArialMT" size:15];
    _lab1.textColor=[UIColor whiteColor];
    _lab1.speed=0.85;
    [_headView addSubview:_lab1];
    
    _lab2=[[MagicLabel alloc]initWithFrame:CGRectMake(65, 172,SCREEN_WIDTH-80, 30)];
    _lab2.font=[UIFont fontWithName:@"ArialMT" size:18];
//    _lab2.backgroundColor=RGBACOLOR(210, 222, 222,0.5);
    _lab2.textColor=[UIColor whiteColor];
    _lab2.speed=0.5;
    [_headView addSubview:_lab2];
    
    NSArray *nameArray=@[@"CO",@"NO₂",@"O₃",@"PM10",@"PM2.5",@"SO2"];
    NSArray *countArray=@[_infoDic[@"co"],_infoDic[@"notwo"],_infoDic[@"othree"],_infoDic[@"pmten"],_infoDic[@"pmtwo_f"],_infoDic[@"sotwo"]];
    for (int i=0; i<nameArray.count; i++) {
        UILabel *nameLab=[[UILabel alloc]initWithFrame:CGRectMake(4+(SCREEN_WIDTH-8)/6*i, 0, (SCREEN_WIDTH-8)/6, 35)];
        nameLab.textAlignment=NSTextAlignmentCenter;
        nameLab.textColor=RGBACOLOR(244, 244, 244,0.9);
        nameLab.font=[UIFont systemFontOfSize:16];
        nameLab.text=[NSString stringWithFormat:@"%@",nameArray[i]];
        [_infoView addSubview:nameLab];

        
        UILabel *mindLab=[[UILabel alloc]initWithFrame:CGRectMake(4+(SCREEN_WIDTH-8)/6*i, 35, (SCREEN_WIDTH-8)/6, 35)];
        mindLab.textAlignment=NSTextAlignmentCenter;
        mindLab.textColor=RGBACOLOR(244, 244, 244,0.9);
        mindLab.font=[UIFont systemFontOfSize:14];
        mindLab.text=[NSString stringWithFormat:@"%@",countArray[i]];
        [_infoView addSubview:mindLab];
    }
    
    _aqisign.layer.masksToBounds=YES;
    _aqisign.layer.cornerRadius=5;
    _aqisign.layer.borderWidth=1;
    _aqisign.layer.borderColor=[UIColor whiteColor].CGColor;
    

}

- (void)createColumnViewXarray:(NSArray *)aArr aqiArray:(NSArray *)aqiArr pmArray:(NSArray *)pnArr{
    CGFloat h,h1,f1,h3;
    f1=SCREEN_HEIGHT>600 ?(SCREEN_WIDTH>400?10:10):10;
    h=SCREEN_HEIGHT>600 ?(SCREEN_WIDTH>400?260:240):220;
    h1=SCREEN_HEIGHT>600 ?(SCREEN_WIDTH>400?260:240):230;
    _pm2_5sign.layer.masksToBounds=YES;
    _pm2_5sign.layer.cornerRadius=5;
    _pm2_5sign.layer.borderWidth=1;
    _pm2_5sign.layer.borderColor=[UIColor whiteColor].CGColor;
    
    _columnAQI = [[ColumnViwq alloc] initWithFrame:CGRectMake(10, 450, SCREEN_WIDTH-20, h)];
    // _columnAQI.xYlineColor=[UIColor whiteColor];
    _columnAQI.xYLineWidth=1;
    _columnAQI.xfont=f1;
    _columnAQI.yValfont=11;
    _columnAQI.yPerVal=50;
    _columnAQI.zerolenth=25;
    //NSArray *yvalueArr = @[@"80", @"70", @"90", @"60", @"40", @"30", @"70", @"90", @"60", @"40", @"130", @"60"];
    // NSArray *xvalueArr = @[@"12/22",@"12/23",@"12/23",@"12/23",@"12/23",@"12/23",@"12/23",@"12/23",@"12/23",@"12/23",@"12/23",@"12/23"];
    [_columnAQI drawZhuZhuangTu:aArr and:aqiArr];
    
    [_scrollBgView addSubview:_columnAQI];
    
    UILabel *jsLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 200, 100, 15)];
    jsLab.font=[UIFont fontWithName:@"ArialMT" size:10];
    jsLab.textColor=RGBCOLOR(244, 244, 244);
    jsLab.textAlignment=NSTextAlignmentLeft;
    jsLab.text=@"aqi指数";
    jsLab.transform = CGAffineTransformMakeRotation(M_PI/2*3);
    jsLab.center=CGPointMake(10, h+350);
    [_scrollBgView addSubview:jsLab];
    
    
    
    
    UILabel *tlab1=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-100, 450+h, 200, 15)];
    tlab1.font=[UIFont fontWithName:@"ArialMT" size:9];
    tlab1.textColor=RGBCOLOR(244, 244, 244);
    tlab1.textAlignment=NSTextAlignmentCenter;
    tlab1.text=@"(时间:时/日)";
    [_scrollBgView addSubview:tlab1];
    
    UILabel *tlab2=[[UILabel alloc]initWithFrame:CGRectMake(30, 458+h, 100, 15)];
    tlab2.font=[UIFont fontWithName:@"ArialMT" size:8];
    tlab2.textColor=RGBCOLOR(244, 244, 244);
    tlab2.textAlignment=NSTextAlignmentLeft;
    tlab2.text=@"∎(时间:时/日)";
    [_scrollBgView addSubview:tlab2];
    
    
    
    
    
    UIImageView * sigImageView=[[UIImageView alloc]init];
    sigImageView.frame = CGRectMake(15,480+h, SCREEN_WIDTH-30, 35*Rat);
    sigImageView.contentMode=UIViewContentModeScaleToFill;
    [sigImageView setImage:[UIImage imageNamed:@"ariquality_char"]];
    [_scrollBgView addSubview:sigImageView];
    
    _header2.frame=CGRectMake(0, 480+h+35*Rat, SCREEN_WIDTH, 70);
    [_scrollBgView addSubview:_header2];
    
    _columnPM2_5 = [[ColumnViwq alloc] initWithFrame:CGRectMake(10, h+35*Rat+540, SCREEN_WIDTH-20, h1)];
    // _columnPM2_5.xYlineColor=[UIColor whiteColor];
    _columnPM2_5.xYLineWidth=1;
    _columnPM2_5.xfont=f1;
    _columnPM2_5.yValfont=11;
    _columnPM2_5.yPerVal=20;
    _columnPM2_5.zerolenth=25;
    [_columnPM2_5 drawZhuZhuangTu:aArr and:pnArr];
    
    [_scrollBgView addSubview:_columnPM2_5];
    
    UILabel *jsLab2=[[UILabel alloc]initWithFrame:CGRectMake(0, 200, 100, 15)];
    jsLab2.font=[UIFont fontWithName:@"ArialMT" size:10];
    jsLab2.textColor=RGBCOLOR(244, 244, 244);
    jsLab2.textAlignment=NSTextAlignmentLeft;
    jsLab2.text=@"PM2.5(µg/m³)";
    jsLab2.transform = CGAffineTransformMakeRotation(M_PI/2*3);
    jsLab2.center=CGPointMake(10, h+35*Rat+440+h1);
    [_scrollBgView addSubview:jsLab2];
    
    UILabel *tlab3=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-100, h+35*Rat+540+h1, 200, 15)];
    tlab3.font=[UIFont fontWithName:@"ArialMT" size:9];
    tlab3.textColor=RGBCOLOR(244, 244, 244);
    tlab3.textAlignment=NSTextAlignmentCenter;
    tlab3.text=@"(时间:时/日)";
    [_scrollBgView addSubview:tlab3];
    
    UILabel *tlab4=[[UILabel alloc]initWithFrame:CGRectMake(30, h+35*Rat+548+h1, 100, 15)];
    tlab4.font=[UIFont fontWithName:@"ArialMT" size:8];
    tlab4.textColor=RGBCOLOR(244, 244, 244);
    tlab4.textAlignment=NSTextAlignmentLeft;
    tlab4.text=@"∎(时间:时/日)";
    [_scrollBgView addSubview:tlab4];


}
- (void)updateColumnViewXarray:(NSArray *)aArr aqiArray:(NSArray *)aqiArr pmArray:(NSArray *)pnArr{
    
    [_columnAQI drawZhuZhuangTu:aArr and:aqiArr];
    [_columnPM2_5 drawZhuZhuangTu:aArr and:pnArr];

}

- (void)setInformWith:(NSInteger)aqi{
    if (aqi>=0 && aqi<=50) {
        [_aqiStaImage setImage:[UIImage imageNamed:@"photo_yd"]];
        [_aqiFace setImage:[UIImage imageNamed:@"photo_you"]];
        [_aqiStaLab setText:@"优"];
        _lab1.text=@"各类人群可正常活动";
        _lab2.text=@"空气质量令人满意，基本无空气污染";
    }else if (aqi>=51 && aqi<=100) {
        [_aqiStaImage setImage:[UIImage imageNamed:@"photo_ld"]];
        [_aqiFace setImage:[UIImage imageNamed:@"photo_liang"]];
        [_aqiStaLab setText:@"良"];
        _lab1.text=@"极少数异常敏感人群应减少户外活动";
        _lab2.text=@"空气质量可接受，但某些污染物可能对极少数异常敏感人群健康有较弱影响";
    }else if (aqi>=101 && aqi<=150) {
        [_aqiStaImage setImage:[UIImage imageNamed:@"photo_qd"]];
        [_aqiFace setImage:[UIImage imageNamed:@"photo_qing"]];
        [_aqiStaLab setText:@"轻度污染"];
        _lab1.text=@"易感人群症状有轻度加剧，健康人群出现刺激症状";
        _lab2.text=@"儿童、老年人及心脏病、呼吸系统疾病患者应减少长时间、高强度的户外锻炼";
    }else if (aqi>=151 && aqi<=200) {
        [_aqiStaImage setImage:[UIImage imageNamed:@"photo_zd"]];
        [_aqiFace setImage:[UIImage imageNamed:@"photo_qing"]];
        [_aqiStaLab setText:@"中度污染"];
        _lab1.text=@"进一步加剧易感人群症状，可能对健康人群心脏、呼吸系统有影响";
        _lab2.text=@"儿童、老年人及心脏病、呼吸系统疾病患者应减少长时间、高强度的户外锻炼";
    }else if (aqi>=201 && aqi<=300) {
        [_aqiStaImage setImage:[UIImage imageNamed:@"photo_yzd"]];
        [_aqiFace setImage:[UIImage imageNamed:@"photo_zhong"]];
        [_aqiStaLab setText:@"重度污染"];
        _lab1.text=@"心脏病和肺病患者症状显著加剧，运动耐受力降低，健康人群普遍出现症状";
        _lab2.text=@"儿童、老年人和心脏病、肺病患者应停留在室内，停止户外运动，一般人群减少户外运动";
    }else if (aqi>=300) {
        [_aqiStaImage setImage:[UIImage imageNamed:@"photo_yd"]];
        [_aqiFace setImage:[UIImage imageNamed:@"photo_zhong"]];
        [_aqiStaLab setText:@"严重污染"];
        _lab1.text=@"健康人群运动耐受力降低，有明显强烈症状，提前出现某些疾病";
        _lab2.text=@"儿童、老年人和病人应当留在室内，避免体力消耗，一般人群应避免户外活动";
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
