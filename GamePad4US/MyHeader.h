
//  MyHeader.h
//  GamePad4US
//
//  Created by 朱 俊健 on 13-12-6.
//  Copyright (c) 2013年 朱 俊健. All rights reserved.
//

#ifndef GamePad4US_MyHeader_h
#define GamePad4US_MyHeader_h

//main VC
#define MAIN_NFS_X 35
#define MAIN_NFS_Y 88
#define MAIN_ACE_X 205
#define MAIN_ACE_Y 88
#define MAIN_HAWX_X 375
#define MAIN_HAWX_Y 88

//nfs VC
//所有按钮的坐标
#define ACCELERATE_X 10
#define ACCELERATE_Y 40
#define SHIFTUP_X 107.5
#define SHIFTUP_Y 40
#define SHIFTDOWN_X 107.5
#define SHIFTDOWN_Y 175
#define N2_X 295
#define N2_Y 40
#define HANDBREAK_X 341.5
#define HANDBREAK_Y 40
#define BREAK_X 341.5
#define BREAK_Y 175
//检测刷新的时间间隔
#define NFS_REFRESH_TIME 0.01

//ace VC
//所有按钮坐标
#define TITLE_X 200
#define TITLE_Y 0

#define THRUST_X 15
#define THRUST_Y 45
#define YAWLEFT_X 0
#define YAWLEFT_Y 60
#define YAWRIGHT_X 160
#define YAWRIGHT_Y 60
#define BRAKES_X 15
#define BRAKES_Y 200
#define CANNON_X 300
#define CANNON_Y 50
#define CHANGE_X 430
#define CHANGE_Y 0
#define WEAPON_X 430
#define WEAPON_Y 110
#define LOCKON_X 300
#define LOCKON_Y 180
#define TARGET_X 430
#define TARGET_Y 240
//检测刷新的时间间隔
#define ACE_REFRESH_TIME 0.01



//send messages
//NFS发送的消息
#define PRESS_ACCELERATE @"X*P#"
#define RELEASE_ACCELERATE @"X*R#"
#define PRESS_SHIFTUP @"Q*P#"
#define RELEASE_SHIFTUP @"Q*R#"
#define PRESS_SHIFTDOWN @"W*P#"
#define RELEASE_SHIFTDOWN @"W*R#"
#define PRESS_N2 @"E*P#"
#define RELEASE_N2 @"E*R#"
#define PRESS_HANDBREAK @"A*P#"
#define RELEASE_HANDBREAK @"A*R#"
#define PRESS_BREAK @"Z*P#"
#define RELEASE_BREAK @"Z*R#"

//ACE发送的消息
#define PRESS_THRUST @"X*P#"
#define RELEASE_THRUST @"X*R#"
#define PRESS_YAWRIGHT @"D*P#"
#define RELEASE_YAWRIGHT @"D*R#"
#define PRESS_YAWLEFT @"S*P#"
#define RELEASE_YAWLEFT @"S*R#"
#define PRESS_BRAKES @"Z*P#"
#define RELEASE_BRAKES @"Z*R#"
#define PRESS_CHANGE @"A*P#"
#define RELEASE_CHANGE @"A*R#"
#define PRESS_CANNON @"E*P#"
#define RELEASE_CANNON @"E*R#"
#define PRESS_LOCKON @"B*P#"
#define RELEASE_LOCKON @"B*R#"
#define PRESS_WEAPON @"W*P#"
#define RELEASE_WEAPON @"W*R#"
#define PRESS_TARGET @"Q*P#"
#define RELEASE_TARGET @"Q*R#"


//NetWork
//发送心跳消息的时间间隔
#define NETWORK_SEND_ACTIVE_TIME 2
//发送按键消息的时间间隔
#define NETWORK_SEND_OTHERS_TIME 0.01
//端口
#define PORT_ACTIVE 1760
#define PORT_X 1761
#define PORT_Y 1762
#define PORT_KEY_1 1763
#define PORT_KEY_2 1764
#define PORT_KEY_3 1765
//连接状态
#define STATE_CONNECT_NONE -1
#define STATE_CONNECT_SEARCHING_CLIENT 0
#define STATE_CONNECT_ESTABLISHED 2
//端口的标志
#define MESSAGE_ID_ACTIVE 0
#define MESSAGE_ID_X 1
#define MESSAGE_ID_Y 2
#define MESSAGE_ID_KEY_1 3
#define MESSAGE_ID_KEY_2 4
#define MESSAGE_ID_KEY_3 5
//发送的HOST地址
#define USER_IP @"255.255.255.255"
//连接时发送接收的消息
#define CONNECT_SEND_FIRST @"STARTAJYEND"
#define CONNECT_RECEIVED_FIRST @"STARTAJYACCEPTEND"
#define CONNECT_SEND_SECOND @"STARTAJYESTABLISHEND"
//发送心跳包时发送接收的消息
#define CONNECT_RECEIVED_ALWAYS @"STARTHEARTEND"
#define CONNECT_SEND_ALWAYS @"STARTHEARTEND"

enum nfsType {
    accelerateType = 1,
    shiftUpType,
    shiftDownType,
    n2Type,
    handBreakType,
    breakType,
    };

enum aceType {
    thrustType = 1,
    yawleftType,
    yawrightType,
    brakesType,
    cannonType,
    changeType,
    weaponType,
    targetType,
    lockonType
    };


#endif
