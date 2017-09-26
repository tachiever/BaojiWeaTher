//
//  NearLyViewController.m
//  BaojiWeather
//
//  Created by Tcy on 2017/3/18.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import "NearLyViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "PointinforModel.h"
#import "NearPointCell.h"

@interface NearLyViewController ()<MAMapViewDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,UIAlertViewDelegate>{
    UITableView *_tableView;
    MAMapView *_mapView;
}
@property (nonatomic)UIView *listView;
@property (nonatomic)UIScrollView *scrollerView;
@property(nonatomic)UIView *maskView;
@property(nonatomic)NSMutableArray *dataArray;
@property (nonatomic)UIImageView *headerImageView;
@property(nonatomic,retain)CLLocationManager *locationManager;
@property(nonatomic)BOOL isFin;

@property (strong, nonatomic) IBOutlet UIView *inforView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UILabel *cityInfoLab;
@property (weak, nonatomic) IBOutlet UILabel *tempLab;
@property (weak, nonatomic) IBOutlet UILabel *fallInfoLab;
@property (weak, nonatomic) IBOutlet UILabel *humLab;

@property (weak, nonatomic) IBOutlet UILabel *pressLab;
@property (weak, nonatomic) IBOutlet UILabel *windLab;
@property(nonatomic)NSDictionary *dataDict;

@end

@implementation NearLyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    _dataArray=[[NSMutableArray alloc]init];
    _dataDict=[[NSDictionary alloc]init];
    _isFin=NO;
    [self stupNav];
    [self locate];

    [self addSwipeGesture];
    [self createMapView];
    [self createScrollerView];
    [self createTableView];


}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden=NO;
}

- (void)getNearPointList:(NSString *)lat longtitude:(NSString *)lon{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:lat forKey:@"latitude"];
    [dict setObject:lon forKey:@"longitude"];
    [dict setObject:@"bymyposition" forKey:@"type"];
    [NBRequest postWithURL:NearPoint type:RequestRefresh dic:dict success:^(NSData *requestData) {
        [_dataArray removeAllObjects];
        //  NSArray *array = [NSJSONSerialization JSONObjectWithData:requestData options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:requestData options:NSJSONReadingMutableContainers error:nil];
        
        
        NSDictionary *dic=dict[@"nearEstData"];
        
        PointinforModel *pointModel=[[PointinforModel alloc]init];
        
        [pointModel setValuesForKeysWithDictionary:dic];
        
       // NSLog(@"%@",dict[@"nearEstData"]);
        
        NSArray *arr=dict[@"position_list"];
        for (NSDictionary *diction in arr) {
            
            NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
            [dictionary setObject:diction[@"distance"] forKey:@"distance"];
            [dictionary setObject:diction[@"lat"] forKey:@"lat"];
            [dictionary setObject:diction[@"log"] forKey:@"log"];
            [dictionary setObject:diction[@"name"] forKey:@"name"];
            [dictionary setObject:diction[@"position"] forKey:@"position"];
            [dictionary setObject:diction[@"site_id"] forKey:@"site_id"];
            [_dataArray addObject:dictionary];
        }
    
        [self setinforWithDictionary:pointModel infDic:_dataArray[0]];
        [_tableView reloadData];
    } failed:^(NSError *error) {
        
    }];
}

- (void)getNearPointDetail:(NSString *)site_id{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:site_id forKey:@"site_id"];
    [dict setObject:@"bysite" forKey:@"type"];
    [NBRequest postWithURL:NearPoint type:RequestRefresh dic:dict success:^(NSData *requestData) {
        //  NSArray *array = [NSJSONSerialization JSONObjectWithData:requestData options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:requestData options:NSJSONReadingMutableContainers error:nil];
        
        
        //NSDictionary *dic=dict[@"nearEstData"];
        
        PointinforModel *pointModel=[[PointinforModel alloc]init];
        
        [pointModel setValuesForKeysWithDictionary:dict];
        
        //NSLog(@"%@",dict);
        [_scrollerView setContentOffset:CGPointMake(0, 0)];
        [self setinforWithDictionary:pointModel infDic:_dataDict];

    } failed:^(NSError *error) {
        
    }];
}


