//
//  WarSignController.m
//  BaojiWeather
//
//  Created by Tcy on 2017/3/24.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import "WarSignController.h"
#import "CommonUtility.h"

@interface WarSignController ()<MAMapViewDelegate,UIScrollViewDelegate,AMapSearchDelegate>{
    
    MAMapView *_mapView;
    MAGroundOverlay *_groundOverlay;
    MACoordinateBounds _coordinateBounds;
}
@property (nonatomic)AMapSearchAPI *search;
@property (nonatomic)NSMutableArray *pointArray;
@property (nonatomic)NSMutableArray *dataArray;
@property (nonatomic)CGFloat h;
@property (nonatomic)UILabel *statuesLab;
@property (nonatomic)NSMutableArray *annotations;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *detailLab;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UILabel *inforLab;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UIView *detailView;


@end

@implementation WarSignController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self stupNav];
    
    _h=(SCREEN_WIDTH>330)?((SCREEN_HEIGHT>700)?250:230):200;
    
    _pointArray=[[NSMutableArray alloc]init];
    _dataArray=[[NSMutableArray alloc]init];

    [self stupNav];
    self.title=self.titleStr;
    self.view.backgroundColor = [UIColor whiteColor];
    [self createMapView];
    [self getFallPointList];

}

- (void)getFallPointList{
    NSString *urlStr=[NSString stringWithFormat:YJSignal];
    [NBRequest requestWithURL:urlStr type:RequestRefresh success:^(NSData *requestData) {

        [_pointArray removeAllObjects];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:requestData options:NSJSONReadingMutableContainers error:nil];
        
        NSArray *array=dict[@"list"];
       // NSLog(@"======%@",dict);
        if (array.count>0) {
            for (NSDictionary *dic in array) {
                NSMutableDictionary *dicti=[[NSMutableDictionary alloc]init];
                [dicti setValue:dic[@"diteals"] forKey:@"diteals"];
                [dicti setValue:dic[@"id"] forKey:@"id"];
                [dicti setValue:dic[@"lat"] forKey:@"lat"];
                [dicti setValue:dic[@"log"] forKey:@"log"];
                [dicti setValue:dic[@"name"] forKey:@"name"];
                [dicti setValue:dic[@"publish_time"] forKey:@"publish_time"];
                [dicti setValue:dic[@"short_name"] forKey:@"short_name"];
                [dicti setValue:dic[@"show_position"] forKey:@"show_position"];
                [dicti setValue:dic[@"type"] forKey:@"type"];
                [_dataArray addObject:dicti];
            }
            _statuesLab.hidden=YES;
            [self addFallPointWithArray:_dataArray];
        }
    } failed:^(NSError *error) {
        
    }];
    
}

- (void)createMapView{
    [AMapServices sharedServices].enableHTTPS = YES;
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64)];
    _mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _mapView.delegate = self;
    _mapView.centerCoordinate = CLLocationCoordinate2DMake(34.349493,107.183017);
        _mapView.zoomLevel=8;
    [self.view addSubview:_mapView];

    
    
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    
    AMapDistrictSearchRequest *dist = [[AMapDistrictSearchRequest alloc] init];
    dist.keywords = @"宝鸡市";
    dist.requireExtension = YES;
    dist.showBusinessArea = YES;

    [self.search AMapDistrictSearch:dist];

    _statuesLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 30)];
    _statuesLab.text=@"当前没有预警";
    _statuesLab.textAlignment=NSTextAlignmentCenter;
    _statuesLab.backgroundColor=RGBCOLOR(238, 246, 206);
    _statuesLab.font=[UIFont systemFontOfSize:16];
    [self.view addSubview:_statuesLab];
    
    _detailView.frame=CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH,280*Rat);
    
    [self.view addSubview:_detailView];
    _bgView.layer.masksToBounds=YES;
    _bgView.layer.cornerRadius=8;
    _bgView.layer.borderWidth=1;
    _bgView.layer.borderColor=RGBCOLOR(6, 170, 243).CGColor;
    CGFloat f1,f2;
    f1=(SCREEN_WIDTH>330)?16:15;
    f2=(SCREEN_WIDTH>330)?13:11;
    _detailLab.font=[UIFont systemFontOfSize:f1];
    _dateLab.font=[UIFont systemFontOfSize:f2];

    
}

- (void)onDistrictSearchDone:(AMapDistrictSearchRequest *)request response:(AMapDistrictSearchResponse *)response
{
    
    if (response == nil)
    {
        return;
    }
    
    NSLog(@"%@",response);
    
    [_mapView removeOverlays:_mapView.overlays];
    [self handleDistrictResponse:response];
}
#pragma mark - Helpers

