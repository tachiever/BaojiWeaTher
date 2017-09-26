//
//  RadarViewController.m
//  BaojiWeather
//
//  Created by Tcy on 2017/3/17.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import "RadarViewController.h"

@interface RadarViewController ()<UIScrollViewDelegate>
@property (nonatomic,strong)UIScrollView * scrollView;
@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic,strong)NSMutableArray *radaimageArray;
@property (nonatomic,strong)NSMutableArray *radasimageArray;
@property (nonatomic,strong)NSMutableArray *radaListArray;
@property (nonatomic,strong)NSMutableArray *radasListArray;
@property (nonatomic,strong)NSString *model;
@property ( nonatomic) UILabel *titleLab;
@property ( nonatomic) UIButton *changeBtn;
@property ( nonatomic)  UILabel *dateLab;
@property ( nonatomic)  UIView *bgview;

@property (nonatomic)UIView *proView;
@property (nonatomic)BOOL isPlay;
@property (nonatomic)BOOL isZuhe;
@property (nonatomic)BOOL isDownImage;
@property ( nonatomic) UILabel *lab1;
@property ( nonatomic) UILabel *lab2;
@property ( nonatomic) UILabel *lab3;
@property ( nonatomic) UILabel *lab4;
@property ( nonatomic) UILabel *lab5;
@property ( nonatomic) UILabel *lab6;
@property ( nonatomic) NSInteger n;
@property ( nonatomic) NSTimer *timer;
@property ( nonatomic) UIButton *playBtn;


@end


@implementation RadarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    _titleLab.text=self.titleStr;
    _isZuhe=NO;
    _isPlay=NO;
    _isDownImage=NO;
    _n=5;
    _radaListArray=[[NSMutableArray alloc]init];
    _radasListArray=[[NSMutableArray alloc]init];
    _radaimageArray=[[NSMutableArray alloc]init];
    _radasimageArray=[[NSMutableArray alloc]init];
    [self createImageView];
    [self createDownView];
    [self createHeaderView];
    
    [self getImageListForRada];
    [self getImageListForRadas];



}
- (void)getImageListForRada{
    
    [NBRequest requestWithURL:RadarImageList type:RequestRefresh success:^(NSData *requestData) {
         NSArray *array = [NSJSONSerialization JSONObjectWithData:requestData options:NSJSONReadingMutableContainers error:nil];
        [_radaListArray removeAllObjects];
        
        
        if (array.count>0) {
            for (NSDictionary *dic in array) {
                [_radaListArray addObject:dic[@"imgpathname"]];
            }
            _radaListArray = (NSMutableArray *)[[_radaListArray reverseObjectEnumerator] allObjects];
            
            
            [self updateDownLab:[self strChangeDate:_radaListArray]];
            _dateLab.text=[NSString stringWithFormat:@"%@",[self strChangeDate:_radaListArray][5]];
            
            
            
          //  [self getRadaImages:_radaListArray];
            
            
            [self getImageWithArr:_radaListArray];

        }else{
            
            [SVProgressHUD showErrorWithStatus:@"数据出错！"];
        }

    } failed:^(NSError *error) {
        
    }];
    
    
}
- (void)getImageListForRadas{
    [NBRequest requestWithURL:RadarsImageList type:RequestRefresh success:^(NSData *requestData) {
        [_radasListArray removeAllObjects];

         NSArray *array = [NSJSONSerialization JSONObjectWithData:requestData options:NSJSONReadingMutableContainers error:nil];
        
        if (array.count>0) {
            for (NSDictionary *dic in array) {
                [_radasListArray addObject:dic[@"imgpathname"]];
            }
            _radasListArray = (NSMutableArray *)[[_radasListArray reverseObjectEnumerator] allObjects];
            
            
            
            //  [self getRadasImages:_radasListArray];
            [self getImagesWithArr:_radasListArray];
            
            
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:@"数据出错！"];
        }
    } failed:^(NSError *error) {
        
    }];
}

- (void)getImageWithArr:(NSMutableArray *)radasImage{
    [_radaimageArray removeAllObjects];
    NSString *urlStr=[NSString stringWithFormat:RadarImage,radasImage[5]];
    [NBRequest requestWithURL:urlStr type:RequestRefresh success:^(NSData *requestData) {
        UIImage *radarImage = [UIImage imageWithData:requestData];
        [_radaimageArray addObject:radarImage];
        
        [_imageView setImage:radarImage];

        
    } failed:^(NSError *error) {
        
    }];



}

