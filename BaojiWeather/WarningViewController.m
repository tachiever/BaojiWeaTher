//
//  WarningViewController.m
//  BaojiWeather
//
//  Created by Tcy on 2017/3/24.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import "WarningViewController.h"
#import "WarSignCell.h"

@interface WarningViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    UITableView *_tableView;
}
@property(nonatomic)NSMutableArray *dataArray;
@end

@implementation WarningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    _dataArray =[[NSMutableArray alloc]init];
    NSLog(@"%@",self.kind);
   // NSLog(@"%@",[_dataArray lastObject]);
    
    [self stupNav];
    
    if ([self.kind isEqualToString:@"air"]) {
        
        _dataArray=[[[DataDefault shareInstance] airInformArray] mutableCopy];
        
        
    }else if([self.kind isEqualToString:@"rain"]){
        
        _dataArray=[[[DataDefault shareInstance] rainInformArray] mutableCopy];
        
        
    }else if ([self.kind isEqualToString:@"temp"]){
        _dataArray=[[[DataDefault shareInstance] tempInformArray] mutableCopy];
        
        
    }
    
    
    [self createTableView];
    [self downloadDate];
    
}

- (void)downloadDate{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    
    NSString *urlStr=[NSString stringWithFormat:YuJingURL,self.kind];
    [NBRequest requestWithURL:urlStr type:RequestRefresh success:^(NSData *requestData) {
        NSArray *array = [NSJSONSerialization JSONObjectWithData:requestData options:NSJSONReadingMutableContainers error:nil];
        //NSLog(@"-----%@",array);


        if ([self.kind isEqualToString:@"air"]) {
            NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
            
            for (NSString *str in array) {
                NSMutableArray *dataArr=[[NSMutableArray alloc]init];

                if ([[DataDefault shareInstance] airInformArray]==nil){
                    [dic setObject:str forKey:@"inform"];
                    [dic setObject:currentDateStr forKey:@"data"];
                    [dataArr addObject:dic];
                    [[DataDefault shareInstance] setAirInformArray:dataArr];

                }else{
                    
                    if (![[NSString stringWithFormat:@"%@",[[[DataDefault shareInstance] airInformArray] lastObject][@"inform"]] isEqualToString:str]) {
                        dataArr =[[[DataDefault shareInstance] airInformArray] mutableCopy];

                        [dic setObject:str forKey:@"inform"];
                        [dic setObject:currentDateStr forKey:@"data"];
                        [dataArr addObject:dic];
                        [[DataDefault shareInstance] setAirInformArray:dataArr];

                    }
                }

            }
            
           _dataArray=[[[DataDefault shareInstance] airInformArray] mutableCopy];
        }
        else if([self.kind isEqualToString:@"rain"]){
            for (NSString *str in array) {
                NSMutableArray *dataArr=[[NSMutableArray alloc]init];

                NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
                if ([[DataDefault shareInstance] rainInformArray]==nil){
                    [dic setObject:str forKey:@"inform"];
                    [dic setObject:currentDateStr forKey:@"data"];
                    [dataArr addObject:dic];
                    [[DataDefault shareInstance] setRainInformArray:dataArr];

                }else{
                    if (![[NSString stringWithFormat:@"%@",[[[DataDefault shareInstance] rainInformArray] lastObject][@"inform"]] isEqualToString:str]) {
                        
                        dataArr=[[[DataDefault shareInstance] rainInformArray] mutableCopy];
                        
                        [dic setObject:str forKey:@"inform"];
                        [dic setObject:currentDateStr forKey:@"data"];
                        [dataArr addObject:dic];
                        [[DataDefault shareInstance] setRainInformArray:dataArr];

                    }
                }

                
            }
            _dataArray=[[[DataDefault shareInstance] rainInformArray] mutableCopy];
        }
        else if ([self.kind isEqualToString:@"temp"]){
            for (NSString *str in array) {
                NSMutableArray *dataArr=[[NSMutableArray alloc]init];

                NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
                if ([[DataDefault shareInstance] tempInformArray].count==0){
                    [dic setObject:str forKey:@"inform"];
                    [dic setObject:currentDateStr forKey:@"data"];
                    [dataArr addObject:dic];
                    [[DataDefault shareInstance] setTempInformArray:dataArr];

                }else{
                    if (![[NSString stringWithFormat:@"%@",[[[DataDefault shareInstance] tempInformArray] lastObject][@"inform"]] isEqualToString:str]) {
                        dataArr=[[[DataDefault shareInstance] tempInformArray] mutableCopy];
                        
                        [dic setObject:str forKey:@"inform"];
                        [dic setObject:currentDateStr forKey:@"data"];
                        [dataArr addObject:dic];
                        [[DataDefault shareInstance] setTempInformArray:dataArr];

                    }
                }

            }
            _dataArray=[[[DataDefault shareInstance] tempInformArray] mutableCopy];
        }
        [_tableView reloadData];
    } failed:^(NSError *error) {
        
    }];
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

- (void)createTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.backgroundColor=[UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.separatorColor = RGBCOLOR(120, 120, 120);
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];//纯代码定制cell
    [_tableView registerNib:[UINib nibWithNibName:@"WarSignCell" bundle:nil] forCellReuseIdentifier:@"WarSignCell"];//xib定制cell
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WarSignCell *cell=[tableView dequeueReusableCellWithIdentifier:@"WarSignCell"];
    
    CGFloat f= (SCREEN_HEIGHT>600? 17 :14);
    cell.backgroundColor=[UIColor clearColor];
    cell.textLabel.textColor=[UIColor whiteColor];
    cell.nameLab.font=[UIFont systemFontOfSize:f];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    if ([self.kind isEqualToString:@"air"]) {
        [cell.nameLab setText:@"空气质量:"];

        [cell.iconImage setImage:[UIImage imageNamed:@"noti_air"]];
        cell.dateLab.text=[NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"data"]];
        
        if ([NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"inform"]].length>0) {
            cell.detailLab.text=[NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"inform"]];
            
        }else{
            cell.detailLab.text=@"暂无空气质量异常";
            
            
        }
        
    }
    
    if([self.kind isEqualToString:@"rain"]){
        [cell.nameLab setText:@"最近24小时降水统计:"];

        [cell.iconImage setImage:[UIImage imageNamed:@"noti_rain"]];
        cell.dateLab.text=[NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"data"]];
        
        if ([NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"inform"]].length>0) {
            cell.detailLab.text=[NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"inform"]];
            
        }else{
            cell.detailLab.text=@"暂无降水异常";
            
            
        }
        
    }
    if ([self.kind isEqualToString:@"temp"]){
        
        
        [cell.iconImage setImage:[UIImage imageNamed:@"noti_temp"]];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"M"];
        NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];

        if ([currentDateStr integerValue]>5&&[currentDateStr integerValue]<10) {
            [cell.nameLab setText:@"温度高于35℃的地区:"];

        }else{
            [cell.nameLab setText:@"温度低于-5℃的地区:"];
        }
        
        cell.dateLab.text=[NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"data"]];
        
        if ([NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"inform"]].length>0) {
            cell.detailLab.text=[NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"inform"]];
            
        }else{
            cell.detailLab.text=@"暂无温度异常";
            
            
        }
        
        
    }
    
