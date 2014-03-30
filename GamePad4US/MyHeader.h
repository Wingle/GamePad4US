
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
#define MAIN_TOPIC_X 215
#define MAIN_TOPIC_Y 18

//所有子视图退出时的手势响应区域
#define EXIT_AREA CGRectMake(120, 0, 330, 35)

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

#define THRUST_X 20
#define THRUST_Y 52
#define YAWLEFT_X 10
#define YAWLEFT_Y 66
#define YAWRIGHT_X 160
#define YAWRIGHT_Y 66
#define BRAKES_X 20
#define BRAKES_Y 204
#define CANNON_X 299
#define CANNON_Y 49
#define CHANGE_X 430
#define CHANGE_Y 0
#define WEAPON_X 430
#define WEAPON_Y 110
#define LOCKON_X 299
#define LOCKON_Y 183
#define TARGET_X 430
#define TARGET_Y 242
//检测刷新的时间间隔
#define ACE_REFRESH_TIME 0.01

//hawx VC
//所有按钮坐标
#define HAWX_TITLE_X 200
#define HAWX_TITLE_Y 0

#define HAWX_THRUST_X 20
#define HAWX_THRUST_Y 52
#define HAWX_YAWRIGHT_X 160
#define HAWX_YAWRIGHT_Y 66
#define HAWX_YAWLEFT_X 10
#define HAWX_YAWLEFT_Y 66
#define HAWX_BRAKES_X 20
#define HAWX_BRAKES_Y 204
#define HAWX_CANNON_X 298
#define HAWX_CANNON_Y 46
#define HAWX_TARGET_X 430
#define HAWX_TARGET_Y 46
#define HAWX_FLARES_X 298
#define HAWX_FLARES_Y 183
#define HAWX_WEAPON_X 430
#define HAWX_WEAPON_Y 183
//检测刷新的时间间隔
#define HAWX_REFRESH_TIME 0.01

//xbox VC
//所有按钮坐标
#define XBOX_CROSS_X 29
#define XBOX_CROSS_Y 66

#define XBOX_RB_X 123
#define XBOX_RB_Y 87
#define XBOX_LB_X 49
#define XBOX_LB_Y 162
#define XBOX_LT_X 200
#define XBOX_LT_Y 162
#define XBOX_RT_X 126
#define XBOX_RT_Y 244
#define XBOX_Y_X 383
#define XBOX_Y_Y 50
#define XBOX_B_X 460
#define XBOX_B_Y 120
#define XBOX_A_X 388
#define XBOX_A_Y 201
#define XBOX_X_X 308
#define XBOX_X_Y 128

#define XBOX_START_X 305
#define XBOX_START_Y 262
#define XBOX_SELECT_X 233
#define XBOX_SELECT_Y 262

#define XBOX_UP_X 28
#define XBOX_UP_Y 43
#define XBOX_DOWN_X 28
#define XBOX_DOWN_Y 211
#define XBOX_LEFT_X 7
#define XBOX_LEFT_Y 58
#define XBOX_RIGHT_X 178
#define XBOX_RIGHT_Y 58
//检测刷新的时间间隔
#define XBOX_REFRESH_TIME 0.01

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

//HAWX发送的消息
#define PRESS_HAWX_THRUST @"X*P#"
#define RELEASE_HAWX_THRUST @"X*R#"
#define PRESS_HAWX_YAWLEFT @"S*P#"
#define RELEASE_HAWX_YAWLEFT @"S*R#"
#define PRESS_HAWX_YAWRIGHT @"D*P#"
#define RELEASE_HAWX_YAWRIGHT @"D*R#"
#define PRESS_HAWX_BRAKES @"Z*P#"
#define RELEASE_HAWX_BRAKES @"Z*R#"
#define PRESS_HAWX_TARGET @"Q*P#"
#define RELEASE_HAWX_TARGET @"Q*R#"
#define PRESS_HAWX_CANNON @"W*P#"
#define RELEASE_HAWX_CANNON @"W*R#"
#define PRESS_HAWX_FLARES @"A*P#"
#define RELEASE_HAWX_FLARES @"A*R#"
#define PRESS_HAWX_WEAPON @"E*P#"
#define RELEASE_HAWX_WEAPON @"E*R#"

//XBOX发送的消息
#define PRESS_XBOX_RB @"D*P#"
#define RELEASE_XBOX_RB @"D*R#"
#define PRESS_XBOX_LB @"S*P#"
#define RELEASE_XBOX_LB @"S*R#"
#define PRESS_XBOX_LT @"Z*P#"
#define RELEASE_XBOX_LT @"Z*R#"
#define PRESS_XBOX_RT @"X*P#"
#define RELEASE_XBOX_RT @"X*R#"
#define PRESS_XBOX_Y @"Q*P#"
#define RELEASE_XBOX_Y @"Q*R#"
#define PRESS_XBOX_X @"A*P#"
#define RELEASE_XBOX_X @"A*R#"
#define PRESS_XBOX_A @"E*P#"
#define RELEASE_XBOX_A @"E*R#"
#define PRESS_XBOX_B @"W*P#"
#define RELEASE_XBOX_B @"W*R#"

#define PRESS_XBOX_SELECT @"C*P#"
#define RELEASE_XBOX_SELECT @"C*R#"
#define PRESS_XBOX_START @"V*P#"
#define RELEASE_XBOX_START @"V*R#"

//NetWork
//发送心跳消息的时间间隔
#define NETWORK_SEND_ACTIVE_TIME 1
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
    lockonType,
    flaresType
    };
enum xboxType {
    rbType = 1,
    lbType,
    ltType,
    rtType,
    xType,
    yType,
    aType,
    bType,
    
    };

#endif
