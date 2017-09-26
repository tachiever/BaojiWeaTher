//
//  MainPageViewController.m
//  BaojiWeather
//
//  Created by Tcy on 2017/2/15.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import "MainPageViewController.h"
#import "RightViewController.h"
#import "LeftViewController.h"
#import "DataDefault.h"
#import "UUID.h"
#import "CityListViewController.h"
#import "MyTransition.h"
#import "CAEmitterLayerView.h"

#import "MainPageView.h"
#import <QuickLook/QuickLook.h>
#import <CoreLocation/CoreLocation.h>
#import "WeekWeatherView.h"
#import "LifeIndx.h"
#import "TableHeadView.h"
#import "CalendaruiViewController.h"
#import "WeatherView.h"

#import "ChooseCell.h"

#import "MSSCalendarViewController.h"
#import "MSSCalendarDefine.h"
#import "FallViewController.h"
#import "AirViewController.h"
#import "RadarViewController.h"

#import "NearLyViewController.h"
#import "FallUrlViewController.h"
#import "FangZaiViewController.h"
#import "QXFWViewController.h"
#import "WarningViewController.h"
#import "WarSignController.h"

static NSString* const kPullDateKey = @"refresh";

@interface MainPageViewController ()<UITextFieldDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate, UIDocumentInteractionControllerDelegate,MSSCalendarViewControllerDelegate>{
    UIView *_preView;     // 前一页
    UIView *_currentView; // 当前页
    UIView *_nextView;    // 后一页
    NSInteger _currentIndex;        // 当前页索引
    NSMutableArray *_countyArray;
    BOOL _isOpen;
    BOOL _isDingwei;
    BOOL _showMind;
    CAAnimationGroup *_group;
    UIImageView *_bgImageView;
    UIImageView *_sunImageView;
    UIImageView *_cloudImageView;
    CGFloat _w;
    UIView *_inputView;
    UIImageView *_sigImageView;
    
    UIScrollView *_perTab;
    UIScrollView *_curTab;
    UIScrollView *_nexTab;
    TableHeadView *sectionPerView0;
    MainPageView *sectionPerView1;
    WeatherView *sectionPerView3;
    WeekWeatherView *sectionPerView4;
    LifeIndx *sectionPerView5;
    
    TableHeadView *sectionCurView0;
    MainPageView *sectionCurView1;
    WeatherView *sectionCurView3;
    WeekWeatherView *sectionCurView4;
    LifeIndx *sectionCurView5;
    
    TableHeadView *sectionNexView0;
    MainPageView *sectionNexView1;
    WeatherView *sectionNexView3;
    WeekWeatherView *sectionNexView4;
    LifeIndx *sectionNexView5;
    
    UITableView *mTableView;
    UILabel *mindLab;
}
@property(nonatomic)NSString  *locationCity;
@property(nonatomic)NSString  *locationCounty;
@property (nonatomic) NSTimer *sunTimer;
@property (nonatomic) NSTimer *cloudTimer;

@property(strong) NSMutableDictionary *dataDic;
@property(nonatomic)UIView *maskView;
@property(nonatomic)UILabel *cityName;
@property(nonatomic)UIView *registerView;
@property(nonatomic)UITextField *accountField;

@property (nonatomic, assign) NBRequestType requestType;
@property (nonatomic, assign) BOOL isRefresh;
@property(nonatomic,retain)CLLocationManager *locationManager;
@property (nonatomic) BOOL isNetShow;
@property (nonatomic) BOOL isShow;


@property (strong,nonatomic) NSMutableArray     *cacheEmitterLayers;
@end

@implementation MainPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _w=SCREEN_WIDTH*0.73;
    _isOpen=NO;
    _showMind=NO;
    _isNetShow=NO;
    _dataDic=[[NSMutableDictionary alloc]init];
    _countyArray=[NSMutableArray new];
    _cacheEmitterLayers=[NSMutableArray new];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    self.navigationItem.backBarButtonItem = item;
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [self locate];
    if ([_locationCity isEqualToString:@"宝鸡市"]) {
        _isDingwei=YES;
    }
    else{
        _isDingwei=NO;
        
    }
    
    [self checkUpdate];
    
    [self createScreChangeView];
    [self createScrollView];
    [self creteHeaderView];
    [self loadData];
    
    [self netWorkMonitor];
    
    [self listenNotification];
    
    [self createFangZaiView];
    
}
- (void)back:(id)btn{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [NBRequest cancleRequest];
    
}

- (void)checkUpdate{
    [NBRequest requestWithURL:RemindUrl type:RequestRefresh success:^(NSData *requestData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:requestData options:NSJSONReadingMutableContainers error:nil];
        
        //NSLog(@"%@",dict);
        // NSLog(@"=======%@",dict);
        if (dict!=nil) {
            
            if ([[NSString  stringWithFormat:@"%.1f",[dict[@"ver"][@"version"]floatValue]]floatValue]>[[NSString stringWithFormat:@"3.1" ] floatValue]) {
                [self updateWithUrl:dict[@"ad"][@"weburl"]];
            }
        }
        
    } failed:^(NSError *error) {
        
    }];
    
    
}

- (void)updateWithUrl:(NSString *)appUrl{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"更新提示" message:@"有新的版本已更新，是否前往AppStore更新？" preferredStyle:  UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *urlStr = [NSString stringWithFormat:@"%@",appUrl];
        NSURL *url = [NSURL URLWithString:urlStr];
        [[UIApplication sharedApplication] openURL:url];
        
    }]];
    
    [self presentViewController:alert animated:true completion:nil];
    
}

- (void)prepareCountys{
    [_countyArray removeAllObjects];
    NSArray *coArray=@[@"定位",@"宝鸡市",@"渭滨区",@"金台区",@"陈仓区",@"凤翔县",@"岐山县",@"扶风县",@"眉县",@"陇县",@"千阳县",@"麟游县",@"凤县",@"太白县"];
    for (int i=0; i<[[DataDefault shareInstance] cityId].count; i++) {
        if ([[[DataDefault shareInstance] cityId][i] boolValue]) {
            [_countyArray addObject:coArray[i]];
        }
    }
    
}
- (void)listenNotification{
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(notice:) name:@"menulistSelect" object:nil];
}
- (void)notice:(NSNotification *)noti{
    NSLog(@"%@",noti.userInfo);
    [self leftswipeGestureAction];
    
    
    if ([noti.userInfo[@"section"] integerValue]==0&&[noti.userInfo[@"row"] integerValue]==0) {
        FallViewController *clvc=[FallViewController new];
        clvc.titleStr=noti.userInfo[@"title"];
        [self.navigationController pushViewController:clvc animated:YES];
    }
    if ([noti.userInfo[@"section"] integerValue]==0&&[noti.userInfo[@"row"] integerValue]==1) {
        AirViewController *clvc=[AirViewController new];
        clvc.titleStr=noti.userInfo[@"title"];
        [self.navigationController pushViewController:clvc animated:YES];
    }
    if ([noti.userInfo[@"section"] integerValue]==0&&[noti.userInfo[@"row"] integerValue]==2) {
        RadarViewController *clvc=[RadarViewController new];
        clvc.titleStr=@"基本速度雷达图";
        [self.navigationController pushViewController:clvc animated:YES];
    }
    if ([noti.userInfo[@"section"] integerValue]==0&&[noti.userInfo[@"row"] integerValue]==3) {
        
        NearLyViewController *clvc=[NearLyViewController new];
        clvc.titleStr=noti.userInfo[@"title"];
        [self.navigationController pushViewController:clvc animated:YES];
    }
    
    
    if ([noti.userInfo[@"section"] integerValue]==1&&[noti.userInfo[@"row"] integerValue]==0) {
        FallUrlViewController *clvc=[FallUrlViewController new];
        clvc.titleStr=noti.userInfo[@"title"];
        clvc.kind=@"townForecast";
        [self.navigationController pushViewController:clvc animated:YES];
    }
    if ([noti.userInfo[@"section"] integerValue]==1&&[noti.userInfo[@"row"] integerValue]==1) {
        
        WarningViewController *clvc=[WarningViewController new];
        clvc.titleStr=noti.userInfo[@"title"];
        clvc.kind=@"air";
        [self.navigationController pushViewController:clvc animated:YES];
    }
    if ([noti.userInfo[@"section"] integerValue]==1&&[noti.userInfo[@"row"] integerValue]==2) {
        
        WarningViewController *clvc=[WarningViewController new];
        clvc.titleStr=noti.userInfo[@"title"];
        clvc.kind=@"flood";
        [self.navigationController pushViewController:clvc animated:YES];
    }
    if ([noti.userInfo[@"section"] integerValue]==1&&[noti.userInfo[@"row"] integerValue]==3) {
        
        WarSignController *clvc=[WarSignController new];
        clvc.titleStr=@"预警信号地图";
        clvc.kind=@"signal";
        [self.navigationController pushViewController:clvc animated:YES];
    }
    if ([noti.userInfo[@"section"] integerValue]==1&&[noti.userInfo[@"row"] integerValue]==4) {
        
        WarningViewController *clvc=[WarningViewController new];
        clvc.titleStr=noti.userInfo[@"title"];
        clvc.kind=@"rain";
        [self.navigationController pushViewController:clvc animated:YES];
    }
    if ([noti.userInfo[@"section"] integerValue]==1&&[noti.userInfo[@"row"] integerValue]==5) {
        
        WarningViewController *clvc=[WarningViewController new];
        clvc.titleStr=noti.userInfo[@"title"];
        clvc.kind=@"temp";
        [self.navigationController pushViewController:clvc animated:YES];
    }
    if ([noti.userInfo[@"section"] integerValue]==1&&[noti.userInfo[@"row"] integerValue]==6) {
        
        QXFWViewController *clvc=[QXFWViewController new];
        clvc.titleStr=noti.userInfo[@"title"];
        clvc.kind=@"7";
        [self.navigationController pushViewController:clvc animated:YES];
    }
    if ([noti.userInfo[@"section"] integerValue]==1&&[noti.userInfo[@"row"] integerValue]==7) {
        
        QXFWViewController *clvc=[QXFWViewController new];
        clvc.titleStr=noti.userInfo[@"title"];
        clvc.kind=@"8";
        [self.navigationController pushViewController:clvc animated:YES];
    }
    
    
    if ([noti.userInfo[@"section"] integerValue]==2&&[noti.userInfo[@"row"] integerValue]==0) {
        
        QXFWViewController *clvc=[QXFWViewController new];
        clvc.titleStr=noti.userInfo[@"title"];
        clvc.kind=@"1";
        [self.navigationController pushViewController:clvc animated:YES];
    }
    if ([noti.userInfo[@"section"] integerValue]==2&&[noti.userInfo[@"row"] integerValue]==1) {
        
        QXFWViewController *clvc=[QXFWViewController new];
        clvc.titleStr=noti.userInfo[@"title"];
        clvc.kind=@"2";
        [self.navigationController pushViewController:clvc animated:YES];
    }
    if ([noti.userInfo[@"section"] integerValue]==2&&[noti.userInfo[@"row"] integerValue]==2) {
        
        QXFWViewController *clvc=[QXFWViewController new];
        clvc.titleStr=noti.userInfo[@"title"];
        clvc.kind=@"4";
        [self.navigationController pushViewController:clvc animated:YES];
    }
    if ([noti.userInfo[@"section"] integerValue]==2&&[noti.userInfo[@"row"] integerValue]==3) {
        
        QXFWViewController *clvc=[QXFWViewController new];
        clvc.titleStr=noti.userInfo[@"title"];
        clvc.kind=@"5";
        [self.navigationController pushViewController:clvc animated:YES];
    }
    if ([noti.userInfo[@"section"] integerValue]==2&&[noti.userInfo[@"row"] integerValue]==4) {
        
        QXFWViewController *clvc=[QXFWViewController new];
        clvc.titleStr=noti.userInfo[@"title"];
        clvc.kind=@"6";
        [self.navigationController pushViewController:clvc animated:YES];
    }
    if ([noti.userInfo[@"section"] integerValue]==2&&[noti.userInfo[@"row"] integerValue]==5) {
        
        QXFWViewController *clvc=[QXFWViewController new];
        clvc.titleStr=noti.userInfo[@"title"];
        clvc.kind=@"3";
        [self.navigationController pushViewController:clvc animated:YES];
    }
    
    
    if ([noti.userInfo[@"section"] integerValue]==3&&[noti.userInfo[@"row"] integerValue]==0) {
        
        FangZaiViewController *clvc=[FangZaiViewController new];
        clvc.titleStr=noti.userInfo[@"title"];
        clvc.kind=@"zaihaitu";
        [self.navigationController pushViewController:clvc animated:YES];
    }
    if ([noti.userInfo[@"section"] integerValue]==3&&[noti.userInfo[@"row"] integerValue]==1) {
        
        FangZaiViewController *clvc=[FangZaiViewController new];
        clvc.titleStr=noti.userInfo[@"title"];
        clvc.kind=@"lianxiren";
        [self.navigationController pushViewController:clvc animated:YES];
    }
    if ([noti.userInfo[@"section"] integerValue]==3&&[noti.userInfo[@"row"] integerValue]==2) {
        FallUrlViewController *clvc=[FallUrlViewController new];
        clvc.titleStr=noti.userInfo[@"title"];
        clvc.kind=@"yingji";
        [self.navigationController pushViewController:clvc animated:YES];
    }
    
    
    if ([noti.userInfo[@"section"] integerValue]==4&&[noti.userInfo[@"row"] integerValue]==0) {
        
        FallUrlViewController *clvc=[FallUrlViewController new];
        clvc.titleStr=noti.userInfo[@"title"];
        clvc.kind=@"yujixinghao";
        [self.navigationController pushViewController:clvc animated:YES];
    }
    if ([noti.userInfo[@"section"] integerValue]==4&&[noti.userInfo[@"row"] integerValue]==1) {
        
        FallUrlViewController *clvc=[FallUrlViewController new];
        clvc.titleStr=noti.userInfo[@"title"];
        clvc.kind=@"meteorologicalLaw";
        [self.navigationController pushViewController:clvc animated:YES];
    }
    if ([noti.userInfo[@"section"] integerValue]==4&&[noti.userInfo[@"row"] integerValue]==2) {
        FallUrlViewController *clvc=[FallUrlViewController new];
        clvc.titleStr=noti.userInfo[@"title"];
        clvc.kind=@"commenceSence";
        [self.navigationController pushViewController:clvc animated:YES];
    }
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    //self.navigationController.tabBarController.tabBar.hidden=YES;
    self.navigationController.navigationBarHidden=YES;
    _currentIndex=0;
    
    if ([[DataDefault shareInstance] userPhone]== nil) {
        if ([self compareDate:@"20170715 12"]!=1) {
            [self showRegisterView];
        }
    }
    
    if ([[DataDefault shareInstance] cityId]==nil) {
        NSMutableArray *cityArray=[NSMutableArray new];
        for (int i=0; i<14; i++) {
            if (i==1) {
                [cityArray addObject:@(YES)];
                
            }else{
                [cityArray addObject:@(NO)];
                
            }
        }
        [[DataDefault shareInstance] setCityId:cityArray];
        [self prepareCountys];
        
        // [self showCitylist];
    }
    else {
        [self prepareCountys];
        
        int n=0;
        for (int i=0; i<[[DataDefault shareInstance] cityId].count; i++) {
            if ([[[DataDefault shareInstance] cityId][i] boolValue]) {
                n++;
            }
        }
        if (n==0) {
            [self showCitylist];
        }else{
            [self loadData];
            [self updateaHeadUI:_countyArray[_currentIndex]];
            
        }
    }
    //NSLog(@"%@",[[DataDefault shareInstance] cityId]);
    
}

