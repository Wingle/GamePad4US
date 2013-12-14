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

@synthesize nfsNetWork;
@synthesize socket;


#pragma mark - init methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        nfsNetWork = [[NetWork alloc] init];
        [nfsNetWork start];
        
        //Important!!! setMutipleTouch
        [self.view setMultipleTouchEnabled:YES];
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.]
    
    //设置重力感应
    motionManager = [[CMMotionManager alloc]init];
    
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
    
    
    //motion label init
    motionLabel = [[UILabel alloc] init];
    motionLabel.frame = CGRectMake(0, 10, 500, 20);
    motionLabel.text = @"0";
    [self.view addSubview:motionLabel];
    
    //Timer init and start
    [self initTimer];
    
    //touches init
    m_touchArray = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//使客户端一直保持横屏
-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscapeLeft;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

//隐藏StateBar
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - NSTimer

- (void)initTimer
{
    //时间间隔
    NSTimeInterval timeInterval = NFS_REFRESH_TIME;
    //定时器
    NSTimer *showTimer;
    showTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(checkTouchedBtnWithTimer:)userInfo:nil repeats:YES];
}

//timer selector
- (void)checkTouchedBtnWithTimer:(NSTimer *)theTimer
{
//    NSLog(@"开始检查按钮的状态");
    [self checkButtonsAndChangeBtnState];
    
//    NSLog(@"开始检查按钮并发送状态");
    [self checkButtonsAndSendMessages];
    
//    NSLog(@"开始检查陀螺仪并发送状态");
    [self checkMotionStateAndSendMessage];
    
//    NSLog(@"检查完毕");
}

//check buttons and change state to HL or NOR
- (void)checkButtonsAndChangeBtnState
{
//    accelerateImgView.image = accelerateImg;
//    shiftUpImgView.image = shiftUpImg;
//    shiftDownImgView.image = shiftDownImg;
//    n2ImgView.image = n2Img;
//    handBreakImgView.image = handBreakImg;
//    breakImgView.image = breakImg;
    BOOL theAcce = NO,theSU= NO,theSD= NO,theHB= NO,theB= NO,theN2= NO;
    for (TouchRecord * touchRecord in m_touchArray) {
        if ([self isTouchedByType:accelerateType withPoint:touchRecord.m_point]) {
            theAcce = YES;
//            accelerateImgView.image = accelerateHLImg;
            continue;
        }
        if ([self isTouchedByType:shiftUpType withPoint:touchRecord.m_point]) {
            theSU = YES;
//            shiftUpImgView.image = shiftUpHLImg;
            continue;
        }
        if ([self isTouchedByType:shiftDownType withPoint:touchRecord.m_point]) {
            theSD = YES;
//            shiftDownImgView.image = shiftDownHLImg;
            continue;
        }
        if ([self isTouchedByType:n2Type withPoint:touchRecord.m_point]) {
            theN2 = YES;
//            n2ImgView.image = n2HLImg;
            continue;
        }
        if ([self isTouchedByType:handBreakType withPoint:touchRecord.m_point]) {
            theHB = YES;
//            handBreakImgView.image = handBreakHLImg;
            continue;
        }
        if ([self isTouchedByType:breakType withPoint:touchRecord.m_point]) {
            theB = YES;
//            breakImgView.image = breakHLImg;
            continue;
        }
    }
    
    if (theAcce) {
        if (accelerateImgView.image == accelerateImg) {
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
        }
        accelerateImgView.image = accelerateHLImg;
    }
    else{
        accelerateImgView.image = accelerateImg;
    }
    
    if (theSU) {
        if (shiftUpImgView.image == shiftUpImg) {
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
        }
        shiftUpImgView.image = shiftUpHLImg;
    }
    else{
        shiftUpImgView.image = shiftUpImg;
    }
    
    if (theSD) {
        if (shiftDownImgView.image == shiftDownImg) {
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
        }
        shiftDownImgView.image = shiftDownHLImg;
    }
    else{
        shiftDownImgView.image = shiftDownImg;
    }
    
    if (theN2) {
        if (n2ImgView.image == n2Img) {
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
        }
        n2ImgView.image = n2HLImg;
    }
    else{
        n2ImgView.image = n2Img;
    }
    
    if (theHB) {
        if (handBreakImgView.image == handBreakImg) {
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
        }
        handBreakImgView.image = handBreakHLImg;
    }
    else{
        handBreakImgView.image = handBreakImg;
    }
    
    if (theB) {
        if (breakImgView.image == breakImg) {
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
        }
        breakImgView.image = breakHLImg;
    }
    else{
        breakImgView.image = breakImg;
    }
    
}

