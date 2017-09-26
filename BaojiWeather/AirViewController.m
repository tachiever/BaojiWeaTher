//
//  AirViewController.m
//  BaojiWeather
//
//  Created by Tcy on 2017/3/14.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import "AirViewController.h"
#import "MagicLabel.h"
#import "PointTableViewCell.h"
#import "AirDetailViewController.h"
#import <UIKit/UIView.h> 
static CGFloat kImageOriginHight = 260.f;

@interface AirViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>{
    UITableView *mTableView;

}
@property (nonatomic)UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *imageBg;
@property (nonatomic)UIScrollView *scrollBgView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *aqiCount;
@property (weak, nonatomic) IBOutlet UILabel *aqisign;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *weekdayLab;
@property (weak, nonatomic) IBOutlet UILabel *statuesLab;
@property (weak, nonatomic) IBOutlet UIImageView *staSignImage;

@property (weak, nonatomic) IBOutlet UILabel *aqiLv;
@property (weak, nonatomic) IBOutlet UIView *scrollRemind;
@property (weak, nonatomic) IBOutlet UIImageView *aqiface;

@property (weak, nonatomic) IBOutlet UIView *noticeView;
@property (nonatomic)MagicLabel *lab1;
@property(nonatomic)MagicLabel *noticeLab;
@property(nonatomic)NSMutableArray *dataArray;
@property (nonatomic) JHLineChart *lineChart;
@property (strong, nonatomic) IBOutlet UIView *tabHeaderView;

@end

@implementation AirViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    _dataArray=[[NSMutableArray alloc]init];
    [self stupNav];

    [self createScrollerView];
    [self getMainData];

    

}

- (void)getMainData{

    NSString *urlStr=[NSString stringWithFormat:AirQualityMainPage];
    [NBRequest requestWithURL:urlStr type:RequestRefresh success:^(NSData *requestData) {
       // NSArray *array = [NSJSONSerialization JSONObjectWithData:requestData options:NSJSONReadingMutableContainers error:nil];
        [_dataArray removeAllObjects];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:requestData options:NSJSONReadingMutableContainers error:nil];
        
        
        NSArray *array=dict[@"detail"];
        NSArray *lineArray=dict[@"line"];
        NSLog(@"%@",dict);
        //NSLog(@"%@",array);
        
        
        for (NSDictionary *dic in array) {
            NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
            [dict setValue:dic[@"aqi"] forKey:@"aqi"];
            [dict setValue:dic[@"co"] forKey:@"co"];
            [dict setValue:dic[@"id"] forKey:@"id"];
            [dict setValue:dic[@"notwo"] forKey:@"notwo"];
            [dict setValue:dic[@"othree"] forKey:@"othree"];
            [dict setValue:dic[@"pmten"] forKey:@"pmten"];
            [dict setValue:dic[@"pmtwo_f"] forKey:@"pmtwo_f"];
            [dict setValue:dic[@"position_name"] forKey:@"position_name"];
            [dict setValue:dic[@"quality"] forKey:@"quality"];
            [dict setValue:dic[@"sotwo"] forKey:@"sotwo"];
            [dict setValue:dic[@"time_point"] forKey:@"time_point"];
            
            [_dataArray addObject:dict];
        }

        [mTableView reloadData];
        [self updateScrellowUI];

        for (int i=0; i<_dataArray.count; i++) {
            if ([_dataArray[i][@"position_name"] isEqualToString:@"全市"]) {
               // NSLog(@"%@",_dataArray[i]);
                [self updateDateForUI:_dataArray[i]];
            }
            
        }
        NSMutableArray *xNameArray=[[NSMutableArray alloc]init];
        NSMutableArray *yValueArray=[[NSMutableArray alloc]init];
        
        for (NSMutableDictionary *dic in lineArray) {
            [xNameArray addObject:dic[@"hours"]];
            [yValueArray addObject:dic[@"aqi"]];
        }
        if (xNameArray.count>0) {
            NSMutableArray *valArray=[[NSMutableArray alloc]init];
            [valArray addObject:yValueArray];
            [self updatelineChartValueYarray:valArray xArray:xNameArray];
            
        }
        
        [mTableView reloadData];
    } failed:^(NSError *error) {
        
    }];

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    PointTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"PointTableViewCell"];
    if (cell == nil) {
        cell = [[PointTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"PointTableViewCell"];
    }
    if (indexPath.row%2) {
        cell.backgroundColor=RGBACOLOR(1, 10, 10, 0);
    }else{
        cell.backgroundColor=RGBACOLOR(220, 244, 251, 1);

    }
    NSDictionary *dic=_dataArray[indexPath.row];
    cell.countLab.text = [NSString stringWithFormat:@"%ld",indexPath.row+1];
    cell.pointLab.text = [NSString stringWithFormat:@"%@",dic[@"position_name"]];
    cell.aqi.text = [NSString stringWithFormat:@"%@",dic[@"aqi"]];
    cell.pm2_5.text = [NSString stringWithFormat:@"%@",dic[@"pmtwo_f"]];
    cell.qualityLab.text = [NSString stringWithFormat:@"%@",dic[@"quality"]];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AirDetailViewController *advc=[[AirDetailViewController alloc]init];
    
    advc.infoDic=_dataArray[indexPath.row];
    advc.num=indexPath.row+1;
    [self.navigationController pushViewController:advc animated:YES];
}

