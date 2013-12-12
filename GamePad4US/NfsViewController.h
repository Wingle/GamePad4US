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

@class TouchRecord;
@class NetWork;

@interface NfsViewController : UIViewController<AsyncUdpSocketDelegate>{
    
    AsyncUdpSocket * socket;
    
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
    
    NSMutableArray * m_touchArray;

    NetWork * netWork;
}

@property AsyncUdpSocket * socket;

@end
