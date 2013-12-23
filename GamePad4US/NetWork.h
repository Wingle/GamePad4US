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

@interface NetWork : NSObject<AsyncUdpSocketDelegate>{
    int connectState;
    
//    NSString * targetIp;
    
    
    NSMutableString * activeMessageArrayList;
    NSMutableString * xMessageArrayList;
    NSMutableString * yMessageArrayList;
    NSMutableString * key1MessageArrayList;
    NSMutableString * key2MessageArrayList;
    NSMutableString * key3MessageArrayList;
    

    
    
    AsyncUdpSocket * activeSocket;
    AsyncUdpSocket * xSocket;
    AsyncUdpSocket * ySocket;
    AsyncUdpSocket * key1Socket;
    AsyncUdpSocket * key2Socket;
    AsyncUdpSocket * key3Socket;
    
    NSString * receiveMessage;
    
    NSString * pcHost;
}
//对外接口
//添加按键信息
-(void)addKeyMessage:(NSString *)theKeyMessage withIndex:(int)theIndex;
//获得连接状态
-(int)connectState;
//开始UDP
-(void)start;



@end
