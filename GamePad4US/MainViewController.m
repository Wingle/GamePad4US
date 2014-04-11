//
//  MainViewController.m
//  GamePad4US
//
//  Created by 朱 俊健 on 13-12-5.
//  Copyright (c) 2013年 朱 俊健. All rights reserved.
//

#import "MainViewController.h"
#import "NfsViewController.h"
#import "AceViewController.h"
#import "HawxViewController.h"
#import "XBoxViewController.h"
#import <SystemConfiguration/CaptiveNetwork.h>



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
        
        //禁止锁屏
        [[UIApplication sharedApplication] setIdleTimerDisabled: YES];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //load backgound pic
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]]];
    
    //load topic image
    topicImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"topic.png"]];
    topicImgView.frame = CGRectMake(MAIN_TOPIC_X, MAIN_TOPIC_Y, topicImgView.image.size.width, topicImgView.image.size.height);
    [self.view addSubview:topicImgView];
    

    //init the Frames..
    theMainFrame[0] = CGRectMake(-402, 102, 265, 158);
    theMainFrame[1] = CGRectMake(-402, 102, 265, 158);
    theMainFrame[2] = CGRectMake(-132, 102, 265, 158);
    theMainFrame[3] = CGRectMake(136, 82, 295, 204);
    theMainFrame[4] = CGRectMake(435, 102, 265, 158);
    theMainFrame[5] = CGRectMake(704, 102, 265, 158);
    theMainFrame[6] = CGRectMake(704, 102, 265, 158);
    
    positionOfNfs = 2;
    positionOfAce = 3;
    positionOfXbox = 4;
    positionOfDescribe = 5;
    
    //init main btns, nfs/ace/xbox/describe
    [self initMainBtns];
    
    //init netTestBtn..
    UIImage * netTestBtnImg = [UIImage imageNamed:@"main_test_btn_normal.png"];
    UIImage * netTestBtnHLImg = [UIImage imageNamed:@"main_test_btn_normalHL.png"];
    netTestBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [netTestBtn setImage:netTestBtnImg forState:UIControlStateNormal];
    [netTestBtn setImage:netTestBtnHLImg forState:UIControlStateHighlighted];
    netTestBtn.frame = CGRectMake(12 - netTestBtnImg.size.width * 0.5, 20 - netTestBtnImg.size.height * 0.5, netTestBtnImg.size.width * 2, netTestBtnImg.size.height * 2);
    [self.view addSubview:netTestBtn];
    [netTestBtn addTarget:self action:@selector(onPressTestBtn:) forControlEvents:UIControlEventTouchUpInside]; 
    
    //init setting btn..
    
    //setting view
    UIImage * settingBackgroundImg = [UIImage imageNamed:@"main_setting_view_background.png"];
    UIImage * soundImg = [UIImage imageNamed:@"main_setting_sound.png"];
    UIImage * shockImg = [UIImage imageNamed:@"main_setting_noshock.png"];
    UIImage * soundBackgroundImg = [UIImage imageNamed:@"main_setting_sound_background.png"];
    UIImage * shockBackgroundImg = [UIImage imageNamed:@"main_setting_shock_background.png"];
    
    settingView = [[UIScrollView alloc] initWithFrame:CGRectMake(417, 20, settingBackgroundImg.size.width + 18, settingBackgroundImg.size.height)];
    [self.view addSubview:settingView];
    settingBackgroundImgView = [[UIImageView alloc] initWithImage:settingBackgroundImg];
    settingBackgroundImgView.frame = CGRectMake(settingBackgroundImg.size.width + 18, 0, settingBackgroundImg.size.width, settingBackgroundImg.size.height);
    [settingView addSubview:settingBackgroundImgView];
    
    soundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [soundBtn setImage:soundImg forState:UIControlStateNormal];
    soundBtn.frame = CGRectMake(0, 0, 53, 33);
    [soundBtn addTarget:self action:@selector(onPressSoundBtn:) forControlEvents:UIControlEventTouchDown];
    [soundBtn setBackgroundImage:soundBackgroundImg forState:UIControlStateHighlighted];
    [settingBackgroundImgView addSubview:soundBtn];
    
    shockBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shockBtn setImage:shockImg forState:UIControlStateNormal];
    shockBtn.frame = CGRectMake(53, 0, 53, 33);
    [shockBtn addTarget:self action:@selector(onPressShockBtn:) forControlEvents:UIControlEventTouchDown];
    [shockBtn setBackgroundImage:shockBackgroundImg forState:UIControlStateHighlighted];
    [settingBackgroundImgView addSubview:shockBtn];
    
    [settingBackgroundImgView setUserInteractionEnabled:YES];
    
    //setting button
    UIImage * settingBtnImg = [UIImage imageNamed:@"main_setting_btn.png"];
    UIImage * settingBtnBackgroundImg = [UIImage imageNamed:@"main_setting_btn_background.png"];
    
    settingBtnBackgroundImgView = [[UIImageView alloc] initWithImage:settingBtnBackgroundImg];
    settingBtnBackgroundImgView.frame = CGRectMake(524, 20, settingBtnBackgroundImg.size.width, settingBtnBackgroundImg.size.height);
    [self.view addSubview:settingBtnBackgroundImgView];
    settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    settingBtn.frame = CGRectMake(530 - settingBtnImg.size.width * 0.5, 26 - settingBtnImg.size.height * 0.5, settingBtnImg.size.width * 2, settingBtnImg.size.height * 2);
    [settingBtn setImage:settingBtnImg forState:UIControlStateNormal];
    [self.view addSubview:settingBtn];
    [settingBtn addTarget:self action:@selector(onPressSettingBtn:) forControlEvents:UIControlEventTouchUpInside];
    

    
    //gesture init..
    UISwipeGestureRecognizer * swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipeLeft:)];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer * swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipeRight:)];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swipeRight];
    
    
    //detect timer init..
    NSTimer * detectTimer;
    detectTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(onDetectTimer:) userInfo:nil repeats:YES];
    
    netStatus = STATE_CONNECT_NONE;
    netStatusView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_test_view_pcerror.png"]];
    netStatusView.alpha = 0;
    netStatusView.frame = CGRectMake(50, 20, netStatusView.image.size.width, netStatusView.image.size.height);
    [self.view addSubview:netStatusView];

}

