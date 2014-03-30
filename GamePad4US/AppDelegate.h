//
//  AppDelegate.h
//  GamePad4US
//
//  Created by 朱 俊健 on 13-12-5.
//  Copyright (c) 2013年 朱 俊健. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainViewController;
@class loadingViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//@property (strong, nonatomic) MainViewController *viewController;

@property (strong, nonatomic) loadingViewController * viewController;


@end
