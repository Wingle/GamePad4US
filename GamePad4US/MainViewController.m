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
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //load backgound pic
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.jpg"]]];
    
    aceBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [aceBtn setBackgroundImage:[UIImage imageNamed:@"main_ace.png"] forState:UIControlStateNormal];
    [aceBtn setBackgroundImage:[UIImage imageNamed:@"main_ace_HL.png"] forState:UIControlStateHighlighted];
    aceBtn.frame = MAIN_ACE_BTN;
    [self.view addSubview:aceBtn];
    
    hawxBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [hawxBtn setBackgroundImage:[UIImage imageNamed:@"main_hawx.png"] forState:UIControlStateNormal];
    [hawxBtn setBackgroundImage:[UIImage imageNamed:@"main_hawx_HL.png"] forState:UIControlStateHighlighted];
    hawxBtn.frame = MAIN_HAWX_BTN;
    [self.view addSubview:hawxBtn];
    
    nfsBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [nfsBtn setBackgroundImage:[UIImage imageNamed:@"main_nfs.png"] forState:UIControlStateNormal];
    [nfsBtn setBackgroundImage:[UIImage imageNamed:@"main_nfs_HL.png"] forState:UIControlStateHighlighted];
    nfsBtn.frame = MAIN_NFS_BTN;
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
    NfsViewController * nfsVC = [[NfsViewController alloc] init];
    nfsVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:nfsVC animated:YES completion:^(void){
        
    }];
    
    
    NSLog(@"press nfs btn");
}



@end
