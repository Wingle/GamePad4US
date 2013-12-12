//
//  NfsViewController.m
//  GamePad4US
//
//  Created by 朱 俊健 on 13-12-6.
//  Copyright (c) 2013年 朱 俊健. All rights reserved.
//

#import "NfsViewController.h"
#import "TouchRecord.h"
#import "NetWork.h"


@interface NfsViewController ()

@end

@implementation NfsViewController

@synthesize socket;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        netWork = [[NetWork alloc] init];
//        [netWork start];
        [self initSocket];
        //Important!!! setMutipleTouch
        [self.view setMultipleTouchEnabled:YES];
    }
    return self;
}

- (void)initSocket
{
    socket = [[AsyncUdpSocket alloc] initIPv4];
    [socket setDelegate:self];

    NSError * error = Nil;
    [socket bindToPort:PORT_ACTIVE error:& error];
    [socket enableBroadcast:YES error:& error];
    
    [socket receiveWithTimeout:-1 tag:0];
    
    NSMutableString * testStr = [NSMutableString stringWithFormat:CONNECT_SEND_FIRST];
    
    NSData * data = [testStr dataUsingEncoding:NSASCIIStringEncoding] ;
    
    BOOL result = NO;
    //开始发送
    result = [socket sendData:data
                            toHost:USER_IP
                              port:PORT_ACTIVE
                       withTimeout:-1
                               tag:0];
    
    NSLog(@"send upd complete.");
    
    if (!result) {
//        [self showAlertWhenFaield:@"Send failed"];//发送失败
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示~"message:@"连接失败" delegate:self cancelButtonTitle:@"Ok"otherButtonTitles:nil, nil];
        [alert show];
        NSLog(@"send failed");
    }
    else{
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示~"message:@"连接成功" delegate:self cancelButtonTitle:@"Ok"otherButtonTitles:nil, nil];
        [alert show];
        NSLog(@"send succeed");
    }
    
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.]
    
    //设置背景图
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"nfs_background.jpg"]]];
    
    //accelerate init
    accelerateHLImg = [UIImage imageNamed:@"nfs_accelerate_HL.png"];
    accelerateImg = [UIImage imageNamed:@"nfs_accelerate.png"];
    accelerateImgView = [[UIImageView alloc]initWithImage:accelerateImg];
    accelerateImgView.frame = CGRectMake(ACCELERATE_X, ACCELERATE_Y, accelerateImg.size.width, accelerateImg.size.height);
    [self.view addSubview:accelerateImgView];
    

    //shiftdown init
    shiftDownHLImg = [UIImage imageNamed:@"nfs_shiftdown_HL.png"];
    shiftDownImg = [UIImage imageNamed:@"nfs_shiftdown.png"];
    shiftDownImgView = [[UIImageView alloc]initWithImage:shiftDownImg];
    shiftDownImgView.frame = CGRectMake(SHIFTDOWN_X, SHIFTDOWN_Y, shiftDownImg.size.width, shiftDownImg.size.height);
    [self.view addSubview:shiftDownImgView];

    //shiftup init
    shiftUpHLImg = [UIImage imageNamed:@"nfs_shiftup_HL.png"];
    shiftUpImg = [UIImage imageNamed:@"nfs_shiftup.png"];
    shiftUpImgView = [[UIImageView alloc]initWithImage:shiftUpImg];
    shiftUpImgView.frame = CGRectMake(SHIFTUP_X, SHIFTUP_Y, shiftUpImg.size.width, shiftUpImg.size.height);
    [self.view addSubview:shiftUpImgView];
    
    //n2 init
    n2HLImg = [UIImage imageNamed:@"nfs_n2_HL.png"];
    n2Img = [UIImage imageNamed:@"nfs_n2.png"];
    n2ImgView = [[UIImageView alloc]initWithImage:n2Img];
    n2ImgView.frame = CGRectMake(N2_X, N2_Y, n2Img.size.width, n2Img.size.height);
    [self.view addSubview:n2ImgView];
    
    
    //handbreak init
    handBreakHLImg = [UIImage imageNamed:@"nfs_handbreak_HL.png"];
    handBreakImg = [UIImage imageNamed:@"nfs_handbreak.png"];
    handBreakImgView = [[UIImageView alloc]initWithImage:handBreakImg];
    handBreakImgView.frame = CGRectMake(HANDBREAK_X, HANDBREAK_Y, handBreakImg.size.width, handBreakImg.size.height);
    [self.view addSubview:handBreakImgView];
    
    //break init
    breakHLImg = [UIImage imageNamed:@"nfs_break_HL.png"];
    breakImg = [UIImage imageNamed:@"nfs_break.png"];
    breakImgView = [[UIImageView alloc]initWithImage:breakImg];
    breakImgView.frame = CGRectMake(BREAK_X, BREAK_Y, breakImg.size.width, breakImg.size.height);
    [self.view addSubview:breakImgView];
    
    
    [self initTimer];
    m_touchArray = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NSTimer

