//
//  XBoxViewController.m
//  GamePad4US
//
//  Created by 朱 俊健 on 14-2-24.
//  Copyright (c) 2014年 朱 俊健. All rights reserved.
//

#import "XBoxViewController.h"
#import "TouchRecord.h"
#import "NetWork.h"

@interface XBoxViewController ()

@end

@implementation XBoxViewController

@synthesize xboxNetWork;
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
        
        [self.view setMultipleTouchEnabled:YES];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //设置重力感应
    motionManager = [[CMMotionManager alloc]init];
    
    //设置背景图
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"xbox_background.png"]]];
    
    //cross init
    crossImg = [UIImage imageNamed:@"xbox_cross.png"];
    crossImgView = [[UIImageView alloc] initWithImage:crossImg];
    crossImgView.frame = CGRectMake(XBOX_CROSS_X, XBOX_CROSS_Y, crossImg.size.width, crossImg.size.height);
    [self.view addSubview:crossImgView];
    
    //rb init
    rbHLImg = [UIImage imageNamed:@"xbox_rb_HL.png"];
    rbImg = [UIImage imageNamed:@"xbox_rb.png"];
    rbImgView = [[UIImageView alloc]initWithImage:rbImg];
    rbImgView.frame = CGRectMake(XBOX_RB_X, XBOX_RB_Y, rbImg.size.width, rbImg.size.height);
    [self.view addSubview:rbImgView];
    
    //lb init
    lbHLImg = [UIImage imageNamed:@"xbox_lb_HL.png"];
    lbImg = [UIImage imageNamed:@"xbox_lb.png"];
    lbImgView = [[UIImageView alloc]initWithImage:lbImg];
    lbImgView.frame = CGRectMake(XBOX_LB_X, XBOX_LB_Y, lbImg.size.width, lbImg.size.height);
    [self.view addSubview:lbImgView];
    
    //lt init
    ltHLImg = [UIImage imageNamed:@"xbox_lt_HL.png"];
    ltImg = [UIImage imageNamed:@"xbox_lt.png"];
    ltImgView = [[UIImageView alloc]initWithImage:ltImg];
    ltImgView.frame = CGRectMake(XBOX_LT_X, XBOX_LT_Y, ltImg.size.width, ltImg.size.height);
    [self.view addSubview:ltImgView];
    
    //rt init
    rtHLImg = [UIImage imageNamed:@"xbox_rt_HL.png"];
    rtImg = [UIImage imageNamed:@"xbox_rt.png"];
    rtImgView = [[UIImageView alloc]initWithImage:rtImg];
    rtImgView.frame = CGRectMake(XBOX_RT_X, XBOX_RT_Y, rtImg.size.width, rtImg.size.height);
    [self.view addSubview:rtImgView];
    
    //y init
    yHLImg = [UIImage imageNamed:@"xbox_y_HL.png"];
    yImg = [UIImage imageNamed:@"xbox_y.png"];
    yImgView = [[UIImageView alloc]initWithImage:yImg];
    yImgView.frame = CGRectMake(XBOX_Y_X, XBOX_Y_Y, yImg.size.width, yImg.size.height);
    [self.view addSubview:yImgView];
    
    //b init
    bHLImg = [UIImage imageNamed:@"xbox_b_HL.png"];
    bImg = [UIImage imageNamed:@"xbox_b.png"];
    bImgView = [[UIImageView alloc]initWithImage:bImg];
    bImgView.frame = CGRectMake(XBOX_B_X, XBOX_B_Y, bImg.size.width, bImg.size.height);
    [self.view addSubview:bImgView];
    
    //a init
    aHLImg = [UIImage imageNamed:@"xbox_a_HL.png"];
    aImg = [UIImage imageNamed:@"xbox_a.png"];
    aImgView = [[UIImageView alloc]initWithImage:aImg];
    aImgView.frame = CGRectMake(XBOX_A_X, XBOX_A_Y, aImg.size.width, aImg.size.height);
    [self.view addSubview:aImgView];
    
    //x init
    xHLImg = [UIImage imageNamed:@"xbox_x_HL.png"];
    xImg = [UIImage imageNamed:@"xbox_x.png"];
    xImgView = [[UIImageView alloc]initWithImage:xImg];
    xImgView.frame = CGRectMake(XBOX_X_X, XBOX_X_Y, xImg.size.width, xImg.size.height);
    [self.view addSubview:xImgView];
    
    //判定区域
    //up init
    upImg = [UIImage imageNamed:@"xbox_up.png"];
    upImgView = [[UIImageView alloc] initWithImage:upImg];
    upImgView.frame = CGRectMake(XBOX_UP_X, XBOX_UP_Y, upImg.size.width, upImg.size.height);
    
    //down init
    downImg = [UIImage imageNamed:@"xbox_down.png"];
    downImgView = [[UIImageView alloc] initWithImage:downImg];
    downImgView.frame = CGRectMake(XBOX_DOWN_X, XBOX_DOWN_Y, downImg.size.width, downImg.size.height);
    
    //left init
    leftImg = [UIImage imageNamed:@"xbox_left.png"];
    leftImgView = [[UIImageView alloc] initWithImage:leftImg];
    leftImgView.frame = CGRectMake(XBOX_LEFT_X, XBOX_LEFT_Y, leftImg.size.width, leftImg.size.height);
    
    //right init
    rightImg = [UIImage imageNamed:@"xbox_right.png"];
    rightImgView = [[UIImageView alloc] initWithImage:rightImg];
    rightImgView.frame = CGRectMake(XBOX_RIGHT_X, XBOX_RIGHT_Y, rightImg.size.width, rightImg.size.height);
    
    //选择暂停按钮 init
    UIImage * startImg = [UIImage imageNamed:@"xbox_start.png"];
    UIImage * startHLImg = [UIImage imageNamed:@"xbox_start_HL.png"];
    UIButton * startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [startBtn setImage:startImg forState:UIControlStateNormal];
    [startBtn setImage:startHLImg forState:UIControlStateHighlighted];
    startBtn.frame = CGRectMake(XBOX_START_X, XBOX_START_Y, startImg.size.width, startImg.size.height);
    [startBtn addTarget:self action:@selector(onPressStart:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startBtn];

    UIImage * selectImg = [UIImage imageNamed:@"xbox_select.png"];
    UIImage * selectHLImg = [UIImage imageNamed:@"xbox_select_HL.png"];
    UIButton * selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectBtn setImage:selectImg forState:UIControlStateNormal];
    [selectBtn setImage:selectHLImg forState:UIControlStateHighlighted];
    selectBtn.frame = CGRectMake(XBOX_SELECT_X, XBOX_SELECT_Y, selectImg.size.width, selectImg.size.height);
    [selectBtn addTarget:self action:@selector(onPressSelect:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectBtn];
    
    
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
-(NSUInteger)supportedInterfxboxOrientations{
    return UIInterfaceOrientationMaskLandscapeLeft;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

//隐藏StateBar
- (BOOL)prefersStatusBarHidden
{
    return YES;
}
#pragma mrak - Timer
- (void)initTimer
{
    //时间间隔
    NSTimeInterval timeInterval = XBOX_REFRESH_TIME;
    //定时器
    NSTimer *showTimer;
    showTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(checkTouchedBtnWithTimer:)userInfo:nil repeats:YES];
}

- (void)checkTouchedBtnWithTimer:(NSTimer *)theTimer
{
    //    [self checkButtonsAndChangeBtnState];
    //
    //    [self checkButtonsAndSendMessages];
    
    [self checkButtonsAndChangeStateAndSendMessages];
    
    [self checkMotionStateAndSendMessage];
}
- (void)checkButtonsAndChangeStateAndSendMessages
{
    BOOL isTouched = NO;
    for (TouchRecord * touchRecord in m_touchArray) {
        if ([self isTouchedByType:rbType withPoint:touchRecord.m_point]) {
            isTouched = YES;
            break;
        }
    }
    if (isTouched) {
        if (rbImgView.image == rbImg) {
            rbImgView.image = rbHLImg;
            [self playSoundAndShock];
            //            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
        }
        [xboxNetWork addKeyMessage:PRESS_XBOX_RB withIndex:MESSAGE_ID_KEY_1];
    }
    else{
        rbImgView.image = rbImg;
        [xboxNetWork addKeyMessage:RELEASE_XBOX_RB withIndex:MESSAGE_ID_KEY_1];
    }
    
    isTouched = NO;
    for (TouchRecord * touchRecord in m_touchArray) {
        if ([self isTouchedByType:lbType withPoint:touchRecord.m_point]) {
            isTouched = YES;
            break;
        }
    }
    if (isTouched) {
        if (lbImgView.image == lbImg) {
            lbImgView.image = lbHLImg;
            [self playSoundAndShock];
            //            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
        }
        [xboxNetWork addKeyMessage:PRESS_XBOX_LB withIndex:MESSAGE_ID_KEY_1];
    }
    else{
        lbImgView.image = lbImg;
        [xboxNetWork addKeyMessage:RELEASE_XBOX_LB withIndex:MESSAGE_ID_KEY_1];
    }
    
    isTouched = NO;
    for (TouchRecord * touchRecord in m_touchArray) {
        if ([self isTouchedByType:ltType withPoint:touchRecord.m_point]) {
            isTouched = YES;
            break;
        }
    }
    if (isTouched) {
        if (ltImgView.image == ltImg) {
            ltImgView.image = ltHLImg;
            [self playSoundAndShock];
            //            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
        }
        [xboxNetWork addKeyMessage:PRESS_XBOX_LT withIndex:MESSAGE_ID_KEY_1];
    }
    else{
        ltImgView.image = ltImg;
        [xboxNetWork addKeyMessage:RELEASE_XBOX_LT withIndex:MESSAGE_ID_KEY_1];
    }
    
    isTouched = NO;
    for (TouchRecord * touchRecord in m_touchArray) {
        if ([self isTouchedByType:rtType withPoint:touchRecord.m_point]) {
            isTouched = YES;
            break;
        }
    }
    if (isTouched) {
        if (rtImgView.image == rtImg) {
            rtImgView.image = rtHLImg;
            [self playSoundAndShock];
            //            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
        }
        [xboxNetWork addKeyMessage:PRESS_XBOX_RT withIndex:MESSAGE_ID_KEY_1];
    }
    else{
        rtImgView.image = rtImg;
        [xboxNetWork addKeyMessage:RELEASE_XBOX_RT withIndex:MESSAGE_ID_KEY_1];
    }
    
    isTouched = NO;
    for (TouchRecord * touchRecord in m_touchArray) {
        if ([self isTouchedByType:yType withPoint:touchRecord.m_point]) {
            isTouched = YES;
            break;
        }
    }
    if (isTouched) {
        if (yImgView.image == yImg) {
            yImgView.image = yHLImg;
            [self playSoundAndShock];
            //            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
        }
        [xboxNetWork addKeyMessage:PRESS_XBOX_Y withIndex:MESSAGE_ID_KEY_2];
    }
    else{
        yImgView.image = yImg;
        [xboxNetWork addKeyMessage:RELEASE_XBOX_Y withIndex:MESSAGE_ID_KEY_2];
    }
    
    isTouched = NO;
    for (TouchRecord * touchRecord in m_touchArray) {
        if ([self isTouchedByType:aType withPoint:touchRecord.m_point]) {
            isTouched = YES;
            break;
        }
    }
    if (isTouched) {
        if (aImgView.image == aImg) {
            aImgView.image = aHLImg;
            [self playSoundAndShock];
            //            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
        }
        [xboxNetWork addKeyMessage:PRESS_XBOX_A withIndex:MESSAGE_ID_KEY_2];
    }
    else{
        aImgView.image = aImg;
        [xboxNetWork addKeyMessage:RELEASE_XBOX_A withIndex:MESSAGE_ID_KEY_2];
    }
    
    
    isTouched = NO;
    for (TouchRecord * touchRecord in m_touchArray) {
        if ([self isTouchedByType:bType withPoint:touchRecord.m_point]) {
            isTouched = YES;
            break;
        }
    }
    if (isTouched) {
        if (bImgView.image == bImg) {
            bImgView.image = bHLImg;
            [self playSoundAndShock];
            //            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
        }
        [xboxNetWork addKeyMessage:PRESS_XBOX_B withIndex:MESSAGE_ID_KEY_2];
    }
    else{
        bImgView.image = bImg;
        [xboxNetWork addKeyMessage:RELEASE_XBOX_B withIndex:MESSAGE_ID_KEY_2];
    }
    
    isTouched = NO;
    for (TouchRecord * touchRecord in m_touchArray) {
        if ([self isTouchedByType:xType withPoint:touchRecord.m_point]) {
            isTouched = YES;
            break;
        }
    }
    if (isTouched) {
        if (xImgView.image == xImg) {
            xImgView.image = xHLImg;
            [self playSoundAndShock];
            //            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
        }
        [xboxNetWork addKeyMessage:PRESS_XBOX_X withIndex:MESSAGE_ID_KEY_2];
    }
    else{
        xImgView.image = xImg;
        [xboxNetWork addKeyMessage:RELEASE_XBOX_X withIndex:MESSAGE_ID_KEY_2];
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


- (void)checkMotionStateAndSendMessage
{
    [motionManager startDeviceMotionUpdates];
    double gravityX = motionManager.deviceMotion.gravity.x;
    double gravityY = motionManager.deviceMotion.gravity.y;
    //    double gravityZ = motionManager.deviceMotion.gravity.z;
    //    double zTheta = atan2(gravityZ,sqrtf(gravityX*gravityX+gravityY*gravityY))/M_PI*180.0;
    int theRotationX = gravityY * 90 + 90;
    
    int theRotationY = gravityX * 90 + 90;
    
    //旋转角度微调，旋转小于15度就直接判定不转
    //    if ((theRotationX > 75)&&(theRotationX < 105)) {
    //        theRotationX = 90;
    //    }
    //    if ((theRotationY > 75)&&(theRotationY < 105)) {
    //        theRotationY = 90;
    //    }
    
    
    NSString * theMotionX = [NSString stringWithFormat:@"%d#",theRotationX];
    NSString * theMotionY = [NSString stringWithFormat:@"%d#",theRotationY];
    motionLabel.text = [NSString stringWithFormat:@"X:%@ Y:%@",theMotionX,theMotionY];
    
    [xboxNetWork addKeyMessage:theMotionX withIndex:MESSAGE_ID_X];
    [xboxNetWork addKeyMessage:theMotionY withIndex:MESSAGE_ID_Y];
}

#pragma mark - isTouched
- (BOOL)isTouchedByType:(int)theType withPoint:(CGPoint)thePoint
{
    switch (theType) {
        case rbType:
            return [self isTouchedOnBtn:thePoint on:upImgView withX:XBOX_UP_X withY:XBOX_UP_Y];
            break;
            
        case lbType:
            return [self isTouchedOnBtn:thePoint on:leftImgView withX:XBOX_LEFT_X withY:XBOX_LEFT_Y];
            break;
            
        case ltType:
            return [self isTouchedOnBtn:thePoint on:rightImgView withX:XBOX_RIGHT_X withY:XBOX_RIGHT_Y];
            break;
            
        case rtType:
            return [self isTouchedOnBtn:thePoint on:downImgView withX:XBOX_DOWN_X withY:XBOX_DOWN_Y];
            break;
            
        case yType:
            return [self isTouchedOnBtn:thePoint on:yImgView withX:XBOX_Y_X withY:XBOX_Y_Y];
            break;
            
        case aType:
            return [self isTouchedOnBtn:thePoint on:aImgView withX:XBOX_A_X withY:XBOX_A_Y];
            break;
            
        case bType:
            return [self isTouchedOnBtn:thePoint on:bImgView withX:XBOX_B_X withY:XBOX_B_Y];
            break;
            
        case xType:
            return [self isTouchedOnBtn:thePoint on:xImgView withX:XBOX_X_X withY:XBOX_X_Y];
            break;
        default:
            break;
    }
    return [self isTouchedOnBtn:thePoint on:rbImgView withX:XBOX_RB_X withY:XBOX_RB_Y];
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


#pragma mark - gesture to exit
- (IBAction)gestureToExit:(id)sender
{
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


#pragma mark - 选择和开始按钮事件
- (IBAction)onPressSelect:(id)sender
{
    [xboxNetWork addKeyMessage:PRESS_XBOX_SELECT withIndex:MESSAGE_ID_KEY_3];
    NSTimer * sendReleaseSelect;
    sendReleaseSelect = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(onReleaseSelect:) userInfo:nil repeats:NO];
}

- (IBAction)onPressStart:(id)sender
{
    [xboxNetWork addKeyMessage:PRESS_XBOX_START withIndex:MESSAGE_ID_KEY_3];
    NSTimer * sendReleaseStart;
    sendReleaseStart = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(onReleaseStart:) userInfo:nil repeats:NO];
}

- (IBAction)onReleaseSelect:(id)sender
{
    [xboxNetWork addKeyMessage:RELEASE_XBOX_SELECT withIndex:MESSAGE_ID_KEY_3];
}

- (IBAction)onReleaseStart:(id)sender
{
    [xboxNetWork addKeyMessage:RELEASE_XBOX_START withIndex:MESSAGE_ID_KEY_3];
}

@end
