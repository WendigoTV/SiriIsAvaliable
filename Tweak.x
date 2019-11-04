#import <SpringBoard/SpringBoard.h>
#import <Foundation/Foundation.h>
#import "NSTask.h"

@interface PSCellularDataSettingsDetail
@property (readonly) unsigned long long hash; 
@property (readonly) Class superclass; 
@property (copy,readonly) NSString * description; 
@property (copy,readonly) NSString * debugDescription; 
+(BOOL)deviceSupportsCellularData;
+(id)preferencesURL;
+(void)setEnabled:(BOOL)arg1 ;
+(BOOL)isEnabled;
+(id)iconImage;
@end

@interface SBAssistantController : NSObject
+(BOOL)isAssistantVisible;
+(BOOL)shouldEnterAssistant;
+(id)sharedInstance;
-(BOOL)handleSiriButtonDownEventFromSource:(NSInteger)arg1 activationEvent:(NSInteger)arg2;
-(void)_notifyObserversViewWillAppear:(long long)arg1 ;
-(void)handleSiriButtonUpEventFromSource:(NSInteger)arg1;
-(void)addObserver:(id)arg1 ;
-(void)dismissPluginForEvent:(NSInteger)arg1;
-(BOOL)isAssistantViewVisible:(long long)arg1 ;
@end

@interface AFUISiriViewController : UIViewController
-(void)siriViewDidRecieveStatusViewTappedAction:(id)arg1;
@end

@interface SBAssistantRootViewController: UIViewController
@property (nonatomic, assign) AFUISiriViewController *assistantController;
@end

@interface SBAssistantWindow : UIWindow
@property (nonatomic, assign) SBAssistantRootViewController *assistantRootViewController;
@end

@interface SBWiFiManager
-(id)sharedInstance;
-(id)currentNetworkName;
-(void)setWiFiEnabled:(BOOL)enabled;
-(BOOL)isPowered;
-(bool)wiFiEnabled;
@end

@interface WiFiUtils
+ (id)sharedInstance;
+ (bool)scanInfoIs5GHz:(id)arg1;
- (long)closeWiFi;
- (long)disassociateSync;
- (id)getLinkStatus;
- (id)getNetworkPasswordForNetworkNamed:(id)arg1;
- (int)joinNetworkWithNameAsync:(id)arg1 password:(id)arg2 rememberChoice:(int)arg3;
- (BOOL)isJoinInProgress;
- (BOOL)isScanInProgress;
- (BOOL)isScanningActive;
- (void)activateScanning:(BOOL)arg1;
- (void)triggerScan;
- (long)setAutoJoinState:(BOOL)arg1;
- (double)periodicScanInterval;
@end

%hook SBAssistantController

