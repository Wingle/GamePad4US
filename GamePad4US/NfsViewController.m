//
//  NfsViewController.m
//  GamePad4US
//
//  Created by 朱 俊健 on 13-12-6.
//  Copyright (c) 2013年 朱 俊健. All rights reserved.
//

#import "NfsViewController.h"
#import "TouchRecord.h"


@interface NfsViewController ()

@end

@implementation NfsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        //Important!!! setMutipleTouch
        [self.view setMultipleTouchEnabled:YES];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.]
    
    //设置背景图
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"nfs_background.jpg"]]];
    
    //放置图片
    accelerateHLImg = [UIImage imageNamed:@"nfs_accelerate_HL.png"];
    accelerateImg = [UIImage imageNamed:@"nfs_accelerate.png"];
    accelerateImgView = [[UIImageView alloc]initWithImage:accelerateImg];
//    accelerateImgView.center = CGPointMake(150, 170);
    accelerateImgView.frame = CGRectMake(5, 20, accelerateImg.size.width * 0.88, accelerateImg.size.height * 0.88);
    [self.view addSubview:accelerateImgView];
    
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
    showTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval
                                                           target:self
                                                         selector:@selector(checkTouchedBtnWithTimer:)
                                                         userInfo:nil
                                                          repeats:YES];
}

- (void)checkTouchedBtnWithTimer:(NSTimer *)theTimer
{
    accelerateImgView.image = accelerateImg;
    for (TouchRecord * touchRecord in m_touchArray) {
        if ([self isTouchedAccelerate:touchRecord.m_point]) {
            accelerateImgView.image = accelerateHLImg;
        }
    }
}

#pragma mark - isTouched

- (BOOL)isTouchedAccelerate:(CGPoint)thePoint
{
    if (!CGRectContainsPoint(accelerateImgView.frame, thePoint)) {
        return NO;
    }
    
    thePoint.x = (thePoint.x - 5) * 2;
    thePoint.y = (thePoint.y - 20) * 2;
    
    CGFloat alpha = [self getRGBAsFromImage:accelerateImg atX:(int)thePoint.x andY:(int)thePoint.y];
    
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

@end
