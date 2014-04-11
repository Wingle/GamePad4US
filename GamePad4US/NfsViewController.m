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
@synthesize playShock;
@synthesize playSound;

#pragma mark - init methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        NSURL* system_sound_url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"click" ofType:@"wav"]];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)system_sound_url,&soundID);
        
        shockID = kSystemSoundID_Vibrate;

        playShock = NO;
        playSound = YES;
        
        //Important!!! setMutipleTouch
        [self.view setMultipleTouchEnabled:YES];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //设置重力感应
    motionManager = [[CMMotionManager alloc]init];
    
    //设置背景图
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"nfs_background.png"]]];
    
    //初始化控件数组
    imgViewArray = [NSMutableArray arrayWithCapacity:6];
    normalImgArray = [NSMutableArray arrayWithCapacity:6];
    highlightImgArray = [NSMutableArray arrayWithCapacity:6];
    
    //accelerate init
    accelerateHLImg = [UIImage imageNamed:@"nfs_accelerate_HL.png"];
    accelerateImg = [UIImage imageNamed:@"nfs_accelerate.png"];
    accelerateImgView = [[UIImageView alloc]initWithImage:accelerateImg];
    accelerateImgView.frame = CGRectMake(ACCELERATE_X, ACCELERATE_Y, accelerateImg.size.width, accelerateImg.size.height);
    [self.view addSubview:accelerateImgView];
    
    [imgViewArray addObject:accelerateImgView];
    [normalImgArray addObject:accelerateImg];
    [highlightImgArray addObject:accelerateHLImg];
    
    //shiftup init
    shiftUpHLImg = [UIImage imageNamed:@"nfs_shiftup_HL.png"];
    shiftUpImg = [UIImage imageNamed:@"nfs_shiftup.png"];
    shiftUpImgView = [[UIImageView alloc]initWithImage:shiftUpImg];
    shiftUpImgView.frame = CGRectMake(SHIFTUP_X, SHIFTUP_Y, shiftUpImg.size.width, shiftUpImg.size.height);
    [self.view addSubview:shiftUpImgView];
    
    [imgViewArray addObject:shiftUpImgView];
    [normalImgArray addObject:shiftUpImg];
    [highlightImgArray addObject:shiftUpHLImg];

    //shiftdown init
    shiftDownHLImg = [UIImage imageNamed:@"nfs_shiftdown_HL.png"];
    shiftDownImg = [UIImage imageNamed:@"nfs_shiftdown.png"];
    shiftDownImgView = [[UIImageView alloc]initWithImage:shiftDownImg];
    shiftDownImgView.frame = CGRectMake(SHIFTDOWN_X, SHIFTDOWN_Y, shiftDownImg.size.width, shiftDownImg.size.height);
    [self.view addSubview:shiftDownImgView];
    
    [imgViewArray addObject:shiftDownImgView];
    [normalImgArray addObject:shiftDownImg];
    [highlightImgArray addObject:shiftDownHLImg];
    
    
    //n2 init
    n2HLImg = [UIImage imageNamed:@"nfs_n2_HL.png"];
    n2Img = [UIImage imageNamed:@"nfs_n2.png"];
    n2ImgView = [[UIImageView alloc]initWithImage:n2Img];
    n2ImgView.frame = CGRectMake(N2_X, N2_Y, n2Img.size.width, n2Img.size.height);
    [self.view addSubview:n2ImgView];
    
    [imgViewArray addObject:n2ImgView];
    [normalImgArray addObject:n2Img];
    [highlightImgArray addObject:n2HLImg];
    
    
    //handbreak init
    handBreakHLImg = [UIImage imageNamed:@"nfs_handbreak_HL.png"];
    handBreakImg = [UIImage imageNamed:@"nfs_handbreak.png"];
    handBreakImgView = [[UIImageView alloc]initWithImage:handBreakImg];
    handBreakImgView.frame = CGRectMake(HANDBREAK_X, HANDBREAK_Y, handBreakImg.size.width, handBreakImg.size.height);
    [self.view addSubview:handBreakImgView];
    
    [imgViewArray addObject:handBreakImgView];
    [normalImgArray addObject:handBreakImg];
    [highlightImgArray addObject:handBreakHLImg];
    
    //break init
    breakHLImg = [UIImage imageNamed:@"nfs_break_HL.png"];
    breakImg = [UIImage imageNamed:@"nfs_break.png"];
    breakImgView = [[UIImageView alloc]initWithImage:breakImg];
    breakImgView.frame = CGRectMake(BREAK_X, BREAK_Y, breakImg.size.width, breakImg.size.height);
    [self.view addSubview:breakImgView];
    
    [imgViewArray addObject:breakImgView];
    [normalImgArray addObject:breakImg];
    [highlightImgArray addObject:breakHLImg];
    
    //motion label init
    motionLabel = [[UILabel alloc] init];
    motionLabel.frame = CGRectMake(0, 10, 500, 20);
    motionLabel.text = @"0";