//check buttons and send message to network
- (void)checkButtonsAndSendMessages
{
    if (accelerateImgView.image == accelerateHLImg) {
        [nfsNetWork addKeyMessage:PRESS_ACCELERATE withIndex:MESSAGE_ID_KEY_1];
    }
    else{
        [nfsNetWork addKeyMessage:RELEASE_ACCELERATE withIndex:MESSAGE_ID_KEY_1];
    }
    
    if (shiftUpImgView.image == shiftUpHLImg) {
        [nfsNetWork addKeyMessage:PRESS_SHIFTUP withIndex:MESSAGE_ID_KEY_2];
    }
    else{
        [nfsNetWork addKeyMessage:RELEASE_SHIFTUP withIndex:MESSAGE_ID_KEY_2];
    }
    
    if (shiftDownImgView.image == shiftDownHLImg) {
        [nfsNetWork addKeyMessage:PRESS_SHIFTDOWN withIndex:MESSAGE_ID_KEY_2];
    }
    else{
        [nfsNetWork addKeyMessage:RELEASE_SHIFTDOWN withIndex:MESSAGE_ID_KEY_2];
    }
    
    if (n2ImgView.image == n2HLImg) {
        [nfsNetWork addKeyMessage:PRESS_N2 withIndex:MESSAGE_ID_KEY_1];
    }
    else{
        [nfsNetWork addKeyMessage:RELEASE_N2 withIndex:MESSAGE_ID_KEY_1];
    }
    
    if (handBreakImgView.image == handBreakHLImg) {
        [nfsNetWork addKeyMessage:PRESS_HANDBREAK withIndex:MESSAGE_ID_KEY_3];
    }
    else{
        [nfsNetWork addKeyMessage:RELEASE_HANDBREAK withIndex:MESSAGE_ID_KEY_3];
    }
    
    if (breakImgView.image == breakHLImg) {
        [nfsNetWork addKeyMessage:PRESS_BREAK withIndex:MESSAGE_ID_KEY_3];
    }
    else{
        [nfsNetWork addKeyMessage:RELEASE_BREAK withIndex:MESSAGE_ID_KEY_3];
    }
    
}

- (void)checkMotionStateAndSendMessage
{
    [motionManager startDeviceMotionUpdates];
//    double gravityX = motionManager.deviceMotion.gravity.x;
    double gravityY = motionManager.deviceMotion.gravity.y;
//    double gravityZ = motionManager.deviceMotion.gravity.z;
//    double zTheta = atan2(gravityZ,sqrtf(gravityX*gravityX+gravityY*gravityY))/M_PI*180.0;
    int theRotation = gravityY * 90 + 90;
    if ((theRotation > 80)&&(theRotation < 100)) {
        theRotation = 90;
    }
    NSString * theMotion = [NSString stringWithFormat:@"%d#",theRotation];
    motionLabel.text = theMotion;
    
    [nfsNetWork addKeyMessage:theMotion withIndex:MESSAGE_ID_X];
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
    
//    NSLog(@"alpha = %f",alpha);
    
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
//    NSLog(@"touches begin");
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
//    NSLog(@"touches moved");
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