- (void)initMainBtns
{
    //init ace button..
    UIImage * aceImg = [UIImage imageNamed:@"main_ace.png"];
    UIImage * aceHLImg = [UIImage imageNamed:@"main_ace_HL.png"];
    aceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [aceBtn setImage:aceImg forState:UIControlStateNormal];
    [aceBtn setImage:aceHLImg forState:UIControlStateHighlighted];
    aceBtn.frame = theMainFrame[positionOfAce];
    [self.view addSubview:aceBtn];
    [aceBtn addTarget:self action:@selector(onPressAceBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    //init xbox button..
    UIImage * xboxImg = [UIImage imageNamed:@"main_xbox.png"];
    UIImage * xboxHLImg = [UIImage imageNamed:@"main_xbox_HL.png"];
    xboxBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [xboxBtn setImage:xboxImg forState:UIControlStateNormal];
    [xboxBtn setImage:xboxHLImg forState:UIControlStateHighlighted];
    xboxBtn.frame = theMainFrame[positionOfXbox];
    [self.view addSubview:xboxBtn];
    [xboxBtn addTarget:self action:@selector(onPressXboxBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    //init nfs button..
    UIImage * nfsImg = [UIImage imageNamed:@"main_nfs.png"];
    UIImage * nfsHLImg = [UIImage imageNamed:@"main_nfs_HL.png"];
    nfsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nfsBtn setImage:nfsImg forState:UIControlStateNormal];
    [nfsBtn setImage:nfsHLImg forState:UIControlStateHighlighted];
    nfsBtn.frame = theMainFrame[positionOfNfs];
    [self.view addSubview:nfsBtn];
    [nfsBtn addTarget:self action:@selector(onPressNfsBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    //init describe scrollView
    UIImage * describeBackground = [UIImage imageNamed:@"main_describe.png"];
    UIImage * describeText = [UIImage imageNamed:@"main_describe_text.png"];
    
    describeView = [[UIImageView alloc] initWithImage:describeBackground];
    describeView.frame = theMainFrame[positionOfDescribe];
    [self.view addSubview:describeView];
    
    [describeView setUserInteractionEnabled:YES];
    
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:theMainFrame[positionOfDescribe]];
    [scrollView addSubview:[[UIImageView alloc] initWithImage:describeText]];
    
    [scrollView setFrame:CGRectMake(26, 21, describeText.size.width, describeText.size.height * 0.6)];
    scrollView.contentSize = CGSizeMake(describeText.size.width, describeText.size.height);
    [describeView addSubview:scrollView];
    
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
    if (nfsVC.nfsNetWork.connectState != STATE_CONNECT_ESTABLISHED) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"warning!"message:@"Your computer does not open the client properly.\n Please go to www.ea-co.co to download our client and open it." delegate:self cancelButtonTitle:@"Ok"otherButtonTitles:nil, nil];
        [alert show];
    }
    nfsVC.modalTransitionStyle = 0;
    [self presentViewController:nfsVC animated:YES completion:^(void){
        
    }];

    NSLog(@"press nfs btn");
}

- (IBAction)onPressAceBtn:(id)sender
{
    aceVC = [[AceViewController alloc] init];
    aceVC.aceNetWork = mainNetWork;
    if (aceVC.aceNetWork.connectState != STATE_CONNECT_ESTABLISHED) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"warning!"message:@"Your computer does not open the client properly.\n Please go to www.ea-co.co to download our client and open it." delegate:self cancelButtonTitle:@"Ok"otherButtonTitles:nil, nil];
        [alert show];

    }
    aceVC.modalTransitionStyle = 0;
    [self presentViewController:aceVC animated:YES completion:^(void){
        
    }];

    NSLog(@"press ace btn");
}

