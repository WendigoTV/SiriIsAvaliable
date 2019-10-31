#line 1 "Tweak.x"
#import <SpringBoard/SpringBoard.h>
#import <Foundation/Foundation.h>

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


#include <substrate.h>
#if defined(__clang__)
#if __has_feature(objc_arc)
#define _LOGOS_SELF_TYPE_NORMAL __unsafe_unretained
#define _LOGOS_SELF_TYPE_INIT __attribute__((ns_consumed))
#define _LOGOS_SELF_CONST const
#define _LOGOS_RETURN_RETAINED __attribute__((ns_returns_retained))
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif

@class SBWiFiManager; @class PSCellularDataSettingsDetail; @class SBAssistantController; @class WiFiUtils; 
static void (*_logos_orig$_ungrouped$SBAssistantController$_notifyObserversViewWillAppear$)(_LOGOS_SELF_TYPE_NORMAL SBAssistantController* _LOGOS_SELF_CONST, SEL, long long); static void _logos_method$_ungrouped$SBAssistantController$_notifyObserversViewWillAppear$(_LOGOS_SELF_TYPE_NORMAL SBAssistantController* _LOGOS_SELF_CONST, SEL, long long); static void (*_logos_orig$_ungrouped$SBAssistantController$_viewDidAppearWithType$)(_LOGOS_SELF_TYPE_NORMAL SBAssistantController* _LOGOS_SELF_CONST, SEL, long long); static void _logos_method$_ungrouped$SBAssistantController$_viewDidAppearWithType$(_LOGOS_SELF_TYPE_NORMAL SBAssistantController* _LOGOS_SELF_CONST, SEL, long long); static void (*_logos_orig$_ungrouped$SBAssistantController$_viewDidDisappearOnMainScreen$)(_LOGOS_SELF_TYPE_NORMAL SBAssistantController* _LOGOS_SELF_CONST, SEL, BOOL); static void _logos_method$_ungrouped$SBAssistantController$_viewDidDisappearOnMainScreen$(_LOGOS_SELF_TYPE_NORMAL SBAssistantController* _LOGOS_SELF_CONST, SEL, BOOL); 
static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$PSCellularDataSettingsDetail(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("PSCellularDataSettingsDetail"); } return _klass; }static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$SBWiFiManager(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("SBWiFiManager"); } return _klass; }static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$WiFiUtils(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("WiFiUtils"); } return _klass; }static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$SBAssistantController(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("SBAssistantController"); } return _klass; }
#line 65 "Tweak.x"


static void _logos_method$_ungrouped$SBAssistantController$_notifyObserversViewWillAppear$(_LOGOS_SELF_TYPE_NORMAL SBAssistantController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, long long arg1) {
	SBWiFiManager *WifiToggle = (SBWiFiManager *)[_logos_static_class_lookup$SBWiFiManager() sharedInstance];
	WiFiUtils *WifiDetails = (WiFiUtils *)[_logos_static_class_lookup$WiFiUtils() sharedInstance];
	

	
	
	
	
	
	if ([[NSFileManager defaultManager] isReadableFileAtPath:@"/Applications/SiriViewService.app/en.lproj/"]) {
    [[NSFileManager defaultManager] copyItemAtPath:@"/System/Library/Application Support/SiriIsAvaliable/Localizable.strings" toPath:@"/Applications/SiriViewService.app/en.lproj/Localizable.strings" error:nil];
	}
	if ([_logos_static_class_lookup$PSCellularDataSettingsDetail() isEnabled] && ([WifiDetails isJoinInProgress] || [WifiDetails isScanInProgress])) { 
		[WifiToggle setWiFiEnabled:YES];
		[_logos_static_class_lookup$PSCellularDataSettingsDetail() setEnabled:0];
	}
	if ([[_logos_static_class_lookup$SBWiFiManager() sharedInstance] currentNetworkName] == nil) { 
		if([WifiToggle wiFiEnabled]) {	
				[WifiToggle setWiFiEnabled:NO];
				[WifiToggle setWiFiEnabled:YES]; 
			if (![WifiDetails isJoinInProgress] || ![WifiDetails isScanInProgress]) { 
		[_logos_static_class_lookup$PSCellularDataSettingsDetail() setEnabled:1]; 
			}
		} else {
		[WifiToggle setWiFiEnabled:YES];	
		[WifiDetails triggerScan];		
		double delayInSeconds = 2.0;																																				
		dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));																			
		dispatch_after(popTime, dispatch_get_main_queue(), ^(void){																														
		if ((![WifiDetails isJoinInProgress] || ![WifiDetails isScanInProgress]) && [WifiToggle wiFiEnabled] && [[_logos_static_class_lookup$SBWiFiManager() sharedInstance] currentNetworkName] == nil) { 		
		[_logos_static_class_lookup$PSCellularDataSettingsDetail() setEnabled:1];																																
		[WifiToggle setWiFiEnabled:NO];																																					
		}																																												
		});																																											

	} 

}
_logos_orig$_ungrouped$SBAssistantController$_notifyObserversViewWillAppear$(self, _cmd, arg1);	
}