- (void)showRegisterView{
    
    if (_registerView==nil) {
        _registerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _registerView.backgroundColor=RGBACOLOR(1, 1, 1, 0.4);
        [self.view addSubview:_registerView];
        
        _inputView=[[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, 200*Rat, 0, 0)];
        _inputView.layer.masksToBounds=YES;
        _inputView.layer.cornerRadius=7;
        _inputView.backgroundColor=RGBACOLOR(246, 246, 246, 0.8);
        [_registerView addSubview:_inputView];
        
        
        CGRect fram=CGRectMake(SCREEN_WIDTH/2-170*Rat, 200*Rat, 350*Rat, 170*Rat);
        [UIView animateWithDuration:0.7 animations:^{
            _inputView.frame=fram;
        }completion:^(BOOL finished){
            
            UIImageView *sigImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 120*Rat, 150*Rat)];
            [sigImageView setImage:[UIImage imageNamed:@"resIcon"]];
            [_inputView addSubview:sigImageView];
            
            _accountField=[[UITextField alloc]initWithFrame:CGRectMake(120*Rat+20, 85*Rat-30-15*Rat,350*Rat-120*Rat-20*Rat-10-10, 30)];
            _accountField.borderStyle=UITextBorderStyleRoundedRect;
            _accountField.delegate=self;
            _accountField.placeholder=@"请输入手机号";
            [_accountField setValue:[UIColor colorWithRed:65/255.0 green:86/255.0 blue:97/255.0 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
            
            [_accountField setValue:[UIFont systemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
            
            _accountField.keyboardType=UIKeyboardTypeNumberPad;
            _accountField.textColor=RGBACOLOR(4, 40, 4,0.9);
            _accountField.font = [UIFont fontWithName:@"ArialMT" size:15];
            _accountField.clearButtonMode=UITextFieldViewModeAlways;
            [_inputView addSubview:_accountField];
            
            UIButton *surBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            surBtn.frame=CGRectMake(120*Rat+20, 85*Rat+15*Rat,350*Rat-120*Rat-20*Rat-10-10, 30);
            [surBtn setTitle:@"确定" forState:UIControlStateNormal];
            [surBtn setTitleColor:RGBACOLOR(236, 236, 236, 0.9) forState:UIControlStateHighlighted];
            surBtn.layer.masksToBounds=YES;
            surBtn.layer.cornerRadius=4;
            [surBtn setBackgroundColor:RGBACOLOR(7, 100, 177, 0.9)];
            [surBtn addTarget:self action:@selector(registerPhone:) forControlEvents:UIControlEventTouchUpInside];
            [_inputView addSubview:surBtn];
            
        }];
    }
}
- (void)registerViewHidden{
    [UIView animateWithDuration:0.8 animations:^{
        _registerView.alpha=0;
    }completion:^(BOOL finished){
        _registerView.hidden=YES;
    }];
    
}
- (void)registerPhone:(UIButton *)btn{
    [_accountField resignFirstResponder];
    NSString * phone= [_accountField text];
    NSString * uuid= [UUID getUUID];
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:phone forKey:@"phone"];
    [dict setObject:@"register" forKey:@"registerOrcount"];
    [dict setObject:@"宝鸡市" forKey:@"position"];
    [dict setObject:uuid forKey:@"uuid"];
    if (phone.length==11) {
        [manger POST:UserRegisterUrl parameters:dict success:^(AFHTTPRequestOperation * operation, id responseObject) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            if ([dict[@"msg"] isEqualToString:@"ok"]) {
                [[DataDefault shareInstance]setUserPhone:phone];
                [self sendCount:phone uuid:uuid];
                [self registerViewHidden];
            }
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            //  [SVProgressHUD showErrorWithStatus:error];
        }];
    }
    else{
        [SVProgressHUD showErrorWithStatus:@"手机号码不正确！"];
    }
    
    
}
- (void)sendCount:(NSString *)phone uuid:(NSString *)uuid{
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:phone forKey:@"phone"];
    [dict setObject:@"count" forKey:@"registerOrcount"];
    [dict setObject:@"宝鸡市" forKey:@"position"];
    [dict setObject:uuid forKey:@"uuid"];
    [manger POST:UserRegisterUrl parameters:dict success:^(AFHTTPRequestOperation * operation, id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
      //  NSLog(@"===%@",dict);
        
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        
    }];
    
}

- (void)refreshAction {
    
    
    [self loadNewData];
    
    
    
}

- (void)loadData {
    if (_countyArray.count>0) {
        [self loadDataWithCityname:_countyArray[_currentIndex]];
        
    }else{
        [self loadDataWithCityname:@"宝鸡市"];
        
    }
    
    
    self.requestType = RequestRefresh;
    self.isRefresh = YES;
}
- (void)loadNewData {
    [self loadDataWithCityname:_countyArray[_currentIndex]];
    
    // [self loadDataWithCityname:@"宝鸡市"];
    
    self.requestType = RequestRefresh;
    self.isRefresh = YES;
}


