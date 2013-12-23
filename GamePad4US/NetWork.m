//
//  NetWork.m
//  GamePad4US
//
//  Created by 朱 俊健 on 13-12-12.
//  Copyright (c) 2013年 朱 俊健. All rights reserved.
//

#import "NetWork.h"
//#import "AsyncUdpSocket.h"

@implementation NetWork

#pragma mark - init
- (id)init
{
    self = [super init];
    if (self) {
        connectState = STATE_CONNECT_NONE;

//        targetIp = [NSString stringWithFormat:@""];
        [self initSockets];
        [self initMessagesArrayList];

    }
    return self;
}

- (void)initMessagesArrayList
{
    activeMessageArrayList = [[NSMutableString alloc] init];
    xMessageArrayList = [[NSMutableString alloc] init];
    yMessageArrayList = [[NSMutableString alloc] init];
    key1MessageArrayList = [[NSMutableString alloc] init];
    key2MessageArrayList = [[NSMutableString alloc] init];
    key3MessageArrayList = [[NSMutableString alloc] init];
}

- (void)initSockets
{
    NSError * error = Nil;
    
    activeSocket = [[AsyncUdpSocket alloc] initIPv4];
    [activeSocket setDelegate:self];
    [activeSocket bindToPort:PORT_ACTIVE error:& error];
    [activeSocket enableBroadcast:YES error:& error];
    [activeSocket receiveWithTimeout:-1 tag:0];
    
    xSocket = [[AsyncUdpSocket alloc] initIPv4];
    [xSocket setDelegate:self];
    [xSocket bindToPort:PORT_X error:& error];
    [xSocket enableBroadcast:YES error:& error];
    
    ySocket = [[AsyncUdpSocket alloc] initIPv4];
    [ySocket setDelegate:self];
    [ySocket bindToPort:PORT_Y error:& error];
    [ySocket enableBroadcast:YES error:& error];
    
    key1Socket = [[AsyncUdpSocket alloc] initIPv4];
    [key1Socket setDelegate:self];
    [key1Socket bindToPort:PORT_KEY_1 error:& error];
    [key1Socket enableBroadcast:YES error:& error];
    
    key2Socket = [[AsyncUdpSocket alloc] initIPv4];
    [key2Socket setDelegate:self];
    [key2Socket bindToPort:PORT_KEY_2 error:& error];
    [key2Socket enableBroadcast:YES error:& error];
    
    key3Socket = [[AsyncUdpSocket alloc] initIPv4];
    [key3Socket setDelegate:self];
    [key3Socket bindToPort:PORT_KEY_3 error:& error];
    [key3Socket enableBroadcast:YES error:& error];
    
}

#pragma mark - 对外接口

- (void)addKeyMessage:(NSString *)theKeyMessage withIndex:(int)theIndex
{
    NSMutableString * tempString = [self getMessageList:theIndex];
    [tempString appendString:theKeyMessage];
}

- (int)connectState
{
    return connectState;
}

- (void)start
{
    connectState = STATE_CONNECT_SEARCHING_CLIENT;

    //时间间隔
    NSTimeInterval activeTimeInterval = NETWORK_SEND_ACTIVE_TIME;
    NSTimeInterval otherTimeInterval = NETWORK_SEND_OTHERS_TIME;
    //定时器
    NSTimer *mianTimer;
    mianTimer = [NSTimer scheduledTimerWithTimeInterval:activeTimeInterval target:self selector:@selector(beginMainTimer:)userInfo:nil repeats:YES];

    NSTimer * xTimer;
    xTimer = [NSTimer scheduledTimerWithTimeInterval:otherTimeInterval target:self selector:@selector(beginXTimer:) userInfo:nil repeats:YES];

    NSTimer * yTimer;
    yTimer = [NSTimer scheduledTimerWithTimeInterval:otherTimeInterval target:self selector:@selector(beginYTimer:) userInfo:nil repeats:YES];
    
    NSTimer * key1Timer;
    key1Timer = [NSTimer scheduledTimerWithTimeInterval:otherTimeInterval target:self selector:@selector(beginKey1Timer:) userInfo:nil repeats:YES];

    NSTimer * key2Timer;
    key2Timer = [NSTimer scheduledTimerWithTimeInterval:otherTimeInterval target:self selector:@selector(beginKey2Timer:) userInfo:nil repeats:YES];
    
    NSTimer * key3Timer;
    key3Timer = [NSTimer scheduledTimerWithTimeInterval:otherTimeInterval target:self selector:@selector(beginKey3Timer:) userInfo:nil repeats:YES];

}



 	

