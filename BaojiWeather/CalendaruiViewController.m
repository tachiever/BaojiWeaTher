//
//  CalendaruiViewController.m
//  BaojiWeather
//
//  Created by Tcy on 2017/2/27.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import "CalendaruiViewController.h"
#import "MindDetailCell.h"

@interface CalendaruiViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *_tableView;
}
@property (nonatomic) NSMutableArray *dataArray;
@end
@implementation CalendaruiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];

    [self stupNav];
    
    _dataArray=[[NSMutableArray alloc]init];
    if ([self.kind isEqualToString:@"detail"]) {
        //为导航栏添加右侧按钮1
//        UIBarButtonItem *right1 = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"owner_good_share"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(rightAction:)];
        
//        //为导航栏添加右侧按钮2
//        UIBarButtonItem *right2 = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"more"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(rightAction:)];
        
        //NSArray *arr=[[NSArray alloc]initWithObjects:right1, nil];
        
        //self.navigationItem.rightBarButtonItems=arr;
        //self.navigationItem.rightBarButtonItem=right1;
        [self createTableView];
        [self loadDataWithCityname:@"宝鸡市"];
        NSLog(@"%@",_city);
    }else if ([self.kind isEqualToString:@"webPage"]) {
        [self createWebPageWithIndex:self.indexNum];
    }
}

- (void)stupNav{
    self.title=self.titleStr;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
    [[UINavigationBar appearance] setBarTintColor:RGBACOLOR(20, 37, 83, 0.1)];
}

- (void)createWebPageWithIndex:(NSInteger)index{
    
    NSArray *urlArray=@[webUrl1,webUrl2,webUrl3,webUrl4,webUrl5,webUrl6,webUrl7];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:urlArray[index]]];
    [self.view addSubview: webView];
    [webView loadRequest:request];
    

}

- (void)rightAction:(id *)sender{


    NSLog(@"share!");
}

- (void)loadDataWithCityname:(NSString *)cityName{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:cityName forKey:@"cityname"];
    
    [NBRequest postWithURL:WarningUrl type:RequestRefresh dic:dict success:^(NSData *requestData) {
//        if (self.isRefresh) {
//            
//        }
        
        [_dataArray removeAllObjects];
        NSArray *array = [NSJSONSerialization JSONObjectWithData:requestData options:NSJSONReadingMutableContainers error:nil];
//        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:requestData options:NSJSONReadingMutableContainers error:nil];
      //  NSLog(@"%@",array[0]);
        if (array.count>0) {
            for (NSDictionary *listDict in array) {
                NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
                [dic setValue:listDict[@"diteals"] forKey:@"diteals"];
                [dic setValue:listDict[@"name"] forKey:@"name"];
                [dic setValue:listDict[@"publish_time"] forKey:@"publish_time"];
                [dic setValue:listDict[@"short_name"] forKey:@"short_name"];
                [dic setValue:listDict[@"type"] forKey:@"type"];
                
                
                [_dataArray addObject:dic];
            }
            [_tableView reloadData];
        }else{
        
            [self.navigationController popViewControllerAnimated:YES];
        }


    } failed:^(NSError *error) {

    }];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.0001;
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

- (void)createTableView{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.backgroundColor=[UIColor whiteColor];
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.separatorColor = RGBCOLOR(120, 120, 120);
    
    [self.view addSubview:_tableView];
    
    [_tableView registerNib:[UINib nibWithNibName:@"MindDetailCell" bundle:nil] forCellReuseIdentifier:@"MindDetailCell"];//xib定制cell
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MindDetailCell *cell=[tableView dequeueReusableCellWithIdentifier:@"MindDetailCell"];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    [cell setValueFor:_dataArray[indexPath.row]];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self hightWithString:_dataArray[indexPath.row][@"diteals"]];
}



- (CGFloat)hightWithString:(NSString *)str{
    CGFloat h,h2;
    h2=SCREEN_WIDTH>320?(SCREEN_HEIGHT>700?80:77):60;
    CGSize titleSize = [str boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-60, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;

    h=titleSize.height;
    return h+h2+20;
}





- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden=NO;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
