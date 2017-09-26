//
//  CityListViewController.m
//  BaojiWeather
//
//  Created by Tcy on 2017/2/21.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import "CityListViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface CityListViewController ()<CLLocationManagerDelegate>{
    NSArray *_norArray;
    NSArray *_selArray;
    NSMutableArray *_cityArray;
    
    
}
@property(nonatomic)NSString  *locationCity;
@property(nonatomic)NSString  *locationCounty;
@property(nonatomic,retain)CLLocationManager *locationManager;

@end

@implementation CityListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self stupNav];
    [self prepareData];
    [self createSellectView];
}
- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden=NO;
}
- (void)viewWillDisappear:(BOOL)animated{
    [[DataDefault shareInstance] setCityId:_cityArray];

}
- (void)prepareData{
    _cityArray=[NSMutableArray new];
    
    _cityArray=[[[DataDefault shareInstance] cityId] mutableCopy];
    _norArray=@[@"default_nor",@"un_bj",@"un_wb",@"un_jt",@"un_cc",@"un_fxx",@"un_qs",@"un_ff",@"un_m",@"un_lx",@"un_qy",@"un_ly",@"un_fx",@"un_tb"];
    _selArray=@[@"default_sel",@"p_bj",@"p_wb",@"p_jt",@"p_cc",@"p_fxx",@"p_qs",@"p_ff",@"p_m",@"p_lx",@"p_qy",@"p_ly",@"p_fx",@"p_tb"];


}
- (void)createSellectView{
    
    CGFloat f;
    f=SCREEN_HEIGHT>600 ?(SCREEN_WIDTH>400?26:22):20;

    NSArray *nameArray=@[@"定位",@"宝鸡市",@"渭滨区",@"金台区",@"陈仓区",@"凤翔县",@"岐山县",@"扶风县",@"眉县",@"陇县",@"千阳县",@"麟游县",@"凤县",@"太白县"];
    
    for (int i=0; i<nameArray.count; i++) {
        UIButton *iconBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        iconBtn.frame=CGRectMake(10+((SCREEN_WIDTH-60)/3.0+20)*(i%3), 84+((SCREEN_WIDTH-60)/3.0+10)*(i/3),(SCREEN_WIDTH-60)/3.0, (SCREEN_WIDTH-60)/3.0);
        iconBtn.tag=100+i;
        if ([_cityArray[i] boolValue]) {
            [iconBtn setBackgroundImage:[UIImage imageNamed:_selArray[i]] forState:UIControlStateNormal];
        }else{
            [iconBtn setBackgroundImage:[UIImage imageNamed:_norArray[i]] forState:UIControlStateNormal];

        }
        [iconBtn setTitle:nameArray[i] forState:UIControlStateNormal];
        [iconBtn setTintColor:[UIColor whiteColor]];
        iconBtn.titleLabel.font=[UIFont fontWithName:@"ArialMT" size:22];
        [iconBtn addTarget:self action:@selector(selectCity:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:iconBtn];
    }
}

- (void)selectCity:(UIButton *)btn{
    
    if (btn.tag==100) {
        NSLog(@"点击了定位");
        [SVProgressHUD showWithStatus:@"正在定位，请稍后！" maskType:SVProgressHUDMaskTypeBlack];

        [self locate];
    }else{
        if ([_cityArray[btn.tag-100] boolValue]) {
            [btn setBackgroundImage:[UIImage imageNamed:_norArray[btn.tag-100]] forState:UIControlStateNormal];
        }else{
            [btn setBackgroundImage:[UIImage imageNamed:_selArray[btn.tag-100]] forState:UIControlStateNormal];
        }
        BOOL state = [_cityArray[btn.tag-100] boolValue];
        [_cityArray replaceObjectAtIndex:btn.tag-100 withObject:@(!state)];
    }



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
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"定位不成功 ,请确认开启定位" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    
    [self.locationManager startUpdatingLocation];
}

#pragma mark - CoreLocation Delegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *array, NSError *error){
        
        if (array.count > 0)
        {
            CLPlacemark *placemark = [array objectAtIndex:0];
            
            //获取城市
            NSString *city = placemark.locality;
            if (!city) {
                city = placemark.administrativeArea;
            }
            _locationCity=[NSString stringWithFormat:@"%@",city];
            _locationCounty=[NSString stringWithFormat:@"%@",placemark.subLocality];
            if ([_locationCity isEqualToString:@"宝鸡市"]) {

                if(self.action)
                {
                    self.action();
                }
                [SVProgressHUD showSuccessWithStatus:@"定位成功"];
            }
            if (![_locationCity isEqualToString:@"宝鸡市"]) {
                [SVProgressHUD showErrorWithStatus:@"定位不在宝鸡市，请手动选择"];
            }
        }
        else if (error == nil && [array count] == 0)
        {
            NSLog(@"No results were returned.");
            [SVProgressHUD showErrorWithStatus:@"定位失败，请手动选择"];

        }
        else if (error != nil)
        {
            NSLog(@"An error occurred = %@", error);
            [SVProgressHUD showErrorWithStatus:@"定位失败，请手动选择"];

        }
        
    }];
    [manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager

       didFailWithError:(NSError *)error {
    if (error.code == kCLErrorDenied) {
        
        // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
        
    }
}




- (void)stupNav{
    self.title=@"选择区县";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
    [[UINavigationBar appearance] setBarTintColor:RGBACOLOR(20, 37, 83, 0.1)];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
