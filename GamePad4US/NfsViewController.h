//
//  NfsViewController.h
//  GamePad4US
//
//  Created by 朱 俊健 on 13-12-6.
//  Copyright (c) 2013年 朱 俊健. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TouchRecord;

@interface NfsViewController : UIViewController{
    UIImage * accelerateImg;
    UIImage * accelerateHLImg;
    UIImageView * accelerateImgView;
    
    NSMutableArray * m_touchArray;
    
}

@end