#pragma mark - private methods

#pragma mark - new timers

- (void)beginMainTimer:(NSTimer *)theTimer
{
    int thePort = PORT_ACTIVE;
    
    switch (connectState) {
        case STATE_CONNECT_SEARCHING_CLIENT:
            
            if (receiveMessage != nil) {
                NSRange found = [receiveMessage rangeOfString:CONNECT_RECEIVED_FIRST options:NSCaseInsensitiveSearch];
                if (found.length > 0) {
                    [self broadCast:USER_IP withSocket:activeSocket withMessage:CONNECT_SEND_SECOND withPort:thePort];
                    NSLog(@"send message: %@",CONNECT_SEND_SECOND);
                    connectState = STATE_CONNECT_ESTABLISHED;
                    return;
                }
            }
            [self broadCast:USER_IP withSocket:activeSocket withMessage:CONNECT_SEND_FIRST withPort:thePort];
            NSLog(@"send message: %@",CONNECT_SEND_FIRST);

            ;
            break;
            
        case STATE_CONNECT_ESTABLISHED:
            [self broadCast:USER_IP withSocket:activeSocket withMessage:CONNECT_SEND_ALWAYS withPort:thePort];
            NSLog(@"send message: %@",CONNECT_SEND_ALWAYS);
            ;
            break;
        default:
            break;
    }
}

- (void)beginXTimer:(NSTimer *)theTimer
{
    int thePort = PORT_X;
    NSString * sendMessage;
    switch (connectState) {
        case STATE_CONNECT_SEARCHING_CLIENT:
            ;
            break;
            
        case STATE_CONNECT_ESTABLISHED:
            sendMessage = [self getNowSendMessage:MESSAGE_ID_X];
            [self broadCast:USER_IP withSocket:xSocket withMessage:sendMessage withPort:thePort];
            NSLog(@"send message : %@",sendMessage);
            ;
            break;
        default:
            break;
    }
}

- (void)beginYTimer:(NSTimer *)theTimer
{
    int thePort = PORT_Y;
    NSString * sendMessage;
    switch (connectState) {
        case STATE_CONNECT_SEARCHING_CLIENT:
            ;
            break;
            
        case STATE_CONNECT_ESTABLISHED:
            sendMessage = [self getNowSendMessage:MESSAGE_ID_Y];
            [self broadCast:USER_IP withSocket:ySocket withMessage:sendMessage withPort:thePort];
            NSLog(@"send message : %@",sendMessage);
            ;
            break;
        default:
            break;
    }
}


- (void)beginKey1Timer:(NSTimer *)theTimer
{
    int thePort = PORT_KEY_1;
    NSString * sendMessage;
    switch (connectState) {
        case STATE_CONNECT_SEARCHING_CLIENT:
            ;
            break;
            
        case STATE_CONNECT_ESTABLISHED:
            sendMessage = [self getNowSendMessage:MESSAGE_ID_KEY_1];
            [self broadCast:USER_IP withSocket:key1Socket withMessage:sendMessage withPort:thePort];
            NSLog(@"send Message : %@",sendMessage);
            ;
            break;
        default:
            break;
    }
}

- (void)beginKey2Timer:(NSTimer *)theTimer
{
    int thePort = PORT_KEY_2;
    NSString * sendMessage;
    switch (connectState) {
        case STATE_CONNECT_SEARCHING_CLIENT:
            ;
            break;
            
        case STATE_CONNECT_ESTABLISHED:
            sendMessage = [self getNowSendMessage:MESSAGE_ID_KEY_2];
            [self broadCast:USER_IP withSocket:key2Socket withMessage:sendMessage withPort:thePort];
            NSLog(@"send Message : %@",sendMessage);
            ;
            break;
        default:
            break;
    }
}
- (void)beginKey3Timer:(NSTimer *)theTimer
{
    int thePort = PORT_KEY_3;
    NSString * sendMessage;
    switch (connectState) {
        case STATE_CONNECT_SEARCHING_CLIENT:
            ;
            break;
            
        case STATE_CONNECT_ESTABLISHED:
            sendMessage = [self getNowSendMessage:MESSAGE_ID_KEY_3];
            [self broadCast:USER_IP withSocket:key3Socket withMessage:sendMessage withPort:thePort];
            NSLog(@"send Message : %@",sendMessage);
            ;
            break;
        default:
            break;
    }
}