//    [self.view addSubview:motionLabel];
    
    //Timer init and start
    [self initTimer];
    
    //touches init
    m_touchArray = [[NSMutableArray alloc] init];
    

    //gesture init
    UISwipeGestureRecognizer * gestureExit = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gestureToExit:)];
    [gestureExit setDirection:UISwipeGestureRecognizerDirectionDown];
    [gestureExit setDelegate:self];
    [gestureExit setNumberOfTouchesRequired:2];
    [self.view addGestureRecognizer:gestureExit];
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
    showTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(checkTouchedBtnWithTimer:)userInfo:nil repeats:YES];
}

//timer selector
- (void)checkTouchedBtnWithTimer:(NSTimer *)theTimer
{
    [self checkButtonsAndChangeStateAndSendMessages];
    
    [self checkMotionStateAndSendMessage];
}



- (void)checkButtonsAndChangeStateAndSendMessages
{
    //总共6个按钮，i为按钮的类型，为枚举，每个按钮分别做一次遍历
    for (int i = accelerateType; i <= breakType; i++) {
        //判断触摸点是否点击到这个按钮
        BOOL isTouched = NO;
        
        //每个触摸点做一次判断，touchRecord为遍历中的一个触摸点
        for (TouchRecord * touchRecord in m_touchArray) {
            //判断这个触摸点是否能触摸到当前按钮，如果触摸到了，就退出当前循环
            if ([self isTouchedByType:i withPoint:touchRecord.m_point]) {
                isTouched = YES;
                break;
            }
        }
        
        //根据按钮类型和是否被触摸来改变按钮的状态
        [self changeButtonStateWithType:i Touched:isTouched];
    }
}

- (void)checkMotionStateAndSendMessage
{
    [motionManager startDeviceMotionUpdates];
//    double gravityX = motionManager.deviceMotion.gravity.x;
    double gravityY = motionManager.deviceMotion.gravity.y;
//    double gravityZ = motionManager.deviceMotion.gravity.z;

    int theRotation = gravityY * 90 + 90;
    NSString * theMotion = [NSString stringWithFormat:@"%d#",theRotation];
    motionLabel.text = theMotion;
    
    [nfsNetWork addKeyMessage:theMotion withIndex:MESSAGE_ID_X];
}

#pragma mark - 按下按钮效果
- (void)changeButtonStateWithType:(int)theType Touched:(BOOL)isTouched
{
    UIImageView * theTouchedImgView = imgViewArray[theType];
    UIImage * theTouchedImg = normalImgArray[theType];
    UIImage * theTouchedHLImg = highlightImgArray[theType];
    
    if (isTouched) {
        if (theTouchedImgView.image == theTouchedImg) {
            theTouchedImgView.image = theTouchedHLImg;
            [self playSoundAndShock];
        }
        [self sendMessageWithType:theType pressed:YES];
    }
    else{
        theTouchedImgView.image = theTouchedImg;
        [self sendMessageWithType:theType pressed:NO];
    }
}

- (void)playSoundAndShock
{
    if (playSound) {
        AudioServicesPlaySystemSound(soundID);
    }
    if (playShock) {
        AudioServicesPlaySystemSound(shockID);
    }
}

- (void)sendMessageWithType:(int)theType pressed:(BOOL)isPressed
{
    NSString * message;
    int index = 0;
    switch (theType) {
        case accelerateType:
            if (isPressed) {
                message = PRESS_ACCELERATE;
            }
            else{
                message = RELEASE_ACCELERATE;
            }
            index = MESSAGE_ID_KEY_1;
            break;
        case shiftUpType:
            if (isPressed) {
                message = PRESS_SHIFTUP;
            }
            else{
                message = RELEASE_SHIFTUP;
            }
            index = MESSAGE_ID_KEY_2;
            break;
        case shiftDownType:
            if (isPressed) {
                message = PRESS_SHIFTDOWN;
            }
            else{
                message = RELEASE_SHIFTDOWN;
            }
            index = MESSAGE_ID_KEY_2;
            break;
        case n2Type:
            if (isPressed) {
                message = PRESS_N2;
            }
            else{
                message = RELEASE_N2;
            }
            index = MESSAGE_ID_KEY_2;
            break;
        case handBreakType:
            if (isPressed) {
                message = PRESS_HANDBREAK;
            }
            else{
                message = RELEASE_HANDBREAK;
            }
            index = MESSAGE_ID_KEY_2;
            break;
        case breakType:
            if (isPressed) {
                message = PRESS_BREAK;
            }
            else{
                message = RELEASE_BREAK;
            }
            index = MESSAGE_ID_KEY_2;
            break;
        default:
            break;
    }
    
    [nfsNetWork addKeyMessage:message withIndex:index];
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
}

#pragma mark - gesture to exit
- (IBAction)gestureToExit:(id)sender
{
    [nfsNetWork releaseAllKeys];
    [showTimer invalidate];
    showTimer = Nil;
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint currentPoint = [gestureRecognizer locationInView:self.view];
    if (CGRectContainsPoint(EXIT_AREA, currentPoint)) {
        return YES;
    }
    return NO;
}
@end