- (void)loadDataWithCityname:(NSString *)cityName{
    //@"宝鸡市"
    [NBRequest cancleRequest];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:cityName forKey:@"name"];
    
    [NBRequest postWithURL:MainCityNameUrl type:self.requestType dic:dict success:^(NSData *requestData) {
        if (self.isRefresh) {
            
        }
        //  NSArray *array = [NSJSONSerialization JSONObjectWithData:requestData options:NSJSONReadingMutableContainers erro                                                                                                                    r:nil];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:requestData options:NSJSONReadingMutableContainers error:nil];
        
        
         NSLog(@"===***%@",dict);
        if (dict!=nil) {
            
            if (![dict[@"cityname"] isEqual: [NSNull null]]) {
                
                NSMutableDictionary *dic0=[[NSMutableDictionary alloc]init];
                //[dic0 setValue:@"0" forKey:@"wr_count"];
                [dic0 setValue:dict[@"wr_count"] forKey:@"wr_count"];
                if ([dict[@"wr_count"] integerValue]>=1) {
                    [dic0 setValue:dict[@"wr"][0][@"type"] forKey:@"type"];
                    [dic0 setValue:dict[@"wr"][0][@"short_name"] forKey:@"short_name"];
                    [_dataDic setObject:dic0 forKey:@"section0"];
                    
                }
                
                if (![dict[@"live"] isEqual: [NSNull null]]) {
                    
                    NSMutableDictionary *dic1=[[NSMutableDictionary alloc]init];
                    [dic1 setObject:dict[@"live"][@"weather"] forKey:@"weather"];
                    [dic1 setValue:dict[@"live"][@"temp"] forKey:@"tem"];
                    [dic1 setValue:dict[@"live"][@"wind_direct"] forKey:@"wind_direction"];
                    [dic1 setValue:dict[@"live"][@"wind_level"] forKey:@"wind_lv"];
                    [dic1 setValue:dict[@"live"][@"hum"] forKey:@"hum"];
                    [dic1 setValue:dict[@"live"][@"rain"] forKey:@"rain"];
                    [dic1 setValue:dict[@"live"][@"updata_time"] forKey:@"updata_time"];
                    
                    [_dataDic setObject:dic1 forKey:@"section1"];
                    
                }
                
                
                if (![dict[@"wf"] isEqual: [NSNull null]]) {
                    NSString *todayTem=[NSString stringWithFormat:@"%@/%@℃",dict[@"wf"][@"temp_24_max"],dict[@"wf"][@"temp_24_min"]];
                    NSString *tomTem=[NSString stringWithFormat:@"%@/%@℃",dict[@"wf"][@"temp_48_max"],dict[@"wf"][@"temp_48_min"]];
                    NSMutableDictionary *dic3=[[NSMutableDictionary alloc]init];
                    [dic3 setValue:dict[@"wf"][@"wf_24_d"] forKey:@"weather_tod"];
                    [dic3 setValue:todayTem forKey:@"tem_tod"];
                    [dic3 setValue:dict[@"wf"][@"wf_48_d"] forKey:@"weather_tom"];
                    [dic3 setValue:tomTem forKey:@"tem_tom"];
                    [dic3 setValue:dict[@"wf"][@"img_1"] forKey:@"weatherIamgeD"];
                    [dic3 setValue:dict[@"wf"][@"img_2"] forKey:@"weatherIamgeT"];
                    [_dataDic setObject:dic3 forKey:@"section3"];
                    

                    
                    
                    NSArray *tempMax=@[dict[@"wf"][@"temp_24_max"],dict[@"wf"][@"temp_48_max"],dict[@"wf"][@"temp_72_max"],dict[@"wf"][@"temp_96_max"],dict[@"wf"][@"temp_120_max"],dict[@"wf"][@"temp_144_max"],dict[@"wf"][@"temp_168_max"]];
                    NSArray *tempMin=@[dict[@"wf"][@"temp_24_min"],dict[@"wf"][@"temp_48_min"],dict[@"wf"][@"temp_72_min"],dict[@"wf"][@"temp_96_min"],dict[@"wf"][@"temp_120_min"],dict[@"wf"][@"temp_144_min"],dict[@"wf"][@"temp_168_min"]];
                    NSArray *weatherD=@[dict[@"wf"][@"wf_24_d"],dict[@"wf"][@"wf_48_d"],dict[@"wf"][@"wf_72_d"],dict[@"wf"][@"wf_96_d"],dict[@"wf"][@"wf_120_d"],dict[@"wf"][@"wf_144_d"],dict[@"wf"][@"wf_168_d"]];
                    NSArray *weatherN=@[dict[@"wf"][@"wf_24_n"],dict[@"wf"][@"wf_48_n"],dict[@"wf"][@"wf_72_n"],dict[@"wf"][@"wf_96_n"],dict[@"wf"][@"wf_120_n"],dict[@"wf"][@"wf_144_n"],dict[@"wf"][@"wf_168_n"]];
                    NSArray *imageD=@[dict[@"wf"][@"img_1"],dict[@"wf"][@"img_2"],dict[@"wf"][@"img_3"],dict[@"wf"][@"img_4"],dict[@"wf"][@"img_5"],dict[@"wf"][@"img_6"],dict[@"wf"][@"img_7"]];
                    NSArray *imageN=@[dict[@"wf"][@"img_11"],dict[@"wf"][@"img_22"],dict[@"wf"][@"img_33"],dict[@"wf"][@"img_44"],dict[@"wf"][@"img_55"],dict[@"wf"][@"img_66"],dict[@"wf"][@"img_77"]];
                    NSMutableDictionary *dic4=[[NSMutableDictionary alloc]init];
                    [dic4 setValue:tempMax forKey:@"tempMax"];
                    [dic4 setValue:tempMin forKey:@"tempMin"];
                    [dic4 setValue:weatherD forKey:@"weatherD"];
                    [dic4 setValue:weatherN forKey:@"weatherN"];
                    [dic4 setValue:imageD forKey:@"imageD"];
                    [dic4 setValue:imageN forKey:@"imageN"];
                    [_dataDic setObject:dic4 forKey:@"section4"];
                    
                }
                if (![dict[@"wf"] isEqual: [NSNull null]]&&![dict[@"live"] isEqual: [NSNull null]]&&![dict[@"cityname"] isEqual: [NSNull null]]) {
                    [self loadDataWithCityid:[self cityIdWithName:cityName]];
                    
                }
                
                
            }
            
        }
        
    } failed:^(NSError *error) {
        [_perTab headerEndRefreshing];
        [_curTab headerEndRefreshing];
        [_nexTab headerEndRefreshing];
    }];
    
}

- (void)loadDataWithCityid:(NSString *)cyityId {
    // @"101110901"
    NSString *string = [NSString stringWithFormat:MainCityIdUrl,cyityId];
    [NBRequest requestWithURL:string type:self.requestType success:^(NSData *requestData) {
        //        if (self.isRefresh) {
        //            [self.dataArray removeAllObjects];
        //        }
        NSArray *array = [NSJSONSerialization JSONObjectWithData:requestData options:NSJSONReadingMutableContainers error:nil];
        //NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:requestData options:NSJSONReadingMutableContainers error:nil];
        // NSLog(@"%@",array);
        NSMutableArray *shortAdviseArr=[[NSMutableArray alloc]init];
        [shortAdviseArr addObject:array[6][@"shortAdvise"]];
        [shortAdviseArr addObject:array[2][@"shortAdvise"]];
        [shortAdviseArr addObject:array[10][@"shortAdvise"]];
        [shortAdviseArr addObject:array[0][@"shortAdvise"]];
        [shortAdviseArr addObject:array[1][@"shortAdvise"]];
        [shortAdviseArr addObject:array[3][@"shortAdvise"]];
        [shortAdviseArr addObject:array[8][@"shortAdvise"]];
        [shortAdviseArr addObject:array[7][@"shortAdvise"]];
        [shortAdviseArr addObject:array[4][@"shortAdvise"]];
        [shortAdviseArr addObject:array[9][@"shortAdvise"]];
        [shortAdviseArr addObject:array[5][@"shortAdvise"]];
        
        [_dataDic setObject:shortAdviseArr forKey:@"section5"];
        //NSLog(@"%@",_dataDic);
        
        [self updateScrollView:_dataDic];
        //NSLog(@"----请求成功-------");
        [_perTab headerEndRefreshing];
        [_curTab headerEndRefreshing];
        [_nexTab headerEndRefreshing];
    } failed:^(NSError *error) {
        [_perTab headerEndRefreshing];
        [_curTab headerEndRefreshing];
        [_nexTab headerEndRefreshing];
        
    }];
}

- (void)updateScrollView:(NSDictionary *)dic{
    
    // NSLog(@"lslslsl-----%@",dic);
    
    NSString *timeLen=dic[@"section1"][@"updata_time"];
    
    mindLab.text=[NSString stringWithFormat:@"宝鸡市气象台%@前发布",[self timelenth:timeLen]];
    
    
    if (_preView.frame.origin.x==0) {
        [self updatePersentScoll:dic];
    }
    else if (_currentView.frame.origin.x==0) {
        [self updateCurrentScoll:dic];
        
    }else if(_nextView.frame.origin.x==0){
        [self updateNextScoll:dic];
    }
    [self updateUIWithWeather:dic[@"section1"][@"weather"]];
}

- (NSString *)timelenth:(NSString *)str{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.s"];
    
    NSDate *date1 = [dateFormatter dateFromString:str];
    NSDate *date = [NSDate date];
    
    
    NSTimeInterval time = [date timeIntervalSinceDate:date1];
    NSString *dateContent;
    if ((int)time>3600) {
        int minutes = ((int)time)/3600;
        
        dateContent = [[NSString alloc] initWithFormat:@"%i小时",minutes];
        
    }else{
        int minutes = ((int)time)/60;
        
        dateContent = [[NSString alloc] initWithFormat:@"%i分钟",minutes];
        
    }
    
    return dateContent;
}
- (void)updateCurrentScoll:(NSDictionary *)dic{
    
    
    
    
    [sectionCurView0 updateHeaderWithDic:dic[@"section0"]];
    [sectionCurView1 updateViewdata:dic[@"section1"]];
    [sectionCurView3 updateStatuesdic:dic[@"section3"]];
    [sectionCurView4 updateTemH:dic[@"section4"][@"tempMax"] temL:dic[@"section4"][@"tempMin"] weatherDay:dic[@"section4"][@"weatherD"] weatherNig:dic[@"section4"][@"weatherN"] imageDay:dic[@"section4"][@"imageD"] imageNig:dic[@"section4"][@"imageN"]];
    [sectionCurView5 updateStatues:dic[@"section5"]];
}
- (void)updatePersentScoll:(NSDictionary *)dic{
    [sectionPerView0 updateHeaderWithDic:dic[@"section0"]];
    [sectionPerView1 updateViewdata:dic[@"section1"]];
    [sectionPerView3 updateStatuesdic:dic[@"section3"]];
    [sectionPerView4 updateTemH:dic[@"section4"][@"tempMax"] temL:dic[@"section4"][@"tempMin"] weatherDay:dic[@"section4"][@"weatherD"] weatherNig:dic[@"section4"][@"weatherN"] imageDay:dic[@"section4"][@"imageD"] imageNig:dic[@"section4"][@"imageN"]];
    [sectionPerView5 updateStatues:dic[@"section5"]];
}
- (void)updateNextScoll:(NSDictionary *)dic{
    [sectionNexView0 updateHeaderWithDic:dic[@"section0"]];
    [sectionNexView1 updateViewdata:dic[@"section1"]];
    [sectionNexView3 updateStatuesdic:dic[@"section3"]];
    [sectionNexView4 updateTemH:dic[@"section4"][@"tempMax"] temL:dic[@"section4"][@"tempMin"] weatherDay:dic[@"section4"][@"weatherD"] weatherNig:dic[@"section4"][@"weatherN"] imageDay:dic[@"section4"][@"imageD"] imageNig:dic[@"section4"][@"imageN"]];
    [sectionNexView5 updateStatues:dic[@"section5"]];
}



