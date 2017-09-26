
//
//  FallUrlViewController.m
//  BaojiWeather
//
//  Created by Tcy on 2017/3/13.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import "FallUrlViewController.h"

@interface FallUrlViewController ()


@end

@implementation FallUrlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self stupNav];
    if ([self.kind isEqualToString:@"fall"]) {
        [self createWebPageWithIndex:0];
    }
    if ([self.kind isEqualToString:@"temp"]) {
        [self createWebPageWithIndex:1];
    }
    if ([self.kind isEqualToString:@"townForecast"]) {
        [self createWebPageWithIndex:2];
    }
    
    if ([self.kind isEqualToString:@"commenceSence"]) {
        [self createWebPageWithIndex:3];
    }
    if ([self.kind isEqualToString:@"yingji"]) {
        [self createWebPageWithIndex:4];
    }
    if ([self.kind isEqualToString:@"meteorologicalLaw"]) {
        [self createWebPageWithIndex:5];
    }
    if ([self.kind isEqualToString:@"yujixinghao"]) {
        [self createWebPageWithIndex:6];
    }
    
}
- (void)createWebPageWithIndex:(NSInteger)index{
    NSArray *urlArray=@[FallPageUrl,TemperturePageUrl,TownForecast,CommenSence,Yingji,MeteorologicalLaw,YujiSign];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:urlArray[index]]];
    [self.view addSubview: webView];
    [webView loadRequest:request];
}
- (void)stupNav{
    self.title=self.titleStr;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
    [[UINavigationBar appearance] setBarTintColor:RGBACOLOR(20, 37, 83, 0.1)];
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



- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden=NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