- (void)getImagesWithArr:(NSMutableArray *)radasImage{
    
    [_radasimageArray removeAllObjects];
    NSString *urlStr=[NSString stringWithFormat:RadarsImage,radasImage[5]];
    [NBRequest requestWithURL:urlStr type:RequestRefresh success:^(NSData *requestData) {
        UIImage *radarImage = [UIImage imageWithData:requestData];
        [_radasimageArray addObject:radarImage];
        
    } failed:^(NSError *error) {
        
    }];
    
    
    
}



- (void)getRadaImages:(NSArray *)Arr{
    
    [SVProgressHUD showWithStatus:@"雷达图加载中..."];

    [_radaimageArray removeAllObjects];
    
        NSString *urlStr=[NSString stringWithFormat:RadarImage,Arr[0]];
        [NBRequest requestWithURL:urlStr type:RequestRefresh success:^(NSData *requestData) {
            UIImage *radarImage = [UIImage imageWithData:requestData];
            [_radaimageArray addObject:radarImage];
            
            NSString *urlStr=[NSString stringWithFormat:RadarImage,Arr[1]];
            [NBRequest requestWithURL:urlStr type:RequestRefresh success:^(NSData *requestData) {
                UIImage *radarImage = [UIImage imageWithData:requestData];
                [_radaimageArray addObject:radarImage];
                
                NSString *urlStr=[NSString stringWithFormat:RadarImage,Arr[2]];
                [NBRequest requestWithURL:urlStr type:RequestRefresh success:^(NSData *requestData) {
                    UIImage *radarImage = [UIImage imageWithData:requestData];
                    [_radaimageArray addObject:radarImage];
                    
                    NSString *urlStr=[NSString stringWithFormat:RadarImage,Arr[3]];
                    [NBRequest requestWithURL:urlStr type:RequestRefresh success:^(NSData *requestData) {
                        UIImage *radarImage = [UIImage imageWithData:requestData];
                        [_radaimageArray addObject:radarImage];
                        
                        NSString *urlStr=[NSString stringWithFormat:RadarImage,Arr[4]];
                        [NBRequest requestWithURL:urlStr type:RequestRefresh success:^(NSData *requestData) {
                            UIImage *radarImage = [UIImage imageWithData:requestData];
                            [_radaimageArray addObject:radarImage];
                            
                            NSString *urlStr=[NSString stringWithFormat:RadarImage,Arr[5]];
                            [NBRequest requestWithURL:urlStr type:RequestRefresh success:^(NSData *requestData) {
                                UIImage *radarImage = [UIImage imageWithData:requestData];
                                [_radaimageArray addObject:radarImage];
                                
                                [self getRadasImages:_radasListArray];
                                
                                
                            } failed:^(NSError *error) {
                                
                            }];
                        } failed:^(NSError *error) {
                            
                        }];
                    } failed:^(NSError *error) {
                        
                    }];
                } failed:^(NSError *error) {
                    
                }];
            } failed:^(NSError *error) {
                
            }];
        } failed:^(NSError *error) {
            
        }];
    
}