- (void)initTimer
{
    //时间间隔
    NSTimeInterval timeInterval = 0.01;
    //定时器
    NSTimer *showTimer;
    showTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(checkTouchedBtnWithTimer:)userInfo:nil repeats:YES];
}

- (void)checkTouchedBtnWithTimer:(NSTimer *)theTimer
{
    accelerateImgView.image = accelerateImg;
    shiftUpImgView.image = shiftUpImg;
    shiftDownImgView.image = shiftDownImg;
    n2ImgView.image = n2Img;
    handBreakImgView.image = handBreakImg;
    breakImgView.image = breakImg;
    for (TouchRecord * touchRecord in m_touchArray) {
        if ([self isTouchedByType:accelerateType withPoint:touchRecord.m_point]) {
            accelerateImgView.image = accelerateHLImg;
            continue;
        }
        if ([self isTouchedByType:shiftUpType withPoint:touchRecord.m_point]) {
            shiftUpImgView.image = shiftUpHLImg;
            continue;
        }
        if ([self isTouchedByType:shiftDownType withPoint:touchRecord.m_point]) {
            shiftDownImgView.image = shiftDownHLImg;
            continue;
        }
        if ([self isTouchedByType:n2Type withPoint:touchRecord.m_point]) {
            n2ImgView.image = n2HLImg;
            continue;
        }
        if ([self isTouchedByType:handBreakType withPoint:touchRecord.m_point]) {
            handBreakImgView.image = handBreakHLImg;
            continue;
        }
        if ([self isTouchedByType:breakType withPoint:touchRecord.m_point]) {
            breakImgView.image = breakHLImg;
            continue;
        }
    }
}

#pragma mark - isTouched

- (BOOL)isTouchedByType:(int)theType withPoint:(CGPoint)thePoint
{
    switch (theType) {
        case accelerateType:
            return [self isTouchedOnBtn:thePoint on:accelerateImgView withX:ACCELERATE_X withY:ACCELERATE_Y];
            break;
        case shiftUpType:
            return [self isTouchedOnBtn:thePoint on:shiftUpImgView withX:SHIFTUP_X withY:SHIFTUP_Y];
            break;
        case shiftDownType:
            return [self isTouchedOnBtn:thePoint on:shiftDownImgView withX:SHIFTDOWN_X withY:SHIFTDOWN_Y];
            break;
        case n2Type:
            return [self isTouchedOnBtn:thePoint on:n2ImgView withX:N2_X withY:N2_Y];
            break;
        case handBreakType:
            return [self isTouchedOnBtn:thePoint on:handBreakImgView withX:HANDBREAK_X withY:HANDBREAK_Y];
            break;
        case breakType:
            return [self isTouchedOnBtn:thePoint on:breakImgView withX:BREAK_X withY:BREAK_Y];
            break;
        default:
            break;
    }
    return [self isTouchedOnBtn:thePoint on:accelerateImgView withX:ACCELERATE_X withY:ACCELERATE_Y];

}


- (BOOL)isTouchedOnBtn:(CGPoint)thePoint on:(UIImageView *)theImgView withX:(int)theX withY:(int)theY
{
    if (!CGRectContainsPoint(theImgView.frame, thePoint)) {
        return NO;
    }
    
    thePoint.x = (thePoint.x - theX) * 2;
    thePoint.y = (thePoint.y - theY) * 2;
    
    CGFloat alpha = [self getRGBAsFromImage:theImgView.image atX:(int)thePoint.x andY:(int)thePoint.y];
    
    NSLog(@"alpha = %f",alpha);
    
    if (alpha < 0.01) {
        return NO;
    }
    return YES;
}

