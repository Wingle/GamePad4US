//
//  MainViewController.h
//  GamePad4US
//
//  Created by 朱 俊健 on 13-12-5.
//  Copyright (c) 2013年 朱 俊健. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyHeader.h"
#import "NetWork.h"
#import <QuartzCore/QuartzCore.h>
#import <SystemConfiguration/SystemConfiguration.h>



@class NfsViewController;
@class AceViewController;
@class HawxViewController;
@class XBoxViewController;

@interface MainViewController : UIViewController<UIGestureRecognizerDelegate>{
    UIButton * aceBtn;
    UIButton * xboxBtn;
    UIButton * nfsBtn;
    
    UIImageView * describeView;
    
    CGRect theMainFrame[7];
    int positionOfNfs;
    int positionOfAce;
    int positionOfXbox;
    int positionOfDescribe;
    
    UIImageView * topicImgView;
    
    NetWork * mainNetWork;
    
    NfsViewController * nfsVC;
    AceViewController * aceVC;
    XBoxViewController * xboxVC;
    
    UIButton * netTestBtn;
    
    UIImageView * netStatusView;
    int netStatus;
    
    UIButton * settingBtn;
    UIImageView * settingBtnBackgroundImgView;
    UIScrollView * settingView;
    UIImageView * settingBackgroundImgView;
    
    UIButton * soundBtn;
    UIButton * shockBtn;
    
    BOOL playSound;
    BOOL playShock;
}

@end
