//
//  JoypadCocoaTouchSampleAppDelegate.h
//  JoypadCocoaTouchSample
//
//  Created by Lou Zell on 6/1/11.
//  Copyright 2011 Hazelmade. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JoypadCocoaTouchSampleViewController;

@interface JoypadCocoaTouchSampleAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    JoypadCocoaTouchSampleViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet JoypadCocoaTouchSampleViewController *viewController;

@end