- (void)updateDateForUI:(NSDictionary *)dic{
    
    NSLog(@"%@",dic);
    NSString* string =dic[@"time_point"];
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.S"];
    NSDate* inputDate = [inputFormatter dateFromString:string];
    
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"EEEE"];
    NSString *  weekString = [dateformatter stringFromDate:inputDate];
    NSDateFormatter  *dateformatter2=[[NSDateFormatter alloc] init];
    [dateformatter2 setDateFormat:@"M/dd"];
    NSString *  date = [dateformatter2 stringFromDate:inputDate];
    
    NSDateFormatter  *dateformatter3=[[NSDateFormatter alloc] init];
    [dateformatter3 setDateFormat:@"HH:mm"];
    NSString *  time = [dateformatter3 stringFromDate:inputDate];
    
    _timeLab.text=[NSString stringWithFormat:@"%@",time];
    _dateLab.text=[NSString stringWithFormat:@"%@",date];
    _weekdayLab.text=[NSString stringWithFormat:@"%@",weekString];
    _aqiCount.text=[NSString stringWithFormat:@"%@",dic[@"aqi"]];
    _statuesLab.text=[NSString stringWithFormat:@"%@",dic[@"quality"]];
    [self setInformWith:[dic[@"aqi"] integerValue]];
}

