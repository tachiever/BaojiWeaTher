//
//  FangZaiViewController.m
//  BaojiWeather
//
//  Created by Tcy on 2017/3/22.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import "FangZaiViewController.h"
#import "PersonModel.h"
#import "CityButton.h"
#import "PersonTableViewCell.h"
#import "PerTableViewCell.h"
#import <MessageUI/MessageUI.h>

@interface FangZaiViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,MFMessageComposeViewControllerDelegate>{
    UITableView *_tableView;

}


@property (nonatomic)UIScrollView *scrollerView;
@property (nonatomic,strong)UIScrollView * scroll;
@property (nonatomic)UIImageView *imageView;

@property (strong, nonatomic) IBOutlet UIView *ScanView;
@property (nonatomic)NSMutableArray *dataArray;
@property (nonatomic)NSMutableArray *statuArray;
@property (nonatomic)NSArray *cityArray;
@property (nonatomic)NSInteger num;

@property (nonatomic)CityButton *btn0;
@property (nonatomic)CityButton *btn1;
@property (nonatomic)CityButton *btn2;
@property (nonatomic)CityButton *btn3;
@property (nonatomic)CityButton *btn4;
@property (nonatomic)CityButton *btn5;
@property (nonatomic)CityButton *btn6;
@property (nonatomic)CityButton *btn7;
@property (nonatomic)CityButton *btn8;
@property (nonatomic)CityButton *btn9;
@property (nonatomic)CityButton *btn10;
@property (nonatomic)CityButton *btn11;
@property (nonatomic)CityButton *btn12;

@end

@implementation FangZaiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self stupNav];
    self.view.backgroundColor=[UIColor whiteColor];
    if ([self.kind isEqualToString:@"zaihaitu"]) {
        [self createScrollView];
    }
    if ([self.kind isEqualToString:@"lianxiren"]) {
        _dataArray=[[NSMutableArray alloc]init];
        _statuArray=[[NSMutableArray alloc]init];
        _num=9999999;
        _cityArray=@[@"宝鸡市",@"渭滨区",@"金台区",@"陈仓区",@"凤翔县",@"岐山县",@"扶风县",@"眉县",@"陇县",@"千阳县",@"麟游县",@"凤县",@"太白县"];
        
        [self createTableView];
        [self getPersonInfor:@"宝鸡市"];

    }
}
#pragma Mark CommunicatePerson Part
- (void)getPersonInfor:(NSString *)city{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:city forKey:@"site_id"];
    
    [NBRequest postWithURL:AddressBook type:RequestRefresh dic:dict success:^(NSData *requestData) {
        
        [_dataArray removeAllObjects];
        [_statuArray removeAllObjects];
        _num=9999999;

          NSArray *array = [NSJSONSerialization JSONObjectWithData:requestData options:NSJSONReadingMutableContainers error:nil];
         //NSLog(@"%@",array);
        if (array.count>0) {
            for (NSDictionary *dic in array) {
                NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
                NSArray *arr=dic[@"childlist"];
                [dict setObject:dic[@"childlist"] forKey:@"childlist"];
                [dict setObject:dic[@"prentMenuName"] forKey:@"prentMenuName"];
                [dict setObject:[NSString stringWithFormat:@"%ld人",arr.count] forKey:@"presonNum"];
                [_dataArray addObject:dict];
            }
            // NSLog(@"%ld",_dataArray.count);
            NSLog(@"%@",_dataArray[0]);
            
            for (int i=0; i<_dataArray.count; i++) {
                [_statuArray addObject:@(NO)];
            }
        }
        [_tableView reloadData];
 
    } failed:^(NSError *error) {
        
    }];



}


