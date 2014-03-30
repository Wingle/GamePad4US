//
//  AceViewController.h
//  GamePad4US
//
//  Created by 朱 俊健 on 13-12-23.
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

@interface AceViewController : UIViewController<UIGestureRecognizerDelegate>{
    //test udp
    //    AVAudioPlayer * avAudioPlayer;
    BOOL playSound;
    BOOL playShock;
    
    SystemSoundID soundID;
    SystemSoundID shockID;
    
    AsyncUdpSocket * socket;
    
    //main network
    NetWork * aceNetWork;
    
    //calculate the motion
    CMMotionManager * motionManager;
    
    //label to show the motion
    UILabel * motionLabel;
    
    //save the touches
    NSMutableArray * m_touchArray;
    
    //title
    UIImage * titleImg;
    UIImageView * titleImgView;
    
    UIImage * thrustImg;
    UIImage * thrustHLImg;
    UIImageView * thrustImgView;
    
    UIImage * yawleftImg;
    UIImage * yawleftHLImg;
    UIImageView * yawleftImgView;
    
    UIImage * yawrightImg;
    UIImage * yawrightHLImg;
    UIImageView * yawrightImgView;
    
    UIImage * brakesImg;
    UIImage * brakesHLImg;
    UIImageView * brakesImgView;
    
    UIImage * cannonImg;
    UIImage * cannonHLImg;
    UIImageView * cannonImgView;
    
    UIImage * changeImg;
    UIImage * changeHLImg;
    UIImageView * changeImgView;
    
    UIImage * weaponImg;
    UIImage * weaponHLImg;
    UIImageView * weaponImgView;
    
    UIImage * lockonImg;
    UIImage * lockonHLImg;
    UIImageView * lockonImgView;
    
    UIImage * targetImg;
    UIImage * targetHLImg;
    UIImageView * targetImgView;
}

@property AsyncUdpSocket * socket;
@property NetWork * aceNetWork;

@property BOOL playSound;
@property BOOL playShock;

@end