- (void)setinforWithDictionary:(PointinforModel *)model infDic:(NSDictionary *)dic{
    [_nameLab setText:[NSString stringWithFormat:@"%@",dic[@"name"]]];
    [_dateLab setText:[NSString stringWithFormat:@"%@",model.update_time]];
    
    if ([dic[@"distance"] floatValue]<1) {
        [_cityInfoLab setText:[NSString stringWithFormat:@"所属:%@\n距离:%.2f米\n日照:%@小时",dic[@"position"],([dic[@"distance"] floatValue]*1000),model.dpt]];

    }else {
        [_cityInfoLab setText:[NSString stringWithFormat:@"所属:%@\n距离:%.2f千米\n日照:%@小时",dic[@"position"],[dic[@"distance"] floatValue],model.dpt]];

    }
    
    [_tempLab setText:[self getTempInfoStr:model]];
    [_fallInfoLab setText:[self getFallInfoStr:model]];
    [_humLab setText:[self getHumInfoStr:model]];
    [_pressLab setText:[self getPressInfoStr:model]];
    [_windLab setText:[self getWindInfoStr:model]];

}


- (void)createMapView{
    
    CGFloat h;
    h=SCREEN_HEIGHT>600 ?(SCREEN_WIDTH>400?240:300):350;
    
    UIView *hview=[[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 30)];
    hview.backgroundColor=RGBACOLOR(220, 220, 220, 1);
    [self.view addSubview:hview];
    UIButton *bcBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 30)];
    [bcBtn setImage:[UIImage imageNamed:@"city_itom_location"] forState:UIControlStateNormal];
    [bcBtn setTitle:@" 定位" forState:UIControlStateNormal];
    [bcBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [bcBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [bcBtn addTarget:self action:@selector(getPosition:) forControlEvents:UIControlEventTouchUpInside];
    [hview addSubview:bcBtn];

    UILabel *jsLab=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-80, 3, 160, 24)];
    jsLab.font=[UIFont fontWithName:@"ArialMT" size:17];
    jsLab.textColor=[UIColor blackColor];
    jsLab.textAlignment=NSTextAlignmentCenter;
    jsLab.text=@"查看附近";
    [hview addSubview:jsLab];

    [AMapServices sharedServices].enableHTTPS = YES;
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 94, self.view.bounds.size.width, h)];
    //_mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    _mapView.zoomLevel=6;

    _mapView.centerCoordinate = CLLocationCoordinate2DMake(34.349493,107.183017);
    
    
}

- (void)getPosition:(UIButton *)btn{
    [self locate];
    
    
}

