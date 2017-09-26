//
//  FallViewController.m
//  BaojiWeather
//
//  Created by Tcy on 2017/3/7.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import "FallViewController.h"
#import "JHChartHeader.h"
#import "FallUrlViewController.h"


@interface FallViewController ()<MAMapViewDelegate,UIScrollViewDelegate>{

    MAMapView *_mapView;
    MAGroundOverlay *_groundOverlay;
    MACoordinateBounds _coordinateBounds;
    //CustomOverlayRenderer *_renderer;
}
@property (weak, nonatomic) IBOutlet UIButton *fallBtn;
@property (weak, nonatomic) IBOutlet UIButton *temBtn;
@property (nonatomic)UIImageView *comImageView;
@property (strong, nonatomic) IBOutlet UIView *selectView;
@property (weak, nonatomic) IBOutlet UILabel *titLab;
@property (strong, nonatomic) IBOutlet UIView *downCharView;
@property (weak, nonatomic) IBOutlet UILabel *downCharTitLab;
@property (weak, nonatomic) IBOutlet UIButton *downCharShowAndHidden;
@property (nonatomic)CGFloat h;
@property (nonatomic)UILabel *timeLab;
@property (nonatomic)JHColumnChart *column;
@property (nonatomic)NSMutableArray *xNameArray;
@property (nonatomic)NSMutableArray *yValueArray;
@property (nonatomic)NSMutableArray *pointArray;


@property (nonatomic,copy)NSString *imageString;
@property (nonatomic)NSMutableArray *annotations;


@end

@implementation FallViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


#pragma mark - MAMapViewDelegate
- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAGroundOverlay class]])
    {
        MAGroundOverlayView *groundOverlayView = [[MAGroundOverlayView alloc]initWithGroundOverlay:overlay];
        
        return groundOverlayView;
    }
    return nil;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _h=(SCREEN_WIDTH>330)?((SCREEN_HEIGHT>700)?250:230):200;
    
    _xNameArray=[[NSMutableArray alloc]init];
    _yValueArray=[[NSMutableArray alloc]init];
    _pointArray=[[NSMutableArray alloc]init];
	
    [self stupNav];
    [self prepareUI];
    self.title=self.titleStr;
    self.view.backgroundColor = [UIColor whiteColor];
    [self createMapView];
    [self initOverlay];
    [self getFallPointList];
    [self createDownPartView];
	[self GetImageWithTime:@"1"];
    [self getFallInformationWithTime:@"1"];
    
    
}


- (void)getFallPointList{
    NSString *urlStr=[NSString stringWithFormat:FallPointlist];
    [NBRequest requestWithURL:urlStr type:RequestRefresh success:^(NSData *requestData) {
       // NSArray *array = [NSJSONSerialization JSONObjectWithData:requestData options:NSJSONReadingMutableContainers error:nil];
		[_pointArray removeAllObjects];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:requestData options:NSJSONReadingMutableContainers error:nil];
        

		_pointArray=dict[@"list"];
		//NSLog(@"======%@",_pointArray);
		if (_pointArray.count>0) {
			[self addFallPointWithArray:_pointArray];
		}

    } failed:^(NSError *error) {
        
    }];
    
}

- (void)getFallPointDetailWithId:(NSString *)point{
    
    NSString *urlStr=[NSString stringWithFormat:FallPointDetail,point];
    [NBRequest requestWithURL:urlStr type:RequestRefresh success:^(NSData *requestData) {
		 NSArray *array = [NSJSONSerialization JSONObjectWithData:requestData options:NSJSONReadingMutableContainers error:nil];
		//NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:requestData options:NSJSONReadingMutableContainers error:nil];
		NSMutableArray *xNam=[[NSMutableArray alloc]init];
		NSMutableArray *yVal=[[NSMutableArray alloc]init];
		
		//NSLog(@"======%@",array);

		if (array.count>0) {
			
			for (NSMutableDictionary *dic in array) {
				[xNam addObject:dic[@"xName"]];
				NSArray *aa =[NSArray arrayWithObject:dic[@"yRainValue"]];
				[yVal addObject:aa];
			}
			[self updateColumValueYarray:yVal xArray:xNam];
			
		}
		
    } failed:^(NSError *error) {
		
    }];
    
}