- (void)updateUIWithWeather:(NSString *)weather{
    if ([weather isEqualToString:@"晴"]) {
        [_bgImageView setImage:[UIImage imageNamed:@"w_qing"]];
        
        [self qingAnimation];
        // [self yuAnimation];
        
    }else if([weather isEqualToString:@"阴"]){
        [_bgImageView setImage:[UIImage imageNamed:@"w_yin"]];
        
        [self yingAnimation];
        
    }else{
        [_bgImageView setImage:[UIImage imageNamed:@"w_yu"]];
        
        [self yuAnimation];
        
    }
    
    
}

#pragma mark Animation

- (void)qingAnimation{
    [_sunTimer invalidate];
    _sunTimer=nil;
    
    [self stopRain];
    
    _sunImageView.frame=CGRectMake(0,70,SCREEN_WIDTH,200);
    [_sunImageView setImage:[UIImage imageNamed:@"sun"]];
    
    [self createSunAnimation];
    
    [self createCloudAnimation];
    if (_cloudTimer==nil) {
        _cloudTimer=[HWWeakTimer scheduledTimerWithTimeInterval:61.0f block:^(id userInfo) {
            [self createCloudAnimation];
        } userInfo:nil repeats:YES ];
    }
}

- (void)yingAnimation{
    [self stopRain];
    
    int i=random()%4;
    int j=random()%4;
    NSArray *name=@[@"cloud1",@"fine_day_cloud1",@"cloud2",@"fine_day_cloud2"];
    [_sunImageView.layer removeAllAnimations];
    _sunImageView.frame=CGRectMake(0,70,SCREEN_WIDTH,220);

    [_sunImageView setImage:[UIImage imageNamed:name[i]]];
    [_cloudImageView setImage:[UIImage imageNamed:name[j]]];
    
    //  [self sunViewIntCloudAnimation];
    [self createCloudAnimation];
    
    //    if (_sunTimer==nil) {
    //        _sunTimer=[HWWeakTimer scheduledTimerWithTimeInterval:40.0f block:^(id userInfo) {
    //            [self sunViewIntCloudAnimation];
    //        } userInfo:nil repeats:YES ];
    //    }
    if (_cloudTimer==nil) {
        _cloudTimer=[HWWeakTimer scheduledTimerWithTimeInterval:61.0f block:^(id userInfo) {
            [self createCloudAnimation];
        } userInfo:nil repeats:YES ];
    }
}
-(void)startRain{
    UIImage *image = [UIImage imageNamed:@"rainImage"];
    CGPoint piont=CGPointMake(SCREEN_WIDTH/2, 0);
    [self shootFrom:piont Level:50 Cells:@[image]];
}

- (void)shootFrom:(CGPoint)position Level:(int)level Cells:(NSArray <UIImage *>*)images; {
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isclear"]){
        
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isclear"];
        
        CGPoint emiterPosition = position;
        // 配置发射器
        CAEmitterLayer *emitterLayer = [CAEmitterLayer layer];
        emitterLayer.emitterPosition = emiterPosition;
        //发射源的尺寸大小
        emitterLayer.emitterSize     = CGSizeMake(SCREEN_WIDTH, 10);
        //发射模式
        emitterLayer.emitterMode     = kCAEmitterLayerSurface;
        //发射源的形状
        emitterLayer.emitterShape    = kCAEmitterLayerLine;
        emitterLayer.renderMode      = kCAEmitterLayerOldestLast;
        
        [self.view.layer addSublayer:emitterLayer];
        
        int index = rand()%[images count];
        CAEmitterCell *snowflake          = [CAEmitterCell emitterCell];
        //粒子的名字
        snowflake.name                    = @"sprite";
        //粒子参数的速度乘数因子
        snowflake.birthRate               = level;
        snowflake.lifetime                = 10;
        //粒子速度
        snowflake.velocity                = 20;
        //粒子的速度范围
        snowflake.velocityRange           = 250;
        //粒子y方向的加速度分量
        snowflake.yAcceleration           = 500;
        //snowflake.xAcceleration = 200;
        //周围发射角度
        snowflake.emissionRange           = 0.25*M_PI;
        //    snowflake.emissionLatitude = 200;
        snowflake.emissionLongitude       = M_PI;//
        //子旋转角度范围
        //snowflake.spinRange               = 2*M_PI;
        
        snowflake.contents                = (id)[[images objectAtIndex:index] CGImage];
        //snowflake.contentsScale = 1;
        snowflake.scale                   = 0.1;
        snowflake.scaleSpeed              = 0.1;
        emitterLayer.emitterCells  = [NSArray arrayWithObject:snowflake];
        [self.cacheEmitterLayers addObject:emitterLayer];
    }
    
}

-(void)stopRain{
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isclear"];
    for (CAEmitterLayer *emitterLayer in self.cacheEmitterLayers)
    {
        [emitterLayer removeFromSuperlayer];
        emitterLayer.emitterCells = nil;
    }
    [self.cacheEmitterLayers removeAllObjects];
}



- (void)yuAnimation{
    [_sunTimer invalidate];
    _sunTimer=nil;
    [_sunImageView.layer removeAllAnimations];
    _sunImageView.frame=CGRectMake(0,0,SCREEN_WIDTH,470*Rat);
    [_sunImageView setImage:[UIImage imageNamed:@"rain"]];
    
    [self startRain];
    
    if (_cloudTimer==nil) {
        _cloudTimer=[HWWeakTimer scheduledTimerWithTimeInterval:61.0f block:^(id userInfo) {
            [self createCloudAnimation];
        } userInfo:nil repeats:YES ];
    }
    
}

//_sunImageView Animation
- (void)sunViewIntCloudAnimation{
    CGFloat f=random()%80;
    NSArray *name=@[@"cloud1",@"fine_day_cloud1",@"cloud2",@"fine_day_cloud2"];
    int i=random()%4;
    
    if (_sunImageView.frame.origin.x>-SCREEN_WIDTH&&_sunImageView.frame.origin.x<=SCREEN_WIDTH) {
        CGRect preframe=_sunImageView.frame;
        CGFloat r=(rand()%10)/6.0;
        if (rand()%2==1) {
            preframe.origin.x +=SCREEN_WIDTH*r;
            
        }else{
            preframe.origin.x -=SCREEN_WIDTH*r;
            
        }
        
        [UIView animateWithDuration:40.5 animations:^{
            _sunImageView.frame=preframe;
            
        }completion:^(BOOL finished) {
            
        }];
    }else if(_sunImageView.frame.origin.x>SCREEN_WIDTH){
        
        _sunImageView.frame=CGRectMake(SCREEN_WIDTH,30+f,SCREEN_WIDTH,160-f/10);
        [_sunImageView setImage:[UIImage imageNamed:name[i]]];
        CGRect preframe=_sunImageView.frame;
        CGFloat r=(rand()%10)/5.0;
        preframe.origin.x -=SCREEN_WIDTH*r;
        
        [UIView animateWithDuration:40.5 animations:^{
            _sunImageView.frame=preframe;
            
            
        }completion:^(BOOL finished) {
            
        }];
    }else if(_sunImageView.frame.origin.x<=-SCREEN_WIDTH){
        _sunImageView.frame=CGRectMake(-SCREEN_WIDTH,30+f,SCREEN_WIDTH,160-f/10);
        [_sunImageView setImage:[UIImage imageNamed:name[i]]];
        CGRect preframe=_sunImageView.frame;
        CGFloat r=(rand()%10)/8.0;
        preframe.origin.x +=SCREEN_WIDTH*r;
        [UIView animateWithDuration:40.5 animations:^{
            _sunImageView.frame=preframe;
        }completion:^(BOOL finished) {
            
        }];
    }
}

- (void)createSunAnimation{
    if (_group==nil) {
        CABasicAnimation* rotationAnimation1= [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation1.toValue = [NSNumber numberWithFloat: M_PI /2.0 ];
        //        _rotationAnimation.fillMode=kCAFillModeForwards;
        //        _rotationAnimation.removedOnCompletion = NO;
        //        _rotationAnimation.duration = 2;
        //        _rotationAnimation.cumulative =NO;
        //        _rotationAnimation.repeatCount = MAXFLOAT;
        CABasicAnimation* rotationAnimation2 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation2.toValue = [NSNumber numberWithFloat: -M_PI /1.5 ];
        CABasicAnimation* rotationAnimation3 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation3.toValue = [NSNumber numberWithFloat: 0];
        // rotationAnimation2.beginTime = CACurrentMediaTime() + 2; // 2秒后执行
        _group = [CAAnimationGroup animation];
        
        _group.duration = 26.0;
        _group.repeatCount = MAXFLOAT;
        _group.animations = [NSArray arrayWithObjects:rotationAnimation1, rotationAnimation2, rotationAnimation3,nil];
    }
    [_sunImageView.layer addAnimation:_group forKey:@"move-rotate-layer"];
}

//cloudImageView Animation
- (void)createCloudAnimation{
    CGFloat f=random()%20;
    int i=random()%4;
    NSArray *name=@[@"cloud1",@"fine_day_cloud1",@"cloud2",@"fine_day_cloud2"];
    
    if (_cloudImageView.frame.origin.x>-SCREEN_WIDTH&&_cloudImageView.frame.origin.x<=SCREEN_WIDTH) {
        CGRect preframe=_cloudImageView.frame;
        CGFloat r=(rand()%10)/6.0;
        if (rand()%2==1) {
            preframe.origin.x +=SCREEN_WIDTH*r;
            
        }else{
            preframe.origin.x -=SCREEN_WIDTH*r;
            
        }
        
        [UIView animateWithDuration:60.5 animations:^{
            _cloudImageView.frame=preframe;
            
            
        }completion:^(BOOL finished) {
            
            
            
        }];
    }else if(_cloudImageView.frame.origin.x>SCREEN_WIDTH){
        _cloudImageView.frame=CGRectMake(SCREEN_WIDTH,30+f,SCREEN_WIDTH,160+f/20);
        [_cloudImageView setImage:[UIImage imageNamed:name[i]]];
        CGRect preframe=_cloudImageView.frame;
        CGFloat r=(rand()%10)/8.0;
        preframe.origin.x -=SCREEN_WIDTH*r;
        
        [UIView animateWithDuration:60.5 animations:^{
            _cloudImageView.frame=preframe;
            
            
        }completion:^(BOOL finished) {
            
        }];
    }else if(_cloudImageView.frame.origin.x<=-SCREEN_WIDTH){
        _cloudImageView.frame=CGRectMake(-SCREEN_WIDTH,30+f,SCREEN_WIDTH,160+f/20);
        [_cloudImageView setImage:[UIImage imageNamed:name[i]]];
        CGRect preframe=_cloudImageView.frame;
        CGFloat r=(rand()%10)/8.0;
        preframe.origin.x +=SCREEN_WIDTH*r;
        [UIView animateWithDuration:60.5 animations:^{
            _cloudImageView.frame=preframe;
            
            
        }completion:^(BOOL finished) {
            
        }];
    }
}



#pragma mark PageUIPart
- (void)updateaHeadUI:(NSString *)city{
    _cityName.text=city;
    
    if ([city isEqualToString:_locationCity]||[city isEqualToString:_locationCounty]) {
        CGRect cityFrame=CGRectMake(60, 34, 130, 25);
        
        [UIView animateWithDuration:0.3 animations:^{
            
            _cityName.frame=cityFrame;
            
        }completion:^(BOOL finished){
            _sigImageView.hidden=NO;
            
        }];
        
    }else{
        CGRect cityFrame=CGRectMake(42, 34, 130, 25);
        _sigImageView.hidden=YES;
        
        [UIView animateWithDuration:0.3 animations:^{
            
            _cityName.frame=cityFrame;
            
        }completion:^(BOOL finished){
            
        }];
    }
    
    
    
}

- (void)creteHeaderView{
    CGFloat f1;
    CGFloat f2;
    f1=SCREEN_HEIGHT>600? 23:19;
    f2=SCREEN_HEIGHT>600? 16:14;
    
    UIButton *listBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    listBtn.frame=CGRectMake(12, 40, 24, 15);
    [listBtn setBackgroundImage:[UIImage imageNamed:@"sk_list"] forState:UIControlStateNormal];
    [listBtn addTarget:self action:@selector(showCitylist) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:listBtn];
    
    _sigImageView=[[UIImageView alloc]initWithFrame:CGRectMake(44, 37, 16, 20)];
    [_sigImageView setImage:[UIImage imageNamed:@"city_itom_location"]];
    _sigImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.view addSubview:_sigImageView];
    
    if (_isDingwei) {
        _sigImageView.hidden=NO;
        _cityName=[[UILabel alloc]initWithFrame:CGRectMake(60, 34, 130, 25)];
        
    }else{
        _sigImageView.hidden=YES;
        
        _cityName=[[UILabel alloc]initWithFrame:CGRectMake(42, 34, 130, 25)];
    }
    _cityName.textAlignment=NSTextAlignmentLeft;
    _cityName.textColor=RGBACOLOR(244, 244, 244,0.9);
    _cityName.font=[UIFont systemFontOfSize:f1];
    _cityName.text=@"宝鸡市";
    [self.view addSubview:_cityName];
    UIButton *listBtn2=[UIButton buttonWithType:UIButtonTypeCustom];
    listBtn2.frame=CGRectMake(0, 20, 150, 50);
    [listBtn2 setBackgroundColor:[UIColor clearColor]];
    [listBtn2 addTarget:self action:@selector(showCitylist) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:listBtn2];
    
    
    mindLab=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-248, 38, 240, 20)];
    
    mindLab.textAlignment=NSTextAlignmentRight;
    mindLab.textColor=RGBACOLOR(244, 244, 244,0.9);
    mindLab.font=[UIFont systemFontOfSize:f2];
    mindLab.text=@"宝鸡市气象台24分钟前发布";
    [self.view addSubview:mindLab];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 69, SCREEN_WIDTH, 0.7)];
    lineView.backgroundColor=RGBACOLOR(210, 222, 222,0.5);
    
    [self.view addSubview:lineView];
    
    _maskView =[[UIView alloc]initWithFrame:CGRectMake(0, 70, SCREEN_WIDTH*0.25-70*Rat, SCREEN_HEIGHT-70)];
    _maskView.backgroundColor=RGBACOLOR(1, 1, 1, 0);
    
    
    UISwipeGestureRecognizer *sideLeftsGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(closeSideView:)];
    sideLeftsGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [_maskView addGestureRecognizer:sideLeftsGesture];
    UISwipeGestureRecognizer *sideRightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(openSideView:)];
    
    sideRightGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [_maskView addGestureRecognizer:sideRightGesture];
    
    [self.view addSubview:_maskView];
    
}

