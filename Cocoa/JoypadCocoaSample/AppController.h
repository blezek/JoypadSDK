//
//  AppController.h
//  JoypadCocoaSample
//
//  Created by Lou Zell on 8/14/11.
//  Copyright 2011 Hazelmade. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@class JoypadManager;

@interface AppController : NSObject 
{
  JoypadManager *joypadManager;
  NSTextField *connectionAddressTextField;
}

-(IBAction)searchForJoypad:(id)sender;
-(IBAction)connectManually:(id)sender;

@property (nonatomic, retain) IBOutlet NSTextField *connectionAddressTextField;



@end
