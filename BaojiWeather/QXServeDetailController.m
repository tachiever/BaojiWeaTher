//
//  QXServeDetailController.m
//  BaojiWeather
//
//  Created by Tcy on 2017/3/24.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import "QXServeDetailController.h"

@interface QXServeDetailController ()<UIScrollViewDelegate>{
    
    UIWebView *webView;
}
@property (nonatomic)UIScrollView *scroll;


@end

@implementation QXServeDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationController.navigationBarHidden=YES;

    [self createScrellow];
    [self downLoadData];
    
}
- (void)viewWillDisappear:(BOOL)animated{

    self.navigationController.navigationBarHidden=NO;

}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];

}
- (void)createScrellow{
    _scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0,64, SCREEN_WIDTH,SCREEN_HEIGHT-64)];
    [self.view addSubview:_scroll];
    
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    [_scroll addSubview:webView];
    _scroll.backgroundColor=[UIColor whiteColor];
    _scroll.contentSize = webView.frame.size;
    _scroll.showsVerticalScrollIndicator=NO;
    _scroll.showsHorizontalScrollIndicator=NO;
    _scroll.delegate = self;
    _scroll.minimumZoomScale = 1;
    _scroll.maximumZoomScale = 5;
    
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGesture:)];
    tapGesture.numberOfTapsRequired=2;
    [_scroll addGestureRecognizer:tapGesture];

}

-(void)handleTapGesture:(UIGestureRecognizer*)sender{
    if(_scroll.zoomScale > 1.0){
        
        [_scroll setZoomScale:1.0 animated:YES];
    }else{
        [_scroll setZoomScale:5.0 animated:YES];
    }
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return webView;
}

- (void)downLoadData{
    
        NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:PDFUrl,self.detailid]]];
       // [self.view addSubview: webView];
        [webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
