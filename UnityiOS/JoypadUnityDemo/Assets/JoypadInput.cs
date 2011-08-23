using UnityEngine;
using System.Collections;
using System.Threading;
using JoypadConnect.JoypadSDK;

public class JoypadInput : MonoBehaviour
{
	private JoypadManager joypadManager = null;
	private float movementK = 30.0f;			// Greater means faster movement.
	private float moveX; 
	private float moveY;

	// Set to true to move your character with the accelerometer
	// instead of an analog stick.
	private bool moveWithAccelerometer = false;
	
	void Awake()
	{
		moveX = 0.0f;
		moveY = 0.0f;
		
		joypadManager = new JoypadManager(SynchronizationContext.Current);
        joypadManager.DidFindDevice 		+= new JoypadManager.DidFindDeviceHandler(JoypadManager_DidFindDevice);
        joypadManager.DidLoseDevice 		+= new JoypadManager.DidLoseDeviceHandler(JoypadManager_DidLoseDevice);
        joypadManager.DeviceDidConnect 		+= new JoypadManager.DeviceDidConnectHandler(JoypadManager_DeviceDidConnect);
        joypadManager.DeviceDidDisconnect 	+= new JoypadManager.DeviceDidDisconnectHandler(JoypadManager_DeviceDidDisconnect);
		
		// If you wanted to use one of the Pre-installed layouts, you would make this call:
        // joypadManager.UsePreInstalledLayout(JoyControllerIdentifier.kJoyControllerNES);
		
		// Otherwise, you can build up a custom layout:
		JoypadControllerLayout customLayout = new JoypadControllerLayout();
		customLayout.Name = "Unity Joypad Demo";
		
		if(moveWithAccelerometer)
		{
			customLayout.AddAccelerometer();
		}
		else
		{
			customLayout.AddAnalogStickWithFrame(CGRect.Make(0, 70, 240, 240), JoyInputIdentifier.kJoyInputAnalogStick1);
		}
		
		customLayout.AddButtonWithFrame(CGRect.Make(280, 0, 100, 320), 
		                                "B", 
		                                36, 
		                                JoyButtonShape.kJoyButtonShapeSquare, 
		                                JoyButtonColor.kJoyButtonColorBlue, 
		                                JoyInputIdentifier.kJoyInputBButton);
		
		customLayout.AddButtonWithFrame(CGRect.Make(380, 0, 100, 320), 
		                                "A",
		                                36, 
		                                JoyButtonShape.kJoyButtonShapeSquare, 
		                                JoyButtonColor.kJoyButtonColorBlue, 
		                                JoyInputIdentifier.kJoyInputAButton);
		
		joypadManager.UseCustomLayout(customLayout);

        if(!joypadManager.StartFindingDevices())
        {
        	print("!!! Major Problems, can't use Bonjour !!!");
        }
	}
	
	void Update()
	{
		Vector3 moveVector 	= new Vector3(moveX * movementK, 0, moveY * movementK);
		transform.position 	+= (moveVector * Time.deltaTime);
	}
	
	void Stop()
	{
		joypadManager.DidFindDevice 		-= new JoypadManager.DidFindDeviceHandler(JoypadManager_DidFindDevice);
        joypadManager.DidLoseDevice 		-= new JoypadManager.DidLoseDeviceHandler(JoypadManager_DidLoseDevice);
        joypadManager.DeviceDidConnect 		-= new JoypadManager.DeviceDidConnectHandler(JoypadManager_DeviceDidConnect);
        joypadManager.DeviceDidDisconnect 	-= new JoypadManager.DeviceDidDisconnectHandler(JoypadManager_DeviceDidDisconnect);
		joypadManager.Dispose();
	}
	

    /////////////////////////////////////////////////////////////////////////////////////////////////////
	#region JoypadManager Delegate Callbacks
    /////////////////////////////////////////////////////////////////////////////////////////////////////
    private void JoypadManager_DidFindDevice(JoypadManager sender, JoypadDevice device, bool previouslyConnected)
    {
 		joypadManager.ConnectToDevice(device, 1);
    }

