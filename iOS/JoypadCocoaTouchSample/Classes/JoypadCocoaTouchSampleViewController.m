//
//  JoypadCocoaTouchSampleViewController.m
//  JoypadCocoaTouchSample
//
//  Created by Lou Zell on 6/1/11.
//  Copyright 2011 Hazelmade. All rights reserved.
//

#import "JoypadCocoaTouchSampleViewController.h"
#import "JoypadSDK.h"
#import "JoypadXIBConfigure.h"

static int counter = 0;

@implementation JoypadCocoaTouchSampleViewController

#pragma mark -
-(void)viewDidLoad
{
  buttonMap = [[NSArray arrayWithObjects:@"kJoyInputDpad1",
               @"kJoyInputDpad2",
               @"kJoyInputAnalogStick1",
               @"kJoyInputAnalogStick2",
               @"kJoyInputAccelerometer",
               @"kJoyInputWheel",
               @"kJoyInputAButton",
               @"kJoyInputBButton",
               @"kJoyInputCButton",
               @"kJoyInputXButton",
               @"kJoyInputYButton",
               @"kJoyInputZButton",
               @"kJoyInputSelectButton",
               @"kJoyInputStartButton",
               @"kJoyInputLButton",
               @"kJoyInputRButton",
               nil] retain];
  joypadManager = [[JoypadManager alloc] init];
  [joypadManager setDelegate:self];

  // Create custom layout.
  
  JoypadXIBConfigure* config = [[JoypadXIBConfigure alloc] init];
  
  JoypadControllerLayout *customLayout = [config configureLayout:@"DualAnalogSticks"];
  [joypadManager useCustomLayout:customLayout];
  [customLayout release];
  [config release];
  
  // Start finding devices running Joypad.
  //[joypadManager startFindingDevices];
  
  [super viewDidLoad];
}

-(void)dealloc
{
  [joypadManager release];
  [super dealloc];
}

#pragma mark Actions
-(IBAction)searchForJoypad:(id)sender
{
  [joypadManager startFindingDevices];
}

-(IBAction)connectManually:(id)sender
{
  [joypadManager connectToDeviceAtAddress:[connectionAddressTextField text] asPlayer:1];
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

#pragma mark JoypadDevice Delegate Callbacks
-(void)joypadManager:(JoypadManager *)manager deviceDidConnect:(JoypadDevice *)device player:(unsigned int)player
{
  NSLog(@"Device connected as player: %i!", player);
  [device setDelegate:self];
}

-(void)joypadManager:(JoypadManager *)manager deviceDidDisconnect:(JoypadDevice *)device player:(unsigned int)player
{
  NSLog(@"Player %i disconnected.", player);
}

-(void)joypadDevice:(JoypadDevice *)device buttonDown:(JoyInputIdentifier)button
{
    NSLog(@"Button %@ is down", [buttonMap objectAtIndex:button]);
}

-(void)joypadDevice:(JoypadDevice *)device buttonUp:(JoyInputIdentifier)button
{
  NSLog(@"Button %@ is up", [buttonMap objectAtIndex:button]);

}

-(void)joypadDevice:(JoypadDevice *)device analogStick:(JoyInputIdentifier)stick didMove:(JoypadStickPosition)newPosition
{
  NSLog(@"Analog stick distance: %f, angle (rad): %f", newPosition.distance, newPosition.angle);
}

<<<<<<< HEAD:iOS/JoypadCocoaTouchSample/Classes/JoypadCocoaTouchSampleViewController.m
#pragma mark Accessors
@synthesize connectionAddressTextField;
=======

-(void)joypadDevice:(JoypadDevice *)device dPad:(JoyInputIdentifier)dpad buttonUp:(JoyDpadButton)dpadButton
{
  NSLog(@"Dpad %@ button %@ is up!", [buttonMap objectAtIndex:dpad], [buttonMap objectAtIndex:dpadButton] );
}

-(void)joypadDevice:(JoypadDevice *)device dPad:(JoyInputIdentifier)dpad buttonDown:(JoyDpadButton)dpadButton
{
  NSLog(@"Dpad %@ button %@ is down!", [buttonMap objectAtIndex:dpad], [buttonMap objectAtIndex:dpadButton] );
}

-(void)joypadDevice:(JoypadDevice *)device didAccelerate:(JoypadAcceleration)accel {
  if ( counter > 500 ) {
    NSLog(@"Accelerometer %f, %f, %f", accel.x, accel.y, accel.z );
    counter = 0;
  }
  counter++;
}

>>>>>>> Support for configuring a customLayout using an iOS XIB file:CocoaTouch/JoypadCocoaTouchSample/Classes/JoypadCocoaTouchSampleViewController.m


@end
