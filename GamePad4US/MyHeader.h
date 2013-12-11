
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

//udp
#define PORT_ACTIVE 1760

#define USER_IP @"255.255.255.255"

enum theType {
    accelerateType = 1,
    shiftUpType,
    shiftDownType,
    n2Type,
    handBreakType,
    breakType
    };

#endif