- (void)getRadasImages:(NSArray *)Arr{
    [_radasimageArray removeAllObjects];
    
        NSString *urlStr=[NSString stringWithFormat:RadarsImage,Arr[0]];
        [NBRequest requestWithURL:urlStr type:RequestRefresh success:^(NSData *requestData) {
            UIImage *radarImage = [UIImage imageWithData:requestData];
            [_radasimageArray addObject:radarImage];
            
            NSString *urlStr=[NSString stringWithFormat:RadarsImage,Arr[1]];
            [NBRequest requestWithURL:urlStr type:RequestRefresh success:^(NSData *requestData) {
                UIImage *radarImage = [UIImage imageWithData:requestData];
                [_radasimageArray addObject:radarImage];
                
                NSString *urlStr=[NSString stringWithFormat:RadarsImage,Arr[2]];
                [NBRequest requestWithURL:urlStr type:RequestRefresh success:^(NSData *requestData) {
                    UIImage *radarImage = [UIImage imageWithData:requestData];
                    [_radasimageArray addObject:radarImage];
                    
                    NSString *urlStr=[NSString stringWithFormat:RadarsImage,Arr[3]];
                    [NBRequest requestWithURL:urlStr type:RequestRefresh success:^(NSData *requestData) {
                        UIImage *radarImage = [UIImage imageWithData:requestData];
                        [_radasimageArray addObject:radarImage];
                        
                        NSString *urlStr=[NSString stringWithFormat:RadarsImage,Arr[4]];
                        [NBRequest requestWithURL:urlStr type:RequestRefresh success:^(NSData *requestData) {
                            UIImage *radarImage = [UIImage imageWithData:requestData];
                            [_radasimageArray addObject:radarImage];
                            
                            NSString *urlStr=[NSString stringWithFormat:RadarsImage,Arr[5]];
                            [NBRequest requestWithURL:urlStr type:RequestRefresh success:^(NSData *requestData) {
                                UIImage *radarImage = [UIImage imageWithData:requestData];
                                [_radasimageArray addObject:radarImage];
                                
                                [SVProgressHUD showSuccessWithStatus:@"加载成功"];
                                _isDownImage=YES;


                            } failed:^(NSError *error) {
                                
                            }];
                        } failed:^(NSError *error) {
                            
                        }];
                    } failed:^(NSError *error) {
                        
                    }];
                } failed:^(NSError *error) {
                    
                }];
            } failed:^(NSError *error) {
                
            }];
        } failed:^(NSError *error) {
            
        }];
}

- (void)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)changeModel:(UIButton *)sender {

        if (_isZuhe) {
        [sender setBackgroundImage:[UIImage imageNamed:@"btn_radars"] forState:UIControlStateNormal];
            _titleLab.text=@"组合反射率雷达图";

        if (_radaimageArray.count==0) {
            
            [self getImageListForRada];
        }
        if (_radaListArray.count>0) {
                [self updateDownLab:[self strChangeDate:_radaListArray]];

        }


    }else{
        _titleLab.text=@"基本速度雷达图";

        [sender setBackgroundImage:[UIImage imageNamed:@"btn_radar"] forState:UIControlStateNormal];
        if (_radasimageArray.count==0) {
            [self getImageListForRadas];
        }
        if (_radasListArray.count>0) {
            [self updateDownLab:[self strChangeDate:_radasListArray]];

        }

    }
    _isZuhe=!_isZuhe;
    _n=5;
    [_playBtn setBackgroundImage:[UIImage imageNamed:@"btn_start"] forState:UIControlStateNormal];
    [_timer invalidate];
    _timer = nil;
    _isPlay=NO;
    if (_radasListArray.count>0&&_radaListArray.count>0) {
            [self function];
    }

}

- (void)playAndStop:(UIButton *)btn{
    if (_radasListArray.count>0&&_radaListArray.count>0) {
        
        if (!_isDownImage) {

            [self getRadaImages:_radaListArray];

        }
        
        if (_isPlay) {
            [_playBtn setBackgroundImage:[UIImage imageNamed:@"btn_start"] forState:UIControlStateNormal];
            
            [_timer invalidate];
            _timer = nil;
            
            
        }else{
            
            [_playBtn setBackgroundImage:[UIImage imageNamed:@"btn_stop"] forState:UIControlStateNormal];
            
            
            if (_timer==nil) {
                _timer =  [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(function) userInfo:nil repeats:YES];
                
                
            }
        }
        _isPlay=!_isPlay;

    }
}

- (void)function{
    if (_isZuhe) {
        if (_isDownImage) {

        [_imageView setImage:_radasimageArray[_n]];
        }else{
            
            [_imageView setImage:_radasimageArray[0]];

        }
        _dateLab.text=[NSString stringWithFormat:@"%@",[self strChangeDate:_radasListArray][_n]];

    }else{
           if (_isDownImage) {
        [_imageView setImage:_radaimageArray[_n]];
           }else{
               [_imageView setImage:_radaimageArray[0]];

           }
        _dateLab.text=[NSString stringWithFormat:@"%@",[self strChangeDate:_radaListArray][_n]];

    }
    CGRect fram=CGRectMake(0, 29, SCREEN_WIDTH/6.000*(_n+1), 5);
    [UIView animateWithDuration:0.2 animations:^{
        _proView.frame=fram;
        
    }completion:^(BOOL finished) {
        
    }];
    _n++;
    if (_n>=6) {
        _n=0;
    }

}