- (void)showCitylist{
    NSLog(@"show city list");
    CityListViewController *clvc=[CityListViewController new];
    [clvc setAction:^( ) {
        [self locate];
    }];
    [self.navigationController pushViewController:clvc animated:YES];
    
}

- (void)createScreChangeView{
    _bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT)];
    [_bgImageView setImage:[UIImage imageNamed:@"w_qing"]];
    _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    _bgImageView.clipsToBounds = YES;
    [self.view addSubview:_bgImageView];
    
    _sunImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,70,SCREEN_WIDTH,200)];
    _sunImageView.backgroundColor=[UIColor clearColor];
    
    [_sunImageView setImage:[UIImage imageNamed:@"sun"]];
    _sunImageView.contentMode = UIViewContentModeScaleToFill;
    _sunImageView.clipsToBounds = YES;
    [self.view addSubview:_sunImageView];
    
    NSArray *name=@[@"cloud1",@"fine_day_cloud1",@"cloud2",@"fine_day_cloud2"];
    int i=random()%4;
    _cloudImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,70,SCREEN_WIDTH,160)];
    _cloudImageView.backgroundColor=[UIColor clearColor];
    [_cloudImageView setImage:[UIImage imageNamed:name[i]]];
    _cloudImageView.contentMode = UIViewContentModeScaleToFill;
    _cloudImageView.clipsToBounds = YES;
    [self.view addSubview:_cloudImageView];
    
    _currentIndex = 0;  // 第0页
    _preView = [[UIView alloc] initWithFrame:CGRectMake(-SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _currentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _nextView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    _preView.userInteractionEnabled=YES;
    _currentView.userInteractionEnabled=YES;
    _nextView.userInteractionEnabled=YES;
    _preView.backgroundColor=[UIColor clearColor];
    _currentView.backgroundColor=[UIColor clearColor];
    _nextView.backgroundColor=[UIColor clearColor];
    
    [self.view addSubview:_preView];
    [self.view addSubview:_currentView];
    [self.view addSubview:_nextView];
    
    UISwipeGestureRecognizer *preLeftsGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(preViewLeft:)];
    preLeftsGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [_preView addGestureRecognizer:preLeftsGesture];
    
    UISwipeGestureRecognizer *preRightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(preViewRight:)];
    
    preRightGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [_preView addGestureRecognizer:preRightGesture];
    
    UISwipeGestureRecognizer *curLeftsGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(currentViewLeft:)];
    curLeftsGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [_currentView addGestureRecognizer:curLeftsGesture];
    
    UISwipeGestureRecognizer *curRightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(currentViewrRight:)];
    
    curRightGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [_currentView addGestureRecognizer:curRightGesture];
    
    UISwipeGestureRecognizer *nextLeftsGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(nextViewLeft:)];
    nextLeftsGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [_nextView addGestureRecognizer:nextLeftsGesture];
    
    UISwipeGestureRecognizer *nextRightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(nextViewrRight:)];
    
    nextRightGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [_nextView addGestureRecognizer:nextRightGesture];
}


- (void)closeSideView:(UISwipeGestureRecognizer *)sender{
    
    NSLog(@"side View Is Close !");
    _isOpen=NO;
    [self leftswipeGestureAction];
    
}
- (void)openSideView:(UISwipeGestureRecognizer *)sender{
    
    NSLog(@"side View Is Open !");
    _isOpen=YES;
    [self rightswipeGestureAction];
}

