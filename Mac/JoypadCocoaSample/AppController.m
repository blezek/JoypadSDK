//
//  AppController.m
//  JoypadCocoaSample
//
//  Created by Lou Zell on 8/14/11.
//  Copyright 2011 Hazelmade. All rights reserved.
//

#import "AppController.h"
#import "JoypadSDK.h"

@implementation AppController

-(void)awakeFromNib
{
  joypadManager = [[JoypadManager alloc] init];
  [joypadManager setDelegate:self];
  
  // Create custom layout.
  JoypadControllerLayout *customLayout = [[JoypadControllerLayout alloc] init];
  [customLayout setName:@"SampleApp"];
  [customLayout addAnalogStickWithFrame:CGRectMake(0, 70, 240, 240) identifier:kJoyInputAnalogStick1];
  
  [customLayout addButtonWithFrame:CGRectMake(280,0,100,320) 
                             label:@"B" 
                          fontSize:36
                             shape:kJoyButtonShapeSquare
                             color:kJoyButtonColorBlue
                        identifier:kJoyInputBButton];
  
  [customLayout addButtonWithFrame:CGRectMake(380,0,100,320) 
                             label:@"A" 
                          fontSize:36
                             shape:kJoyButtonShapeSquare
                             color:kJoyButtonColorBlue
                        identifier:kJoyInputAButton];
  
  [joypadManager useCustomLayout:customLayout];
  [customLayout release];
}

-(void)dealloc
{
  [joypadManager release];
  NSLog(@"Here");
  [super dealloc];
}

#pragma mark Actions
-(IBAction)searchForJoypad:(id)sender
{
  [joypadManager startFindingDevices];
}

-(IBAction)connectManually:(id)sender
{
  [joypadManager connectToDeviceAtAddress:[connectionAddressTextField stringValue] asPlayer:1];
}

#pragma mark JoypadManager Delegate Callbacks
-(void)joypadManager:(JoypadManager *)manager didFindDevice:(JoypadDevice *)device previouslyConnected:(BOOL)prev
{
  NSLog(@"Found a device running Joypad!  Stopping the search and connecting to it.");
  [manager stopFindingDevices];
  [manager connectToDevice:device asPlayer:1];
}

-(void)joypadManager:(JoypadManager *)manager didLoseDevice:(JoypadDevice *)device
{
  NSLog(@"Lost a device");
}

-(void)joypadManager:(JoypadManager *)manager deviceDidConnect:(JoypadDevice *)device player:(unsigned int)player
{
  NSLog(@"Device connected as player: %i!", player);
  [device setDelegate:self];
}

-(void)joypadManager:(JoypadManager *)manager deviceDidDisconnect:(JoypadDevice *)device player:(unsigned int)player
{
  NSLog(@"Player %i disconnected.", player);
}

#pragma mark JoypadDevice Delegate Callbacks
-(void)joypadDevice:(JoypadDevice *)device buttonDown:(JoyInputIdentifier)button
{
  switch(button)
  {
    case kJoyInputAButton:  NSLog(@"A is down");  break;
    case kJoyInputBButton:  NSLog(@"B is down");  break;
    default:
      NSLog(@"Button %i is down", button);
      break;
  }
}

-(void)joypadDevice:(JoypadDevice *)device buttonUp:(JoyInputIdentifier)button
{
  switch(button)
  {
    case kJoyInputAButton:  NSLog(@"A is up");  break;
    case kJoyInputBButton:  NSLog(@"B is up");  break;
    default:
      NSLog(@"Button %i is up", button);
      break;
  }
}

-(void)joypadDevice:(JoypadDevice *)device analogStick:(JoyInputIdentifier)stick didMove:(JoypadStickPosition)newPosition
{
  NSLog(@"Analog stick distance: %f, angle (rad): %f", newPosition.distance, newPosition.angle);
}

#pragma mark Accessors
@synthesize connectionAddressTextField;


@end
