//
//  QXFWViewController.m
//  BaojiWeather
//
//  Created by Tcy on 2017/3/22.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import "QXFWViewController.h"
#import "QiXiangServeCell.h"
#import "QXServeDetailController.h"

@interface QXFWViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *_tableView;
    NSInteger _maxNum;
    
}
@property (nonatomic, assign) NBRequestType requestType;
@property (nonatomic, assign) BOOL isRefresh;

@property (nonatomic)NSMutableArray *dataArray;

@end

@implementation QXFWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    _dataArray=[[NSMutableArray alloc]init];
    _maxNum = 0;
    self.requestType = RequestRefresh;

    
    [self stupNav];
    [self createTableView];
    
    [self downLoadData];
}
- (void)back:(id)btn{
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)loadNewData {
    self.isRefresh = YES;
    _maxNum = 0;
    self.requestType = RequestRefresh;
    [self downLoadData];
}

// 上拉加载更多
- (void)loadMoreData {
    self.requestType = RequestRefresh;
    _maxNum +=10;
    [self downLoadData];
}

- (void)downLoadData{
    
    NSLog(@"-------%ld",_maxNum);
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:self.kind forKey:@"severid"];
    [dict setObject:[NSString stringWithFormat:@"%ld",_maxNum] forKey:@"num"];
    [dict setObject:@10 forKey:@"tonum"];
    
    [NBRequest postWithURL:QiXiang type:self.requestType dic:dict success:^(NSData *requestData) {
        if (_isRefresh) {
            [_dataArray removeAllObjects];
            _isRefresh=!_isRefresh;
        }
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:requestData options:NSJSONReadingMutableContainers error:nil];
        NSArray *array=dict[@"pdfbean"];
        // NSLog(@"%@",dict);
        for (NSDictionary *dic in array) {
            NSMutableDictionary *di=[[NSMutableDictionary alloc]init];
            [di setObject:dic[@"createtime"] forKey:@"createtime"];
            [di setObject:dic[@"id"] forKey:@"id"];
            [di setObject:dic[@"name"] forKey:@"name"];
            [di setObject:dic[@"parentid"] forKey:@"parentid"];
            [_dataArray addObject:di];
            
        }
        //         NSLog(@"%ld",_dataArray.count);
        NSLog(@"%@",[_dataArray lastObject][@"name"]);
        
        [_tableView reloadData];
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
    } failed:^(NSError *error) {
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
    }];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    QXServeDetailController *dvc=[[QXServeDetailController alloc]init];
    dvc.detailid=[NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"id"]];
    [self.navigationController pushViewController:dvc animated:YES];
}

- (void)createTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.backgroundColor=[UIColor clearColor];
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.separatorColor = RGBCOLOR(120, 120, 120);
    
    [self.view addSubview:_tableView];
    
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];//纯代码定制cell
    [_tableView registerNib:[UINib nibWithNibName:@"QiXiangServeCell" bundle:nil] forCellReuseIdentifier:@"QiXiangServeCell"];//xib定制cell
    [_tableView addHeaderWithTarget:self action:@selector(loadNewData) dateKey:@"refresh"];
    [_tableView setHeaderRefreshingText:@"正在刷新..."];
    [_tableView addFooterWithTarget:self action:@selector(loadMoreData)];
    [_tableView setFooterPullToRefreshText:@"正在加载..."];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QiXiangServeCell *cell=[tableView dequeueReusableCellWithIdentifier:@"QiXiangServeCell"];
    CGFloat f= (SCREEN_HEIGHT>600? 15 :14);
    NSDictionary *dic =_dataArray[indexPath.row];
    cell.dateLab.text = [NSString stringWithFormat:@"%@",dic[@"createtime"]];
    cell.bameLab.text = [NSString stringWithFormat:@"%@",dic[@"name"]];
    [cell.iconImage setImage:[UIImage imageNamed:[self getStr:[self.kind integerValue]]]];
    //cell.textLabel.text=@"sss";
    cell.backgroundColor=[UIColor clearColor];
    cell.dateLab.font=[UIFont systemFontOfSize:14];
    cell.bameLab.font=[UIFont systemFontOfSize:f];
//    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
//    cell.selectedBackgroundView.backgroundColor = RGBACOLOR(77, 77, 77, 1);
    cell.selectionStyle=UITableViewCellSelectionStyleBlue;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}


- (NSString *)getStr:(NSInteger )dayIcon{
    NSString *dayIconstr;
    
    
    if (1==dayIcon){
        dayIconstr=@"ztyb";
    }
    else if (2==dayIcon){
        dayIconstr=@"qxxxkb";
    }
    else if (3==dayIcon){
        dayIconstr=@"nqcp";
        
    }
    else if (4==dayIcon){
        dayIconstr=@"slhxyb";
    }
    else if (5==dayIcon){
        dayIconstr=@"qxhjzb";
    }
    else if (6==dayIcon){
        dayIconstr=@"renyin";
    }
    else if (7==dayIcon){
        dayIconstr=@"dizhi";
    }
    else if (0==dayIcon){
        dayIconstr=@"ztyb";
    }
    else if (8==dayIcon){
        dayIconstr=@"zxhl";
    }
    
    return dayIconstr;
    
    
}
- (void)stupNav{
    self.title=self.titleStr;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
    [[UINavigationBar appearance] setBarTintColor:RGBACOLOR(20, 37, 83, 0.1)];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    self.navigationItem.backBarButtonItem = item;
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
}
- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden=NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
