//
//  AceViewController.m
//  GamePad4US
//
//  Created by 朱 俊健 on 13-12-23.
//  Copyright (c) 2013年 朱 俊健. All rights reserved.
//

#import "AceViewController.h"
#import "TouchRecord.h"
#import "NetWork.h"

@interface AceViewController ()

@end

@implementation AceViewController

@synthesize aceNetWork;
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
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"ace_background.jpg"]]];
    
    //title init
    titleImg = [UIImage imageNamed:@"ace_title.png"];
    titleImgView = [[UIImageView alloc] initWithImage:titleImg];
    titleImgView.frame = CGRectMake(TITLE_X, TITLE_Y, titleImg.size.width, titleImg.size.height);
    [self.view addSubview:titleImgView];
    
    //thrust init
    thrustHLImg = [UIImage imageNamed:@"ace_thrust_HL.png"];
    thrustImg = [UIImage imageNamed:@"ace_thrust.png"];
    thrustImgView = [[UIImageView alloc]initWithImage:thrustImg];
    thrustImgView.frame = CGRectMake(THRUST_X, THRUST_Y, thrustImg.size.width, thrustImg.size.height);
    [self.view addSubview:thrustImgView];
    
    //yawleft init
    yawleftHLImg = [UIImage imageNamed:@"ace_yawleft_HL.png"];
    yawleftImg = [UIImage imageNamed:@"ace_yawleft.png"];
    yawleftImgView = [[UIImageView alloc]initWithImage:yawleftImg];
    yawleftImgView.frame = CGRectMake(YAWLEFT_X, YAWLEFT_Y, yawleftImg.size.width, yawleftImg.size.height);
    [self.view addSubview:yawleftImgView];
    
    //yawright init
    yawrightHLImg = [UIImage imageNamed:@"ace_yawright_HL.png"];
    yawrightImg = [UIImage imageNamed:@"ace_yawright.png"];
    yawrightImgView = [[UIImageView alloc]initWithImage:yawrightImg];
    yawrightImgView.frame = CGRectMake(YAWRIGHT_X, YAWRIGHT_Y, yawrightImg.size.width, yawrightImg.size.height);
    [self.view addSubview:yawrightImgView];
    
    //brakes init
    brakesHLImg = [UIImage imageNamed:@"ace_brakes_HL.png"];
    brakesImg = [UIImage imageNamed:@"ace_brakes.png"];
    brakesImgView = [[UIImageView alloc]initWithImage:brakesImg];
    brakesImgView.frame = CGRectMake(BRAKES_X, BRAKES_Y, brakesImg.size.width, brakesImg.size.height);
    [self.view addSubview:brakesImgView];
    
    //cannon init
    cannonHLImg = [UIImage imageNamed:@"ace_cannon_HL.png"];
    cannonImg = [UIImage imageNamed:@"ace_cannon.png"];
    cannonImgView = [[UIImageView alloc]initWithImage:cannonImg];
    cannonImgView.frame = CGRectMake(CANNON_X, CANNON_Y, cannonImg.size.width, cannonImg.size.height);
    [self.view addSubview:cannonImgView];
    
    //change init
    changeHLImg = [UIImage imageNamed:@"ace_change_HL.png"];
    changeImg = [UIImage imageNamed:@"ace_change.png"];
    changeImgView = [[UIImageView alloc]initWithImage:changeImg];
    changeImgView.frame = CGRectMake(CHANGE_X, CHANGE_Y, changeImg.size.width, changeImg.size.height);
    [self.view addSubview:changeImgView];
    
    //weapon init
    weaponHLImg = [UIImage imageNamed:@"ace_weapon_HL.png"];
    weaponImg = [UIImage imageNamed:@"ace_weapon.png"];
    weaponImgView = [[UIImageView alloc]initWithImage:weaponImg];
    weaponImgView.frame = CGRectMake(WEAPON_X, WEAPON_Y, weaponImg.size.width, weaponImg.size.height);
    [self.view addSubview:weaponImgView];
    
    //lockon init
    lockonHLImg = [UIImage imageNamed:@"ace_lockon_HL.png"];
    lockonImg = [UIImage imageNamed:@"ace_lockon.png"];
    lockonImgView = [[UIImageView alloc]initWithImage:lockonImg];
    lockonImgView.frame = CGRectMake(LOCKON_X, LOCKON_Y, lockonImg.size.width, lockonImg.size.height);
    [self.view addSubview:lockonImgView];
    
    //target init
    targetHLImg = [UIImage imageNamed:@"ace_target_HL.png"];
    targetImg = [UIImage imageNamed:@"ace_target.png"];
    targetImgView = [[UIImageView alloc]initWithImage:targetImg];
    targetImgView.frame = CGRectMake(TARGET_X, TARGET_Y, targetImg.size.width, targetImg.size.height);
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


#pragma mark - Timer 
- (void)initTimer
{
    //时间间隔
    NSTimeInterval timeInterval = ACE_REFRESH_TIME;
    //定时器
    NSTimer *showTimer;
    showTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(checkTouchedBtnWithTimer:)userInfo:nil repeats:YES];
}

