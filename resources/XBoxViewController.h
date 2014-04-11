//
//  XBoxViewController.h
//  GamePad4US
//
//  Created by 朱 俊健 on 14-2-24.
//  Copyright (c) 2014年 朱 俊健. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncUdpSocket.h"
#import "MyHeader.h"
#import <CoreMotion/CoreMotion.h>
#import "AudioToolbox/AudioToolbox.h"

@class NetWork;
@class TouchRecord;

@interface XBoxViewController : UIViewController<UIGestureRecognizerDelegate>{
    //test udp
    //    AVAudioPlayer * avAudioPlayer;
    SystemSoundID soundID;
    SystemSoundID shockID;
    BOOL playSound;
    BOOL plsyShock;
    
    AsyncUdpSocket * socket;
    
    //main network
    NetWork * xboxNetWork;
    
    //calculate the motion
    CMMotionManager * motionManager;
    
    //label to show the motion
    UILabel * motionLabel;
    
    //save the touches
    NSMutableArray * m_touchArray;
    
    //timer
    NSTimer * showTimer;
    
    //title
    UIImage * crossImg;
    UIImageView * crossImgView;
    
    UIImage * rbImg;
    UIImage * rbHLImg;
    UIImageView * rbImgView;
    
    UIImage * lbImg;
    UIImage * lbHLImg;
    UIImageView * lbImgView;
    
    UIImage * ltImg;
    UIImage * ltHLImg;
    UIImageView * ltImgView;
    
    UIImage * rtImg;
    UIImage * rtHLImg;
    UIImageView * rtImgView;
    
    UIImage * yImg;
    UIImage * yHLImg;
    UIImageView * yImgView;
    
    UIImage * bImg;
    UIImage * bHLImg;
    UIImageView * bImgView;
    
    UIImage * aImg;
    UIImage * aHLImg;
    UIImageView * aImgView;
    
    UIImage * xImg;
    UIImage * xHLImg;
    UIImageView * xImgView;
    
    
    //方向检测控件
    UIImage * upImg;
    UIImageView * upImgView;
    
    UIImage * downImg;
    UIImageView * downImgView;
    
    UIImage * leftImg;
    UIImageView * leftImgView;
    
    UIImage * rightImg;
    UIImageView * rightImgView;

}

@property AsyncUdpSocket * socket;
@property NetWork * xboxNetWork;

@property BOOL playSound;
@property BOOL playShock;

@end