#pragma mark - main methods

- (NSMutableString *)getMessageList:(int)tID
{
    switch (tID) {
        case MESSAGE_ID_ACTIVE:
        return activeMessageArrayList;
        break;
        case MESSAGE_ID_X:
        return xMessageArrayList;
        break;
        case MESSAGE_ID_Y:
        return yMessageArrayList;
        break;
        case MESSAGE_ID_KEY_1:
        return key1MessageArrayList;
        break;
        case MESSAGE_ID_KEY_2:
        return key2MessageArrayList;
        break;
        case MESSAGE_ID_KEY_3:
        return key3MessageArrayList;
        break;
        default:
        break;
    }
    return key3MessageArrayList;
}



- (void)broadCast:(NSString *)theHost withSocket:(AsyncUdpSocket *)theSocket withMessage:(NSString *)theMessage withPort:(int)thePort
{
    NSData * data = [theMessage dataUsingEncoding:NSASCIIStringEncoding] ;
    
    BOOL result = NO;
    //开始发送
    result = [theSocket sendData:data
                       toHost:USER_IP
                         port:thePort
                  withTimeout:1000
                          tag:0];
    
    if (!result) {
//        NSLog(@"send failed");
    }
    else{
//        NSLog(@"send succeed");
    }
}

- (NSString * )getNowSendMessage:(int)tId
{
    NSString * theResult;
    switch (tId) {
        case MESSAGE_ID_X:
            theResult = [NSString stringWithFormat:@"STARTOPT%@END",xMessageArrayList];
            [xMessageArrayList setString:@""];
            break;
        case MESSAGE_ID_Y:
            theResult = [NSString stringWithFormat:@"STARTOPT%@END",yMessageArrayList];
            [yMessageArrayList setString:@""];
            break;
        case MESSAGE_ID_KEY_1:
            theResult = [NSString stringWithFormat:@"STARTOPT%@END",key1MessageArrayList];
            [key1MessageArrayList setString:@""];
            break;
        case MESSAGE_ID_KEY_2:
            theResult = [NSString stringWithFormat:@"STARTOPT%@END",key2MessageArrayList];
            [key2MessageArrayList setString:@""];
            break;
        case MESSAGE_ID_KEY_3:
            theResult = [NSString stringWithFormat:@"STARTOPT%@END",key3MessageArrayList];
            [key3MessageArrayList setString:@""];
            break;
        default:
            break;
    }
    
    return theResult;
}

#pragma mark - AsyncUdpSocket Delegate
- (BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port
{
    [sock receiveWithTimeout:-1 tag:0];
    NSLog(@"host---->%@",host);
    
    NSString *info=[[NSString alloc] initWithData:data encoding: NSUTF8StringEncoding];
    NSLog(@"the resource string:%@",info);
    
    //已经处理完毕
    if (!([info isEqualToString:CONNECT_SEND_FIRST]||[info isEqualToString:CONNECT_SEND_SECOND]||[info isEqualToString:CONNECT_SEND_ALWAYS])) {
        receiveMessage = [NSString stringWithFormat:@"%@",info];
        if ((connectState == STATE_CONNECT_SEARCHING_CLIENT)&& (receiveMessage != nil)) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示~"message:@"可以进入手柄了~" delegate:self cancelButtonTitle:@"Ok"otherButtonTitles:nil, nil];
            [alert show];
        }
        NSLog(@"recieved message:%@",info);
    }

    
    return YES;
}

- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotReceiveDataWithTag:(long)tag dueToError:(NSError *)error
{
    
}

- (void)onUdpSocket:(AsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
//    NSLog(@"send succeed");
}

- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
//    NSLog(@"send failed");
    
}

- (void)onUdpSocketDidClose:(AsyncUdpSocket *)sock
{
    
}
@end