//timer selector
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
        [aceNetWork addKeyMessage:PRESS_THRUST withIndex:MESSAGE_ID_KEY_1];
    }
    else{
        thrustImgView.image = thrustImg;
        [aceNetWork addKeyMessage:RELEASE_THRUST withIndex:MESSAGE_ID_KEY_1];
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
        [aceNetWork addKeyMessage:PRESS_YAWLEFT withIndex:MESSAGE_ID_KEY_1];
    }
    else{
        yawleftImgView.image = yawleftImg;
        [aceNetWork addKeyMessage:RELEASE_YAWLEFT withIndex:MESSAGE_ID_KEY_1];
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
        [aceNetWork addKeyMessage:PRESS_YAWRIGHT withIndex:MESSAGE_ID_KEY_1];
    }
    else{
        yawrightImgView.image = yawrightImg;
        [aceNetWork addKeyMessage:RELEASE_YAWRIGHT withIndex:MESSAGE_ID_KEY_1];
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
        [aceNetWork addKeyMessage:PRESS_BRAKES withIndex:MESSAGE_ID_KEY_1];
    }
    else{
        brakesImgView.image = brakesImg;
        [aceNetWork addKeyMessage:RELEASE_BRAKES withIndex:MESSAGE_ID_KEY_1];
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
        [aceNetWork addKeyMessage:PRESS_CANNON withIndex:MESSAGE_ID_KEY_1];
    }
    else{
        cannonImgView.image = cannonImg;
        [aceNetWork addKeyMessage:RELEASE_CANNON withIndex:MESSAGE_ID_KEY_1];
    }
    
    isTouched = NO;
    for (TouchRecord * touchRecord in m_touchArray) {
        if ([self isTouchedByType:changeType withPoint:touchRecord.m_point]) {
            isTouched = YES;
            break;
        }
    }
    if (isTouched) {
        if (changeImgView.image == changeImg) {
            changeImgView.image = changeHLImg;
            [self playSound];
            //            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
        }
        [aceNetWork addKeyMessage:PRESS_CHANGE withIndex:MESSAGE_ID_KEY_1];
    }
    else{
        changeImgView.image = changeImg;
        [aceNetWork addKeyMessage:RELEASE_CHANGE withIndex:MESSAGE_ID_KEY_1];
    }
    
    isTouched = NO;
    for (TouchRecord * touchRecord in m_touchArray) {
        if ([self isTouchedByType:lockonType withPoint:touchRecord.m_point]) {
            isTouched = YES;
            break;
        }
    }
    if (isTouched) {
        if (lockonImgView.image == lockonImg) {
            lockonImgView.image = lockonHLImg;
            [self playSound];
            //            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
        }
        [aceNetWork addKeyMessage:PRESS_LOCKON withIndex:MESSAGE_ID_KEY_1];
    }
    else{
        lockonImgView.image = lockonImg;
        [aceNetWork addKeyMessage:RELEASE_LOCKON withIndex:MESSAGE_ID_KEY_1];
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
        [aceNetWork addKeyMessage:PRESS_WEAPON withIndex:MESSAGE_ID_KEY_1];
    }
    else{
        weaponImgView.image = weaponImg;
        [aceNetWork addKeyMessage:RELEASE_WEAPON withIndex:MESSAGE_ID_KEY_1];
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
        [aceNetWork addKeyMessage:PRESS_TARGET withIndex:MESSAGE_ID_KEY_1];
    }
    else{
        targetImgView.image = targetImg;
        [aceNetWork addKeyMessage:RELEASE_TARGET withIndex:MESSAGE_ID_KEY_1];
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
    double gravityZ = motionManager.deviceMotion.gravity.z;
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
    
    [aceNetWork addKeyMessage:theMotionX withIndex:MESSAGE_ID_X];
    [aceNetWork addKeyMessage:theMotionY withIndex:MESSAGE_ID_Y];
}

#pragma mark - isTouched
- (BOOL)isTouchedByType:(int)theType withPoint:(CGPoint)thePoint
{
    switch (theType) {
        case thrustType:
            return [self isTouchedOnBtn:thePoint on:thrustImgView withX:THRUST_X withY:THRUST_Y];
            break;
            
        case yawleftType:
            return [self isTouchedOnBtn:thePoint on:yawleftImgView withX:YAWLEFT_X withY:YAWLEFT_Y];
            break;
            
        case yawrightType:
            return [self isTouchedOnBtn:thePoint on:yawrightImgView withX:YAWRIGHT_X withY:YAWRIGHT_Y];
            break;
            
        case brakesType:
            return [self isTouchedOnBtn:thePoint on:brakesImgView withX:BRAKES_X withY:BRAKES_Y];
            break;
            
        case cannonType:
            return [self isTouchedOnBtn:thePoint on:cannonImgView withX:CANNON_X withY:CANNON_Y];
            break;
            
        case changeType:
            return [self isTouchedOnBtn:thePoint on:changeImgView withX:CHANGE_X withY:CHANGE_Y];
            break;
            
        case weaponType:
            return [self isTouchedOnBtn:thePoint on:weaponImgView withX:WEAPON_X withY:WEAPON_Y];
            break;
            
        case targetType:
            return [self isTouchedOnBtn:thePoint on:targetImgView withX:TARGET_X withY:TARGET_Y];
            break;
            
        case lockonType:
            return [self isTouchedOnBtn:thePoint on:lockonImgView withX:LOCKON_X withY:LOCKON_Y];
            break;
        default:
            break;
    }
    return [self isTouchedOnBtn:thePoint on:thrustImgView withX:THRUST_X withY:THRUST_Y];
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
