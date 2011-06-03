//
//  JoypadCocoaSampleAppDelegate.h
//  JoypadCocoaSample
//
//  Created by Lou Zell on 6/1/11.
//  Copyright 2011 Hazelmade. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class JoypadManager;

@interface JoypadCocoaSampleAppDelegate : NSObject
{
  NSWindow *window;
  JoypadManager *joypadManager;
}

@property (assign) IBOutlet NSWindow *window;

@end
