//
//  NetWork.h
//  GamePad4US
//
//  Created by 朱 俊健 on 13-12-12.
//  Copyright (c) 2013年 朱 俊健. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyHeader.h"
#import "AsyncUdpSocket.h"

//@class AsyncUdpSocket;

@interface NetWork : NSObject{
    int connectState;
    
    NSString * targetIp;
    
    
    NSMutableString * activeMessageArrayList;
    NSMutableString * xMessageArrayList;
    NSMutableString * yMessageArrayList;
    NSMutableString * key1MessageArrayList;
    NSMutableString * key2MessageArrayList;
    NSMutableString * key3MessageArrayList;
    
    NSThread * activeThread;
    NSThread * xThread;
    NSThread * yThread;
    NSThread * key1Thread;
    NSThread * key2Thread;
    NSThread * key3Thread;
    
    NSString * receiveMessage;
}
//对外接口
//添加按键信息
-(void)addKeyMessage:(NSString *)theKeyMessage withIndex:(int)theIndex;
//获得连接状态
-(int)connectState;
//开始UDP
-(void)start;



@end
