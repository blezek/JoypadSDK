Markdown? 
=========

Welcome to the Joypad SDK!  Joypad is the iOS game controller, see getjoypad.com for more about that.
This SDK enables you to add Joypad support directly to your Mac or iPad games (or other apps, if you want to get wild).
You can make your own controller layouts, add virtual analog sticks, get input from the accelerometer, etc.  If you want 
to see pictures, look at getjoypad.com/sdk.html

Cool, how do I use it?
----------

You drag the JoypadCocoaSDK or JoypadCocoaTouchSDK folder into your Xcode project.  Use the CocoaTouchSDK for iOS apps.
Next, let's walk through the API.  We need an instance of JoypadManager in OurClass:

    @interface OurClass : NSObject
    {
      JoypadManager *joypadManager;
    }

In OurClass implementation, instantiate JoypadManager and set it's delegate:

    joypadManager = [[JoypadManager alloc] init];
    [joypadManager setDelegate:self];


Next, we commit to make sure this looks normal.

Next we need to find iOS devices on the network that are running Joypad.  We do this task asynchronously;
kick it off with: 



