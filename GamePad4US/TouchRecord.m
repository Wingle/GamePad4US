//
//  TouchRecord.m
//  GamePad4US
//
//  Created by 朱 俊健 on 13-12-7.
//  Copyright (c) 2013年 朱 俊健. All rights reserved.
//

#import "TouchRecord.h"

@implementation TouchRecord

@synthesize m_id;
@synthesize m_point;
@synthesize m_phase;


- (id)init
{
    return [self initWithTouch:nil pointInView:CGPointMake(0.0, 0.0)];
}




- (id)initWithTouch:(UITouch*)aTouch pointInView:(CGPoint)point
{
    self = [super init];
    if (self) {
        /* class-specific initialization goes here */
        m_id = aTouch;
        m_point = point;
        m_phase = aTouch.phase;
        
    }
    return self;
}

@end