- (IBAction)onPressXboxBtn:(id)sender
{
    xboxVC = [[XBoxViewController alloc] init];
    xboxVC.xboxNetWork = mainNetWork;
    if (xboxVC.xboxNetWork.connectState != STATE_CONNECT_ESTABLISHED) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"warning!"message:@"Your computer does not open the client properly.\n Please go to www.ea-co.co to download our client and open it." delegate:self cancelButtonTitle:@"Ok"otherButtonTitles:nil, nil];
        [alert show];
        
    }
    xboxVC.modalTransitionStyle = 0;
    [self presentViewController:xboxVC animated:YES completion:^{
        
    }];

    NSLog(@"press xbox btn");
}

#pragma mark - gesture swipe
- (IBAction)onSwipeLeft:(id)sender
{
    if (positionOfNfs > 0) {
        [UIView animateWithDuration:0.6 animations:^{
            positionOfNfs --;
            nfsBtn.frame = theMainFrame[positionOfNfs];
            positionOfAce --;
            aceBtn.frame = theMainFrame[positionOfAce];
            positionOfXbox --;
            xboxBtn.frame = theMainFrame[positionOfXbox];
            positionOfDescribe --;
            describeView.frame = theMainFrame[positionOfDescribe];
            [self setTextImg];
        }];
    }
}

- (IBAction)onSwipeRight:(id)sender
{
    if (positionOfDescribe < 6) {
        [UIView animateWithDuration:0.6 animations:^{
            positionOfNfs ++;
            nfsBtn.frame = theMainFrame[positionOfNfs];
            positionOfAce ++;
            aceBtn.frame = theMainFrame[positionOfAce];
            positionOfXbox ++ ;
            xboxBtn.frame = theMainFrame[positionOfXbox];
            positionOfDescribe ++;
            describeView.frame = theMainFrame[positionOfDescribe];
            [self setTextImg];
        }];
    }
}

- (void)setTextImg
{
    if (positionOfDescribe == 3) {
        UIScrollView * scrollView = [[describeView subviews] objectAtIndex:0];
        UIImageView * textImgView = [[scrollView subviews] objectAtIndex:0];
        UIImage * textImg = [UIImage imageNamed:@"main_describe_text.png"];
        
        scrollView.frame = CGRectMake(26, 21, textImg.size.width, textImg.size.height * 0.6);
        textImgView.frame = CGRectMake(0, 0, textImg.size.width, textImg.size.height);
    }
    else{
        UIScrollView * scrollView = [[describeView subviews] objectAtIndex:0];
        UIImageView * textImgView = [[scrollView subviews] objectAtIndex:0];
        UIImage * textImg = [UIImage imageNamed:@"main_describe_text.png"];
        
        scrollView.frame = CGRectMake(20, 17, textImg.size.width, textImg.size.height * 0.45);
        textImgView.frame = CGRectMake(0, 0, textImg.size.width * 0.77, textImg.size.height * 0.77);
    }
}

#pragma mark - test btn methods
- (IBAction)onPressTestBtn:(id)sender
{
    netStatus = STATE_CONNECT_SEARCHING_CLIENT;
}