- (void)updateDownLab:(NSArray *)arr{
    _lab1.text=[[NSString stringWithFormat:@"%@",arr[0]] substringFromIndex:12];
    _lab2.text=[[NSString stringWithFormat:@"%@",arr[1]] substringFromIndex:12];
    _lab3.text=[[NSString stringWithFormat:@"%@",arr[2]] substringFromIndex:12];
    _lab4.text=[[NSString stringWithFormat:@"%@",arr[3]] substringFromIndex:12];
    _lab5.text=[[NSString stringWithFormat:@"%@",arr[4]] substringFromIndex:12];
    _lab6.text=[[NSString stringWithFormat:@"%@",arr[5]] substringFromIndex:12];
}

- (NSArray *)strChangeDate:(NSArray *)arr{
    NSMutableArray *array=[[NSMutableArray alloc]init];
    for (int i=0; i<arr.count; i++) {
        NSString *str= [[NSString stringWithFormat:@"%@",arr[i]] substringToIndex:12];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyyMMddHHmm"];
        NSDate *date = [dateFormatter dateFromString:str];
        
        NSTimeInterval a_day = 8*60*60;
        NSDate *newDate = [date addTimeInterval: a_day];
        NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
        [dateFormatter2 setDateFormat:@"yyyy年MM月dd日 HH时mm分"];
        NSString *strDate = [dateFormatter2 stringFromDate:newDate];
        
        [array addObject:strDate];
    }
    return array;
}

- (void)createImageView{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,64,SCREEN_WIDTH,SCREEN_HEIGHT-128)];
    [self.view addSubview:_scrollView];
    
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH,SCREEN_HEIGHT-128)];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_scrollView addSubview:_imageView];
    
    _scrollView.contentSize = _imageView.frame.size;
    _scrollView.showsVerticalScrollIndicator=NO;
    _scrollView.showsHorizontalScrollIndicator=NO;
    _scrollView.delegate = self;
    _scrollView.minimumZoomScale = 1;
    _scrollView.maximumZoomScale = 4;
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGesture:)];
    tapGesture.numberOfTapsRequired=2;
    [_scrollView addGestureRecognizer:tapGesture];
}

- (void)createHeaderView{
    UIView *hview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    hview.backgroundColor=RGBACOLOR(20, 37, 83, 1);
    [self.view addSubview:hview];
    UIButton *bcBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 21, 75, 40)];
    [bcBtn setImage:[UIImage imageNamed:@"jiantou_left"] forState:UIControlStateNormal];
    [bcBtn setTitle:@" 返回" forState:UIControlStateNormal];
    [bcBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [hview addSubview:bcBtn];
    
    _titleLab=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-100, 25, 200, 26)];
    _titleLab.textAlignment=NSTextAlignmentCenter;
    _titleLab.textColor=[UIColor whiteColor];
    _titleLab.font=[UIFont systemFontOfSize:18];
    _titleLab.text=[NSString stringWithFormat:@"组合反射率雷达图"];
    [hview addSubview:_titleLab];
    _changeBtn=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-8-54, 30, 53, 26)];
    [_changeBtn setBackgroundImage:[UIImage imageNamed:@"btn_radars"] forState:UIControlStateNormal];
    [_changeBtn addTarget:self action:@selector(changeModel:) forControlEvents:UIControlEventTouchUpInside];
    [hview addSubview:_changeBtn];
    
    
    _playBtn=[[UIButton alloc]initWithFrame:CGRectMake(30,95, 40, 40)];
    [_playBtn setBackgroundImage:[UIImage imageNamed:@"btn_start"] forState:UIControlStateNormal];
    [_playBtn addTarget:self action:@selector(playAndStop:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_playBtn];
    
}

