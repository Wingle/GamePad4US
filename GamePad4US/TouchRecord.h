//
//  TouchRecord.h
//  GamePad4US
//
//  Created by 朱 俊健 on 13-12-7.
//  Copyright (c) 2013年 朱 俊健. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TouchRecord : NSObject{
    id m_id;  // 用以唯一标识touch对象，实际他是传入的touches集合中touch对象的指针
    CGPoint m_point;  // touch对象的位置
    
    UITouchPhase m_phase;  //touch对象的状态
    
//    BOOL 

}

@property id m_id;
@property CGPoint m_point;
@property UITouchPhase m_phase;

-(id)initWithTouch:(UITouch *)aTouch pointInView:(CGPoint)point;

@end