- (void)preViewLeft:(UISwipeGestureRecognizer *)sender{
    
    if (_isOpen) {
        
        _isOpen=NO;
        [self leftswipeGestureAction];
        
        NSLog(@"close sideliseView !");
        
    }else{
        if (_currentIndex==_countyArray.count-1) {
            NSLog(@"到头了----");
        }else{
            
            CGRect preframe=_preView.frame;
            CGRect curframe=_currentView.frame;
            CGRect nexframe=_nextView.frame;
            preframe.origin.x -=SCREEN_WIDTH;
            curframe.origin.x -=SCREEN_WIDTH;
            nexframe.origin.x -=SCREEN_WIDTH;
            
            [UIView animateWithDuration:0.5 animations:^{
                _preView.frame=preframe;
                _currentView.frame=curframe;
                _nextView.frame=nexframe;
                
            }completion:^(BOOL finished) {
                if (_preView.frame.origin.x==-SCREEN_WIDTH) {
                    
                    CGRect nexframe1=_nextView.frame;
                    nexframe1.origin.x =SCREEN_WIDTH;
                    _nextView.frame=nexframe1;
                }
                [_perTab setContentOffset:CGPointMake(0, 0)];
                
            }];
            
            _currentIndex++;
            NSLog(@"left and index :%ld",_currentIndex);
            NSLog(@"left and index :%@",_countyArray[_currentIndex]);
            [self updateaHeadUI:_countyArray[_currentIndex]];
            [self loadDataWithCityname:_countyArray[_currentIndex]];
        }
    }
}
- (void)preViewRight:(UISwipeGestureRecognizer *)sender{
    if (_currentIndex==0) {
        if (!_isOpen) {
            NSLog(@"---------打开侧边栏-------------");
        }
    }if (_currentIndex>=1){
        _currentIndex--;
        CGRect preframe=_preView.frame;
        CGRect curframe=_currentView.frame;
        CGRect nexframe=_nextView.frame;
        preframe.origin.x +=SCREEN_WIDTH;
        curframe.origin.x +=SCREEN_WIDTH;
        nexframe.origin.x +=SCREEN_WIDTH;
        
        [UIView animateWithDuration:0.5 animations:^{
            _preView.frame=preframe;
            _currentView.frame=curframe;
            _nextView.frame=nexframe;
            
        }completion:^(BOOL finished) {
            
            if (_preView.frame.origin.x==SCREEN_WIDTH) {
                CGRect curframe1=_currentView.frame;
                curframe1.origin.x =-SCREEN_WIDTH;
                _currentView.frame=curframe1;
                
            }
            [_perTab setContentOffset:CGPointMake(0, 0)];
        }];
        
        NSLog(@"right");
        
        NSLog(@"right and index :%ld",_currentIndex);
        NSLog(@"right and index :%@",_countyArray[_currentIndex]);
        [self updateaHeadUI:_countyArray[_currentIndex]];
        [self loadDataWithCityname:_countyArray[_currentIndex]];
        
    }
}
- (void)currentViewLeft:(UISwipeGestureRecognizer *)sender{
    
    
    if (_isOpen) {
        
        _isOpen=NO;
        [self leftswipeGestureAction];
        
        NSLog(@"close sideliseView !");
        
    }else{
        
        if (_currentIndex==_countyArray.count-1) {
            NSLog(@"到头了----");
        }else{
            _currentIndex++;
            
            CGRect preframe=_preView.frame;
            CGRect curframe=_currentView.frame;
            CGRect nexframe=_nextView.frame;
            preframe.origin.x -=SCREEN_WIDTH;
            curframe.origin.x -=SCREEN_WIDTH;
            nexframe.origin.x -=SCREEN_WIDTH;
            
            [UIView animateWithDuration:0.5 animations:^{
                _preView.frame=preframe;
                _currentView.frame=curframe;
                _nextView.frame=nexframe;
                
            }completion:^(BOOL finished) {
                
                
                if (_currentView.frame.origin.x==-SCREEN_WIDTH) {
                    
                    CGRect preframe1=_preView.frame;
                    preframe1.origin.x =SCREEN_WIDTH;
                    _preView.frame=preframe1;
                    
                }
                [_curTab setContentOffset:CGPointMake(0, 0)];
                
            }];
            
            NSLog(@"left and index :%ld",_currentIndex);
            NSLog(@"left and index :%@",_countyArray[_currentIndex]);
            [self updateaHeadUI:_countyArray[_currentIndex]];
            [self loadDataWithCityname:_countyArray[_currentIndex]];
        }
    }
}
- (void)currentViewrRight:(UISwipeGestureRecognizer *)sender{
    if (_currentIndex==0) {
        if (!_isOpen) {
            NSLog(@"---------打开侧边栏-------------");
        }
    }if (_currentIndex>=1){
        _currentIndex--;
        CGRect preframe=_preView.frame;
        CGRect curframe=_currentView.frame;
        CGRect nexframe=_nextView.frame;
        preframe.origin.x +=SCREEN_WIDTH;
        curframe.origin.x +=SCREEN_WIDTH;
        nexframe.origin.x +=SCREEN_WIDTH;
        
        [UIView animateWithDuration:0.5 animations:^{
            _preView.frame=preframe;
            _currentView.frame=curframe;
            _nextView.frame=nexframe;
            
        }completion:^(BOOL finished) {
            
            if (_currentView.frame.origin.x==SCREEN_WIDTH) {
                CGRect nexframe1=_nextView.frame;
                nexframe1.origin.x =-SCREEN_WIDTH;
                _nextView.frame=nexframe1;
                
            }
            [_curTab setContentOffset:CGPointMake(0, 0)];
            
        }];
        NSLog(@"right");
        
        NSLog(@"right and index :%ld",_currentIndex);
        NSLog(@"right and index :%@",_countyArray[_currentIndex]);
        [self updateaHeadUI:_countyArray[_currentIndex]];
        [self loadDataWithCityname:_countyArray[_currentIndex]];
    }
}
- (void)nextViewLeft:(UISwipeGestureRecognizer *)sender{
    if (_isOpen) {
        _isOpen=NO;
        [self leftswipeGestureAction];
        NSLog(@"close sideliseView !");
    }else{
        
        if (_currentIndex==_countyArray.count-1) {
            NSLog(@"到头了----");
        }else{
            _currentIndex++;
            
            CGRect preframe=_preView.frame;
            CGRect curframe=_currentView.frame;
            CGRect nexframe=_nextView.frame;
            preframe.origin.x -=SCREEN_WIDTH;
            curframe.origin.x -=SCREEN_WIDTH;
            nexframe.origin.x -=SCREEN_WIDTH;
            
            [UIView animateWithDuration:0.5 animations:^{
                _preView.frame=preframe;
                _currentView.frame=curframe;
                _nextView.frame=nexframe;
                
            }completion:^(BOOL finished) {
                
                if (_nextView.frame.origin.x==-SCREEN_WIDTH) {
                    CGRect curframe1=_currentView.frame;
                    curframe1.origin.x =SCREEN_WIDTH;
                    _currentView.frame=curframe1;
                    
                }
                [_nexTab setContentOffset:CGPointMake(0, 0)];
                
            }];
            
            
            NSLog(@"left and index :%ld",_currentIndex);
            NSLog(@"left and index :%@",_countyArray[_currentIndex]);
            
            [self updateaHeadUI:_countyArray[_currentIndex]];
            [self loadDataWithCityname:_countyArray[_currentIndex]];
        }
    }
    
}
- (void)nextViewrRight:(UISwipeGestureRecognizer *)sender{
    if (_currentIndex==0) {
        if (!_isOpen) {
            NSLog(@"---------在最前端-------------");
            
        }
    }if (_currentIndex>=1){
        _currentIndex--;
        CGRect preframe=_preView.frame;
        CGRect curframe=_currentView.frame;
        CGRect nexframe=_nextView.frame;
        preframe.origin.x +=SCREEN_WIDTH;
        curframe.origin.x +=SCREEN_WIDTH;
        nexframe.origin.x +=SCREEN_WIDTH;
        
        [UIView animateWithDuration:0.5 animations:^{
            _preView.frame=preframe;
            _currentView.frame=curframe;
            _nextView.frame=nexframe;
            
        }completion:^(BOOL finished) {
            
            if (_nextView.frame.origin.x==SCREEN_WIDTH) {
                CGRect preframe1=_preView.frame;
                preframe1.origin.x =-SCREEN_WIDTH;
                _preView.frame=preframe1;
                
            }
            [_nexTab setContentOffset:CGPointMake(0, 0)];
            
        }];
        
        NSLog(@"right");
        
        NSLog(@"right and index :%ld",_currentIndex);
        NSLog(@"right and index :%@",_countyArray[_currentIndex]);
        [self updateaHeadUI:_countyArray[_currentIndex]];
        [self loadDataWithCityname:_countyArray[_currentIndex]];
    }
}