- (void)createScrollerView{
    CGFloat h,h1,f1,h3;
    f1=SCREEN_HEIGHT>600 ?(SCREEN_WIDTH>400?10:10):10;
    h=SCREEN_HEIGHT>600 ?(SCREEN_WIDTH>400?334:320):272;
    h1=SCREEN_HEIGHT>600 ?(SCREEN_WIDTH>400?260:240):230;
    h3=SCREEN_HEIGHT>600 ?(SCREEN_WIDTH>400?1125:1085):1045;
    
    
    
    _scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, h, SCREEN_WIDTH, SCREEN_HEIGHT-h)];
    _scrollerView.backgroundColor=[UIColor whiteColor];
    _scrollerView.directionalLockEnabled = YES; //只能一个方向滑动
    _scrollerView.pagingEnabled = NO; //是否翻页
   // _scrollerView.backgroundColor = [UIColor clearColor];
    _scrollerView.showsVerticalScrollIndicator =NO; //垂直方向的滚动指示
    _scrollerView.showsHorizontalScrollIndicator =NO; //垂直方向的滚动指示
    _scrollerView.bounces = YES;
    _scrollerView.delegate = self;
    _scrollerView.contentSize = CGSizeMake(0, 1030);
    [self.view addSubview:_scrollerView];
    
    
    _inforView.frame=CGRectMake(0, 0, SCREEN_WIDTH, 1030);
    [_scrollerView addSubview:_inforView];
    
    
    _listView =[[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 64, SCREEN_WIDTH*0.8, SCREEN_HEIGHT-64)];
    _listView.backgroundColor=RGBACOLOR(1, 1, 1, 0.5);
    [self.view addSubview:_listView];
    
    _maskView =[[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH*0.2, SCREEN_HEIGHT-64)];
    _maskView.backgroundColor=RGBACOLOR(1, 1, 1, 0.6);
    [self.view addSubview:_maskView];
    _maskView.hidden=YES;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    _headerImageView=[[UIImageView alloc]init];
    _headerImageView.frame = CGRectMake(0,0, SCREEN_WIDTH*0.75, 220*Rat);
    _headerImageView.contentMode=UIViewContentModeScaleToFill;
    [_headerImageView setImage:[UIImage imageNamed:@"air_headerbg"]];

    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 220*Rat-30, SCREEN_WIDTH*0.8, 30)];
    bgView.backgroundColor=RGBACOLOR(0, 0, 0, 0.8);
    [_headerImageView addSubview:bgView];
    
    UIImageView *icon=[[UIImageView alloc]initWithFrame:CGRectMake(30,3, 27, 24)];
    icon.contentMode=UIViewContentModeScaleToFill;
    [icon setImage:[UIImage imageNamed:@"pos_icon"]];
    [bgView addSubview:icon];
    
    UILabel *jsLab=[[UILabel alloc]initWithFrame:CGRectMake(60, 3, 150, 24)];
    jsLab.font=[UIFont fontWithName:@"ArialMT" size:17];
    jsLab.textColor=[UIColor whiteColor];
    jsLab.textAlignment=NSTextAlignmentLeft;
    jsLab.text=@"附近站点列表";
    [bgView addSubview:jsLab];
    
    return _headerImageView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 220*Rat;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.0001;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self rightswipeGestureAction];
    _dataDict=_dataArray[indexPath.row];

    NSString *str=[NSString stringWithFormat:@"%@",[self dictionaryToJson:_dataDict]];
    [self addPointWithLat:[_dataArray[indexPath.row][@"lat"] floatValue]lon:[_dataArray[indexPath.row][@"log"] floatValue] site_id:_dataArray[indexPath.row][@"site_id"] infor:str];
    [self getNearPointDetail:_dataArray[indexPath.row][@"site_id"]];
    NSLog(@"%@",_dataArray[indexPath.row]);

}




- (void)createTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*0.8, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.backgroundColor=[UIColor whiteColor];
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.separatorColor = RGBCOLOR(120, 120, 120);
    
    [_listView addSubview:_tableView];
    
    
    //[_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];//纯代码定制cell
    [_tableView registerNib:[UINib nibWithNibName:@"NearPointCell" bundle:nil] forCellReuseIdentifier:@"NearPointCell"];//xib定制cell
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NearPointCell *cell=[tableView dequeueReusableCellWithIdentifier:@"NearPointCell"];
    
    CGFloat f= (SCREEN_HEIGHT>600? 15 :14);

    cell.nameLab.text = _dataArray[indexPath.row][@"name"];
    if ([_dataArray[indexPath.row][@"distance"] floatValue]<1) {
        cell.dixtenceLab.text = [NSString stringWithFormat:@"%.2f米(%@)",([_dataArray[indexPath.row][@"distance"] floatValue]*1000),_dataArray[indexPath.row][@"position"]];
    }else {
        cell.dixtenceLab.text = [NSString stringWithFormat:@"%.2f千米(%@)",[_dataArray[indexPath.row][@"distance"] floatValue],_dataArray[indexPath.row][@"position"]];
    }
    
    if ( cell.nameLab.text.length>=5 ) {
        cell.nameLab.font=[UIFont systemFontOfSize:13];

    }else{
        cell.nameLab.font=[UIFont systemFontOfSize:15];

    }
    cell.dixtenceLab.font=[UIFont systemFontOfSize:f];
   // cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    
    //cell.selectedBackgroundView.backgroundColor = RGBACOLOR(77, 77, 77, 1);
    cell.selectionStyle=UITableViewCellSelectionStyleBlue;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