- (void)setInformWith:(NSInteger)aqi{
    
    
    
    
    _lab1=[[MagicLabel alloc]initWithFrame:CGRectMake(0, 6,_scrollRemind.frame.size.width, _scrollRemind.frame.size.height-3)];
    _lab1.font=[UIFont fontWithName:@"ArialMT" size:16];
    _lab1.textColor=[UIColor whiteColor];
    
    _noticeLab=[[MagicLabel alloc]initWithFrame:CGRectMake(60, 12,SCREEN_WIDTH-70,30)];
    _noticeLab.font=[UIFont fontWithName:@"ArialMT" size:18];
    _noticeLab.textColor=[UIColor whiteColor];
    
    if (aqi>=0 && aqi<=50) {
        _aqiLv.text=@"一级";
        [_staSignImage setImage:[UIImage imageNamed:@"photo_yd"]];
        [_aqiface setImage:[UIImage imageNamed:@"photo_you"]];
        _lab1.text=@"各类人群可正常活动";
        _noticeLab.text=@"空气质量令人满意，基本无空气污染";
    }else if (aqi>=51 && aqi<=100) {
        _aqiLv.text=@"二级";
        [_staSignImage setImage:[UIImage imageNamed:@"photo_ld"]];
        [_aqiface setImage:[UIImage imageNamed:@"photo_liang"]];
        _lab1.text=@"极少数异常敏感人群应减少户外活动";
        _noticeLab.text=@"空气质量可接受，但某些污染物可能对极少数异常敏感人群健康有较弱影响";
    }else if (aqi>=101 && aqi<=150) {
        _aqiLv.text=@"三级";
        [_staSignImage setImage:[UIImage imageNamed:@"photo_qd"]];
        [_aqiface setImage:[UIImage imageNamed:@"photo_qing"]];
        _lab1.text=@"易感人群症状有轻度加剧，健康人群出现刺激症状";
        _noticeLab.text=@"儿童、老年人及心脏病、呼吸系统疾病患者应减少长时间、高强度的户外锻炼";
    }else if (aqi>=151 && aqi<=200) {
        _aqiLv.text=@"四级";
        [_staSignImage setImage:[UIImage imageNamed:@"photo_zd"]];
        [_aqiface setImage:[UIImage imageNamed:@"photo_qing"]];
        _lab1.text=@"进一步加剧易感人群症状，可能对健康人群心脏、呼吸系统有影响";
        _noticeLab.text=@"儿童、老年人及心脏病、呼吸系统疾病患者应减少长时间、高强度的户外锻炼";
    }else if (aqi>=201 && aqi<=300) {
        _aqiLv.text=@"五级";
        [_staSignImage setImage:[UIImage imageNamed:@"photo_yzd"]];
        [_aqiface setImage:[UIImage imageNamed:@"photo_zhong"]];
        _lab1.text=@"心脏病和肺病患者症状显著加剧，运动耐受力降低，健康人群普遍出现症状";
        _noticeLab.text=@"儿童、老年人和心脏病、肺病患者应停留在室内，停止户外运动，一般人群减少户外运动";
    }else if (aqi>=300) {
        _aqiLv.text=@"六级";
        [_staSignImage setImage:[UIImage imageNamed:@"photo_yd"]];
        [_aqiface setImage:[UIImage imageNamed:@"photo_zhong"]];
        _lab1.text=@"健康人群运动耐受力降低，有明显强烈症状，提前出现某些疾病";
        _noticeLab.text=@"儿童、老年人和病人应当留在室内，避免体力消耗，一般人群应避免户外活动";
    }
    _noticeLab.speed=0.5;
    _lab1.speed=0.7;
    [_scrollRemind addSubview:_lab1];

    [_noticeView addSubview:_noticeLab];

}

- (void)updatelineChartValueYarray:(NSArray *)yArray xArray:(NSArray *)xArray{
    
    [_lineChart clear];
    _lineChart.xLineDataArr =xArray;
    _lineChart.valueArr =yArray;
    [_lineChart showAnimation];
    
}

- (void)updateScrellowUI{
    CGFloat h,h1;
    h=SCREEN_HEIGHT>600 ?(SCREEN_WIDTH>400?580:560):520;
    h1=(_dataArray.count+1)  *50;
    _scrollBgView.contentSize = CGSizeMake(0,kImageOriginHight*Rat+h+20+h1);
    mTableView.frame =CGRectMake(0, kImageOriginHight*Rat+h+20, SCREEN_WIDTH,h1);
}