//    NSString *labelText = cell.detailLab.text;
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText attributes:@{NSKernAttributeName:@(1)}];
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle setLineSpacing:2];
//    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
//    cell.detailLab.attributedText = attributedString;
    //[cell.detailLab sizeToFit];
    
    
    
    [cell setDelateAction:^(){
       // NSLog(@"detail!");
        [self showdelate:indexPath.row];
    }];
    return cell;
}

- (void)showdelate:(NSInteger)num{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"删除" message:@"是否要删除该条记录？" preferredStyle:  UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self delateDate:num];
    }]];
    
    [self presentViewController:alert animated:true completion:nil];
    
}

- (void)delateDate:(NSInteger)num{
    [_dataArray removeObjectAtIndex:num];

    if ([self.kind isEqualToString:@"air"]) {
        
        [[DataDefault shareInstance] setAirInformArray:_dataArray];
        
        
    }else if([self.kind isEqualToString:@"rain"]){
        
        [[DataDefault shareInstance] setRainInformArray:_dataArray];
        
        
    }else if ([self.kind isEqualToString:@"temp"]){
        [[DataDefault shareInstance] setTempInformArray:_dataArray];
    }
    [_tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self hightWithString:[NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"inform"]]];
}

- (CGFloat)hightWithString:(NSString *)str{
    CGFloat h,h2;
    h2=SCREEN_WIDTH>320?(SCREEN_HEIGHT>700?370:370):270;
//
//    if ([self.kind isEqualToString:@"air"]) {
//        h2=SCREEN_WIDTH>320?(SCREEN_HEIGHT>700?270:270):270;
//
//    }else if([self.kind isEqualToString:@"rain"]){
//        h2=SCREEN_WIDTH>320?(SCREEN_HEIGHT>700?160:180):160;
//
//    }else if ([self.kind isEqualToString:@"temp"]){
//        h2=SCREEN_WIDTH>320?(SCREEN_HEIGHT>700?160:160):160;
//
//    }
//    CGSize titleSize = [str boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;
//    
//    h=titleSize.height;
    //    return h+h2;
    return h2;
}

- (void)stupNav{
    self.title=self.titleStr;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
    [[UINavigationBar appearance] setBarTintColor:RGBACOLOR(20, 37, 83, 0.1)];
    
    
    UIBarButtonItem *rigitem=[[UIBarButtonItem alloc]initWithTitle:@"清除" style:UIBarButtonItemStylePlain target:self action:@selector(rightAction)];
    //   [rigitem setBackgroundImage:[UIImage imageNamed:@"itemBg"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    self.navigationItem.rightBarButtonItem=rigitem;
}
- (void)rightAction{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"清除" message:@"是否要清空所有记录？" preferredStyle:  UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [_dataArray removeAllObjects];
        [_tableView reloadData];
        if ([self.kind isEqualToString:@"air"]) {
            
            [[DataDefault shareInstance] setAirInformArray:nil];
            
            
        }else if([self.kind isEqualToString:@"rain"]){
            
            [[DataDefault shareInstance] setRainInformArray:nil];
            
            
        }else if ([self.kind isEqualToString:@"temp"]){
            [[DataDefault shareInstance] setTempInformArray:nil];
        }
        
    }]];
    
    [self presentViewController:alert animated:true completion:nil];
    
}
- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden=NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
