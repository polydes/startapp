/*
 *
 * Created by Robin Schaafsma
 * www.byrobingames.com
 *
 */
#include <hx/CFFI.h>
#include <StartAppEx.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <StartApp/StartApp.h>

using namespace startapp;

extern "C" void sendStartAppEvent(char* event);

@interface StartAppController : NSObject <STABannerDelegateProtocol, STADelegateProtocol>
{
    STABannerView* startAppBannerView;
    UIViewController *root;
    
    STAStartAppAd* startAppAd;
    
    BOOL bottom;
    BOOL initBanner;
    BOOL rewardedload;
}

- (id)initWithAppID:(NSString*)APPID withGravity:(NSString*)GMODE;
- (void)showBannerAd;
- (void)hideBannerAd;

- (void)loadInterstitialAd;
- (void)showInterstitialAd;
- (void)loadRewardedAd;

@property (nonatomic, assign) BOOL bottom;
@property (nonatomic, assign) BOOL initBanner;
@property (nonatomic, assign) BOOL rewardedload;

@end

@implementation StartAppController

@synthesize bottom;
@synthesize initBanner;
@synthesize rewardedload;

- (id)initWithAppID:(NSString*)APPID withGravity:(NSString*)GMODE
{
    self = [super init];
    NSLog(@"StartApp Init");
    if(!self) return nil;
    
    STAStartAppSDK* sdk = [STAStartAppSDK sharedInstance];
    sdk.appID = APPID;
    
    
    initBanner=[GMODE isEqualToString:@"NONE"];
    bottom=[GMODE isEqualToString:@"BOTTOM"];
    
    if(!initBanner){
        root = [[[UIApplication sharedApplication] keyWindow] rootViewController];
        
        if (bottom) {
            startAppBannerView = [[STABannerView alloc] initWithSize:STA_AutoAdSize autoOrigin:STAAdOrigin_Bottom
                                                            withView:root.view withDelegate:self];
        }else{
            startAppBannerView = [[STABannerView alloc] initWithSize:STA_AutoAdSize autoOrigin:STAAdOrigin_Top
                                                            withView:root.view withDelegate:self];
        }

        [root.view addSubview:startAppBannerView];
    }
    
    
    return self;
}
////Banner
- (void)showBannerAd
{
    NSLog(@"StartApp ShowBanner");
    [startAppBannerView showBanner];
}


- (void)hideBannerAd
{
    NSLog(@"StartApp HideBanner");
    [startAppBannerView hideBanner];
}

-(void)setPosition:(NSString*)position
{
    NSLog(@"StartApp set position");
    bottom=[position isEqualToString:@"BOTTOM"];
    
    if (bottom)
    {
        [startAppBannerView setSTAAutoOrigin:STAAdOrigin_Bottom];
        
    }else
    {
        [startAppBannerView setSTAAutoOrigin:STAAdOrigin_Top];
    }
}

#pragma mark - STABanner Delegate

- (void) didDisplayBannerAd:(STABannerView*)banner {
    sendStartAppEvent("bannerdiddisplay");
}

- (void) failedLoadBannerAd:(STABannerView*)banner withError:(NSError *)error {
    sendStartAppEvent("bannerfailedload");
}

- (void) didClickBannerAd:(STABannerView*)banner {
    sendStartAppEvent("bannerdidclicked");
}

///Interstitial
- (void)loadInterstitialAd
{
    NSLog(@"StartApp load interstitialAd");
        if(startAppAd == NULL){
            startAppAd = [[STAStartAppAd alloc] init];
        }
    
        rewardedload = NO;
    
        [startAppAd loadAdWithDelegate:self];
    
}

- (void)showInterstitialAd
{
    NSLog(@"StartApp show interstitialAd");
    if([startAppAd isReady]){
        [startAppAd showAd];
    }
}

- (void)loadRewardedAd
{
    NSLog(@"StartApp load rewarded");
    if(startAppAd == NULL){
        startAppAd = [[STAStartAppAd alloc] init];
    }
    
    rewardedload = YES;
    
    [startAppAd loadRewardedVideoAdWithDelegate:self];
    
}

#pragma mark - STA Delegate

- (void) didLoadAd:(STAAbstractAd*)ad {
    sendStartAppEvent("interstitialdidload");
}

- (void) failedLoadAd:(STAAbstractAd*)ad withError:(NSError *)error {
    sendStartAppEvent("interstitialfailedtoload");
}

- (void) didShowAd:(STAAbstractAd*)ad {
    sendStartAppEvent("interstitialdidshow");
}

- (void) failedShowAd:(STAAbstractAd*)ad withError:(NSError *)error {
    sendStartAppEvent("interstitialfailedtoshow");
}

- (void) didCloseAd:(STAAbstractAd*)ad {
    sendStartAppEvent("interstitialdidclosed");
    
    //work around for didCompleteVideo
    /*if(rewardedload){
        rewardedload = NO;
        sendStartAppEvent("rewardedfullywatched");
    }*/
}

- (void) didClickAd:(STAAbstractAd*)ad {
    sendStartAppEvent("interstitialisclicked");
}
//App crashes when called didCompleteVideo after Video is finish.
- (void) didCompleteVideo:(STAAbstractAd*)ad {
    sendStartAppEvent("rewardedfullywatched");
}

@end

namespace startapp {
	
	static StartAppController *startAppController;
    
	void init(const char *__appID, const char *__GMode){
        
        if(startAppController == NULL)
        {
            startAppController = [[StartAppController alloc] init];
        }
        
        NSString *appID = [NSString stringWithUTF8String:__appID];
        NSString *GMODE = [NSString stringWithUTF8String:__GMode];

        
        [startAppController initWithAppID:appID withGravity:GMODE];
    }
    

    void showBanner()
    {
        
        if(startAppController!=NULL) [startAppController showBannerAd];
    }
    
    void hideBanner()
    {
        
        if(startAppController!=NULL) [startAppController hideBannerAd];
    }
    
    void setBannerPosition(const char *__GMode)
    {
        if(startAppController != NULL)
        {
            NSString *GMODE = [NSString stringWithUTF8String:__GMode];
            
            [startAppController setPosition:GMODE];
        }
    }
    
    void loadInterstitial()
    {
        
        if(startAppController!=NULL) [startAppController loadInterstitialAd];
    }
    
    void showInterstitial()
    {
        
        if(startAppController!=NULL) [startAppController showInterstitialAd];
    }
    
    void loadRewarded()
    {
        
        if(startAppController!=NULL) [startAppController loadRewardedAd];
    }
    
    void setStartAppConsent(bool isGranted)
    {
        [[STAStartAppSDK sharedInstance] setUserConsent:isGranted forConsentType:@"pas" withTimestamp:[[NSDate date] timeIntervalSince1970]];
        
        [[NSUserDefaults standardUserDefaults] setBool:isGranted forKey:@"gdpr_consent_startapp"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSLog(@"StartApp SetConsent:  %@", @(isGranted));
    }
    
    bool getStartAppConsent()
    {
        return [[NSUserDefaults standardUserDefaults] boolForKey:@"gdpr_consent_startapp"];
    }
    
    
}