    private void JoypadManager_DidLoseDevice(JoypadManager sender, JoypadDevice device)
    {
    }

    private void JoypadManager_DeviceDidConnect(JoypadManager sender, JoypadDevice device, uint player)
    {
		joypadManager.StopFindingDevices();
		
		device.DidAccelerate 		+= new JoypadDevice.DidAccelerateHandler(JoypadDevice_DidAccelerate);
        device.ButtonDown 			+= new JoypadDevice.ButtonDownHandler(JoypadDevice_ButtonDown);
        device.ButtonUp 			+= new JoypadDevice.ButtonUpHandler(JoypadDevice_ButtonUp);
        device.DpadButtonDown 		+= new JoypadDevice.DpadButtonDownHandler(JoypadDevice_DpadButtonDown);
        device.DpadButtonUp 		+= new JoypadDevice.DpadButtonUpHandler(JoypadDevice_DpadButtonUp);
 		device.AnalogStickDidMove 	+= new JoypadDevice.AnalogStickDidMoveHandler(JoypadDevice_AnalogStickDidMove);
    }

    private void JoypadManager_DeviceDidDisconnect(JoypadManager sender, JoypadDevice device, uint player)
    {
       	device.DidAccelerate 		-= new JoypadDevice.DidAccelerateHandler(JoypadDevice_DidAccelerate);
       	device.ButtonDown 			-= new JoypadDevice.ButtonDownHandler(JoypadDevice_ButtonDown);
       	device.ButtonUp 			-= new JoypadDevice.ButtonUpHandler(JoypadDevice_ButtonUp);
       	device.DpadButtonDown 		-= new JoypadDevice.DpadButtonDownHandler(JoypadDevice_DpadButtonDown);
       	device.DpadButtonUp 		-= new JoypadDevice.DpadButtonUpHandler(JoypadDevice_DpadButtonUp);
	   	device.AnalogStickDidMove 	-= new JoypadDevice.AnalogStickDidMoveHandler(JoypadDevice_AnalogStickDidMove);
    }
    #endregion

    /////////////////////////////////////////////////////////////////////////////////////////////////////
	#region JoypadDevice Delegate Callbacks
    /////////////////////////////////////////////////////////////////////////////////////////////////////
	private void JoypadDevice_DidAccelerate(JoypadDevice device, JoypadAcceleration accel)
	{
		moveY = accel.X;
		moveX = -1 * accel.Y;
	}
	
	private void JoypadDevice_ButtonDown(JoypadDevice device, JoyInputIdentifier button)
	{
		print(string.Format("Button {0} Pressed", button));
	}
	
	private void JoypadDevice_ButtonUp(JoypadDevice device, JoyInputIdentifier button)
	{
		print(string.Format("Button {0} Released", button));
	}
	
	private void JoypadDevice_DpadButtonDown(JoypadDevice device, JoyInputIdentifier dpad, JoyDpadButton dpadButton)
	{
		print(string.Format("Dpad {0} pressed {1}", dpad, dpadButton));
	}
	                                                                                                                                                                                                                                    
	private void JoypadDevice_DpadButtonUp(JoypadDevice device, JoyInputIdentifier dpad, JoyDpadButton dpadButton)
	{
		print(string.Format("Dpad {0} released {1}", dpad, dpadButton));
	}
	
	private void JoypadDevice_AnalogStickDidMove(JoypadDevice device, JoyInputIdentifier stick, JoypadStickPosition newPosition)
	{
		float normalizedDistance = newPosition.Distance / 55.0f;	// Move this into the SDK.
		moveX = normalizedDistance * Mathf.Cos(newPosition.Angle);
		moveY = normalizedDistance * Mathf.Sin(newPosition.Angle);
		print(string.Format("Analog Stick moved - Distance: {0}  Angle:{1}", normalizedDistance, newPosition.Angle));
	}
	#endregion
}
