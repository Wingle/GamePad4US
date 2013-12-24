//
//  HawxViewController.m
//  GamePad4US
//
//  Created by 朱 俊健 on 13-12-23.
//  Copyright (c) 2013年 朱 俊健. All rights reserved.
//

#import "HawxViewController.h"
#import "TouchRecord.h"
#import "NetWork.h"

@interface HawxViewController ()

@end

@implementation HawxViewController

@synthesize hawxNetWork;
@synthesize socket;


#pragma mark - init methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
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
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"hawx_background.png"]]];
    
    //title init
    titleImg = [UIImage imageNamed:@"hawx_title.png"];
    titleImgView = [[UIImageView alloc] initWithImage:titleImg];
    titleImgView.frame = CGRectMake(HAWX_TITLE_X, HAWX_TITLE_Y, titleImg.size.width, titleImg.size.height);
    [self.view addSubview:titleImgView];
    
    //thrust init
    thrustHLImg = [UIImage imageNamed:@"hawx_thrust_HL.png"];
    thrustImg = [UIImage imageNamed:@"hawx_thrust.png"];
    thrustImgView = [[UIImageView alloc]initWithImage:thrustImg];
    thrustImgView.frame = CGRectMake(HAWX_THRUST_X, HAWX_THRUST_Y, thrustImg.size.width, thrustImg.size.height);
    [self.view addSubview:thrustImgView];
    
    //yawleft init
    yawleftHLImg = [UIImage imageNamed:@"hawx_yawleft_HL.png"];
    yawleftImg = [UIImage imageNamed:@"hawx_yawleft.png"];
    yawleftImgView = [[UIImageView alloc]initWithImage:yawleftImg];
    yawleftImgView.frame = CGRectMake(HAWX_YAWLEFT_X, HAWX_YAWLEFT_Y, yawleftImg.size.width, yawleftImg.size.height);
    [self.view addSubview:yawleftImgView];
    
    //yawright init
    yawrightHLImg = [UIImage imageNamed:@"hawx_yawright_HL.png"];
    yawrightImg = [UIImage imageNamed:@"hawx_yawright.png"];
    yawrightImgView = [[UIImageView alloc]initWithImage:yawrightImg];
    yawrightImgView.frame = CGRectMake(HAWX_YAWRIGHT_X, HAWX_YAWRIGHT_Y, yawrightImg.size.width, yawrightImg.size.height);
    [self.view addSubview:yawrightImgView];
    
    //brakes init
    brakesHLImg = [UIImage imageNamed:@"hawx_brakes_HL.png"];
    brakesImg = [UIImage imageNamed:@"hawx_brakes.png"];
    brakesImgView = [[UIImageView alloc]initWithImage:brakesImg];
    brakesImgView.frame = CGRectMake(HAWX_BRAKES_X, HAWX_BRAKES_Y, brakesImg.size.width, brakesImg.size.height);
    [self.view addSubview:brakesImgView];
    
    //cannon init
    cannonHLImg = [UIImage imageNamed:@"hawx_cannon_HL.png"];
    cannonImg = [UIImage imageNamed:@"hawx_cannon.png"];
    cannonImgView = [[UIImageView alloc]initWithImage:cannonImg];
    cannonImgView.frame = CGRectMake(HAWX_CANNON_X, HAWX_CANNON_Y, cannonImg.size.width, cannonImg.size.height);
    [self.view addSubview:cannonImgView];
    
    //weapon init
    weaponHLImg = [UIImage imageNamed:@"hawx_weapon_HL.png"];
    weaponImg = [UIImage imageNamed:@"hawx_weapon.png"];
    weaponImgView = [[UIImageView alloc]initWithImage:weaponImg];
    weaponImgView.frame = CGRectMake(HAWX_WEAPON_X, HAWX_WEAPON_Y, weaponImg.size.width, weaponImg.size.height);
    [self.view addSubview:weaponImgView];
    
    //flares init
    flaresHLImg = [UIImage imageNamed:@"hawx_flares_HL.png"];
    flaresImg = [UIImage imageNamed:@"hawx_flares.png"];
    flaresImgView = [[UIImageView alloc]initWithImage:flaresImg];
    flaresImgView.frame = CGRectMake(HAWX_FLARES_X, HAWX_FLARES_Y, flaresImg.size.width, flaresImg.size.height);
    [self.view addSubview:flaresImgView];
    
    //target init
    targetHLImg = [UIImage imageNamed:@"hawx_target_HL.png"];
    targetImg = [UIImage imageNamed:@"hawx_target.png"];
    targetImgView = [[UIImageView alloc]initWithImage:targetImg];
    targetImgView.frame = CGRectMake(HAWX_TARGET_X, HAWX_TARGET_Y, targetImg.size.width, targetImg.size.height);
    [self.view addSubview:targetImgView];
    
    
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
-(NSUInteger)supportedInterfhawxOrientations{
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

#pragma mrak - Timer
- (void)initTimer
{
    //时间间隔
    NSTimeInterval timeInterval = HAWX_REFRESH_TIME;
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
        if ([self isTouchedByType:thrustType withPoint:touchRecord.m_point]) {
            isTouched = YES;
            break;
        }
    }
    if (isTouched) {
        if (thrustImgView.image == thrustImg) {
            thrustImgView.image = thrustHLImg;
            [self playSound];
            //            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
        }
        [hawxNetWork addKeyMessage:PRESS_HAWX_THRUST withIndex:MESSAGE_ID_KEY_1];
    }
    else{
        thrustImgView.image = thrustImg;
        [hawxNetWork addKeyMessage:RELEASE_HAWX_THRUST withIndex:MESSAGE_ID_KEY_1];
    }
    
    isTouched = NO;
    for (TouchRecord * touchRecord in m_touchArray) {
        if ([self isTouchedByType:yawleftType withPoint:touchRecord.m_point]) {
            isTouched = YES;
            break;
        }
    }
    if (isTouched) {
        if (yawleftImgView.image == yawleftImg) {
            yawleftImgView.image = yawleftHLImg;
            [self playSound];
            //            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
        }
        [hawxNetWork addKeyMessage:PRESS_HAWX_YAWLEFT withIndex:MESSAGE_ID_KEY_1];
    }
    else{
        yawleftImgView.image = yawleftImg;
        [hawxNetWork addKeyMessage:RELEASE_HAWX_YAWLEFT withIndex:MESSAGE_ID_KEY_1];
    }
    
    isTouched = NO;
    for (TouchRecord * touchRecord in m_touchArray) {
        if ([self isTouchedByType:yawrightType withPoint:touchRecord.m_point]) {
            isTouched = YES;
            break;
        }
    }
    if (isTouched) {
        if (yawrightImgView.image == yawrightImg) {
            yawrightImgView.image = yawrightHLImg;
            [self playSound];
            //            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
        }
        [hawxNetWork addKeyMessage:PRESS_HAWX_YAWRIGHT withIndex:MESSAGE_ID_KEY_1];
    }
    else{
        yawrightImgView.image = yawrightImg;
        [hawxNetWork addKeyMessage:RELEASE_HAWX_YAWRIGHT withIndex:MESSAGE_ID_KEY_1];
    }
    
    isTouched = NO;
    for (TouchRecord * touchRecord in m_touchArray) {
        if ([self isTouchedByType:brakesType withPoint:touchRecord.m_point]) {
            isTouched = YES;
            break;
        }
    }
    if (isTouched) {
        if (brakesImgView.image == brakesImg) {
            brakesImgView.image = brakesHLImg;
            [self playSound];
            //            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
        }
        [hawxNetWork addKeyMessage:PRESS_HAWX_BRAKES withIndex:MESSAGE_ID_KEY_1];
    }
    else{
        brakesImgView.image = brakesImg;
        [hawxNetWork addKeyMessage:RELEASE_HAWX_BRAKES withIndex:MESSAGE_ID_KEY_1];
    }
    
    isTouched = NO;
    for (TouchRecord * touchRecord in m_touchArray) {
        if ([self isTouchedByType:cannonType withPoint:touchRecord.m_point]) {
            isTouched = YES;
            break;
        }
    }
    if (isTouched) {
        if (cannonImgView.image == cannonImg) {
            cannonImgView.image = cannonHLImg;
            [self playSound];
            //            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
        }
        [hawxNetWork addKeyMessage:PRESS_HAWX_CANNON withIndex:MESSAGE_ID_KEY_1];
    }
    else{
        cannonImgView.image = cannonImg;
        [hawxNetWork addKeyMessage:RELEASE_HAWX_CANNON withIndex:MESSAGE_ID_KEY_1];
    }
    
    isTouched = NO;
    for (TouchRecord * touchRecord in m_touchArray) {
        if ([self isTouchedByType:flaresType withPoint:touchRecord.m_point]) {
            isTouched = YES;
            break;
        }
    }
    if (isTouched) {
        if (flaresImgView.image == flaresImg) {
            flaresImgView.image = flaresHLImg;
            [self playSound];
            //            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
        }
        [hawxNetWork addKeyMessage:PRESS_HAWX_FLARES withIndex:MESSAGE_ID_KEY_1];
    }
    else{
        flaresImgView.image = flaresImg;
        [hawxNetWork addKeyMessage:RELEASE_HAWX_FLARES withIndex:MESSAGE_ID_KEY_1];
    }
    

    isTouched = NO;
    for (TouchRecord * touchRecord in m_touchArray) {
        if ([self isTouchedByType:weaponType withPoint:touchRecord.m_point]) {
            isTouched = YES;
            break;
        }
    }
    if (isTouched) {
        if (weaponImgView.image == weaponImg) {
            weaponImgView.image = weaponHLImg;
            [self playSound];
            //            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
        }
        [hawxNetWork addKeyMessage:PRESS_HAWX_WEAPON withIndex:MESSAGE_ID_KEY_1];
    }
    else{
        weaponImgView.image = weaponImg;
        [hawxNetWork addKeyMessage:RELEASE_HAWX_WEAPON withIndex:MESSAGE_ID_KEY_1];
    }
    
    isTouched = NO;
    for (TouchRecord * touchRecord in m_touchArray) {
        if ([self isTouchedByType:targetType withPoint:touchRecord.m_point]) {
            isTouched = YES;
            break;
        }
    }
    if (isTouched) {
        if (targetImgView.image == targetImg) {
            targetImgView.image = targetHLImg;
            [self playSound];
            //            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
        }
        [hawxNetWork addKeyMessage:PRESS_HAWX_TARGET withIndex:MESSAGE_ID_KEY_1];
    }
    else{
        targetImgView.image = targetImg;
        [hawxNetWork addKeyMessage:RELEASE_HAWX_TARGET withIndex:MESSAGE_ID_KEY_1];
    }
}