- (IBAction)onDetectTimer:(id)sender
{
    NSArray *ifs = (__bridge id)CNCopySupportedInterfaces();
    for (NSString *ifnam in ifs) {
        NSDictionary *info = (__bridge id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if ([info allKeys] == nil) {
            [netTestBtn setImage:[UIImage imageNamed:@"main_test_btn_error.png"] forState:UIControlStateNormal];
            [netTestBtn setImage:[UIImage imageNamed:@"main_test_btn_errorHL.png"] forState:UIControlStateHighlighted];
            UIImage * statusImg = [UIImage imageNamed:@"main_test_view_wifierror.png"];
            netStatusView.image = statusImg;
            netStatusView.alpha = 1;
            netStatus = [mainNetWork connectState];
            return;
        }
    }
    
    if ([mainNetWork connectState] == STATE_CONNECT_ESTABLISHED) {
        if (netStatus == STATE_CONNECT_ESTABLISHED) {
            return;
        }
        [netTestBtn setImage:[UIImage imageNamed:@"main_test_btn_connect.png"] forState:UIControlStateNormal];
        [netTestBtn setImage:[UIImage imageNamed:@"main_test_btn_connectHL.png"] forState:UIControlStateHighlighted];
        UIImage * statusImg = [UIImage imageNamed:@"main_test_view_success.png"];
        netStatusView.image = statusImg;
        netStatusView.alpha = 1;
        NSTimer * showConnectStatus;
        showConnectStatus = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(onShowConnectView:) userInfo:nil repeats:NO];
    }
    else{
        [netTestBtn setImage:[UIImage imageNamed:@"main_test_btn_error.png"] forState:UIControlStateNormal];
        [netTestBtn setImage:[UIImage imageNamed:@"main_test_btn_errorHL.png"] forState:UIControlStateHighlighted];
        UIImage * statusImg = [UIImage imageNamed:@"main_test_view_pcerror.png"];
        netStatusView.image = statusImg;
        netStatusView.alpha = 1;
    }
    netStatus = [mainNetWork connectState];
}

- (IBAction)onShowConnectView:(id)sender
{
    [UIView animateWithDuration:1 animations:^{
        netStatusView.alpha = 0;
    }];
}

- (IBAction)onPressSettingBtn:(id)sender
{
    CABasicAnimation * transformAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
    transformAnim.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    transformAnim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI , 0, 0, 1)];
    transformAnim.cumulative = YES;
    transformAnim.duration = 0.5;
    
    transformAnim.repeatCount = 2;
    
    [settingBtn.layer addAnimation:transformAnim forKey:nil];
    
    if (settingBackgroundImgView.frame.origin.x > 0) {
        [UIView animateWithDuration:1 animations:^{
            settingBackgroundImgView.frame = CGRectMake(0, 0, settingBackgroundImgView.frame.size.width, settingBackgroundImgView.frame.size.height);
        }];
    }
    else{
        [UIView animateWithDuration:1 animations:^{
            settingBackgroundImgView.frame = CGRectMake(settingBackgroundImgView.frame.size.width + 18, 0, settingBackgroundImgView.frame.size.width, settingBackgroundImgView.frame.size.height);
        }];
    }
    
}

- (IBAction)onPressSoundBtn:(id)sender
{
    UIImage * noSoundImg = [UIImage imageNamed:@"main_setting_nosound.png"];
    if ([soundBtn imageForState:UIControlStateNormal] != noSoundImg) {
        [soundBtn setImage:noSoundImg forState:UIControlStateNormal];
        nfsVC.playSound = NO;
        aceVC.playSound = NO;
        xboxVC.playSound = NO;

    }
    else{
        UIImage * soundImg = [UIImage imageNamed:@"main_setting_sound.png"];
        [soundBtn setImage:soundImg forState:UIControlStateNormal];
        nfsVC.playSound = YES;
        aceVC.playSound = YES;
        xboxVC.playSound = YES;
        
        SystemSoundID soundID;
        NSURL* system_sound_url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"click" ofType:@"wav"]];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)system_sound_url,&soundID);

        AudioServicesPlaySystemSound(soundID);
    }
    
}

- (IBAction)onPressShockBtn:(id)sender
{
    UIImage * noShockImg = [UIImage imageNamed:@"main_setting_noshock.png"];
    if ([shockBtn imageForState:UIControlStateNormal] != noShockImg) {
        [shockBtn setImage:noShockImg forState:UIControlStateNormal];
        nfsVC.playShock = NO;
        aceVC.playShock = NO;
        xboxVC.playShock = NO;
    }
    else{
        UIImage * shockImg = [UIImage imageNamed:@"main_setting_shock.png"];
        [shockBtn setImage:shockImg forState:UIControlStateNormal];
        nfsVC.playShock = YES;
        aceVC.playShock = YES;
        xboxVC.playShock = YES;
        SystemSoundID shockID = kSystemSoundID_Vibrate;
        
        AudioServicesPlaySystemSound(shockID);
    }
}

@end
