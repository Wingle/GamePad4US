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

- (id)init
{
    self = [super init];
    if (self) {
        connectState = STATE_CONNECT_NONE;

//        targetIp = [NSString stringWithFormat:@""];
        
        activeMessageArrayList = [[NSMutableString alloc] init];
        xMessageArrayList = [[NSMutableString alloc] init];
        yMessageArrayList = [[NSMutableString alloc] init];
        key1MessageArrayList = [[NSMutableString alloc] init];
        key2MessageArrayList = [[NSMutableString alloc] init];
        key3MessageArrayList = [[NSMutableString alloc] init];
        
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
    
    [activeThread start];
    [xThread start];
    [yThread start];
    [key1Thread start];
    [key2Thread start];
    [key3Thread start];
}


#pragma mark - private methods

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

@end
