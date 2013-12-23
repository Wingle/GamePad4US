//
//  NfsViewController.h
//  GamePad4US
//
//  Created by 朱 俊健 on 13-12-6.
//  Copyright (c) 2013年 朱 俊健. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncUdpSocket.h"
#import "MyHeader.h"
#import <CoreMotion/CoreMotion.h>
#import "AudioToolbox/AudioToolbox.h"
//#import <AVFoundation/AVFoundation.h>


@class NetWork;
@class TouchRecord;

@interface NfsViewController : UIViewController/*<AVAudioPlayerDelegate><AsyncUdpSocketDelegate>*/{
    //test udp
//    AVAudioPlayer * avAudioPlayer;
    SystemSoundID soundID;
    
    AsyncUdpSocket * socket;
    
    //main network
    NetWork * nfsNetWork;
    
    //calculate the motion
    CMMotionManager * motionManager;
    
    //label to show the motion
    UILabel * motionLabel;
    
    //save the touches
    NSMutableArray * m_touchArray;
    
    UIImage * accelerateImg;
    UIImage * accelerateHLImg;
    UIImageView * accelerateImgView;
    
    UIImage * shiftDownImg;
    UIImage * shiftDownHLImg;
    UIImageView * shiftDownImgView;
    
    UIImage * shiftUpImg;
    UIImage * shiftUpHLImg;
    UIImageView * shiftUpImgView;
    
    UIImage * n2Img;
    UIImage * n2HLImg;
    UIImageView * n2ImgView;
    
    UIImage * handBreakImg;
    UIImage * handBreakHLImg;
    UIImageView * handBreakImgView;
    
    UIImage * breakImg;
    UIImage * breakHLImg;
    UIImageView * breakImgView;
    

}

@property AsyncUdpSocket * socket;

@property NetWork * nfsNetWork;

@end