static void _logos_method$_ungrouped$SBAssistantController$_viewDidAppearWithType$(_LOGOS_SELF_TYPE_NORMAL SBAssistantController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, long long arg1) {
	if ([[_logos_static_class_lookup$SBWiFiManager() sharedInstance] currentNetworkName] == nil && ![_logos_static_class_lookup$PSCellularDataSettingsDetail() isEnabled]) {
	double delayInSeconds = 1.5;	
		dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));			
		dispatch_after(popTime, dispatch_get_main_queue(), ^(void){						
		if ([_logos_static_class_lookup$SBAssistantController() isAssistantVisible] && [[_logos_static_class_lookup$SBWiFiManager() sharedInstance] currentNetworkName] != nil) {
			[[[(SBAssistantWindow *)[(NSObject *)[_logos_static_class_lookup$SBAssistantController() sharedInstance] valueForKey:@"_assistantWindow"] assistantRootViewController] assistantController] siriViewDidRecieveStatusViewTappedAction:nil];	
																											
		}
		double delayInSeconds = 0.5;	
		dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));			
		dispatch_after(popTime, dispatch_get_main_queue(), ^(void){						
		if ([_logos_static_class_lookup$SBAssistantController() isAssistantVisible] && [_logos_static_class_lookup$PSCellularDataSettingsDetail() isEnabled]) {
			[[[(SBAssistantWindow *)[(NSObject *)[_logos_static_class_lookup$SBAssistantController() sharedInstance] valueForKey:@"_assistantWindow"] assistantRootViewController] assistantController] siriViewDidRecieveStatusViewTappedAction:nil];																										
		}
	});	
	});	

	}	
}

static void _logos_method$_ungrouped$SBAssistantController$_viewDidDisappearOnMainScreen$(_LOGOS_SELF_TYPE_NORMAL SBAssistantController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, BOOL arg1) {
	SBWiFiManager *WifiToggle = (SBWiFiManager *)[_logos_static_class_lookup$SBWiFiManager() sharedInstance];
	
if ([[NSFileManager defaultManager] isReadableFileAtPath:@"/Applications/SiriViewService.app/en.lproj/"]) {
    [[NSFileManager defaultManager] copyItemAtPath:@"/System/Library/Application Support/SiriIsAvaliable/original/Localizable.strings" toPath:@"/Applications/SiriViewService.app/en.lproj/Localizable.strings" error:nil];
	}
[_logos_static_class_lookup$PSCellularDataSettingsDetail() setEnabled:0];	
if ([[_logos_static_class_lookup$SBWiFiManager() sharedInstance] currentNetworkName] == nil) {	
	[WifiToggle setWiFiEnabled:NO];
}
_logos_orig$_ungrouped$SBAssistantController$_viewDidDisappearOnMainScreen$(self, _cmd, arg1);
}

static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$SBAssistantController = objc_getClass("SBAssistantController"); MSHookMessageEx(_logos_class$_ungrouped$SBAssistantController, @selector(_notifyObserversViewWillAppear:), (IMP)&_logos_method$_ungrouped$SBAssistantController$_notifyObserversViewWillAppear$, (IMP*)&_logos_orig$_ungrouped$SBAssistantController$_notifyObserversViewWillAppear$);MSHookMessageEx(_logos_class$_ungrouped$SBAssistantController, @selector(_viewDidAppearWithType:), (IMP)&_logos_method$_ungrouped$SBAssistantController$_viewDidAppearWithType$, (IMP*)&_logos_orig$_ungrouped$SBAssistantController$_viewDidAppearWithType$);MSHookMessageEx(_logos_class$_ungrouped$SBAssistantController, @selector(_viewDidDisappearOnMainScreen:), (IMP)&_logos_method$_ungrouped$SBAssistantController$_viewDidDisappearOnMainScreen$, (IMP*)&_logos_orig$_ungrouped$SBAssistantController$_viewDidDisappearOnMainScreen$);} }
#line 143 "Tweak.x"