- (void)createDownView{
    _bgview =[[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-64, SCREEN_HEIGHT, 64)];
    _bgview.backgroundColor=[UIColor grayColor];
    [self.view addSubview:_bgview];
    
    
    _proView=[[UIView alloc]initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH/6.000*6, 4)];
    _proView.backgroundColor=RGBACOLOR(71, 173, 238, 1);
    
    [_bgview addSubview:_proView];
    UIView *bgView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, 30)];
    bgView.backgroundColor=[UIColor whiteColor];
    [_bgview addSubview:bgView];
    
    _dateLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 26)];
    _dateLab.textAlignment=NSTextAlignmentCenter;
    _dateLab.backgroundColor=RGBACOLOR(246, 246, 229, 1);
    _dateLab.font=[UIFont systemFontOfSize:14];
    [_bgview addSubview:_dateLab];
    
    
    
    _lab1=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/6.000*0, 34, SCREEN_WIDTH/6.000, 30)];
    _lab1.textAlignment=NSTextAlignmentCenter;
    _lab1.textColor=[UIColor grayColor];
    _lab1.backgroundColor=[UIColor whiteColor];
    _lab1.font=[UIFont systemFontOfSize:11];
    _lab1.text=[NSString stringWithFormat:@"09时52分"];
    [_bgview addSubview:_lab1];
    
    _lab2=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/6.000*1, 34, SCREEN_WIDTH/6.000, 30)];
    _lab2.textAlignment=NSTextAlignmentCenter;
    _lab2.textColor=[UIColor grayColor];
    _lab2.backgroundColor=[UIColor whiteColor];
    _lab2.font=[UIFont systemFontOfSize:11];
    _lab2.text=[NSString stringWithFormat:@"09时52分"];
    [_bgview addSubview:_lab2];
    
    _lab3=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/6.000*2, 34, SCREEN_WIDTH/6.000, 30)];
    _lab3.textAlignment=NSTextAlignmentCenter;
    _lab3.textColor=[UIColor grayColor];
    _lab3.backgroundColor=[UIColor whiteColor];
    _lab3.font=[UIFont systemFontOfSize:11];
    _lab3.text=[NSString stringWithFormat:@"09时52分"];
    [_bgview addSubview:_lab3];
    
    _lab4=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/6.000*3, 34, SCREEN_WIDTH/6.000, 30)];
    _lab4.textAlignment=NSTextAlignmentCenter;
    _lab4.textColor=[UIColor grayColor];
    _lab4.backgroundColor=[UIColor whiteColor];
    _lab4.font=[UIFont systemFontOfSize:11];
    _lab4.text=[NSString stringWithFormat:@"09时52分"];
    [_bgview addSubview:_lab4];
    
    _lab5=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/6.000*4, 34, SCREEN_WIDTH/6.000, 30)];
    _lab5.textAlignment=NSTextAlignmentCenter;
    _lab5.textColor=[UIColor grayColor];
    _lab5.backgroundColor=[UIColor whiteColor];
    _lab5.font=[UIFont systemFontOfSize:11];
    _lab5.text=[NSString stringWithFormat:@"09时52分"];
    [_bgview addSubview:_lab5];
    
    
    
    _lab6=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/6.000*5, 34, SCREEN_WIDTH/6.000, 30)];
    _lab6.textAlignment=NSTextAlignmentCenter;
    _lab6.textColor=[UIColor grayColor];
    _lab6.backgroundColor=[UIColor whiteColor];
    _lab6.font=[UIFont systemFontOfSize:11];
    _lab6.text=[NSString stringWithFormat:@"09时52分"];
    [_bgview addSubview:_lab6];
    
    
    
    
    
}

-(void)handleTapGesture:(UIGestureRecognizer*)sender{
    if(_scrollView.zoomScale > 1.0){
        [_scrollView setZoomScale:1.0 animated:YES];
    }else{
        [_scrollView setZoomScale:4.0 animated:YES];
    }
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}

-(void)viewWillAppear:(BOOL)animated{
    //开启定时器
    [_timer setFireDate:[NSDate distantPast]]; //很远的过去
}

//页面消失，进入后台不显示该页面，关闭定时器
-(void)viewWillDisappear:(BOOL)animated{
    [NBRequest cancleRequest];
    [SVProgressHUD dismiss];
    //关闭定时器
    [_timer setFireDate:[NSDate distantFuture]];  //很远的将来
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