// 轻扫手势
- (void)addSwipeGesture{
    UISwipeGestureRecognizer *leftswipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftswipeGestureAction)];
    leftswipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:leftswipeGesture];
    
    UISwipeGestureRecognizer *rightSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightswipeGestureAction)];
    
    rightSwipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:rightSwipeGesture];
}

// 左轻扫
- (void)leftswipeGestureAction {
    CGRect frame=  CGRectMake(SCREEN_WIDTH*0.2, 64, SCREEN_WIDTH*0.8, SCREEN_HEIGHT-64);
    [UIView animateWithDuration:0.3 animations:^{
        
        _listView.frame=frame;
    }completion:^(BOOL finished) {
        
        _maskView.hidden=NO;
        
    }];
    
}

// 右轻扫
- (void)rightswipeGestureAction{
    _maskView.hidden=YES;
    CGRect frame=  CGRectMake(SCREEN_WIDTH, 64, SCREEN_WIDTH*0.8, SCREEN_HEIGHT-64);
    [UIView animateWithDuration:0.3 animations:^{

        _listView.frame=frame;
    }completion:^(BOOL finished) {
        
    }];
}

-(void)locate{
    if([CLLocationManager locationServicesEnabled]) {
        
        if (self.locationManager == nil) {
            self.locationManager = [[CLLocationManager alloc]init];
        }
        
        self.locationManager.delegate = self;
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0) {
            [self.locationManager requestWhenInUseAuthorization];
        }
    }else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"无法定位，请开启定位" preferredStyle:  UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self.navigationController popViewControllerAnimated:YES];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"]];
            
        }]];
        [self presentViewController:alert animated:true completion:nil];
    }
    
    [self.locationManager startUpdatingLocation];
}


#pragma mark - CoreLocation Delegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
     if (!_isFin) {
    CLLocation *currentLocation = [locations lastObject];
    NSLog(@"当前经纬度%.1f,%.1f",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude);
    
    NSString *lat=[NSString stringWithFormat:@"%.1f",currentLocation.coordinate.latitude];
    NSString *lon=[NSString stringWithFormat:@"%.1f",currentLocation.coordinate.longitude];
         
         [self addPointWithLat:currentLocation.coordinate.latitude lon:currentLocation.coordinate.longitude site_id:@"myLoca" infor:[NSString stringWithFormat:@""]];
         [self getNearPointList:lat longtitude:lon];
         
         
         
        _isFin=!_isFin;
    }
    
//    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
//    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *array, NSError *error){
//        
//        if (array.count > 0)
//        {
//            CLPlacemark *placemark = [array objectAtIndex:0];
//            
//            //获取城市
//            NSString *city = placemark.locality;
//            if (!city) {
//                city = placemark.administrativeArea;
//            }
//            //_locationCity=[NSString stringWithFormat:@"%@",city];
//            //_locationCounty=[NSString stringWithFormat:@"%@",placemark.subLocality];
//            NSLog(@"jsjsjsjsjsjjsjsjsjsjsjsj");
//            
//            
//        }
//        else if (error == nil && [array count] == 0)
//        {
//            NSLog(@"No results were returned.");
//        }
//        else if (error != nil)
//        {
//            NSLog(@"An error occurred = %@", error);
//        }
//        
//    }];
    [manager stopUpdatingLocation];
}



- (void)locationManager:(CLLocationManager *)manager

       didFailWithError:(NSError *)error {
    if (error.code == kCLErrorDenied) {
        
        // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
        
    }
}

