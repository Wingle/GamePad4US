
//  MyHeader.h
//  GamePad4US
//
//  Created by 朱 俊健 on 13-12-6.
//  Copyright (c) 2013年 朱 俊健. All rights reserved.
//

#ifndef GamePad4US_MyHeader_h
#define GamePad4US_MyHeader_h

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

//NetWork
#define PORT_ACTIVE 1760
#define PORT_X 1761
#define PORT_Y 1762
#define PORT_KEY_1 1763
#define PORT_KEY_2 1764
#define PORT_KEY_3 1765

#define STATE_CONNECT_NONE -1
#define STATE_CONNECT_SEARCHING_CLIENT 0
#define STATE_CONNECT_ESTABLISHED 2

#define MESSAGE_ID_ACTIVE 0
#define MESSAGE_ID_X 1
#define MESSAGE_ID_Y 2
#define MESSAGE_ID_KEY_1 3
#define MESSAGE_ID_KEY_2 4
#define MESSAGE_ID_KEY_3 5


#define USER_IP @"255.255.255.255"

#define CONNECT_SEND_FIRST @"STARTAJYEND"
#define CONNECT_RECEIVED_FIRST @"STARTAJYACCEPTEND"
#define CONNECT_SEND_SECOND @"STARTAJYESTABLISHEND"

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