- (void)playSound
{
    
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
    
    [hawxNetWork addKeyMessage:theMotionX withIndex:MESSAGE_ID_X];
    [hawxNetWork addKeyMessage:theMotionY withIndex:MESSAGE_ID_Y];
}

#pragma mark - isTouched
- (BOOL)isTouchedByType:(int)theType withPoint:(CGPoint)thePoint
{
    switch (theType) {
        case thrustType:
            return [self isTouchedOnBtn:thePoint on:thrustImgView withX:HAWX_THRUST_X withY:HAWX_THRUST_Y];
            break;
            
        case yawleftType:
            return [self isTouchedOnBtn:thePoint on:yawleftImgView withX:HAWX_YAWLEFT_X withY:HAWX_YAWLEFT_Y];
            break;
            
        case yawrightType:
            return [self isTouchedOnBtn:thePoint on:yawrightImgView withX:HAWX_YAWRIGHT_X withY:HAWX_YAWRIGHT_Y];
            break;
            
        case brakesType:
            return [self isTouchedOnBtn:thePoint on:brakesImgView withX:HAWX_BRAKES_X withY:HAWX_BRAKES_Y];
            break;
            
        case cannonType:
            return [self isTouchedOnBtn:thePoint on:cannonImgView withX:HAWX_CANNON_X withY:HAWX_CANNON_Y];
            break;
            
        case flaresType:
            return [self isTouchedOnBtn:thePoint on:flaresImgView withX:HAWX_FLARES_X withY:HAWX_FLARES_Y];
            break;
            
        case weaponType:
            return [self isTouchedOnBtn:thePoint on:weaponImgView withX:HAWX_WEAPON_X withY:HAWX_WEAPON_Y];
            break;
            
        case targetType:
            return [self isTouchedOnBtn:thePoint on:targetImgView withX:HAWX_TARGET_X withY:HAWX_TARGET_Y];
            break;
        default:
            break;
    }
    return [self isTouchedOnBtn:thePoint on:thrustImgView withX:HAWX_THRUST_X withY:HAWX_THRUST_Y];
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

@end