- (void)addPointWithLat:(CGFloat)lat lon:(CGFloat)lon site_id:(NSString *)site_id infor:(NSString *)inf{

        MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
        pointAnnotation.coordinate = CLLocationCoordinate2DMake(lat,lon);
        pointAnnotation.title =site_id;
        pointAnnotation.subtitle =inf;
    [_mapView addAnnotation:pointAnnotation];

//    [_mapView addAnnotations:self.annotations];
//    [_mapView showAnnotations:self.annotations edgePadding:UIEdgeInsetsMake(20,20,20,80)animated:YES];
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
        if ([annotation.title isEqualToString:@"myLoca"]) {
            annotationView.image = [UIImage imageNamed:@"location_blue"];

        }else{
        
            annotationView.image = [UIImage imageNamed:@"location_red"];

        }
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
            NSLog(@"点了我 %@",point.title);
            
            
            if (![point.title isEqualToString:@"myLoca"]) {
                
                _dataDict=[self dictionaryWithJsonString:point.subtitle];
                [self getNearPointDetail:point.title];
                NSLog(@"点了我 %@",[self dictionaryWithJsonString:point.subtitle]);
                

            }

        }
        
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

- (NSString *)getCityInfoStr:(NSDictionary *)dic{

    NSString *str;
    str=[NSString stringWithFormat:@"所属:%@\n距离:%@\n日照:%@小时",dic[@"position"],dic[@"distance"],dic[@"dpt"]];

    return str;
    
}
- (NSString *)getTempInfoStr:(PointinforModel *)model{
    NSString *str;
     str=[NSString stringWithFormat:@"实况温度:%@\n最高温度:%@,出现时间:%@\n最低温度:%@,出现时间:%@",model.temp,model.temp_max,model.temp_max_otime,model.temp_min,model.temp_min_otime];

    return str;
}
- (NSString *)getFallInfoStr:(PointinforModel *)model{
 NSString *str;
     str=[NSString stringWithFormat:@"前1小时降水:%@\n前3小时降水:%@\n前6小时降水:%@\n前12小时降水:%@\n前24小时降水:%@",model.pre_1h,model.pre_3h,model.pre_6h,model.pre_12h,model.pre_24h];

    return str;
}
- (NSString *)getHumInfoStr:(PointinforModel *)model{
    NSString *str;
     str=[NSString stringWithFormat:@"湿度:%@\n前最小湿度:%@,出现时间:%@",model.rhu,model.rhu_min,model.rhu_min_otime];
    
    return str;
}
- (NSString *)getPressInfoStr:(PointinforModel *)model{
    NSString *str;
     str=[NSString stringWithFormat:@"气压:%@\n最小气压:%@,出现时间:%@\n最大气压:%@,出现时间:%@\n海平面气压:%@\n水汽压:%@",model.prs,model.prs_min,model.prs_min_otime,model.prs_max,model.prs_max_otime,model.prs_sea,model.vap];

        
    return str;
    
}
- (NSString *)getWindInfoStr:(PointinforModel *)model{
    NSString *str;
     str=[NSString stringWithFormat:@"瞬时风速、风向、风级:%@m/s %@风 %@\n极大风速、风向、风级:%@m/s %@风 %@,出现时间:%@\n最大风速、风向、风级:%@m/s %@风 %@,出现时间:%@\n2分钟平均风速、风向、风级:%@m/s %@风 %@\n10分钟平均风速、风向、风级:%@m/s %@风 %@\n过去6小时极大瞬时风速、风向、风级:%@m/s %@风 %@\n过去12小时极大瞬时风速、风向、风级:%@m/s %@风 %@",
          model.win_s_inst,[self windDirection:model.win_d_inst],[self windSpeed:model.win_s_inst],
          model.win_s_inst_max,[self windDirection:model.win_d_inst_max],[self windSpeed:model.win_s_inst_max],
        model.win_s_inst_max_otime,
          model.win_s_max,[self windDirection:model.win_d_s_max],[self windSpeed:model.win_s_max],model.win_s_inst_max_otime,
          model.win_s_avg_2mi,[self windDirection:model.win_d_avg_2mi],[self windSpeed:model.win_s_avg_2mi],
          model.win_s_avg_10mi,[self windDirection:model.win_d_avg_10mi],[self windSpeed:model.win_s_avg_10mi],
          model.win_s_inst_max_6h,[self windDirection:model.win_d_inst_max_6h],[self windSpeed:model.win_s_inst_max_6h],
          model.win_s_inst_max_12h,[self windDirection:model.win_d_inst_max_12h],[self windSpeed:model.win_s_inst_max_12h]];
        return str;

    
}


