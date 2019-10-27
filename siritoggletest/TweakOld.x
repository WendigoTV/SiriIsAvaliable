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
@end

@interface SBAssistantController
+(BOOL)isAssistantVisible;
+(id)sharedInstance;
-(BOOL)handleSiriButtonDownEventFromSource:(NSInteger)arg1 activationEvent:(NSInteger)arg2;
-(void)handleSiriButtonUpEventFromSource:(NSInteger)arg1;
-(void)dismissPluginForEvent:(NSInteger)arg1;
-(BOOL)isAssistantViewVisible:(long long)arg1 ;
@end

@interface SBWiFiManager
-(id)sharedInstance;
-(void)setWiFiEnabled:(BOOL)enabled;
-(bool)wiFiEnabled;
@end

%hook SBAssistantController
- (void)orderFront {
	%orig;
if ([%c(SBAssistantController) isAssistantVisible]) {
	SBWiFiManager *WifiToggle = (SBWiFiManager *)[%c(SBWiFiManager) sharedInstance];
	[WifiToggle setWiFiEnabled:YES];
} else {

	return;
		}

	}

%end