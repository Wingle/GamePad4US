//
//  MainViewController.h
//  GamePad4US
//
//  Created by 朱 俊健 on 13-12-5.
//  Copyright (c) 2013年 朱 俊健. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyHeader.h"
#import "NetWork.h"

@class NfsViewController;

@interface MainViewController : UIViewController{
    UIButton * aceBtn;
    UIButton * hawxBtn;
    UIButton * nfsBtn;
    
    NfsViewController * nfsVC;
}

@end