- (void)createScrollView{
    CGFloat f1,h0,h1,h2,h3,h4,h5,h6;
    f1=SCREEN_HEIGHT>600 ?17:15;
    h1 =173.0;
    h3=90.0;
    h5=440.0;
    h6=150.0;
    
    if (SCREEN_HEIGHT<600) {
        h0= 240.0;
        h2=(SCREEN_WIDTH/3.0-15)*0.44+10.0;
        h4=520.0;
    }
    if (SCREEN_HEIGHT>600&&SCREEN_HEIGHT<700) {
        h0= 300.0;
        h2=(SCREEN_WIDTH/3.0-15)*0.44+20.0;
        h4=540.0;
        
    }
    if (SCREEN_HEIGHT<740&&SCREEN_HEIGHT>700) {
        h0= 336.0;
        h2=(SCREEN_WIDTH/3.0-15)*0.44+10.0;
        h4=550.0;
        
    }
    if (SCREEN_HEIGHT>740) {
        h0= 336.0;
        h2=(SCREEN_WIDTH/3.0-15)*0.44+10.0;
        h4=800.0;
        
    }
    
    _perTab = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 70, SCREEN_WIDTH, SCREEN_HEIGHT-70)];
    _perTab.directionalLockEnabled = YES; //只能一个方向滑动
    _perTab.pagingEnabled = NO; //是否翻页
    _perTab.backgroundColor = [UIColor clearColor];
    _perTab.showsVerticalScrollIndicator =NO; //垂直方向的滚动指示
    _perTab.showsHorizontalScrollIndicator =NO; //垂直方向的滚动指示
    _perTab.bounces = YES;
    _perTab.delegate = self;
    _perTab.contentSize = CGSizeMake(0, h0+h1+h2+h3+h4+h5+h6+30);
    
    [_preView addSubview:_perTab];
    
    [_perTab addHeaderWithTarget:self action:@selector(refreshAction) dateKey:kPullDateKey];
    [_perTab setHeaderRefreshingText:@"正在刷新..."];
    
    
    
    
    sectionPerView0=[[TableHeadView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, h0)];
    [sectionPerView0 setActionShow:^( ){
        
        [self showDetailInformation];
    }];
    
    [_perTab addSubview:sectionPerView0];
    
    sectionPerView1=[[MainPageView alloc]initWithFrame:CGRectMake(0, h0, SCREEN_WIDTH, h1)];
    
    [sectionPerView1 setAction:^( ) {
        [self showCalendarView];
    }];
    
    [_perTab addSubview:sectionPerView1];
    
    UIView *perView2=[[UIView alloc]initWithFrame:CGRectMake(0, h0+h1, SCREEN_WIDTH, h2)];
    NSArray *na=@[@"监测实况",@"预警预报",@"气象服务"];
    for (int i=0; i<3; i++) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(10+i*((SCREEN_WIDTH-50)/3.0 +15), 0, (SCREEN_WIDTH-50)/3.0, (SCREEN_WIDTH/3.0-15)*0.44);
        btn.titleLabel.font=[UIFont fontWithName:@"ArialMT" size:f1];
        [btn setTitle:na[i] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_bg1"] forState:UIControlStateNormal];
        btn.tag=i+100;
        [btn addTarget:self action:@selector(secBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [perView2 addSubview:btn];
    }
    [_perTab addSubview:perView2];
    
    
    sectionPerView3=[[WeatherView alloc]initWithFrame:CGRectMake(0, h0+h1+h2, SCREEN_WIDTH,h3 )];
    
    [_perTab addSubview:sectionPerView3];
    
    
    sectionPerView4=[[WeekWeatherView alloc]initWithFrame:CGRectMake(0, h0+h1+h2+h3+15, SCREEN_WIDTH, h4)];
    sectionPerView4.layer.masksToBounds=YES;
    sectionPerView4.layer.cornerRadius=4;
    
    sectionPerView4.backgroundColor=HEXACOLOR(0x666666, 0.8);
    //sectionPerView4.backgroundColor=RGBACOLOR(169, 178, 193, 0.9);
    [sectionPerView4 createWeekWeatherWhihTemH:nil temL:nil ];
    [_perTab addSubview:sectionPerView4];
    
    
    sectionPerView5=[[LifeIndx alloc]initWithFrame:CGRectMake(0, h0+h1+h2+h3+h4+30, SCREEN_WIDTH, h5)];
    
    sectionPerView5.layer.masksToBounds=YES;
    sectionPerView5.layer.cornerRadius=4;
    
    sectionPerView5.backgroundColor=HEXACOLOR(0x666666, 0.8);
    //sectionPerView5.backgroundColor=RGBACOLOR(156, 147, 72, 0.9);
    
    [_perTab addSubview:sectionPerView5];
    
    UIView *perView6=[[UIView alloc]initWithFrame:CGRectMake(0, h0+h1+h2+h3+h4+h5+30, SCREEN_WIDTH, h6)];
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(10, 50, SCREEN_WIDTH-20, 80)];
    bgView.backgroundColor=HEXACOLOR(0x666666, 0.9);
    bgView.layer.masksToBounds=YES;
    bgView.layer.cornerRadius=5;
    [perView6 addSubview:bgView];
    
    UIImageView *ico=[[UIImageView alloc]initWithFrame:CGRectMake(20, 15, 50, 50)];
    [ico setImage:[UIImage imageNamed:@"yfzn"]];
    [bgView addSubview:ico];
    UILabel *zhiNan=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-100-20, 25, 80, 30)];
    zhiNan.font=[UIFont fontWithName:@"ArialMT" size:19];
    zhiNan.textColor=[UIColor whiteColor];
    zhiNan.textAlignment=NSTextAlignmentRight;
    zhiNan.text=@"防灾指南";
    [bgView addSubview:zhiNan];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    tapGesture.numberOfTapsRequired = 1; //点击次数
    //tapGesture.numberOfTouchesRequired = 1; //点击手指数
    [bgView addGestureRecognizer:tapGesture];
    
    [_perTab addSubview:perView6];
    
    _curTab = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 70, SCREEN_WIDTH, SCREEN_HEIGHT-70)];
    _curTab.directionalLockEnabled = YES; //只能一个方向滑动
    _curTab.pagingEnabled = NO; //是否翻页
    _curTab.backgroundColor = [UIColor clearColor];
    _curTab.showsVerticalScrollIndicator =NO; //垂直方向的滚动指示
    _curTab.showsHorizontalScrollIndicator =NO; //垂直方向的滚动指示
    _curTab.bounces = YES;
    _curTab.delegate = self;
    _curTab.contentSize = CGSizeMake(0,  h0+h1+h2+h3+h4+h5+h6+30);
    [_currentView addSubview:_curTab];
    
    [_curTab addHeaderWithTarget:self action:@selector(refreshAction) dateKey:kPullDateKey];
    [_curTab setHeaderRefreshingText:@"正在刷新..."];
    
    
    sectionCurView0=[[TableHeadView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, h0)];
    
    [sectionCurView0 setActionShow:^( ){
        
        [self showDetailInformation];
    }];
    
    [_curTab addSubview:sectionCurView0];
    
    sectionCurView1=[[MainPageView alloc]initWithFrame:CGRectMake(0, h0, SCREEN_WIDTH, h1)];
    [sectionCurView1 setAction:^( ) {
        [self showCalendarView];
    }];
    [_curTab addSubview:sectionCurView1];
    
    UIView *curView2=[[UIView alloc]initWithFrame:CGRectMake(0, h0+h1, SCREEN_WIDTH, h2)];
    for (int i=0; i<3; i++) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(10+i*((SCREEN_WIDTH-50)/3.0 +15), 0, (SCREEN_WIDTH-50)/3.0, (SCREEN_WIDTH/3.0-15)*0.44);
        btn.titleLabel.font=[UIFont fontWithName:@"ArialMT" size:f1];
        [btn setTitle:na[i] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_bg1"] forState:UIControlStateNormal];
        btn.tag=i+100;
        
        [btn addTarget:self action:@selector(secBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [curView2 addSubview:btn];
    }
    [_curTab addSubview:curView2];
    
    
    sectionCurView3=[[WeatherView alloc]initWithFrame:CGRectMake(0, h0+h1+h2, SCREEN_WIDTH,h3 )];
    [_curTab addSubview:sectionCurView3];
    
    
    sectionCurView4=[[WeekWeatherView alloc]initWithFrame:CGRectMake(0, h0+h1+h2+h3+15, SCREEN_WIDTH, h4)];
    sectionCurView4.layer.masksToBounds=YES;
    sectionCurView4.layer.cornerRadius=4;
    
    sectionCurView4.backgroundColor=HEXACOLOR(0x666666, 0.8);
    //sectionCurView4.backgroundColor=RGBACOLOR(156, 147, 72, 0.9);
    [sectionCurView4 createWeekWeatherWhihTemH:nil temL:nil ];
    [_curTab addSubview:sectionCurView4];
    
    
    sectionCurView5=[[LifeIndx alloc]initWithFrame:CGRectMake(0, h0+h1+h2+h3+h4+30, SCREEN_WIDTH, h5)];
    sectionCurView5.layer.masksToBounds=YES;
    sectionCurView5.layer.cornerRadius=4;
    
    sectionCurView5.backgroundColor=HEXACOLOR(0x666666, 0.8);
    //sectionCurView5.backgroundColor=RGBACOLOR(156, 147, 72, 0.9);
    
    [_curTab addSubview:sectionCurView5];
    
    UIView *curView6=[[UIView alloc]initWithFrame:CGRectMake(0, h0+h1+h2+h3+h4+h5+30, SCREEN_WIDTH, h6)];
    UIView *bgView2=[[UIView alloc]initWithFrame:CGRectMake(10, 50, SCREEN_WIDTH-20, 80)];
    bgView2.backgroundColor=HEXACOLOR(0x666666, 0.9);
    bgView2.layer.masksToBounds=YES;
    bgView2.layer.cornerRadius=5;
    [curView6 addSubview:bgView2];
    
    UIImageView *ico2=[[UIImageView alloc]initWithFrame:CGRectMake(20, 15, 50, 50)];
    [ico2 setImage:[UIImage imageNamed:@"yfzn"]];
    [bgView2 addSubview:ico2];
    UILabel *zhiNan2=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-100-20, 25, 80, 30)];
    zhiNan2.font=[UIFont fontWithName:@"ArialMT" size:19];
    zhiNan2.textColor=[UIColor whiteColor];
    zhiNan2.textAlignment=NSTextAlignmentRight;
    zhiNan2.text=@"防灾指南";
    [bgView2 addSubview:zhiNan2];
    
    UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    tapGesture2.numberOfTapsRequired = 1; //点击次数
    //tapGesture.numberOfTouchesRequired = 1; //点击手指数
    [bgView2 addGestureRecognizer:tapGesture2];
    
    [_curTab addSubview:curView6];
    
    
    
    
    _nexTab = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 70, SCREEN_WIDTH, SCREEN_HEIGHT-70)];
    _nexTab.directionalLockEnabled = YES; //只能一个方向滑动
    _nexTab.pagingEnabled = NO; //是否翻页
    _nexTab.backgroundColor = [UIColor clearColor];
    _nexTab.showsVerticalScrollIndicator =NO; //垂直方向的滚动指示
    _nexTab.showsHorizontalScrollIndicator =NO; //垂直方向的滚动指示
    _nexTab.bounces = YES;
    _nexTab.delegate = self;
    _nexTab.contentSize = CGSizeMake(0, h0+h1+h2+h3+h4+h5+h6+30);
    [_nextView addSubview:_nexTab];
    
    [_nexTab addHeaderWithTarget:self action:@selector(refreshAction) dateKey:kPullDateKey];
    [_nexTab setHeaderRefreshingText:@"正在刷新..."];
    
    
    sectionNexView0=[[TableHeadView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, h0)];
    
    [sectionNexView0 setActionShow:^( ){
        
        [self showDetailInformation];
    }];
    
    [_nexTab addSubview:sectionNexView0];
    
    sectionNexView1=[[MainPageView alloc]initWithFrame:CGRectMake(0, h0, SCREEN_WIDTH, h1)];
    [sectionNexView1 setAction:^( ) {
        [self showCalendarView];
    }];
    [_nexTab addSubview:sectionNexView1];
    
    UIView *nexView2=[[UIView alloc]initWithFrame:CGRectMake(0, h0+h1, SCREEN_WIDTH, h2)];
    for (int i=0; i<3; i++) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(10+i*((SCREEN_WIDTH-50)/3.0 +15), 0, (SCREEN_WIDTH-50)/3.0, (SCREEN_WIDTH/3.0-15)*0.44);
        btn.titleLabel.font=[UIFont fontWithName:@"ArialMT" size:f1];
        [btn setTitle:na[i] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_bg1"] forState:UIControlStateNormal];
        btn.tag=i+100;
        
        [btn addTarget:self action:@selector(secBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [nexView2 addSubview:btn];
    }
    [_nexTab addSubview:nexView2];
    
    
    sectionNexView3=[[WeatherView alloc]initWithFrame:CGRectMake(0, h0+h1+h2, SCREEN_WIDTH,h3 )];
    [_nexTab addSubview:sectionNexView3];
    
    
    sectionNexView4=[[WeekWeatherView alloc]initWithFrame:CGRectMake(0, h0+h1+h2+h3+15, SCREEN_WIDTH, h4)];
    sectionNexView4.layer.masksToBounds=YES;
    sectionNexView4.layer.cornerRadius=4;
    
    sectionNexView4.backgroundColor=HEXACOLOR(0x666666, 0.8);
    //sectionNexView4.backgroundColor=RGBACOLOR(156, 147, 72, 0.9);
    [sectionNexView4 createWeekWeatherWhihTemH:nil temL:nil ];
    
    [_nexTab addSubview:sectionNexView4];
    
    
    sectionNexView5=[[LifeIndx alloc]initWithFrame:CGRectMake(0, h0+h1+h2+h3+h4+30, SCREEN_WIDTH, h5)];
    sectionNexView5.layer.masksToBounds=YES;
    sectionNexView5.layer.cornerRadius=4;
    
    sectionNexView5.backgroundColor=HEXACOLOR(0x666666, 0.8);
    //sectionNexView5.backgroundColor=RGBACOLOR(156, 147, 72, 0.9);
    
    [_nexTab addSubview:sectionNexView5];
    
    UIView *nexView6=[[UIView alloc]initWithFrame:CGRectMake(0, h0+h1+h2+h3+h4+h5+30, SCREEN_WIDTH, h6)];
    UIView *bgView3=[[UIView alloc]initWithFrame:CGRectMake(10, 50, SCREEN_WIDTH-20, 80)];
    bgView3.backgroundColor=HEXACOLOR(0x666666, 0.9);
    bgView3.layer.masksToBounds=YES;
    bgView3.layer.cornerRadius=5;
    [nexView6 addSubview:bgView3];
    
    UIImageView *ico3=[[UIImageView alloc]initWithFrame:CGRectMake(20, 15, 50, 50)];
    [ico3 setImage:[UIImage imageNamed:@"yfzn"]];
    [bgView3 addSubview:ico3];
    UILabel *zhiNan3=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-100-20, 25, 80, 30)];
    zhiNan3.font=[UIFont fontWithName:@"ArialMT" size:19];
    zhiNan3.textColor=[UIColor whiteColor];
    zhiNan3.textAlignment=NSTextAlignmentRight;
    zhiNan3.text=@"防灾指南";
    [bgView3 addSubview:zhiNan3];
    
    UITapGestureRecognizer *tapGesture3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    tapGesture3.numberOfTapsRequired = 1; //点击次数
    //tapGesture.numberOfTouchesRequired = 1; //点击手指数
    [bgView3 addGestureRecognizer:tapGesture3];
    
    [_nexTab addSubview:nexView6];
}

- (void)secBtnClick:(UIButton *)btn{
    [self rightswipeGestureAction];
    //发送消息
    NSMutableDictionary *dict=[NSMutableDictionary new];
    if (btn.tag==100) {
        [dict setValue:@"100"forKey:@"key"];
        
        NSLog(@"");
    }
    if (btn.tag==101) {
        [dict setValue:@"101"forKey:@"key"];
        
    }
    if (btn.tag==102) {
        [dict setValue:@"102"forKey:@"key"];
        
    }
    NSNotification * notice = [NSNotification notificationWithName:@"openSide" object:nil userInfo:dict];
    [[NSNotificationCenter defaultCenter]postNotification:notice];
    
}

-(void)showDetailInformation{
    
    CalendaruiViewController *clvc=[CalendaruiViewController new];
    clvc.titleStr=@"今日关注";
    clvc.kind=@"detail";
    clvc.city=_countyArray[_currentIndex];
    [self.navigationController pushViewController:clvc animated:YES];
}

