
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

enum theType {
    accelerateType = 1,
    shiftUpType,
    shiftDownType,
    n2Type,
    handBreakType,
    breakType
    };

#endif