-(NSString*)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        
        return nil;
        
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options:NSJSONReadingMutableContainers
                         
                                                          error:&err];  
    
    if(err) {  
        
        NSLog(@"json解析失败：%@",err);  
        
        return nil;  
        
    }  
    
    return dic;  
    
}  

- (NSString *)windSpeed:(NSString *)dic{
    NSString *jb;
    NSInteger val=[dic integerValue];
    if (0.0 <= val && val <= 0.2) {
        jb = @"0级";
    } else if (0.3 <= val && val <= 1.5) {
        jb = @"1级";
    } else if (1.6 <= val && val <= 3.3) {
        jb = @"2级";
    } else if (3.4 <= val && val <= 5.4) {
        jb = @"3级";
    } else if (5.5 <= val && val <= 7.9) {
        jb = @"4级";
    } else if (8.0 <= val && val <= 10.7) {
        jb = @"5级";
    } else if (10.8 <= val && val <= 13.8) {
        jb = @"6级";
    } else if (13.9 <= val && val <= 17.1) {
        jb = @"7级";
    } else if (17.2 <= val && val <= 17.2) {
        jb = @"8级";
    } else if (20.8 <= val && val <= 24.4) {
        jb = @"9级";
    } else if (24.5<= val && val <= 28.4) {
        jb = @"10级";
    } else if (28.5<= val && val <= 32.6) {
        jb = @"11级";
    } else if (32.7<= val && val <= 36.9) {
        jb = @"12级";
    } else if (37.0 <= val && val <= 41.4) {
        jb = @"13级";
    } else if (41.5 <= val && val <= 46.1) {
        jb = @"14级";
    } else if (46.2 <= val && val <= 50.9) {
        jb = @"15级";
    } else if (51.0 <= val && val <= 56.0) {
        jb = @"16集";
    }else if (56.1<= val && val <= 61.2) {
        jb = @"17级";
    }else if(val>=61.3){
        jb = @"18级";
    }
    
    return jb;
    
    
}
- (NSString *)windDirection:(NSString *)dic{
    
	   NSString *WindDirection;
    NSInteger val=[dic integerValue];
	   if (0 == val) {
           WindDirection = @"北";
           //		   img_id=R.drawable.trend_wind_1;
       } else if (0 < val && val < 90) {
           WindDirection = @"东北";
           //	    	img_id=R.drawable.trend_wind_2;
       }  else if (90 == val) {
           WindDirection = @"东";
           //	    	img_id=R.drawable.trend_wind_3;
       } else if (90 < val && val <180) {
           WindDirection = @"东南";
           //	    	img_id=R.drawable.trend_wind_4;
       } else if (180 == val) {
           WindDirection = @"南";
           //	    	img_id=R.drawable.trend_wind_5;
       } else if (180 < val && val <270) {
           WindDirection = @"西南";
           //	    	img_id=R.drawable.trend_wind_6;
       } else if (270 == val) {
           WindDirection = @"西";
           //	    	img_id=R.drawable.trend_wind_7;
       } else if (270 < val && val <359.9) {
           WindDirection = @"西北";
           //	    	img_id=R.drawable.trend_wind_8;
       }  else {
           WindDirection = @"静";
           //	    	img_id=R.drawable.main_icon_wind_no;
       }
    return WindDirection;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