- (void)buttonClick:(UIButton *)button {
    button.transform = CGAffineTransformMakeRotation(M_PI_2);
    // 更改数组里保存的状态的值
    if (_num!=button.tag-100&&_num<1000) {
        [_statuArray replaceObjectAtIndex:_num withObject:@(NO)];
    }
    _num=button.tag-100;
    BOOL state = [_statuArray[button.tag-100] boolValue];
    [_statuArray replaceObjectAtIndex:button.tag-100 withObject:@(!state)];
    [_tableView reloadData];
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:button.tag-100];
    [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 60)];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(_tableView.frame.size.width-40, 10, 30, 30);
        [button setImage:[UIImage imageNamed:@"xyjt"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 100+section;
        BOOL state = [_statuArray[section] boolValue];
        if (state) {
            button.transform = CGAffineTransformMakeRotation(M_PI/2);
        } else {
            button.transform = CGAffineTransformMakeRotation(0);
        }
        [view addSubview:button];
        
        
        CGFloat f= (SCREEN_HEIGHT>600? 17 :15);
        UIView *linView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,_tableView.frame.size.width, 1)];
        linView.backgroundColor= RGBCOLOR(120, 120, 120);
        [view addSubview:linView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 160, 50)];
        label.text = _dataArray[section][@"prentMenuName"];
        label.font = [UIFont systemFontOfSize:f];
        label.textColor=[UIColor darkGrayColor];
        [view addSubview:label];
        view.backgroundColor = RGBCOLOR(253, 253, 255);

        
        UILabel *numLab = [[UILabel alloc] initWithFrame:CGRectMake(_tableView.frame.size.width-80, 0, 40, 50)];
        numLab.text = _dataArray[section][@"presonNum"];
        numLab.font = [UIFont systemFontOfSize:f];
        numLab.textColor=[UIColor darkGrayColor];
        [view addSubview:numLab];
        
        return view;
  
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.0001;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _dataArray.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    BOOL state = [_statuArray[section] boolValue];
    if (state) {
        return [_dataArray[section][@"childlist"] count];
    } else {
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    

}




- (void)createTableView{
    [self createButton];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(((SCREEN_HEIGHT-64-14)/13.00)*2.0+1, 64, SCREEN_WIDTH-((SCREEN_HEIGHT-64-14)/13.00)*2.0-2, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.backgroundColor=[UIColor clearColor];
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.separatorColor = RGBCOLOR(120, 120, 120);
    
    [self.view addSubview:_tableView];
    
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];//纯代码定制cell

    [_tableView registerNib:[UINib nibWithNibName:@"PersonTableViewCell" bundle:nil] forCellReuseIdentifier:@"PersonTableViewCell"];//xib定制cell
    [_tableView registerNib:[UINib nibWithNibName:@"PerTableViewCell" bundle:nil] forCellReuseIdentifier:@"PerTableViewCell"];//xib定制cell
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dic=_dataArray[indexPath.section][@"childlist"][indexPath.row];
    PersonModel *model=[[PersonModel alloc]init];
    [model setValuesForKeysWithDictionary:dic];
    
    if (SCREEN_HEIGHT<600) {
        PerTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"PerTableViewCell"];

        cell.backgroundColor=[UIColor clearColor];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = RGBACOLOR(77, 77, 77, 1);
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.layer.masksToBounds=YES;
        cell.layer.cornerRadius=5;
        cell.layer.borderWidth=1;
        cell.layer.borderColor=RGBCOLOR(32, 183, 238).CGColor;
    
        [cell.nameLab setText:[NSString stringWithFormat:@"%@",model.name]];
        [cell.dutyLab setText:[NSString stringWithFormat:@"%@",model.duty]];
        [cell.comany setText:[NSString stringWithFormat:@"%@",model.company]];
        [cell.otherLab setText:[NSString stringWithFormat:@"%@",model.other]];
        NSString *fax;
        NSString *pho=[model.phone substringWithRange:NSMakeRange(3,11)];
        if (model.fax.length>10) {
            fax=[model.fax substringWithRange:NSMakeRange(3,12)];
            
        }else{
            fax=[model.fax substringFromIndex:3];
            
        }
        [cell.phonebtn setTitle:pho forState:UIControlStateNormal];
        [cell.faxbtn setTitle:fax forState:UIControlStateNormal];

        [cell setMessageAction:^(){
            NSLog(@"message");
            [self showMessageView:pho];

        }];
        [cell setPhoneAction:^(){
            NSLog(@"phone");
            [self makeCall:pho];
        }];
        [cell setFaxAction:^(){
            NSLog(@"fax");
            [self makeCall:fax];

        }];
        
        return cell;
    }
    else{
    
        PersonTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"PersonTableViewCell"];
        cell.backgroundColor=[UIColor clearColor];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = RGBACOLOR(77, 77, 77, 1);
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.layer.masksToBounds=YES;
        cell.layer.cornerRadius=5;
        cell.layer.borderWidth=1;
        cell.layer.borderColor=RGBCOLOR(32, 183, 238).CGColor;
        
        [cell.nameLab setText:[NSString stringWithFormat:@"%@",model.name]];
        [cell.dutyLab setText:[NSString stringWithFormat:@"%@",model.duty]];
        [cell.comany setText:[NSString stringWithFormat:@"%@",model.company]];
        [cell.otherLab setText:[NSString stringWithFormat:@"%@",model.other]];
        NSString *fax;
            NSString *pho=[model.phone substringWithRange:NSMakeRange(3,11)];
        if (model.fax.length>10) {
            fax=[model.fax substringWithRange:NSMakeRange(3,12)];

        }else{
            fax=[model.fax substringFromIndex:3];

        }
        NSLog(@"%@,%@",pho,fax);
        [cell.phoneLab setTitle:pho forState:UIControlStateNormal];
        [cell.faxLab setTitle:fax forState:UIControlStateNormal];
        
        [cell setMessageAction:^(){
            NSLog(@"message");
            [self showMessageView:pho];

        }];
        [cell setPhoneAction:^(){
            NSLog(@"call phone");
            [self makeCall:pho];

        }];
        [cell setFaxAction:^(){
            NSLog(@"call fax");
            [self makeCall:fax];

        }];
        
        return cell;
    }
    
    


}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 240;
}