- (void)handleDistrictResponse:(AMapDistrictSearchResponse *)response
{
    if (response == nil)
    {
        return;
    }
    
    for (AMapDistrict *dist in response.districts)
    {
        MAPointAnnotation *poiAnnotation = [[MAPointAnnotation alloc] init];
        
        poiAnnotation.coordinate = CLLocationCoordinate2DMake(dist.center.latitude, dist.center.longitude);
        poiAnnotation.title      = dist.name;
        poiAnnotation.subtitle   = dist.adcode;
        
        [_mapView addAnnotation:poiAnnotation];
        
        NSMutableArray *subAnnotations = [NSMutableArray array];
        // sub
        for (AMapDistrict *subdist in dist.districts)
        {
            MAPointAnnotation *subAnnotation = [[MAPointAnnotation alloc] init];
            
            subAnnotation.coordinate = CLLocationCoordinate2DMake(subdist.center.latitude, subdist.center.longitude);
            subAnnotation.title      = subdist.name;
            subAnnotation.subtitle   = subdist.adcode;
            [subAnnotations addObject:subAnnotation];
        }
        [_mapView addAnnotations:subAnnotations];
        
        if (dist.polylines.count > 0)
        {
            for (NSString *polylineStr in dist.polylines)
            {
                MAPolyline *polyline = [CommonUtility polylineForCoordinateString:polylineStr];
                [_mapView addOverlay:polyline];
            }
            [_mapView showOverlays:_mapView.overlays animated:YES];
        }
        else
        {
            [_mapView showAnnotations:_mapView.annotations animated:YES];
        }
        
        
    }
    
}

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", error);
}

#pragma mark - MAMapViewDelegate

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        
        polylineRenderer.lineWidth   = 2.f;
        polylineRenderer.strokeColor = RGBACOLOR(0, 150, 100, 0.8);
        
        return polylineRenderer;
    }
    
    return nil;
}




- (void)addFallPointWithArray:(NSArray *)array{
    self.annotations = [NSMutableArray array];

    for (int i =0; i <array.count; ++i)
    {
        NSMutableDictionary *dic=array[i];
        MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
        pointAnnotation.coordinate = CLLocationCoordinate2DMake([dic[@"log"] floatValue],[dic[@"lat"] floatValue]);
        pointAnnotation.title =dic[@"type"];
        pointAnnotation.subtitle =[NSString stringWithFormat:@"%d",i];
        [self.annotations addObject:pointAnnotation];
    }
    [_mapView addAnnotations:self.annotations];
    //[_mapView showAnnotations:self.annotations edgePadding:UIEdgeInsetsMake(20,20,20,80)animated:YES];
}


- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
        }
       // if ([annotation.title isEqualToString:@"myLoca"]) {
        //    annotationView.image = [UIImage imageNamed:@"location_blue"];
            
       // }else{
            annotationView.image = [UIImage imageNamed:[self imageName:annotation.title]];
            
        //}
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
            [self DeatilViewShow:point.subtitle];
            
        }
    }
}
- (void)mapView:(MAMapView *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate{
    NSArray * array = [NSArray arrayWithArray:_mapView.annotations];
    	NSLog(@"%.1f",coordinate.latitude);
    	NSLog(@"%lf",coordinate.longitude);
    for (MAPointAnnotation *point in array) {
        if (coordinate.latitude == point.coordinate.latitude&&coordinate.longitude == point.coordinate.longitude){
           // NSLog(@"点了我 %@",point.subtitle);
            
        }else{
        
            [self DeatilViewHidden];

        
        }
        
    }


}

-(void)DeatilViewHidden{
    
    CGRect fram=CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 280*Rat);
    [UIView animateWithDuration:0.3 animations:^{
        _detailView.frame=fram;
    } completion:^(BOOL finished) {
    }];
}

-(void)DeatilViewShow:(NSString *)num{
    
    CGRect fram=CGRectMake(0, SCREEN_HEIGHT-280*Rat, SCREEN_WIDTH, 280*Rat);
    [UIView animateWithDuration:0.3 animations:^{
        _detailView.frame=fram;
    } completion:^(BOOL finished) {
        [self remindDetail:num];
    }];
}
- (void)remindDetail:(NSString *)num{
    
    NSDictionary *dic=_dataArray[[num integerValue]];
    [_iconImage setImage:[UIImage imageNamed:[self imageName:dic[@"type"]]]];
    [_detailLab setText:[NSString stringWithFormat:@"%@",dic[@"short_name"]]];
    [_dateLab setText:[NSString stringWithFormat:@"%@发布",dic[@"publish_time"]]];
    [_inforLab setText:[NSString stringWithFormat:@"%@",dic[@"diteals"]]];
}

