//
//  MainViewController.m
//  GamePad4US
//
//  Created by 朱 俊健 on 13-12-5.
//  Copyright (c) 2013年 朱 俊健. All rights reserved.
//

#import "MainViewController.h"
#import "NfsViewController.h"


@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        mainNetWork = [[NetWork alloc] init];
        [mainNetWork start];
        
        
//        nfsVC = [[NfsViewController alloc] init];
//        nfsVC.nfsNetWork = mainNetWork;
        //禁止锁屏
        [[UIApplication sharedApplication] setIdleTimerDisabled: YES];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //load backgound pic
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.jpg"]]];
    
    //init ace button..
    UIImage * aceImg = [UIImage imageNamed:@"main_ace.png"];
    UIImage * aceHLImg = [UIImage imageNamed:@"main_ace_HL.png"];
    aceBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [aceBtn setBackgroundImage:aceImg forState:UIControlStateNormal];
    [aceBtn setBackgroundImage:aceHLImg forState:UIControlStateHighlighted];
    aceBtn.frame = CGRectMake(MAIN_ACE_X, MAIN_ACE_Y, aceImg.size.width, aceHLImg.size.height);
    [self.view addSubview:aceBtn];
    [aceBtn addTarget:self action:@selector(onPressAceBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    //init hawx button..
    UIImage * hawxImg = [UIImage imageNamed:@"main_hawx.png"];
    UIImage * hawxHLImg = [UIImage imageNamed:@"main_hawx_HL.png"];
    hawxBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [hawxBtn setBackgroundImage:hawxImg forState:UIControlStateNormal];
    [hawxBtn setBackgroundImage:hawxHLImg forState:UIControlStateHighlighted];
    hawxBtn.frame = CGRectMake(MAIN_HAWX_X, MAIN_HAWX_Y, hawxImg.size.width, hawxImg.size.height);
    [self.view addSubview:hawxBtn];
    [hawxBtn addTarget:self action:@selector(onPressHawxBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    //init nfs button..
    UIImage * nfsImg = [UIImage imageNamed:@"main_nfs.png"];
    UIImage * nfsHLImg = [UIImage imageNamed:@"main_nfs_HL.png"];
    nfsBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [nfsBtn setBackgroundImage:nfsImg forState:UIControlStateNormal];
    [nfsBtn setBackgroundImage:nfsHLImg forState:UIControlStateHighlighted];
    nfsBtn.frame = CGRectMake(MAIN_NFS_X, MAIN_NFS_Y, nfsImg.size.width, nfsImg.size.height);
    [self.view addSubview:nfsBtn];
    [nfsBtn addTarget:self action:@selector(onPressNfsBtn:) forControlEvents:UIControlEventTouchUpInside];
    
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


#pragma mark - btn events

- (IBAction)onPressNfsBtn:(id)sender
{
    nfsVC = [[NfsViewController alloc] init];
    nfsVC.nfsNetWork = mainNetWork;
//    NfsViewController * nfsVC = [[NfsViewController alloc] init];
    if (nfsVC.nfsNetWork.connectState != STATE_CONNECT_ESTABLISHED) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示~"message:@"网络还没连接上哈，看看PC端把~" delegate:self cancelButtonTitle:@"Ok"otherButtonTitles:nil, nil];
        [alert show];
    }
    else{
        nfsVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:nfsVC animated:YES completion:^(void){
            
        }];
    }

    NSLog(@"press nfs btn");
}

- (IBAction)onPressAceBtn:(id)sender
{
    
}

- (IBAction)onPressHawxBtn:(id)sender
{
    
}

@end