- (void)showCalendarView{
    MSSCalendarViewController *cvc = [[MSSCalendarViewController alloc]init];
    cvc.limitMonth = 12 * 30;// 显示几个月的日历
    /*
     MSSCalendarViewControllerLastType 只显示当前月之前
     MSSCalendarViewControllerMiddleType 前后各显示一半
     MSSCalendarViewControllerNextType 只显示当前月之后
     */
    cvc.type = MSSCalendarViewControllerNextType;
    cvc.beforeTodayCanTouch = NO;// 今天之后的日期是否可以点击
    cvc.afterTodayCanTouch = YES;// 今天之前的日期是否可以点击
    // cvc.startDate = _startDate;// 选中开始时间
    //cvc.endDate = _endDate;// 选中结束时间
    /*以下两个属性设为YES,计算中国农历非常耗性能（在5s加载15年以内的数据没有影响）*/
    cvc.showChineseHoliday = YES;// 是否展示农历节日
    cvc.showChineseCalendar = YES;// 是否展示农历
    cvc.showHolidayDifferentColor = YES;// 节假日是否显示不同的颜色
    cvc.showAlertView = YES;// 是否显示提示弹窗
    cvc.delegate = self;
    [self.navigationController pushViewController:cvc animated:YES];
    
    //[self presentViewController:cvc animated:YES completion:nil];
    
}
-(void)tapGesture:(id)sender{
    NSLog(@"show list");
    
    if ([self compareDate:@"20170715 12"]!=1) {
        
        
        CGRect fram;
        if (!_showMind) {
            fram=CGRectMake((SCREEN_WIDTH-320*Rat)/2, 50*Rat, 320*Rat, 540*Rat);
            
        }else{
            fram=CGRectMake((SCREEN_WIDTH-33)/2,SCREEN_HEIGHT, 3, 3);
            
            
        }
        [UIView animateWithDuration:0.5 animations:^{
            mTableView.frame=fram;
            
        }completion:^(BOOL finished){
            
        }];
        _showMind=!_showMind;
        
    }
    
}
- (void)buttonClick:(UIButton *)btn{
    
    CGRect fram=CGRectMake((SCREEN_WIDTH-33)/2,SCREEN_HEIGHT, 3, 3);
    
    [UIView animateWithDuration:0.5 animations:^{
        mTableView.frame=fram;
        
    }completion:^(BOOL finished){
        
    }];
    _showMind=NO;
}
- (void)createFangZaiView{
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, SCREEN_HEIGHT, 3,3) style:UITableViewStylePlain];
    mTableView.delegate = self;
    mTableView.dataSource = self;
    mTableView.rowHeight = 480*Rat/7.0;
    mTableView.layer.masksToBounds=YES;
    mTableView.layer.cornerRadius=5;
    mTableView.scrollEnabled =NO;
    mTableView.showsVerticalScrollIndicator=NO;
    mTableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    
    [mTableView registerNib:[UINib nibWithNibName:@"ChooseCell" bundle:nil] forCellReuseIdentifier:@"ChooseCell"];//xib定制cell
    
    [self.view addSubview:mTableView];
    
    UIView *iView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320*Rat, 60*Rat)];
    iView .backgroundColor=RGBACOLOR(251, 251, 251, 0.9);
    UILabel *titLab=[[UILabel alloc]initWithFrame:CGRectMake(160*Rat-70, 20*Rat, 140, 24)];
    titLab.textAlignment=NSTextAlignmentCenter;
    titLab.textColor=RGBACOLOR(44, 44, 4,0.9);
    titLab.font=[UIFont systemFontOfSize:18];
    titLab.text=@"防灾指南";
    [iView addSubview:titLab];
    
    UIButton *closeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame=CGRectMake(320*Rat-40, 5, 40, 40);
    [closeBtn setImage:[UIImage imageNamed:@"close_btn"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [iView addSubview:closeBtn];
    
    mTableView.tableHeaderView=iView;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *titArray=@[@"气象灾害防范",@"防汛抗旱",@"地质灾害防范",@"森林火险",@"地质灾害防范",@"高致病性禽流感防范",@"普通火灾防范"];
    NSArray *imaArray=@[@"11",@"22",@"33",@"44",@"55",@"66",@"77"];
    
    ChooseCell *cell =[tableView dequeueReusableCellWithIdentifier:@"ChooseCell"];
    if (cell == nil) {
        cell = [[ChooseCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ChooseCell"];
    }
    cell.titleLab.text = [NSString stringWithFormat:@"%@",titArray [indexPath.row]];
    [cell.iocnImage setImage:[UIImage imageNamed:imaArray[indexPath.row]]];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *titArray=@[@"气象灾害防范",@"防汛抗旱",@"地质灾害防范",@"森林火险",@"地质灾害防范",@"高致病性禽流感防范",@"普通火灾防范"];
    
    
    CalendaruiViewController *clvc=[CalendaruiViewController new];
    clvc.title=titArray[indexPath.row];
    clvc.titleStr=@"详情";
    clvc.kind=@"webPage";
    clvc.indexNum=indexPath.row;
    [self.navigationController pushViewController:clvc animated:YES];
}


#pragma mark Gesture
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
    _maskView.backgroundColor=RGBACOLOR(1, 1, 1, 0);
    
    UINavigationController *centerNC = self.navigationController;
    
    LeftViewController *leftVC  = self.navigationController.parentViewController.childViewControllers[0];
    
    RightViewController *rightVC = self.navigationController.parentViewController.childViewControllers[1];
    
    //[[DataDefault shareInstance] setUserid:@"999"];
    
    CGRect fra=CGRectMake(0, 70, SCREEN_WIDTH*0.27-70*Rat, SCREEN_HEIGHT-70);
    
    [UIView animateWithDuration:0.3 animations:^{
        _maskView.frame=fra;
        
        if ( centerNC.view.center.x != self.view.center.x ) {
            
            leftVC.view.frame = CGRectMake(0, 0, _w, [UIScreen mainScreen].bounds.size.height);
            rightVC.view.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - _w, 0, _w, [UIScreen mainScreen].bounds.size.height);
            centerNC.view.frame = [UIScreen mainScreen].bounds;
            return;
        }
        //        else {
        //
        //            centerNC.view.frame = CGRectMake(-250, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        //            leftVC.view.frame =CGRectMake(-250, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        //
        //        }
    }];
    
    
}

// 右轻扫
- (void)rightswipeGestureAction{
    
    if ([self compareDate:@"20170715 12"]!=1) {
        
        UINavigationController *centerNC = self.navigationController;
        
        RightViewController *rightVC = self.navigationController.parentViewController.childViewControllers[1];
        
        LeftViewController *leftVC  = self.navigationController.parentViewController.childViewControllers[0];
        
        _maskView.frame=CGRectMake(0, 0, SCREEN_WIDTH*0.27, SCREEN_HEIGHT);
        [UIView animateWithDuration:0.3 animations:^{
            if ( centerNC.view.center.x != self.view.center.x ) {
                //            leftVC.view.frame = CGRectMake(0, 0, _w, [UIScreen mainScreen].bounds.size.height);
                //            rightVC.view.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - _w, 0, _w, [UIScreen mainScreen].bounds.size.height);
                //            centerNC.view.frame = [UIScreen mainScreen].bounds;
                
            }else{
                centerNC.view.frame = CGRectMake(_w, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
                rightVC.view.frame = CGRectMake(_w, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
                
            }
        }completion:^(BOOL finished) {
            
            _maskView.backgroundColor=RGBACOLOR(1, 1, 1, 0.4);
            
        }];
    }
    
}

#pragma mark NetWorkStatues
- (void)netWorkMonitor{
    /*通过AFNetworkReachabilityManager 可以用来检测网络状态的变化 */
    
    AFNetworkReachabilityManager *reachManager = [AFNetworkReachabilityManager sharedManager];
    [reachManager startMonitoring];
    [reachManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown: {
                
                //                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"网络状态"
                //                                                                    message:@"网络异常"
                //                                                                   delegate:nil
                //                                                          cancelButtonTitle:@"确定"
                //                                                          otherButtonTitles:nil];
                //                [alertView show];
                break;
            }
            case AFNetworkReachabilityStatusNotReachable: {
                
                if (!_isNetShow) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"网络状态"
                                                                        message:@"网络未连接"
                                                                       delegate:nil
                                                              cancelButtonTitle:@"确定"
                                                              otherButtonTitles:nil];
                    [alertView show];
                    _isNetShow=!_isNetShow;
                }
                
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWWAN: {
                //self.title = @"WWAN连接";
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi: {
                //self.title = @"WIFI连接";
                break;
            }
            default: {
                break;
            }
        }
    }];
    
}

#pragma mark -PassWoed TextField Editing

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (SCREEN_HEIGHT<500) {
        CGFloat offset=_inputView.frame.origin.y-50;
        [UIView animateWithDuration:0.3 animations:^{
            
            CGRect frame=_inputView.frame;
            frame.origin.y=offset;
            _inputView.frame=frame;
            
        }];
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (SCREEN_HEIGHT<500) {
        CGFloat offset=_inputView.frame.origin.y+50;
        [UIView animateWithDuration:0.3 animations:^{
            
            CGRect frame=_inputView.frame;
            frame.origin.y=offset;
            _inputView.frame=frame;
            
        }];
    }
    return YES;
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
            
            [self checkUpdate];
            
            
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self checkUpdate];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"]];
            
        }]];
        
        //弹出提示框；
        [self presentViewController:alert animated:true completion:nil];
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
            NSLog(@"jsjsjsjsjsjjsjsjsjsjsjsj");
        }
        else if (error == nil && [array count] == 0)
        {
            NSLog(@"No results were returned.");
        }
        else if (error != nil)
        {
            NSLog(@"An error occurred = %@", error);
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

- (NSString *)cityIdWithName:(NSString *)weath{
    
    
    NSString *cityId;
	   if ([weath isEqualToString:@"定位"]) {
          cityId = @"101110901";
      } else if ([weath isEqualToString:@"宝鸡市"]) {
          cityId = @"101110901";
      } else if ([weath isEqualToString:@"渭滨区"]) {
          cityId = @"101110901";
      }  else if ([weath isEqualToString:@"金台区"]) {
          cityId = @"101110901";
      } else if ([weath isEqualToString:@"陈仓区"]) {
          cityId = @"101110912";
      } else if ([weath isEqualToString:@"凤翔县"]) {
          cityId = @"101110906";
      } else if ([weath isEqualToString:@"岐山县"]) {
          cityId = @"101110905";
      } else if ([weath isEqualToString:@"扶风县"]) {
          cityId = @"101110907";
      } else if ([weath isEqualToString:@"眉县"]) {
          cityId = @"101110908";
      }else if ([weath isEqualToString:@"陇县"]) {
          cityId = @"101110911";
      }else if ([weath isEqualToString:@"千阳县"]) {
          cityId = @"101110903";
      }else if ([weath isEqualToString:@"麟游县"]) {
          cityId = @"101110904";
      }else if ([weath isEqualToString:@"凤县"]) {
          cityId = @"101110910";
      }else if ([weath isEqualToString:@"太白县"]) {
          cityId = @"101110909";
      }
    return cityId;
    
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
#pragma mark - UIDocumentInteractionControllerDelegate

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)interactionController
{
    return self;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //放弃作为第一响应者
    [textField resignFirstResponder];
    
    return YES; //暂时return
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