//这个方法可以成功算出alpha的值，但是运行速度及其慢
- (CGFloat)getRGBAsFromImage:(UIImage*)image atX:(int)xx andY:(int)yy
{
//    NSMutableArray *result = [NSMutableArray arrayWithCapacity:count];
    
    // First get the image into your data buffer
    CGImageRef imageRef = [image CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = (unsigned char*) calloc(height * width * 4, sizeof(unsigned char));
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    // Now your rawData contains the image data in the RGBA8888 pixel format.
    unsigned long byteIndex = (bytesPerRow * yy) + xx * bytesPerPixel;
//    for (int ii = 0 ; ii < count ; ++ii)
//    {
//        CGFloat red   = (rawData[byteIndex]     * 1.0) / 255.0;
//        CGFloat green = (rawData[byteIndex + 1] * 1.0) / 255.0;
//        CGFloat blue  = (rawData[byteIndex + 2] * 1.0) / 255.0;
//        CGFloat alpha = (rawData[byteIndex + 3] * 1.0) / 255.0;
//        byteIndex += 4;
//        
//        UIColor *acolor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
//        [result addObject:acolor];
//    }
//    
//    free(rawData);
//
//    return result;
//    
    CGFloat alpha = (rawData[byteIndex + 3] * 1.0) / 255.0;
    free(rawData);
    return alpha;
}



#pragma mark - UITouch delegates

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint thePoint;
    for (UITouch * touch in touches) {
        thePoint = [touch locationInView:self.view];
        TouchRecord * touchRecord = [[TouchRecord alloc] initWithTouch:touch pointInView:thePoint];
        [m_touchArray addObject:touchRecord];
    }
    
//    UITouch * touch = [touches anyObject];
//    CGPoint point = [touch locationInView:self.view];
//    if ([self isTouchedAccelerate:point]) {
//        accelerateImgView.image = accelerateHLImg;
//    }
//    
//    unsigned long i = [touches count];
//    
//    NSLog(@"touches begin! %lu",i);
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch * touch in touches) {
        for (TouchRecord * touchRecord in m_touchArray) {
            if (touch == touchRecord.m_id) {
                [m_touchArray removeObject:touchRecord];
                break;
            }
        }
    }
    
//    NSLog(@"touches cancelld");
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint thePoint;
    for (UITouch * touch in touches) {
        thePoint = [touch locationInView:self.view];
        for (TouchRecord * touchRecord in m_touchArray) {
            if (touch == touchRecord.m_id) {
                touchRecord.m_point = thePoint;
                touchRecord.m_phase = touch.phase;
                break;
            }
        }
    }
    
//    UITouch * touch = [touches anyObject];
//    CGPoint point = [touch locationInView:self.view];
//    if ([self isTouchedAccelerate:point]) {
//        accelerateImgView.image = accelerateHLImg;
//    }
//    else{
//        accelerateImgView.image = accelerateImg;
//    }
//    
//    for (UITouch* touch in touches) {
//        CGPoint point = [touch locationInView:self.view];
//        NSLog(@"%f,%f",point.x,point.y);
//    }
//    
//    unsigned long i = [touches count];
//
//    NSLog(@"touches moved %lu",i);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch * touch in touches) {
        for (TouchRecord * touchRecord in m_touchArray) {
            if (touch == touchRecord.m_id) {
                [m_touchArray removeObject:touchRecord];
                break;
            }
        }
    }
//    accelerateImgView.image = accelerateImg;
//    NSLog(@"touches ended");
}

#pragma mark - AsyncUdpSocket Delegate

- (BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port
{
    [socket receiveWithTimeout:-1 tag:0];
    NSLog(@"host---->%@",host);
    
    NSString *info=[[NSString alloc] initWithData:data encoding: NSUTF8StringEncoding];
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示~"message:info delegate:self cancelButtonTitle:@"Ok"otherButtonTitles:nil, nil];
    [alert show];
    NSLog(@"send failed");
    
    NSLog(@"%@",info);
    //已经处理完毕
    
    return YES;
}

- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotReceiveDataWithTag:(long)tag dueToError:(NSError *)error
{
    
}

- (void)onUdpSocket:(AsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示~"message:@"发送成功" delegate:self cancelButtonTitle:@"Ok"otherButtonTitles:nil, nil];
    [alert show];
}

- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示~"message:@"发送失败" delegate:self cancelButtonTitle:@"Ok"otherButtonTitles:nil, nil];
    [alert show];
    NSLog(@"send failed");

}

- (void)onUdpSocketDidClose:(AsyncUdpSocket *)sock
{
    
}

@end