- (void)getFallInformationWithTime:(NSString *)time {
	
	NSString *urlStr=[NSString stringWithFormat:FallWithTimeUrl,time];
    [NBRequest requestWithURL:urlStr type:RequestRefresh success:^(NSData *requestData) {
        [_xNameArray removeAllObjects];
        [_yValueArray removeAllObjects];
        
        NSArray *array = [NSJSONSerialization JSONObjectWithData:requestData options:NSJSONReadingMutableContainers error:nil];
		
        for (NSMutableDictionary *dic in array) {
            [_xNameArray addObject:dic[@"xName"]];
            NSArray *aa =[NSArray arrayWithObject:dic[@"yRainValue"]];
            [_yValueArray addObject:aa];
        }
		if (_xNameArray.count>0) {
		[self updateColumValueYarray:_yValueArray xArray:_xNameArray];

		}
    } failed:^(NSError *error) {
        
    }];
}
- (void)GetImageWithTime:(NSString *)time{
    _timeLab.text=[self getTimeWithTime:[time integerValue]];
    _titLab.text=[NSString stringWithFormat:@"%@等值面图",[self getTimeWithTime:[time integerValue]]];
    
    NSString *urlStr=[NSString stringWithFormat:MarkIamgeUrl,time];
    [NBRequest requestWithURL:urlStr type:RequestRefresh success:^(NSData *requestData) {
        UIImage *img = [UIImage imageWithData:requestData];
        [self setImageOnMap:img];
    } failed:^(NSError *error) {
        
    }];
}

- (void)setImageOnMap:(UIImage *)image{
    
    
    [_mapView removeOverlay:_groundOverlay];
    _groundOverlay = [MAGroundOverlay groundOverlayWithBounds:_coordinateBounds icon:[self imageByApplyingAlpha:0.5 image:image]];
    [_mapView addOverlay:_groundOverlay];
}

- (void)createMapView{
    [AMapServices sharedServices].enableHTTPS = YES;
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 144, self.view.bounds.size.width, self.view.bounds.size.height-184)];
    _mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
//    _mapView.centerCoordinate = CLLocationCoordinate2DMake(34.349493,107.183017);
//    _mapView.zoomLevel=9;
	
	
	
	MACoordinateSpan span = MACoordinateSpanMake(2.24, 2.24);
	CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(34.349493,107.183017);
	MACoordinateRegion regoin = MACoordinateRegionMake(coordinate, span);
	_mapView.limitRegion = regoin;
	//_mapView.region = regoin;
	

}
- (void)addFallPointWithArray:(NSArray *)array{
	self.annotations = [NSMutableArray array];
	for (int i =0; i <array.count; ++i)
	{
		NSMutableDictionary *dic=array[i];
		MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
		pointAnnotation.coordinate = CLLocationCoordinate2DMake([dic[@"lattitude"] floatValue],[dic[@"longitude"] floatValue]);
		pointAnnotation.title =dic[@"name"];
		pointAnnotation.subtitle =[NSString stringWithFormat:@"%@",dic[@"site_id"]];
		[self.annotations addObject:pointAnnotation];
	}
	[_mapView addAnnotations:self.annotations];
	[_mapView showAnnotations:self.annotations edgePadding:UIEdgeInsetsMake(20,20,20,80)animated:YES];
}


//- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
//{
//	if ([annotation isKindOfClass:[MAPointAnnotation class]])
//	{
//		static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
//		MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
//		if (annotationView == nil)
//		{
//			annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
//		}
//		annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
//		annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
//		annotationView.draggable = YES;        //设置标注可以拖动，默认为NO
//		annotationView.pinColor = MAPinAnnotationColorPurple;
//		return annotationView;
//	}
//	return nil;
//}


- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
	if ([annotation isKindOfClass:[MAPointAnnotation class]])
	{
		static NSString *reuseIndetifier = @"annotationReuseIndetifier";
		MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
		if (annotationView == nil)
		{
			annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
		}
		annotationView.image = [UIImage imageNamed:@"zytq.png"];
		annotationView.centerOffset = CGPointMake(0, 0);
		return annotationView;
	}
	return nil;
}

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view{
	NSArray * array = [NSArray arrayWithArray:_mapView.annotations];
//	NSLog(@"%.1f",view.annotation.coordinate.latitude);
//	NSLog(@"%lf",view.annotation.coordinate.latitude);
	for (MAPointAnnotation *point in array) {
		if (view.annotation.coordinate.latitude == point.coordinate.latitude&&view.annotation.coordinate.longitude == point.coordinate.longitude){
			NSLog(@"点了我 %@",point.subtitle);
			[self getFallPointDetailWithId:point.subtitle];
			_timeLab.text=[NSString stringWithFormat:@"%@%@站点24小时降水量",point.title,point.subtitle];

			if (_downCharView.frame.origin.y==SCREEN_HEIGHT-40) {
				[self showDownPart];
				
				[_downCharShowAndHidden setBackgroundImage:[UIImage imageNamed:@"xxjt"] forState:UIControlStateNormal];
				_downCharTitLab.text=@"降水柱状图收起";
			}
		}
	
	}
}

#pragma mark - Initialization
- (void)initOverlay{
    //self.customOverlay = [[CustomOverlay alloc] initWithCenter:CLLocationCoordinate2DMake(34.36667752,107.1269989) radius:30000];
    _coordinateBounds = MACoordinateBoundsMake(CLLocationCoordinate2DMake(35.119535,108.061038),CLLocationCoordinate2DMake(33.579451,106.304996));
    
    _groundOverlay = [MAGroundOverlay groundOverlayWithBounds:_coordinateBounds icon:[UIImage imageNamed:@""]];
    _mapView.visibleMapRect = _groundOverlay.boundingMapRect;
    
    [_mapView addOverlay:_groundOverlay];
}
- (void)createDownPartView{

    _comImageView =[[UIImageView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-40-160*Rat, 94*Rat, 160*Rat)];
    [_comImageView setImage:[UIImage imageNamed:@"jstl"]];
    _comImageView.contentMode = UIViewContentModeScaleToFill;
    
    [self.view addSubview:_comImageView];
    
    [_downCharShowAndHidden setBackgroundImage:[UIImage imageNamed:@"xsjt"] forState:UIControlStateNormal];
    _downCharView.frame=CGRectMake(0, SCREEN_HEIGHT-40, SCREEN_WIDTH, _h+40);
    [self.view addSubview:_downCharView];
	

    
    _column = [[JHColumnChart alloc] initWithFrame:CGRectMake(30, 55, SCREEN_WIDTH-30, _h-40)];
    _column.valueArr =@[@[@0],@[@0],@[@0],@[@0],@[@0],@[@0],@[@0],@[@0],@[@0],@[@0],@[@0],@[@0]];
    _column.originSize = CGPointMake(20, 20);
    _column.yDescTextFontSize=12;
    _column.xDescTextFontSize=13;
    _column.drawFromOriginX = 10;
    _column.columnWidth = 40;
    _column.drawTextColorForX_Y = RGBCOLOR(32, 183, 238);
    _column.colorForXYLine = RGBCOLOR(32, 183, 238);
    _column.columnBGcolorsArr = @[RGBCOLOR(32, 183, 238),[UIColor greenColor],[UIColor orangeColor]];
    _column.xShowInfoText = @[@"渭滨区",@"金台区",@"陈仓区",@"凤翔县",@"岐山县",@"扶风县",@"眉县",@"陇县",@"千阳县",@"麟游县",@"凤县",@"太白县"];
    [_downCharView addSubview:_column];
    [_column showAnimation];

    UILabel *jsLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 200, 100, 26)];
    jsLab.font=[UIFont fontWithName:@"ArialMT" size:14];
    jsLab.textColor=RGBCOLOR(32, 183, 238);
    jsLab.textAlignment=NSTextAlignmentLeft;
    jsLab.text=@"降水(mm)";
    jsLab.transform = CGAffineTransformMakeRotation(M_PI/2*3);
    jsLab.center=CGPointMake(13, _h-90);
    [_downCharView addSubview:jsLab];

    _timeLab=[[UILabel alloc]initWithFrame:CGRectMake(10, 55, SCREEN_WIDTH-20, 30)];
    _timeLab.font=[UIFont fontWithName:@"ArialMT" size:14];
    _timeLab.textColor=RGBCOLOR(32, 183, 238);
    _timeLab.textAlignment=NSTextAlignmentRight;
    _timeLab.text=@"2017年03月05日09时至2017年03月06日09时";
    [_downCharView addSubview:_timeLab];
    
    UILabel *zhiNan=[[UILabel alloc]initWithFrame:CGRectMake(45, _h+10, 280, 30)];
    zhiNan.font=[UIFont fontWithName:@"ArialMT" size:12];
    zhiNan.textColor=RGBCOLOR(32, 183, 238);
    zhiNan.textAlignment=NSTextAlignmentLeft;
    zhiNan.text=@"∎ (y轴表示降水量，x轴表示站点名称)";
    [_downCharView addSubview:zhiNan];
    
    _selectView.frame=CGRectMake(0, 115, SCREEN_WIDTH, 0);
    _selectView.clipsToBounds=YES;
    _selectView.layer.masksToBounds=YES;
    _selectView.layer.cornerRadius=8;
    [self.view addSubview:_selectView];

}
- (void)prepareUI{
    CGFloat f;
    f=SCREEN_HEIGHT>600 ?14:12;
    _titLab.font=[UIFont systemFontOfSize:f];
    //  [btnSelect setBackgroundImage:[UIImage imageNamed:@"btBg"] forState:UIControlStateNormal];
    btnSelect.layer.borderWidth = 2;
    btnSelect.layer.borderColor = [RGBCOLOR(0, 162, 235) CGColor];
    btnSelect.layer.cornerRadius = 5;
    
}