- (void)createScrollerView{
    CGFloat h,h1,h2,h3;
    h=SCREEN_HEIGHT>600 ?(SCREEN_WIDTH>400?580:560):520;
    h1=SCREEN_HEIGHT>600 ?(SCREEN_WIDTH>400?280:280):260;
    h2=SCREEN_HEIGHT>600 ?(SCREEN_WIDTH>400?260:240):230;
    h3=SCREEN_HEIGHT>600 ?(SCREEN_WIDTH>400?550:530):500;
 
    _imageBg.userInteractionEnabled=YES;
    _scrollBgView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _scrollBgView.directionalLockEnabled = YES; //只能一个方向滑动
    _scrollBgView.pagingEnabled = NO; //是否翻页
    _scrollBgView.backgroundColor = [UIColor clearColor];
    _scrollBgView.showsVerticalScrollIndicator =NO;
    _scrollBgView.showsHorizontalScrollIndicator =NO;
    _scrollBgView.bounces = YES;
    _scrollBgView.delegate = self;
    _scrollBgView.contentSize = CGSizeMake(0,kImageOriginHight*Rat+h+520);
    [_imageBg addSubview:_scrollBgView];
    _headerImageView=[[UIImageView alloc]init];
    _headerImageView.frame = CGRectMake(0,0, SCREEN_WIDTH, kImageOriginHight*Rat);
    _headerImageView.contentMode=UIViewContentModeScaleToFill;
    [_headerImageView setImage:[UIImage imageNamed:@"air_headerbg"]];
    [_scrollBgView addSubview:_headerImageView];
    
    ////////
    _headerView.frame=CGRectMake(0, kImageOriginHight*Rat, SCREEN_WIDTH, h);
    [_scrollBgView addSubview:_headerView];
    
    _aqisign.layer.masksToBounds=YES;
    _aqisign.layer.cornerRadius=4;
    _aqisign.layer.borderWidth=1;
    _aqisign.layer.borderColor=[UIColor whiteColor].CGColor;
    
    //////////
    _lineChart = [[JHLineChart alloc] initWithFrame:CGRectMake(10,h1, SCREEN_WIDTH-15,h2) andLineChartType:JHChartLineEveryValueForEveryX];
    _lineChart.lineChartQuadrantType = JHLineChartQuadrantTypeFirstAndFouthQuardrant;
    _lineChart.xLineDataArr =@[@"0",@"1",@"2",@3,@4,@5,@6,@7,@"8",@"9",@10,@11];
    _lineChart.lineChartQuadrantType = JHLineChartQuadrantTypeFirstQuardrant;
    _lineChart.valueArr = @[@[@"1",@"1",@"1",@1,@1,@1,@1,@1,@1,@1,@1,@1]];
    _lineChart.valueLineColorArr =@[[UIColor whiteColor]];
    _lineChart.valueFontSize=12;
    _lineChart.xDescTextFontSize=10;
    _lineChart.yDescTextFontSize=10;
    _lineChart.pointColorArr = @[[UIColor whiteColor]];
    _lineChart.xAndYLineColor = [UIColor clearColor];
    _lineChart.xAndYNumberColor = [UIColor whiteColor];
    _lineChart.pointNumberColorArr = @[[UIColor whiteColor]];
    _lineChart.positionLineColorArr = @[[UIColor whiteColor]];
    _lineChart.contentFill = NO;
    _lineChart.pathCurve = YES;
    [_headerView addSubview:_lineChart];
    [_lineChart showAnimation];
    
    UIImageView * sigImageView=[[UIImageView alloc]init];
    sigImageView.frame = CGRectMake(15,h3, SCREEN_WIDTH-30, 35*Rat);
    sigImageView.contentMode=UIViewContentModeScaleToFill;
    [sigImageView setImage:[UIImage imageNamed:@"ariquality_char"]];
    [_headerView addSubview:sigImageView];
    
    
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kImageOriginHight*Rat+h+20, SCREEN_WIDTH,500) style:UITableViewStylePlain];
    mTableView.delegate = self;
    mTableView.dataSource = self;
    mTableView.rowHeight = 50;
//    mTableView.layer.masksToBounds=YES;
//    mTableView.layer.cornerRadius=5;
    mTableView.scrollEnabled =NO;
    mTableView.showsVerticalScrollIndicator=NO;
    mTableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    
    [mTableView registerNib:[UINib nibWithNibName:@"PointTableViewCell" bundle:nil] forCellReuseIdentifier:@"PointTableViewCell"];//xib定制cell
    
    [_scrollBgView addSubview:mTableView];
    _tabHeaderView.frame=CGRectMake(0, 0, SCREEN_WIDTH, 50);
    
    mTableView.tableHeaderView=_tabHeaderView;
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat yOffset  = scrollView.contentOffset.y;
    if (yOffset < -64) {
        CGRect f = _headerImageView.frame;
        f.origin.y = yOffset+64;
        f.size.height =-yOffset+(260*Rat-64);
        f.size.width =-yOffset+SCREEN_WIDTH;
        f.origin.x=yOffset/2;
        _headerImageView.frame = f;
    }
}

- (void)stupNav{
    self.title=self.titleStr;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
    [[UINavigationBar appearance] setBarTintColor:RGBACOLOR(20, 37, 83, 0.1)];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    self.navigationItem.backBarButtonItem = item;
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
}
- (void)back:(id)btn{
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden=NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
