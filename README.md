Joypad SDK 
=========

Welcome to the Joypad SDK!  Joypad is the iOS game controller, see [getjoypad.com](http://getjoypad.com "Joypad") for more about that.
This SDK enables you to add iOS controller support directly to your Mac or iPad games (or other apps, if you want to get wild).
The controller that you create through the SDK will appear on any phones running Joypad on the network.  You can add dpads,
virtual analog sticks, and buttons.  You can also get accelerometer input from each phone.
To see pictures, go to [getjoypad.com/sdk.html](http://getjoypad.com/sdk.html "Joypad SDK").

Note: Only the latest version of Joypad is SDK enabled, 
get it for free [here](http://itunes.apple.com/us/app/joypad-game-controller/id411422117?mt=8 "Joypad").

How do I get started?
----------

There are two sample projects, JoypadCocoaSample and JoypadCocoaTouchSample, if you want to jump right in (warning, 
they are very minimal at the moment).
Otherwise, let's walk through it: 

First, drag the JoypadCocoaSDK or JoypadCocoaTouchSDK folder into your Xcode project - 
use the CocoaTouchSDK for iOS apps.  Next, you'll need an instance of JoypadManager in YourClass:

    @interface YourClass : NSObject
    {
      JoypadManager *joypadManager;
    }

In your class implementation, instantiate JoypadManager and set its delegate:

    joypadManager = [[JoypadManager alloc] init];
    [joypadManager setDelegate:self];

Now tell joypad manager what controller you would like to display on any iPhones
on the network.  You can use one of the pre-installed Joypad controllers, or create your own.
For now, let's use the NES controller: 

    [joypadManager usePreInstalledLayout:kJoyControllerNES];

To create your own controller, see the "creating a custom controller!" section below.
Next you'll need to find iOS devices on the network that are running Joypad.  This task will be handled
asynchronously; kick it off with: 
  
    [joypadManager startFindingDevices];

Implement the following delegate methods in YourClass, they will be called as devices on the network open and close Joypad: 

    -(void)joypadManager:(JoypadManager *)manager didFindDevice:(JoypadDevice *)device previouslyConnected:(BOOL)prev
    -(void)joypadManager:(JoypadManager *)manager didLoseDevice:(JoypadDevice *)device;

For this simple example, let's automatically connect to the first device that is discovered.  We will connect as player 1.

    -(void)joypadManager:(JoypadManager *)manager didFindDevice:(JoypadDevice *)device previouslyConnected:(BOOL)prev
    {
      [manager connectToDevice:device asPlayer:1];
    }
    

Again, the connectToDevice:asPlayer call is asynchronous, you will be notified when the player connects and disconnects by implementing the delegate methods: 

    -(void)joypadManager:(JoypadManager *)manager deviceDidConnect:(JoypadDevice *)device player:(unsigned int)player;
    -(void)joypadManager:(JoypadManager *)manager deviceDidDisconnect:(JoypadDevice *)device player:(unsigned int)player;

Once a device has connected, you are ready to start receiving input from it.  You'll need to set the device's delegate object: 

    -(void)joypadManager:(JoypadManager *)manager deviceDidConnect:(JoypadDevice *)device player:(unsigned int)player
    {
      [device setDelegate:anObject];  // Use self to have the same delegate object as the joypad manager.
    }

Now anObject will receive input from Joypad!

Receiving inputs from your controllers!
--------------------------------------

Each type of component that you set down (dpads, buttons, etc) gets its own delegate method.  Implement the following in the device's delegate object (anObject from above):

    -(void)joypadDevice:(JoypadDevice *)device didAccelerate:(JoypadAcceleration)accel;
    -(void)joypadDevice:(JoypadDevice *)device dPad:(JoyInputIdentifier)dpad buttonUp:(JoyDpadButton)dpadButton;
    -(void)joypadDevice:(JoypadDevice *)device dPad:(JoyInputIdentifier)dpad buttonDown:(JoyDpadButton)dpadButton;
    -(void)joypadDevice:(JoypadDevice *)device buttonUp:(JoyInputIdentifier)button;
    -(void)joypadDevice:(JoypadDevice *)device buttonDown:(JoyInputIdentifier)button;
    -(void)joypadDevice:(JoypadDevice *)device analogStick:(JoyInputIdentifier)stick didMove:(JoypadStickPosition)newPosition;

Warning: Connecting over Bluetooth
---------------------------------------------------
The iOS version of the SDK can connect to Joypad over wifi or bluetooth.  You *must* stop searching for devices before starting
gameplay.  Do this with: 

    [joypadManager stopFindingDevices];
    
Otherwise, you will see major performance issues over bluetooth.

Creating a custom controller!
-----------------------------

You create a custom layout using JoypadControllerLayout class.  Here are the API calls you will be
concerned with: 

    -(void)addButtonWithFrame:(CGRect)rect 
                        label:(NSString *)label
                     fontSize:(unsigned int)fontSize 
                        shape:(JoyButtonShape)shape 
                        color:(JoyButtonColor)color 
                   identifier:(JoyInputIdentifier)inputId;
    -(void)addDpadWithFrame:(CGRect)rect dpadOrigin:(CGPoint)origin identifier:(JoyInputIdentifier)inputId;
    -(void)addAccelerometer;
    -(void)addAnalogStickWithFrame:(CGRect)rect identifier:(JoyInputIdentifier)inputId;

Please see the JoypadControllerLayout.h header for details.
    

Examples of custom controllers
-------------------------------
Here is a full example of adding an analog stick and two buttons: 

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


Here is an example of adding dual analog sticks: 

    [customLayout addAnalogStickWithFrame:CGRectMake(0, 70, 240, 240) identifier:kJoyInputAnalogStick1];
    [customLayout addAnalogStickWithFrame:CGRectMake(240, 70, 240, 240) identifier:kJoyInputAnalogStick2];


Please email me for suggestions, questions, or clarifications!  lzell11@gmail.com
========================