- (NSString *)imageName:(NSString *)weath{
    NSString *cityId;
	   if ([weath isEqualToString:@"011"]) {
           cityId = @"baoyu_ls";
       } else if ([weath isEqualToString:@"012"]) {
           cityId = @"baoyu_huangse";
       } else if ([weath isEqualToString:@"013"]) {
           cityId = @"baoyu_cs";
       }  else if ([weath isEqualToString:@"014"]) {
           cityId = @"baoyu_hs";
       } else if ([weath isEqualToString:@"021"]) {
           cityId = @"baoxue_ls";
       } else if ([weath isEqualToString:@"022"]) {
           cityId = @"baoxue_huangse";
       } else if ([weath isEqualToString:@"023"]) {
           cityId = @"baoxue_cs";
       } else if ([weath isEqualToString:@"024"]) {
           cityId = @"baoxue_hs";
       } else if ([weath isEqualToString:@"043"]) {
           cityId = @"bingbao_cs";
       }else if ([weath isEqualToString:@"044"]) {
           cityId = @"bingbao_hs";
       }else if ([weath isEqualToString:@"051"]) {
           cityId = @"dafeng_ls";
       }else if ([weath isEqualToString:@"052"]) {
           cityId = @"dafeng_huangse";
       }else if ([weath isEqualToString:@"053"]) {
           cityId = @"dafeng_cs";
       }else if ([weath isEqualToString:@"054"]) {
           cityId = @"dafeng_hs";
       } else if ([weath isEqualToString:@"072"]) {
           cityId = @"dawu_huangse";
       } else if ([weath isEqualToString:@"073"]) {
           cityId = @"dawu_cs";
       }  else if ([weath isEqualToString:@"074"]) {
           cityId = @"dawu_hs";
       } else if ([weath isEqualToString:@"062"]) {
           cityId = @"daolu_huangse";
       } else if ([weath isEqualToString:@"063"]) {
           cityId = @"daolu_cs";
       } else if ([weath isEqualToString:@"064"]) {
           cityId = @"daolu_hs";
       } else if ([weath isEqualToString:@"083"]) {
           cityId = @"daolu_cs";
       } else if ([weath isEqualToString:@"084"]) {
           cityId = @"daolu_hs";
       }else if ([weath isEqualToString:@"092"]) {
           cityId = @"gaowen_huangse";
       }else if ([weath isEqualToString:@"093"]) {
           cityId = @"gaowen_cs";
       }else if ([weath isEqualToString:@"094"]) {
           cityId = @"gaowen_hs";
       }else if ([weath isEqualToString:@"101"]) {
           cityId = @"hanchao_ls";
       }else if ([weath isEqualToString:@"102"]) {
           cityId = @"hanchao_huangse";
       } else if ([weath isEqualToString:@"103"]) {
           cityId = @"hanchao_cs";
       } else if ([weath isEqualToString:@"104"]) {
           cityId = @"hanchao_hs";
       }  else if ([weath isEqualToString:@"032"]) {
           cityId = @"leidian_huangse";
       } else if ([weath isEqualToString:@"033"]) {
           cityId = @"leidian_cs";
       } else if ([weath isEqualToString:@"034"]) {
           cityId = @"leidain_hs";
       } else if ([weath isEqualToString:@"142"]) {
           cityId = @"mai_huangse";
       } else if ([weath isEqualToString:@"143"]) {
           cityId = @"mai_cs";
       } else if ([weath isEqualToString:@"152"]) {
           cityId = @"shachen_cs";
       }else if ([weath isEqualToString:@"153"]) {
           cityId = @"shachen_cs";
       }else if ([weath isEqualToString:@"154"]) {
           cityId = @"shachen_hs";
       }else if ([weath isEqualToString:@"161"]) {
           cityId = @"shuangdong_ls";
       }else if ([weath isEqualToString:@"162"]) {
           cityId = @"shuangdong_huangse";
       }else if ([weath isEqualToString:@"163"]) {
           cityId = @"shuangdong_cs";
       } else if ([weath isEqualToString:@"181"]) {
           cityId = @"taifeng_ls";
       } else if ([weath isEqualToString:@"182"]) {
           cityId = @"taifeng_huangse";
       }  else if ([weath isEqualToString:@"183"]) {
           cityId = @"taifeng_cs";
       } else if ([weath isEqualToString:@"184"]) {
           cityId = @"taifeng_hs";
       }
    return cityId;
}

- (void)stupNav{
    self.title=self.titleStr;
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