- (void)updateColumValueYarray:(NSArray *)yArray xArray:(NSArray *)xArray{
    
    [_column clear];
    _column.valueArr =yArray;
    
    _column.xShowInfoText =xArray;
    [_column showAnimation];
    
}
- (IBAction)showAndHiddenCharView:(id)sender {
    [self downPartViewMove];

    if (_downCharView.frame.origin.y==SCREEN_HEIGHT-40) {
        [_downCharShowAndHidden setBackgroundImage:[UIImage imageNamed:@"xsjt"] forState:UIControlStateNormal];
        _downCharTitLab.text=@"降水柱状图展开";
    }
    if (_downCharView.frame.origin.y==SCREEN_HEIGHT-40-_h) {
        [_downCharShowAndHidden setBackgroundImage:[UIImage imageNamed:@"xxjt"] forState:UIControlStateNormal];
        _downCharTitLab.text=@"降水柱状图收起";
    }
}

- (void)showDownPart{
	CGRect downViewFrame=_downCharView.frame;
	CGRect imageFrame=_comImageView.frame;
	CGRect mapFrame=_mapView.frame;
	
		downViewFrame.origin.y -=_h;
		imageFrame.origin.y -=_h;
		mapFrame.size.height -=_h;
	

	[UIView animateWithDuration:0.5 animations:^{
		_downCharView.frame=downViewFrame;
		_comImageView.frame=imageFrame;
		_mapView.frame=mapFrame;
		
	}completion:^(BOOL finished) {
		
		
		
	}];


}

- (void)downPartViewMove{
    CGRect downViewFrame=_downCharView.frame;
    CGRect imageFrame=_comImageView.frame;
    CGRect mapFrame=_mapView.frame;

    if (_downCharView.frame.origin.y==SCREEN_HEIGHT-40) {
        
        downViewFrame.origin.y -=_h;
        imageFrame.origin.y -=_h;
        mapFrame.size.height -=_h;
    }
    if (_downCharView.frame.origin.y==SCREEN_HEIGHT-40-_h) {
        
        downViewFrame.origin.y +=_h;
        imageFrame.origin.y +=_h;
        mapFrame.size.height +=_h;
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        _downCharView.frame=downViewFrame;
        _comImageView.frame=imageFrame;
        _mapView.frame=mapFrame;
        
    }completion:^(BOOL finished) {

        

    }];
}