-(void)_notifyObserversViewWillAppear:(long long)arg1 {
	SBWiFiManager *WifiToggle = (SBWiFiManager *)[%c(SBWiFiManager) sharedInstance];
	WiFiUtils *WifiDetails = (WiFiUtils *)[%c(WiFiUtils) sharedInstance];
	//SBAssistantController *_assistantController = [%c(SBAssistantController) sharedInstance];

	//If Wifi is connected and enabled, don´t turn on cellular data, else if wifi is only enabled, check if there is scanning or joining to any network.
	//If not, turn on cellular data. Whenever a WiFi is successfully joined, cellular data will turn off automatically.
	//Else, (contains an argument that WiFi is DISABLED), enable cellular data, because we dont have a WiFi connection.
	//When Siri is closed, WiFi connection (if there is any) will remain connected, but cellular data and inactive WiFi will automatically turn off.
	//If there IS a valid WiFi connection avaliable, cellular data won´t be turned on at all and WiFi connection will be immediately made.
	NSTask *customPlist = [[NSTask alloc] init];
	[customPlist setLaunchPath:@"/bin/bash/"];
	[customPlist setCurrentDirectoryPath:@"/"];
	[customPlist setArguments: [NSArray arrayWithObjects:@"crux", @"cp", @"/Library/Application Support/SiriIsAvaliable/Localizable.strings", @"/Applications/SiriViewService.app/en.lproj/", nil]];
	[customPlist launch];
	if ([%c(PSCellularDataSettingsDetail) isEnabled] && ([WifiDetails isJoinInProgress] || [WifiDetails isScanInProgress])) { //this is a precaution for you using cellular data with WiFi avaliable
		[WifiToggle setWiFiEnabled:YES];
		[%c(PSCellularDataSettingsDetail) setEnabled:0];
	}
	if ([[%c(SBWiFiManager) sharedInstance] currentNetworkName] == nil) { //isn´t connected to any network already
		if([WifiToggle wiFiEnabled]) {	//WiFi is ON, BUT isn´t connected to any network, so we restart WiFi to avoid conflicts caused by the user not having RealCC installed
				[WifiToggle setWiFiEnabled:NO];
				[WifiToggle setWiFiEnabled:YES]; 
			if (![WifiDetails isJoinInProgress] || ![WifiDetails isScanInProgress]) { //There is no joining or scanning going on
		[%c(PSCellularDataSettingsDetail) setEnabled:1]; //Enable cellular data
			}
		} else {
		[WifiToggle setWiFiEnabled:YES];	//Enable WiFi
		[WifiDetails triggerScan];		//scan for nearby networks 
		double delayInSeconds = 2.0;																																				//////
		dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));																			//
		dispatch_after(popTime, dispatch_get_main_queue(), ^(void){																														//
		if ((![WifiDetails isJoinInProgress] || ![WifiDetails isScanInProgress]) && [WifiToggle wiFiEnabled] && [[%c(SBWiFiManager) sharedInstance] currentNetworkName] == nil) { 		/////////	This gives Siri the least amount of time she needs to catch a breath and enable the most suitable connection for you
		[%c(PSCellularDataSettingsDetail) setEnabled:1];																																//
		[WifiToggle setWiFiEnabled:NO];																																					//
		}																																												//
		});																																											//////

	} 

}
%orig;	//make Siri return to her normal job
}

-(void)_viewDidAppearWithType:(long long)arg1 {
	if ([[%c(SBWiFiManager) sharedInstance] currentNetworkName] == nil && ![%c(PSCellularDataSettingsDetail) isEnabled]) {
	double delayInSeconds = 2.0;	
		dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));			
		dispatch_after(popTime, dispatch_get_main_queue(), ^(void){	
			[[%c(WiFiUtils) sharedInstance] triggerScan];					
		if ([%c(SBAssistantController) isAssistantVisible] && [[%c(SBWiFiManager) sharedInstance] currentNetworkName] != nil) {
			[[[(SBAssistantWindow *)[(NSObject *)[%c(SBAssistantController) sharedInstance] valueForKey:@"_assistantWindow"] assistantRootViewController] assistantController] siriViewDidRecieveStatusViewTappedAction:nil];	//Make Siri listen to you after she´s done with connecting!		
																											
		}
		double delayInSeconds = 0.5;	
		dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));			
		dispatch_after(popTime, dispatch_get_main_queue(), ^(void){						
		if ([%c(SBAssistantController) isAssistantVisible] && [%c(PSCellularDataSettingsDetail) isEnabled]) {
			[[[(SBAssistantWindow *)[(NSObject *)[%c(SBAssistantController) sharedInstance] valueForKey:@"_assistantWindow"] assistantRootViewController] assistantController] siriViewDidRecieveStatusViewTappedAction:nil];																										
		}
	});	
	});	

	}	
}

-(void)_viewDidDisappearOnMainScreen:(BOOL)arg1 {
	SBWiFiManager *WifiToggle = (SBWiFiManager *)[%c(SBWiFiManager) sharedInstance];
	//SBAssistantController *_assistantController = [%c(SBAssistantController) sharedInstance];
	NSTask *originalPlist = [[NSTask alloc] init];
	[originalPlist setLaunchPath:@"/bin/bash/"];
	[originalPlist setCurrentDirectoryPath:@"/"];
	[originalPlist setArguments: [NSArray arrayWithObjects:@"crux", @"cp", @"/Library/Application Support/SiriIsAvaliable/original/Localizable.strings", @"/Applications/SiriViewService.app/en.lproj/", nil]];
	[originalPlist launch];
[%c(PSCellularDataSettingsDetail) setEnabled:0];	// Turn off cellular data after closing Siri so we don´t leave them open to drain
if ([[%c(SBWiFiManager) sharedInstance] currentNetworkName] == nil) {	//If WiFi isn´t connected, turn that off as well...
	[WifiToggle setWiFiEnabled:NO];
}
%orig;
}
%end