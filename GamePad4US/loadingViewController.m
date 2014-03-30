//
//  loadingViewController.m
//  GamePad4US
//
//  Created by 朱 俊健 on 14-2-28.
//  Copyright (c) 2014年 朱 俊健. All rights reserved.
//

#import "loadingViewController.h"
#import "MainViewController.h"

@interface loadingViewController ()

@end

@implementation loadingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[UIApplication sharedApplication] setIdleTimerDisabled: YES];
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"loading_background.png"]]];
    
    UIImage * logoImg = [UIImage imageNamed:@"loading_logo.png"];
    UIImageView * logoImgView = [[UIImageView alloc] initWithImage:logoImg];
    logoImgView.frame = CGRectMake(150, 80, logoImg.size.width, logoImg.size.height);
    logoImgView.alpha = 0.6;
    [self.view addSubview:logoImgView];
    
    [UIView animateWithDuration:2 animations:^{
        logoImgView.alpha = 1;
    }];
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstStart"]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStart"];
        NSTimer * guideTimer;
        guideTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(beginGuide:) userInfo:nil repeats:NO];
    }else{
        
        NSTimer * guideTimer;
        guideTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(onPressStartBtn:) userInfo:nil repeats:NO];
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//保持横排方向
-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscapeLeft;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

//隐藏StateBar
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - nstimer selector

- (IBAction)beginGuide:(id)sender
{
    UIImage * backgroundImg = [UIImage imageNamed:@"loading_background.png"];
    UIImageView * backgroundImgView = [[UIImageView alloc] initWithImage:backgroundImg];
    backgroundImgView.frame = CGRectMake(568, 0, backgroundImg.size.width, backgroundImg.size.height);
    UIImage * guide1Img = [UIImage imageNamed:@"loading_guide_1.png"];
    UIImageView * guide1ImgView = [[UIImageView alloc] initWithImage:guide1Img];
    UIScrollView * guideScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(568, 0, 568, 320)];
    [self.view addSubview:backgroundImgView];
    [guideScrollView addSubview:guide1ImgView];
    [self.view addSubview:guideScrollView];
    
    UIImage * guide2Img = [UIImage imageNamed:@"loading_guide_2.png"];
    UIImageView * guide2ImgView = [[UIImageView alloc] initWithImage:guide2Img];
    guide2ImgView.frame = CGRectMake(568, 0, 568, 320);
    [guideScrollView addSubview:guide2ImgView];
    
    UIImage * guide3Img = [UIImage imageNamed:@"loading_guide_3.png"];
    UIImageView * guide3ImgView = [[UIImageView alloc] initWithImage:guide3Img];
    guide3ImgView.frame = CGRectMake(568 * 2, 0, 568, 320);
    [guideScrollView addSubview:guide3ImgView];
    
    UIButton * startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage * start1Img = [UIImage imageNamed:@"loading_start_1.png"];
    UIImage * start2Img = [UIImage imageNamed:@"loading_start_2.png"];
    [startBtn setImage:start1Img forState:UIControlStateNormal];
    [startBtn setImage:start2Img forState:UIControlStateHighlighted];
    startBtn.frame = CGRectMake(237, 243, start1Img.size.width, start1Img.size.height);
    [guide3ImgView addSubview:startBtn];
    [guide3ImgView setUserInteractionEnabled:YES];
    
    [startBtn addTarget:self action:@selector(onPressStartBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    guideScrollView.contentSize = CGSizeMake(568 * 3, 320);
    
    guideScrollView.pagingEnabled = YES;
    [guideScrollView setShowsVerticalScrollIndicator:NO];
    
    [UIView animateWithDuration:1 animations:^(void){
        backgroundImgView.frame = CGRectMake(0, 0, backgroundImg.size.width, backgroundImg.size.height);
        guideScrollView.frame = CGRectMake(0, 0, 568, 320);
    }];
}

- (IBAction)onPressStartBtn:(id)sender
{
    MainViewController * mainVC = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    [self presentViewController:mainVC animated:YES completion:^(void){
        
    }];
}

@end
