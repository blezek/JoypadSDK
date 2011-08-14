//
//  JoypadCocoaTouchSampleViewController.h
//  JoypadCocoaTouchSample
//
//  Created by Lou Zell on 6/1/11.
//  Copyright 2011 Hazelmade. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JoypadManager;

@interface JoypadCocoaTouchSampleViewController : UIViewController
{
  JoypadManager *joypadManager;
  UITextField *connectionAddressTextField;
}

-(IBAction)searchForJoypad:(id)sender;
-(IBAction)connectManually:(id)sender;

@property (nonatomic, retain) IBOutlet UITextField *connectionAddressTextField;

@end

