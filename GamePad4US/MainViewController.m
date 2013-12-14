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
        nfsVC = [[NfsViewController alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //load backgound pic
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.jpg"]]];
    
    //load ace button..
    UIImage * aceImg = [UIImage imageNamed:@"main_ace.png"];
    UIImage * aceHLImg = [UIImage imageNamed:@"main_ace_HL.png"];
    aceBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [aceBtn setBackgroundImage:aceImg forState:UIControlStateNormal];
    [aceBtn setBackgroundImage:aceHLImg forState:UIControlStateHighlighted];
    aceBtn.frame = CGRectMake(205, 88, aceImg.size.width, aceHLImg.size.height);
    [self.view addSubview:aceBtn];
    [aceBtn addTarget:self action:@selector(onPressAceBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage * hawxImg = [UIImage imageNamed:@"main_hawx.png"];
    UIImage * hawxHLImg = [UIImage imageNamed:@"main_hawx_HL.png"];
    hawxBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [hawxBtn setBackgroundImage:hawxImg forState:UIControlStateNormal];
    [hawxBtn setBackgroundImage:hawxHLImg forState:UIControlStateHighlighted];
    hawxBtn.frame = CGRectMake(375, 88, hawxImg.size.width, hawxImg.size.height);
    [self.view addSubview:hawxBtn];
    
    UIImage * nfsImg = [UIImage imageNamed:@"main_nfs.png"];
    UIImage * nfsHLImg = [UIImage imageNamed:@"main_nfs_HL.png"];
    nfsBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [nfsBtn setBackgroundImage:nfsImg forState:UIControlStateNormal];
    [nfsBtn setBackgroundImage:nfsHLImg forState:UIControlStateHighlighted];
    nfsBtn.frame = CGRectMake(35, 88, nfsImg.size.width, nfsImg.size.height);
    [self.view addSubview:nfsBtn];
    
    //add target to Btn
    [nfsBtn addTarget:self action:@selector(onPressNfsBtn:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - btn events

- (IBAction)onPressNfsBtn:(id)sender
{
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
    
//    NetWork * network = [[NetWork alloc] init];
//    [network start];
}



@end
