//
//  LeftViewController.m
//  BaojiWeather
//
//  Created by Tcy on 2017/2/15.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import "LeftViewController.h"
#import "ViewCommon.h"
#import "LeftViewCell.h"

@interface LeftViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *_tableView;
    NSMutableArray *_statArray;
    NSMutableArray *_dataArray;
    NSInteger _num;
}
@property (nonatomic, strong) UIDocumentInteractionController *docInteractionController;


@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _num=10000000;
    // Do any additional setup after loading the view.
    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH*0.73,SCREEN_HEIGHT)];
    
    [bgImgView setImage:[UIImage imageNamed:@"menu_left"]];
    bgImgView.contentMode = UIViewContentModeScaleAspectFill;
    
    bgImgView.clipsToBounds = YES;
    [self.view addSubview:bgImgView];
    [self createDataArray];
    
    [self createTableView];
    [self listenNotification];
    
}

- (void)listenNotification{
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    
    [center addObserver:self selector:@selector(notice:) name:@"openSide" object:nil];
}

- (void)notice:(NSNotification *)noti{
    
    NSLog(@"%@",noti.userInfo);
    
    [_statArray removeAllObjects];
    
    [_statArray addObject:@(NO)];
    [_statArray addObject:@(NO)];
    [_statArray addObject:@(NO)];
    [_statArray addObject:@(NO)];
    [_statArray addObject:@(NO)];
    [_statArray addObject:@(NO)];
    [_tableView reloadData];
    _num=[noti.userInfo[@"key"] intValue]-100;
    BOOL state = [_statArray[[noti.userInfo[@"key"] intValue]-100] boolValue];
    [_statArray replaceObjectAtIndex:[noti.userInfo[@"key"] intValue]-100 withObject:@(!state)];
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:[noti.userInfo[@"key"] intValue]-100];
    [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    [_statArray replaceObjectAtIndex:[noti.userInfo[@"key"] intValue]-100 withObject:@(!state)];
    
    [_tableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:YES];

}
- (void)createDataArray {
    // 初始化状态的数组，并且，默认每一个都是开着的
    _statArray = [[NSMutableArray alloc] init];
    // 数据源数组
    _dataArray = [[NSMutableArray alloc] init];
    NSArray *array1 = @[@"降水温度", @"空气质量", @"雷达图", @"附近"];
    NSArray *array2 = @[ @"乡镇预报查询", @"重空气污染", @"泄洪预警", @"预警信号",@"降水异常记录", @"温度异常记录", @"地质灾害气象风险预警产品", @"中小河流气象风险预警产品"];
    NSArray *array3 = @[ @"气象信息快报", @"气象信息专报", @"森林火险气象等级预报",@"环境气象周报", @"人影指挥", @"气象产品"];
    NSArray *array4 = @[ @"灾害区划图", @"防汛责任人及应急联系人", @"应急预案及流程"];
    NSArray *array5 = @[ @"预警信号", @"气象法规", @"避险常识"];
    
    [_dataArray addObject:array1];
    [_dataArray addObject:array2];
    [_dataArray addObject:array3];
    [_dataArray addObject:array4];
    [_dataArray addObject:array5];
    [_statArray addObject:@(NO)];
    [_statArray addObject:@(NO)];
    [_statArray addObject:@(NO)];
    [_statArray addObject:@(NO)];
    [_statArray addObject:@(NO)];
    [_statArray addObject:@(NO)];
}

- (void)buttonClick:(UIButton *)button {
    button.transform = CGAffineTransformMakeRotation(M_PI_2);
    // 更改数组里保存的状态的值
    
    if (_num!=button.tag-100) {
        [_statArray removeAllObjects];
        
        [_statArray addObject:@(NO)];
        [_statArray addObject:@(NO)];
        [_statArray addObject:@(NO)];
        [_statArray addObject:@(NO)];
        [_statArray addObject:@(NO)];
        [_statArray addObject:@(NO)];
        [_tableView reloadData];
    }

    _num=button.tag-100;

    BOOL state = [_statArray[button.tag-100] boolValue];
    [_statArray replaceObjectAtIndex:button.tag-100 withObject:@(!state)];
     [_tableView reloadData];
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:button.tag-100];
    [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];


}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGFloat h;
    h=SCREEN_WIDTH>320?(SCREEN_HEIGHT>700?240:210):180;

    NSArray *array = @[@"监测实况", @"预警预报", @"决策气象服务", @"防灾减害", @"气象知识"];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*0.73, 70)];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(h, 16, 40, 40);
    [button setImage:[UIImage imageNamed:@"jiantou_right"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = 100+section;
    
    BOOL state = [_statArray[section] boolValue];
    if (state) {
        button.transform = CGAffineTransformMakeRotation(M_PI/2);
    } else {
        button.transform = CGAffineTransformMakeRotation(0);
    }
    [view addSubview:button];
    
    CGFloat f= (SCREEN_HEIGHT>480? 18 :16);

    UIView *linView=[[UIView alloc]initWithFrame:CGRectMake(0, 69,SCREEN_WIDTH*0.73, 0.7)];
    linView.backgroundColor= RGBCOLOR(120, 120, 120);
    [view addSubview:linView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 8, 200, 55)];
    label.text = array[section];
    label.font = [UIFont systemFontOfSize:f];
    label.textColor=[UIColor whiteColor];
    [view addSubview:label];
    view.backgroundColor = RGBCOLOR(23, 23, 23);
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.0001;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
        return _dataArray.count;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    BOOL state = [_statArray[section] boolValue];
    if (state) {
        return [_dataArray[section] count];
    } else {
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableDictionary *dict=[NSMutableDictionary new];
    [dict setValue:[NSString stringWithFormat:@"%ld",indexPath.section ]forKey:@"section"];
    [dict setValue:[NSString stringWithFormat:@"%ld",indexPath.row ]forKey:@"row"];
    [dict setValue:[NSString stringWithFormat:@"%@",_dataArray[indexPath.section][indexPath.row] ]forKey:@"title"];
    
    
    NSNotification * notice = [NSNotification notificationWithName:@"menulistSelect" object:nil userInfo:dict];
    [[NSNotificationCenter defaultCenter]postNotification:notice];
}




- (void)createTableView{
    
    CGFloat h= (SCREEN_HEIGHT>600? 192*Rat :192*Rat-30);
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, h, SCREEN_WIDTH*0.73, SCREEN_HEIGHT-h) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.backgroundColor=[UIColor clearColor];
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.separatorColor = RGBCOLOR(120, 120, 120);
    
    [self.view addSubview:_tableView];
    

    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];//纯代码定制cell
    [_tableView registerNib:[UINib nibWithNibName:@"LeftViewCell" bundle:nil] forCellReuseIdentifier:@"LeftViewCell"];//xib定制cell
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    LeftViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"LeftViewCell"];
    
    CGFloat f= (SCREEN_HEIGHT>600? 16 :15);

    
    cell.titleLab.text = _dataArray[indexPath.section][indexPath.row];
    //cell.textLabel.text=@"sss";
    cell.backgroundColor=[UIColor clearColor];
    cell.titleLab.textColor=[UIColor whiteColor];
    cell.titleLab.font=[UIFont systemFontOfSize:f];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];

    cell.selectedBackgroundView.backgroundColor = RGBACOLOR(77, 77, 77, 1);

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
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




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
