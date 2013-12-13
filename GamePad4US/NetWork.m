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
        
//        NSThread * myThread = [[NSThread alloc] initWithTarget:self
//                                                      selector:@selector(doSomething:)
//                                                        object:nil];
        activeThread = [[NSThread alloc] initWithTarget:self selector:@selector(beginActiveThread) object:nil];
        xThread = [[NSThread alloc] initWithTarget:self selector:@selector(beginXThread) object:nil];
        yThread = [[NSThread alloc] initWithTarget:self selector:@selector(beginYThread) object:nil];
        key1Thread = [[NSThread alloc] initWithTarget:self selector:@selector(beginKey1Thread) object:nil];
        key2Thread = [[NSThread alloc] initWithTarget:self selector:@selector(beginKey2Thread) object:nil];
        key3Thread = [[NSThread alloc] initWithTarget:self selector:@selector(beginKey3Thread) object:nil];
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
    NSTimeInterval timeInterval = 2;
    //定时器
    NSTimer *mianTimer;
    mianTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(beginMainTimer:)userInfo:nil repeats:YES];
    
//    [activeThread start];
//    [xThread start];
//    [yThread start];
//    [key1Thread start];
//    [key2Thread start];
//    [key3Thread start];
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
                }
            }
            [self broadCast:USER_IP withSocket:activeSocket withMessage:CONNECT_SEND_FIRST withPort:thePort];
            NSLog(@"send message: %@",CONNECT_SEND_FIRST);

            ;
            break;
            
        case STATE_CONNECT_ESTABLISHED:
            [self broadCast:USER_IP withSocket:activeSocket withMessage:CONNECT_SEND_ALWAYS withPort:thePort];
            NSLog(@"send message: %@",CONNECT_SEND_ALWAYS);
//            if (receiveMessage != nil) {
//                NSRange found = [receiveMessage rangeOfString:CONNECT_RECEIVED_ALWAYS options:NSCaseInsensitiveSearch];
//                if (found.length > 0) {
//                    [self broadCast:USER_IP withSocket:activeSocket withMessage:CONNECT_SEND_ALWAYS withPort:thePort];
//                    NSLog(@"send message: %@",CONNECT_SEND_ALWAYS);
//                }
//            }
            ;
            break;
        default:
            break;
    }
}


#pragma mark - thread methods



- (void)beginActiveThread
{
    [self mainStartListening:PORT_ACTIVE withTId:MESSAGE_ID_ACTIVE];
}

- (void)beginXThread
{
    [self extraStartListening:PORT_X withTId:MESSAGE_ID_X];
}

- (void)beginYThread
{
    [self extraStartListening:PORT_Y withTId:MESSAGE_ID_Y];
}

- (void)beginKey1Thread
{
    [self extraStartListening:PORT_KEY_1 withTId:MESSAGE_ID_KEY_1];
}

- (void)beginKey2Thread
{
    [self extraStartListening:PORT_KEY_2 withTId:MESSAGE_ID_KEY_2];
}

- (void)beginKey3Thread
{
    [self extraStartListening:PORT_KEY_3 withTId:MESSAGE_ID_KEY_3];
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

- (void)mainStartListening:(int)port withTId:(int)tId
{
    AsyncUdpSocket * socket = [[AsyncUdpSocket alloc] initIPv4];
    [socket setDelegate:self];
    NSError * error = nil;
    [socket bindToPort:port error:& error];
    [socket enableBroadcast:YES error:& error];
    [socket receiveWithTimeout:-1 tag:0];
    
    while (YES) {
        switch (connectState) {
            case STATE_CONNECT_SEARCHING_CLIENT:
                [self broadCast:USER_IP withSocket:socket withMessage:CONNECT_SEND_FIRST withPort:port];
                [NSThread sleepForTimeInterval:0.1];
                if (receiveMessage != nil) {
                    NSRange found = [receiveMessage rangeOfString:CONNECT_RECEIVED_FIRST options:NSCaseInsensitiveSearch];
                    if (found.length > 0) {
                        [self broadCast:USER_IP withSocket:socket withMessage:CONNECT_SEND_SECOND withPort:port];
                        connectState = STATE_CONNECT_ESTABLISHED;
                    }
                    else{
                        [NSThread sleepForTimeInterval:0.9];
                    }
                }
                
            break;
            
            case STATE_CONNECT_ESTABLISHED:
            [NSThread sleepForTimeInterval:0.3];
//            NSString * nowMessage = [self getNowSendMessage:tId];
//            if (nowMessage != nil) {
//                [self broadCast:USER_IP withSocket:socket withMessage:nowMessage withPort:port];
//            }
//            else{
//                [self broadCast:USER_IP withSocket:socket withMessage:@"STARTOPTFUCKEND" withPort:port];
//            }
            if (receiveMessage != nil) {
                NSRange found = [receiveMessage rangeOfString:CONNECT_RECEIVED_ALWAYS options:NSCaseInsensitiveSearch];
                if (found.length > 0) {
                    [self broadCast:USER_IP withSocket:socket withMessage:CONNECT_SEND_ALWAYS withPort:port];
                }
                else{
                    [NSThread sleepForTimeInterval:1];
                }
            }
            
            break;
            
//            default:
//            break;
        }
    }
}

- (void)extraStartListening:(int)port withTId:(int)tID
{
    
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
    
    NSLog(@"send upd complete.");
    
    if (!result) {
        //        [self showAlertWhenFaield:@"Send failed"];//发送失败
//        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示~"message:@"连接失败" delegate:self cancelButtonTitle:@"Ok"otherButtonTitles:nil, nil];
//        [alert show];
        NSLog(@"send failed");
    }
    else{
//        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示~"message:@"连接成功" delegate:self cancelButtonTitle:@"Ok"otherButtonTitles:nil, nil];
//        [alert show];
        NSLog(@"send succeed");
    }
}

- (NSString * )getNowSendMessage:(int)tId
{
    return @"";
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
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示~"message:receiveMessage delegate:self cancelButtonTitle:@"Ok"otherButtonTitles:nil, nil];
        [alert show];
        
        NSLog(@"recieved message:%@",info);
    }

    
    return YES;
}

- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotReceiveDataWithTag:(long)tag dueToError:(NSError *)error
{
    
}

- (void)onUdpSocket:(AsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
//    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示~"message:@"发送成功" delegate:self cancelButtonTitle:@"Ok"otherButtonTitles:nil, nil];
//    [alert show];
}

- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
//    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示~"message:@"发送失败" delegate:self cancelButtonTitle:@"Ok"otherButtonTitles:nil, nil];
//    [alert show];
    NSLog(@"send failed");
    
}

- (void)onUdpSocketDidClose:(AsyncUdpSocket *)sock
{
    
}
@end
