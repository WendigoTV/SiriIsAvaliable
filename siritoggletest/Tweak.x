#import <SpringBoard/SpringBoard.h>
#import <UIKit/UIKit.h>

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

@interface SBAssistantController
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
	//SBAssistantController *_assistantController = [%c(SBAssistantController) sharedInstance];			!IMPORTANT!
	
	
	//If Wifi is connected and enabled, don´t turn on cellular data, else if wifi is only enabled, check if there is scanning or joining to any network.
	//If not, turn on cellular data. Whenever a WiFi is successfully joined, cellular data will turn off automatically.
	//Else, (contains an argument that WiFi is DISABLED), enable cellular data, because we dont have a WiFi connection.
	//When Siri is closed, WiFi connection (if there is any) will remain connected, but cellular data and inactive WiFi will automatically turn off.
	//If there IS a valid WiFi connection avaliable, cellular data won´t be turned on at all and WiFi connection will be immediately made.

	if ([[%c(SBWiFiManager) sharedInstance] currentNetworkName] == nil) { //isn´t connected to any network already
		if([WifiToggle wiFiEnabled]) {	//WiFi is ON
				[WifiToggle setWiFiEnabled:NO];
				[WifiToggle setWiFiEnabled:YES]; 
			if (![WifiDetails isJoinInProgress] || ![WifiDetails isScanInProgress]) { //There is no joining or scanning going on
		[%c(PSCellularDataSettingsDetail) setEnabled:1];
			}
		} else {
		[WifiToggle setWiFiEnabled:YES];
		double delayInSeconds = 1.0;
		dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
		dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
		if ((![WifiDetails isJoinInProgress] || ![WifiDetails isScanInProgress]) && [[%c(SBWiFiManager) sharedInstance] currentNetworkName] == nil) {
		[%c(PSCellularDataSettingsDetail) setEnabled:1];
		[WifiToggle setWiFiEnabled:NO];
		}
		});

	} 

}
%orig;
}

-(void)_viewDidDisappearOnMainScreen:(BOOL)arg1 {
	SBWiFiManager *WifiToggle = (SBWiFiManager *)[%c(SBWiFiManager) sharedInstance];
	//SBAssistantController *_assistantController = [%c(SBAssistantController) sharedInstance];
	
[%c(PSCellularDataSettingsDetail) setEnabled:0];
if ([[%c(SBWiFiManager) sharedInstance] currentNetworkName] == nil) {
	[WifiToggle setWiFiEnabled:NO];
}
%orig;
}
%end