- (void)createButton{
    _btn0=[CityButton buttonWithType:UIButtonTypeCustom];
    _btn0.frame=CGRectMake(1, 65+((SCREEN_HEIGHT-64-14)/13.00+1)*0, ((SCREEN_HEIGHT-64-14)/13.00)*2.0, (SCREEN_HEIGHT-64-14)/13.00);
    [_btn0 setTitle:_cityArray[0] forState:UIControlStateNormal];
    [_btn0 addTarget:self action:@selector(selectCity:) forControlEvents:UIControlEventTouchUpInside];
    _btn0.layer.borderColor=[UIColor clearColor].CGColor;
    _btn0.backgroundColor=[UIColor whiteColor];
    _btn0.enabled=NO;
    [self.view addSubview:_btn0];
    
    _btn1=[CityButton buttonWithType:UIButtonTypeCustom];
    _btn1.frame=CGRectMake(1, 65+((SCREEN_HEIGHT-64-14)/13.00+1)*1, ((SCREEN_HEIGHT-64-14)/13.00)*2.0, (SCREEN_HEIGHT-64-14)/13.00);
    [_btn1 setTitle:_cityArray[1] forState:UIControlStateNormal];
    [_btn1 addTarget:self action:@selector(selectCity:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btn1];
    
    _btn2=[CityButton buttonWithType:UIButtonTypeCustom];
    _btn2.frame=CGRectMake(1, 65+((SCREEN_HEIGHT-64-14)/13.00+1)*2, ((SCREEN_HEIGHT-64-14)/13.00)*2.0, (SCREEN_HEIGHT-64-14)/13.00);
    [_btn2 setTitle:_cityArray[2] forState:UIControlStateNormal];
    [_btn2 addTarget:self action:@selector(selectCity:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btn2];
    
    _btn3=[CityButton buttonWithType:UIButtonTypeCustom];
    _btn3.frame=CGRectMake(1, 65+((SCREEN_HEIGHT-64-14)/13.00+1)*3, ((SCREEN_HEIGHT-64-14)/13.00)*2.0, (SCREEN_HEIGHT-64-14)/13.00);
    [_btn3 setTitle:_cityArray[3] forState:UIControlStateNormal];
    [_btn3 addTarget:self action:@selector(selectCity:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btn3];
    
    _btn4=[CityButton buttonWithType:UIButtonTypeCustom];
    _btn4.frame=CGRectMake(1, 65+((SCREEN_HEIGHT-64-14)/13.00+1)*4, ((SCREEN_HEIGHT-64-14)/13.00)*2.0, (SCREEN_HEIGHT-64-14)/13.00);
    [_btn4 setTitle:_cityArray[4] forState:UIControlStateNormal];
    [_btn4 addTarget:self action:@selector(selectCity:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btn4];
    
    _btn5=[CityButton buttonWithType:UIButtonTypeCustom];
    _btn5.frame=CGRectMake(1, 65+((SCREEN_HEIGHT-64-14)/13.00+1)*5, ((SCREEN_HEIGHT-64-14)/13.00)*2.0, (SCREEN_HEIGHT-64-14)/13.00);
    [_btn5 setTitle:_cityArray[5] forState:UIControlStateNormal];
    [_btn5 addTarget:self action:@selector(selectCity:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btn5];
    
    _btn6=[CityButton buttonWithType:UIButtonTypeCustom];
    _btn6.frame=CGRectMake(1, 65+((SCREEN_HEIGHT-64-14)/13.00+1)*6, ((SCREEN_HEIGHT-64-14)/13.00)*2.0, (SCREEN_HEIGHT-64-14)/13.00);
    [_btn6 setTitle:_cityArray[6] forState:UIControlStateNormal];
    [_btn6 addTarget:self action:@selector(selectCity:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btn6];
    
    _btn7=[CityButton buttonWithType:UIButtonTypeCustom];
    _btn7.frame=CGRectMake(1, 65+((SCREEN_HEIGHT-64-14)/13.00+1)*7, ((SCREEN_HEIGHT-64-14)/13.00)*2.0, (SCREEN_HEIGHT-64-14)/13.00);
    [_btn7 setTitle:_cityArray[7] forState:UIControlStateNormal];
    [_btn7 addTarget:self action:@selector(selectCity:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btn7];
    
    _btn8=[CityButton buttonWithType:UIButtonTypeCustom];
    _btn8.frame=CGRectMake(1, 65+((SCREEN_HEIGHT-64-14)/13.00+1)*8, ((SCREEN_HEIGHT-64-14)/13.00)*2.0, (SCREEN_HEIGHT-64-14)/13.00);
    [_btn8 setTitle:_cityArray[8] forState:UIControlStateNormal];
    [_btn8 addTarget:self action:@selector(selectCity:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btn8];
    
    _btn9=[CityButton buttonWithType:UIButtonTypeCustom];
    _btn9.frame=CGRectMake(1, 65+((SCREEN_HEIGHT-64-14)/13.00+1)*9, ((SCREEN_HEIGHT-64-14)/13.00)*2.0, (SCREEN_HEIGHT-64-14)/13.00);
    [_btn9 setTitle:_cityArray[9] forState:UIControlStateNormal];
    [_btn9 addTarget:self action:@selector(selectCity:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btn9];
    
    _btn10=[CityButton buttonWithType:UIButtonTypeCustom];
    _btn10.frame=CGRectMake(1, 65+((SCREEN_HEIGHT-64-14)/13.00+1)*10, ((SCREEN_HEIGHT-64-14)/13.00)*2.0, (SCREEN_HEIGHT-64-14)/13.00);
    [_btn10 setTitle:_cityArray[10] forState:UIControlStateNormal];
    [_btn10 addTarget:self action:@selector(selectCity:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btn10];
    
    _btn11=[CityButton buttonWithType:UIButtonTypeCustom];
    _btn11.frame=CGRectMake(1, 65+((SCREEN_HEIGHT-64-14)/13.00+1)*11, ((SCREEN_HEIGHT-64-14)/13.00)*2.0, (SCREEN_HEIGHT-64-14)/13.00);
    [_btn11 setTitle:_cityArray[11] forState:UIControlStateNormal];
    [_btn11 addTarget:self action:@selector(selectCity:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btn11];
    
    
    _btn12=[CityButton buttonWithType:UIButtonTypeCustom];
    _btn12.frame=CGRectMake(1, 65+((SCREEN_HEIGHT-64-14)/13.00+1)*12, ((SCREEN_HEIGHT-64-14)/13.00)*2.0, (SCREEN_HEIGHT-64-14)/13.00);
    [_btn12 setTitle:_cityArray[12] forState:UIControlStateNormal];
    [_btn12 addTarget:self action:@selector(selectCity:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btn12];
    

}
- (void)selectCity:(UIButton *)btn{
    [self resetButton];
    if (btn==_btn0) {
        _btn0.enabled=NO;
        _btn0.layer.borderColor=[UIColor clearColor].CGColor;
        _btn0.backgroundColor=[UIColor whiteColor];
        [self getPersonInfor:_cityArray[0]];
    }
    if (btn==_btn1) {
        _btn1.enabled=NO;
        _btn1.layer.borderColor=[UIColor clearColor].CGColor;
        _btn1.backgroundColor=[UIColor whiteColor];
        [self getPersonInfor:_cityArray[1]];
    }
    if (btn==_btn2) {
        _btn2.enabled=NO;
        _btn2.layer.borderColor=[UIColor clearColor].CGColor;
        _btn2.backgroundColor=[UIColor whiteColor];
        [self getPersonInfor:_cityArray[2]];
    }
    if (btn==_btn3) {
        _btn3.enabled=NO;
        _btn3.layer.borderColor=[UIColor clearColor].CGColor;
        _btn3.backgroundColor=[UIColor whiteColor];
        [self getPersonInfor:_cityArray[3]];
    }
    if (btn==_btn4) {
        _btn4.enabled=NO;
        _btn4.layer.borderColor=[UIColor clearColor].CGColor;
        _btn4.backgroundColor=[UIColor whiteColor];
        [self getPersonInfor:_cityArray[4]];
    }
    if (btn==_btn5) {
        _btn5.enabled=NO;
        _btn5.layer.borderColor=[UIColor clearColor].CGColor;
        _btn5.backgroundColor=[UIColor whiteColor];
        [self getPersonInfor:_cityArray[5]];
    }
    if (btn==_btn6) {
        _btn6.enabled=NO;
        _btn6.layer.borderColor=[UIColor clearColor].CGColor;
        _btn6.backgroundColor=[UIColor whiteColor];
        [self getPersonInfor:_cityArray[6]];
    }
    if (btn==_btn7) {
        _btn7.enabled=NO;
        _btn7.layer.borderColor=[UIColor clearColor].CGColor;
        _btn7.backgroundColor=[UIColor whiteColor];
        [self getPersonInfor:_cityArray[7]];
    }
    if (btn==_btn8) {
        _btn8.enabled=NO;
        _btn8.layer.borderColor=[UIColor clearColor].CGColor;
        _btn8.backgroundColor=[UIColor whiteColor];
        [self getPersonInfor:_cityArray[8]];
    }
    if (btn==_btn9) {
        _btn9.enabled=NO;
        _btn9.layer.borderColor=[UIColor clearColor].CGColor;
        _btn9.backgroundColor=[UIColor whiteColor];
        [self getPersonInfor:_cityArray[9]];
    }
    if                                                                                                                                                                                                                           (btn==_btn10) {
        _btn10.enabled=NO;
        _btn10.layer.borderColor=[UIColor clearColor].CGColor;
        _btn10.backgroundColor=[UIColor whiteColor];
        [self getPersonInfor:_cityArray[10]];
    }
    if (btn==_btn11) {
        _btn11.enabled=NO;
        _btn11.layer.borderColor=[UIColor clearColor].CGColor;
        _btn11.backgroundColor=[UIColor whiteColor];
        [self getPersonInfor:_cityArray[11]];
    }
    if (btn==_btn12) {
        _btn12.enabled=NO;
        _btn12.layer.borderColor=[UIColor clearColor].CGColor;
        _btn12.backgroundColor=[UIColor whiteColor];
        [self getPersonInfor:_cityArray[12]];
    }
    _tableView.contentOffset=CGPointMake(0, 0);

}

- (void)resetButton{
    _btn0.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _btn0.backgroundColor=RGBCOLOR(243, 244, 246);
    _btn0.enabled=YES;
    
    _btn1.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _btn1.backgroundColor=RGBCOLOR(243, 244, 246);
    _btn1.enabled=YES;

    _btn2.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _btn2.backgroundColor=RGBCOLOR(243, 244, 246);
    _btn2.enabled=YES;

    _btn3.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _btn3.backgroundColor=RGBCOLOR(243, 244, 246);
    _btn3.enabled=YES;

    _btn4.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _btn4.backgroundColor=RGBCOLOR(243, 244, 246);
    _btn4.enabled=YES;

    _btn5.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _btn5.backgroundColor=RGBCOLOR(243, 244, 246);
    _btn5.enabled=YES;

    _btn6.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _btn6.backgroundColor=RGBCOLOR(243, 244, 246);
    _btn6.enabled=YES;

    _btn7.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _btn7.backgroundColor=RGBCOLOR(243, 244, 246);
    _btn7.enabled=YES;

    _btn8.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _btn8.backgroundColor=RGBCOLOR(243, 244, 246);
    _btn8.enabled=YES;

    _btn9.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _btn9.backgroundColor=RGBCOLOR(243, 244, 246);
    _btn9.enabled=YES;

    _btn10.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _btn10.backgroundColor=RGBCOLOR(243, 244, 246);
    _btn10.enabled=YES;

    
    _btn11.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _btn11.backgroundColor=RGBCOLOR(243, 244, 246);
    _btn11.enabled=YES;

    _btn12.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _btn12.backgroundColor=RGBCOLOR(243, 244, 246);
    _btn12.enabled=YES;

}


- (void)showMessageView:(NSString *)num{
    if( [MFMessageComposeViewController canSendText] )
    {
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init]; //autorelease];
        controller.recipients = [NSArray arrayWithObject:num];
        controller.body = @"";
        controller.messageComposeDelegate = self;
 
        [self presentModalViewController:controller animated:YES];
        //[[[[controller viewControllers] lastObject] navigationItem] setTitle:@""];//修改短信界面标题
    }
    else
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示信息" message:@"该设备不支持短信功能" preferredStyle:  UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alert animated:true completion:nil];
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    [controller dismissModalViewControllerAnimated:NO];//关键的一句   不能为YES
    switch ( result ) {
        case MessageComposeResultCancelled:
        {
            //click cancel button
        }
            break;
        case MessageComposeResultFailed:// send failed
            
            break;
        case MessageComposeResultSent:
        {
            
            //do something
        }
            break;
        default:
            break;
    }
    
}


- (void)makeCall:(NSString *)num{
    NSString *allString = [NSString stringWithFormat:@"tel://%@",num];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:allString]];
}
















#pragma Mark ShowImage Part
- (void)createScrollView{

    _scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _scrollerView.directionalLockEnabled = YES; //只能一个方向滑动
    _scrollerView.pagingEnabled = NO; //是否翻页
     _scrollerView.backgroundColor = [UIColor clearColor];
    _scrollerView.showsVerticalScrollIndicator =NO; //垂直方向的滚动指示
    _scrollerView.showsHorizontalScrollIndicator =NO; //垂直方向的滚动指示
    _scrollerView.bounces = YES;
    _scrollerView.delegate = self;
    _scrollerView.contentSize = CGSizeMake(0, 10+(15+(SCREEN_WIDTH-30)/2*1.7)*4);
    [self.view addSubview:_scrollerView];
    
    for (int i=0; i<8; i++) {
        UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(10+((SCREEN_WIDTH-30)/2+10)*(i%2), 10+(15+(SCREEN_WIDTH-30)/2*1.7)*(i/2), (SCREEN_WIDTH-30)/2, ((SCREEN_WIDTH-30)/2)*1.7)];
        bgView.backgroundColor=RGBACOLOR(95, 185, 225, 1);
       // bgView.layer.masksToBounds=YES;
        bgView.layer.cornerRadius=10;
        bgView.layer.shadowColor=RGBACOLOR(72, 172, 148, 1).CGColor;
        bgView.layer.shadowOffset=CGSizeMake(8, 10);
        bgView.layer.shadowOpacity=0.7;
        bgView.layer.shadowRadius=3;
        [_scrollerView addSubview:bgView];
        
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, (SCREEN_WIDTH-30)/2-20, (SCREEN_WIDTH-30)/2*1.7-20)];
        [imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"d%d",i+1]]];
        [bgView addSubview:imageView];
        imageView.tag=i+1;
        imageView.userInteractionEnabled = YES;//打开用户交互
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCategory:)]];

    }
    
    _ScanView.frame=CGRectMake(SCREEN_WIDTH-10, SCREEN_HEIGHT, 1, 1);
    [self.view addSubview:_ScanView];
    
    
    
    _scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0, 1,1)];
    [_ScanView addSubview:_scroll];
    
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 1,1)];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_scroll addSubview:_imageView];
    _scroll.layer.masksToBounds=YES;
    _scroll.layer.cornerRadius=8;
    _scroll.contentSize = _imageView.frame.size;
    _scroll.showsVerticalScrollIndicator=NO;
    _scroll.showsHorizontalScrollIndicator=NO;
    _scroll.delegate = self;
    _scroll.minimumZoomScale = 1;
    _scroll.maximumZoomScale = 4;
    
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGesture:)];
    tapGesture.numberOfTapsRequired=2;
    [_scroll addGestureRecognizer:tapGesture];
}
-(void)handleTapGesture:(UIGestureRecognizer*)sender{
    if(_scroll.zoomScale > 1.0){
        
        [_scroll setZoomScale:1.0 animated:YES];
    }else{
        [_scroll setZoomScale:4.0 animated:YES];
    }
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
  return _imageView;
}
- (IBAction)closeView:(id)sender {
    
    
    CGRect frame=  CGRectMake(SCREEN_WIDTH-10, SCREEN_HEIGHT, 1, 1);
    CGRect frame2=  CGRectMake(0, 0, 1, 1);
    [UIView animateWithDuration:0.3 animations:^{
        
        _ScanView.frame=frame;
        _scroll.frame=frame2;
        _imageView.frame=frame2;
    }completion:^(BOOL finished) {
        
        
    }];
}
-(void)clickCategory:(UITapGestureRecognizer *)gestureRecognizer{
    UIView *viewClicked=[gestureRecognizer view];
    NSString *str;
    if (viewClicked.tag==1) {
        str=@"d1";
    }
    if (viewClicked.tag==2) {
        str=@"d2";
    }
    if (viewClicked.tag==3) {
        str=@"d3";
    }
    if (viewClicked.tag==4) {
        str=@"d4";
    }
    if (viewClicked.tag==5) {
        str=@"d5";
    }
    if (viewClicked.tag==6) {
        str=@"d6";
    }
    if (viewClicked.tag==7) {
        str=@"d7";
    }
    if (viewClicked.tag==8) {
        str=@"d8";
    }
    CGRect frame=  CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    CGRect frame2=  CGRectMake(10, 40, SCREEN_WIDTH-20, SCREEN_HEIGHT-114);
    CGRect frame3=  CGRectMake(0, 0, SCREEN_WIDTH-20, SCREEN_HEIGHT-114);
    [_imageView setImage:[UIImage imageNamed:str]];

    [UIView animateWithDuration:0.3 animations:^{
        
        _ScanView.frame=frame;
        _scroll.frame=frame2;
        _imageView.frame=frame3;
    
    }completion:^(BOOL finished) {
        _ScanView.backgroundColor=RGBACOLOR(1, 1, 1, 0.6);
        
    }];
}
- (void)imageClose {
    CGRect frame=  CGRectMake(SCREEN_WIDTH-10, SCREEN_HEIGHT, 1, 1);
    [UIView animateWithDuration:0.3 animations:^{
        
        _ScanView.frame=frame;
    }completion:^(BOOL finished) {
        _ScanView.backgroundColor=RGBACOLOR(1, 1, 1, 0);

        
    }];
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