- (IBAction)showFallDetail:(id)sender {
	FallUrlViewController *clvc=[FallUrlViewController new];
	clvc.kind=@"fall";
	clvc.titleStr=@"雨量统计";
	[self.navigationController pushViewController:clvc animated:YES];
	
}
- (IBAction)showTempDetail:(id)sender {
	FallUrlViewController *clvc=[FallUrlViewController new];
	clvc.kind=@"temp";
	clvc.titleStr=@"温度统计";
	
	[self.navigationController pushViewController:clvc animated:YES];
}

- (IBAction)selectClicked:(UIButton *)sender  {
    
    CGRect frameq;
    if (_selectView.frame.size.height==0) {
        
        frameq=CGRectMake(0, 115, SCREEN_WIDTH, 248);

    }
    if (_selectView.frame.size.height>0) {
        
    frameq=CGRectMake(0, 115, SCREEN_WIDTH, 0);
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        _selectView.frame=frameq;

    }completion:^(BOOL finished) {


    }];
    if (sender.tag==1) {
        [btnSelect setTitle:@"1小时" forState:UIControlStateNormal];
        [self GetImageWithTime:@"1"];
        [self getFallInformationWithTime:@"1"];

    }else if (sender.tag==3) {
        [btnSelect setTitle:@"3小时" forState:UIControlStateNormal];
        [self GetImageWithTime:@"3"];
        [self getFallInformationWithTime:@"3"];


    }else if (sender.tag==6) {
        [btnSelect setTitle:@"6小时" forState:UIControlStateNormal];
        [self GetImageWithTime:@"6"];
        [self getFallInformationWithTime:@"6"];



    }else if (sender.tag==12) {
        [btnSelect setTitle:@"12小时" forState:UIControlStateNormal];
        [self GetImageWithTime:@"12"];
        [self getFallInformationWithTime:@"12"];


    }else if (sender.tag==24) {

        [btnSelect setTitle:@"24小时" forState:UIControlStateNormal];
        [self GetImageWithTime:@"24"];
        [self getFallInformationWithTime:@"24"];
    }
}

- (NSString *)getTimeWithTime:(NSInteger)inte{
    NSString *time;
    NSTimeInterval  oneHour = 60*60*1;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日HH时"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];

    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"yyyy年MM月dd日HH时"];
    NSString *currentDateStr2 = [dateFormatter2 stringFromDate:[[NSDate date] initWithTimeIntervalSinceNow: +oneHour*inte ]];
    time=[NSString stringWithFormat:@"%@至%@",currentDateStr,currentDateStr2];
    return time;
}

- (UIImage *)imageByApplyingAlpha:(CGFloat)alpha  image:(UIImage*)image{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextSetAlpha(ctx, alpha);
    
    CGContextDrawImage(ctx, area, image.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}
- (NSInteger)compareDate:(NSString*)date{
	NSInteger aa;
	NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
	[dateformater setDateFormat:@"yyyyMMdd HH"];
	NSDate *dta = [NSDate date];
	NSDate *dtb = [[NSDate alloc] init];
	
	dtb = [dateformater dateFromString:date];
	NSComparisonResult result = [dta compare:dtb];
	if (result==NSOrderedSame)
	{
		aa=0;
		//        相等  aa=0
	}else if (result==NSOrderedAscending)
	{
		//bDate比aDate大
		aa=1;
	}else if (result==NSOrderedDescending)
	{
		//bDate比aDate小
		aa=-1;
		
	}
	
	return aa;
}

- (void)stupNav{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
    [[UINavigationBar appearance] setBarTintColor:RGBACOLOR(20, 37, 83, 0.1)];
}
- (void)viewWillAppear:(BOOL)animated{
	self.navigationController.navigationBarHidden=NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
