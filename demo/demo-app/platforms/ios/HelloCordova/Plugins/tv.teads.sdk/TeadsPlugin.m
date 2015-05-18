//
//  TeadsPlugin.h
//  TeadsSDK
//
//  Created by Nikolaï Roycourt on 2/16/15.
//  Copyright (c) 2015 Teads. All rights reserved.
//

#import "TeadsPlugin.h"

@interface TeadsPlugin () <UIScrollViewDelegate>

@property (strong, nonatomic) TeadsInterstitial *teadsInterstitial;
@property (strong, nonatomic) TeadsNativeVideo *teadsNativeVideo;
@property (nonatomic) BOOL nativeVideoAdExperienceStarted;

@end

@implementation TeadsPlugin


#pragma mark - Teads Ad Factory

- (void)loadNativeVideoAdWithPidToAdFactory:(CDVInvokedUrlCommand*)command {
    [self.commandDelegate runInBackground:^{
        NSArray* args = command.arguments;
        NSString *pid = [args objectAtIndex:0];
        
        [TeadsAdFactory setDelegate:self];
        [TeadsAdFactory loadNativeVideoAdWithPid:pid];
    }];
}

- (void)loadInterstitialAdWithPidToAdFactory:(CDVInvokedUrlCommand*)command {
    [self.commandDelegate runInBackground:^{
        NSArray* args = command.arguments;
        NSString *pid = [args objectAtIndex:0];
        
        [TeadsAdFactory setDelegate:self];
        [TeadsAdFactory loadFullscreenAdWithPid:pid];
    }];
}


#pragma mark - Teads Fullscreen Video

- (void)initInFlowWithPlacementId:(CDVInvokedUrlCommand*)command {
    NSString *pid = [command.arguments objectAtIndex:0];
    
    

    [self.commandDelegate runInBackground:^{
        CDVPluginResult* pluginResult = nil;
        if (pid != nil) {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
            self.teadsInterstitial = [[TeadsInterstitial alloc] initInFlowWithPlacementId:pid rootViewController:self.viewController delegate:self];
        } else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"No pid provided"];
        }
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
    
}

- (void)getInFlowIsLoaded:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:self.teadsInterstitial.isLoaded];
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)setPreDownloadInFlow:(CDVInvokedUrlCommand*)command {
    [self.commandDelegate runInBackground:^{
        NSArray* args = command.arguments;
        BOOL preDownload = [[args objectAtIndex:0] boolValue];
        
        [self.teadsInterstitial setPreDownLoad:preDownload];
    }];
}

- (void)loadInFlow:(CDVInvokedUrlCommand*)command {
    [self.commandDelegate runInBackground:^{
        [self.teadsInterstitial load];
    }];
}

- (void)showInFlow:(CDVInvokedUrlCommand*)command {
    [self.teadsInterstitial show];
}

- (void)loadInFlowFromAdFactory:(CDVInvokedUrlCommand*)command {
    [self.commandDelegate runInBackground:^{
        [self.teadsInterstitial loadFromFactory];
    }];
}

- (void)cleanInFlow:(CDVInvokedUrlCommand*)command {
    [self.commandDelegate runInBackground:^{
        [self.teadsInterstitial clean];
    }];
}


#pragma mark - Teads Native Video

- (void)onReset
{
    if (self.nativeVideoAdExperienceStarted) {
        [self.teadsNativeVideo clean];
    }
    [super onReset];
}

- (void)initInBoardWithPlacementId:(CDVInvokedUrlCommand*)command {
    self.nativeVideoAdExperienceStarted = NO;
    NSArray* args = command.arguments;
    
    NSString *pid = [args objectAtIndex:0];
    
    CDVPluginResult* pluginResult = nil;
    if (pid != nil) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        self.teadsNativeVideo = nil;
        self.teadsNativeVideo = [[TeadsNativeVideo alloc] initInBoardWithPlacementId:pid uiWebView:self.webView rootViewController:self.viewController delegate:self];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"No pid provided"];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    
    [self triggerWebViewLoadEvents];
}


- (void)initinReadWithPlacementId:(CDVInvokedUrlCommand*)command {
    self.nativeVideoAdExperienceStarted = NO;
    
    NSString *pid = [command.arguments objectAtIndex:0];
    NSString *placeHolder = [command.arguments objectAtIndex:1];
    
    CDVPluginResult* pluginResult = nil;
    if (pid != nil) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        self.teadsNativeVideo = nil;
        self.teadsNativeVideo = [[TeadsNativeVideo alloc] initInReadWithPlacementId:pid placeholderText:placeHolder uiWebView:self.webView rootViewController:self.viewController delegate:self];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"No pid provided"];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    
    [self triggerWebViewLoadEvents];
}

-(void)triggerWebViewLoadEvents {
    [self.webView.delegate webViewDidStartLoad:self.webView];
    [self.webView.delegate webViewDidFinishLoad:self.webView];
}

- (void)getNativeVideoIsLoaded:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:self.teadsNativeVideo.isLoaded];
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)setPreDownLoadNativeVideo:(CDVInvokedUrlCommand*)command {
    [self.commandDelegate runInBackground:^{
        NSArray* args = command.arguments;
        BOOL preDownload = [[args objectAtIndex:0] boolValue];
        
        [self.teadsNativeVideo setPreDownLoad:preDownload];
    }];
}

- (void)loadNativeVideo:(CDVInvokedUrlCommand*)command {
    if (!self.nativeVideoAdExperienceStarted) {
        [self.teadsNativeVideo load];
    }
}

- (void)loadNativeVideoFromAdFactory:(CDVInvokedUrlCommand*)command {
    [self.teadsNativeVideo loadFromFactory];
}

- (void)cleanNativeVideo:(CDVInvokedUrlCommand*)command {
    [self.teadsNativeVideo clean];
    self.nativeVideoAdExperienceStarted = NO;
}

- (void)requestPauseNativeVideo:(CDVInvokedUrlCommand*)command {
    [self.teadsNativeVideo requestPause];
}

- (void)requestPlayNativeVideo:(CDVInvokedUrlCommand*)command {
    [self.teadsNativeVideo requestPlay];
}

- (void)viewControllerAppearedForNativeVideo:(CDVInvokedUrlCommand*)command {
    [self.teadsNativeVideo viewControllerAppeared:self.viewController];
}

- (void)viewControllerDisappearedForNativeVideo:(CDVInvokedUrlCommand*)command {
    [self.teadsNativeVideo viewControllerDisappeared:self.viewController];
}


#pragma mark - Native to JS

- (void)fireDocumentEvent:(NSString *)eventName withData:(NSString *)jsonStr
{
    NSString* js;
    if(jsonStr && [jsonStr length]>0) {
        js = [NSString stringWithFormat:@"javascript:cordova.fireDocumentEvent('%@',%@);", eventName, jsonStr];
    } else {
        js = [NSString stringWithFormat:@"javascript:cordova.fireDocumentEvent('%@');", eventName];
    }
    [self.commandDelegate evalJs:js];
}

#pragma mark- Teads Ad Factory delegate

- (void)teadsAdType:(TeadsAdType)type withPid:(NSString *)pid didFailLoading:(TeadsError *)error {
    NSString *adType = @"";
    switch (type) {
        case TeadsFullscreenAdType:
            adType = @"TeadsFullscreenAdType";
            break;
        case TeadsNativeVideoAdType:
            adType = @"TeadsNativeVideoAdType";
        default:
            break;
    }
    
    NSString *teadsErrorType = @"";
    switch (error.code) {
        case TeadsAdFailsToLoad:
            teadsErrorType = @"TeadsAdFailsToLoad";
            break;
        case TeadsAdServerBadResponse:
            teadsErrorType = @"TeadsAdServerBadResponse";
            break;
        case TeadsAdServerError:
            teadsErrorType = @"TeadsAdServerError";
            break;
        case TeadsNetworkError:
            teadsErrorType = @"TeadsNetworkError";
            break;
        case TeadsNoAdsAvailable:
            teadsErrorType = @"TeadsNoAdsAvailable";
            break;
        case TeadsTimeoutError:
            teadsErrorType = @"TeadsTimeoutError";
            break;
        default:
            break;
    }
    
    NSString *data = [NSString stringWithFormat:@"{'adType': '%@', 'pid' : '%@', 'teadsError':{'code' : '%@', 'name' : '%@', 'message' : '%@'}}", adType, pid, teadsErrorType, error.name, error.message];
    NSLog(@"data = %@", data);
    [self fireDocumentEvent:@"teadsAdFactoryDidFailLoading" withData:data];
}

- (void)teadsAdType:(TeadsAdType)type willLoad:(NSString *)pid {
    NSString *data = [NSString stringWithFormat:@"{'pid' : '%@'}", pid];
    
    [self fireDocumentEvent:@"teadsAdFactoryWillLoad" withData:data];
}

- (void)teadsAdType:(TeadsAdType)type didLoad:(NSString *)pid {
    NSString *data = [NSString stringWithFormat:@"{'pid' : '%@'}", pid];
    
    [self fireDocumentEvent:@"teadsAdFactoryDidLoad" withData:data];
}

- (void)teadsAdType:(TeadsAdType)type wasConsumed:(NSString *)pid {
    NSString *data = [NSString stringWithFormat:@"{'pid' : '%@'}", pid];
    
    [self fireDocumentEvent:@"teadsAdFactoryWasConsumed" withData:data];
}

- (void)teadsAdType:(TeadsAdType)type DidExpire:(NSString *)pid {
    NSString *data = [NSString stringWithFormat:@"{'pid' : '%@'}", pid];
    
    [self fireDocumentEvent:@"teadsAdFactoryDidExpire" withData:data];
}

#pragma mark - Teads Interstitial delegate

-(UIViewController *)viewControllerForModalPresentation:(TeadsInterstitial *)interstitial {
    return self.viewController;
}

-(void)teadsInterstitial:(TeadsInterstitial *)interstitial didFailLoading:(TeadsError *)error {
    NSString *teadsErrorType = @"";
    switch (error.code) {
        case TeadsAdFailsToLoad:
            teadsErrorType = @"TeadsAdFailsToLoad";
            break;
        case TeadsAdServerBadResponse:
            teadsErrorType = @"TeadsAdServerBadResponse";
            break;
        case TeadsAdServerError:
            teadsErrorType = @"TeadsAdServerError";
            break;
        case TeadsNetworkError:
            teadsErrorType = @"TeadsNetworkError";
            break;
        case TeadsNoAdsAvailable:
            teadsErrorType = @"TeadsNoAdsAvailable";
            break;
        case TeadsTimeoutError:
            teadsErrorType = @"TeadsTimeoutError";
            break;
        default:
            break;
    }
    
    NSString *data = [NSString stringWithFormat:@"{'code' : '%@', 'name' : '%@', 'message' : '%@'}", teadsErrorType, error.name, error.message];
    [self fireDocumentEvent:@"teadsInterstitialDidFailLoading" withData:data];
}

- (void)teadsInterstitialWillLoad:(TeadsInterstitial *)interstitial{
    [self fireDocumentEvent:@"teadsInterstitialWillLoad" withData:@""];
}

-(void)teadsInterstitialWillTakeOverFullScreen:(TeadsInterstitial *)interstitial {
    [self fireDocumentEvent:@"teadsInterstitialWillTakeOverFullScreen" withData:@""];
}

-(void)teadsInterstitialDidTakeOverFullScreen:(TeadsInterstitial *)interstitial {
    [self fireDocumentEvent:@"teadsInterstitialDidTakeOverFullScreen" withData:@""];
}

-(void)teadsInterstitialWillDismissFullScreen:(TeadsInterstitial *)interstitial {
    [self fireDocumentEvent:@"teadsInterstitialWillDismissFullScreen" withData:@""];
}

-(void)teadsInterstitialDidDismissFullScreen:(TeadsInterstitial *)interstitial {
    [self fireDocumentEvent:@"teadsInterstitialDidDismissFullScreen" withData:@""];
}

- (void)teadsInterstitialDidLoad:(TeadsInterstitial *)interstitial{
    [self fireDocumentEvent:@"teadsInterstitialDidLoad" withData:@""];
}

-(void)teadsInterstitialRewardUnlocked:(TeadsInterstitial *)interstitial {
    [self fireDocumentEvent:@"teadsInterstitialRewardUnlocked" withData:@""];
}

-(void)teadsInterstitialDidClean:(TeadsInterstitial *)interstitial {
    [self fireDocumentEvent:@"teadsInterstitialDidClean" withData:@""];
}

#pragma mark - Teads Native Video delegate

/**
 * NativeVideo Failed to Load
 *
 * @param interstitial  : the TeadsNativeVideo object
 * @param error         : the TeadsError object
 */
- (void)teadsNativeVideo:(TeadsNativeVideo *)nativeVideo didFailLoading:(TeadsError *)error {
    NSString *teadsErrorType = @"";
    switch (error.code) {
        case TeadsAdFailsToLoad:
            teadsErrorType = @"TeadsAdFailsToLoad";
            break;
        case TeadsAdServerBadResponse:
            teadsErrorType = @"TeadsAdServerBadResponse";
            break;
        case TeadsAdServerError:
            teadsErrorType = @"TeadsAdServerError";
            break;
        case TeadsNetworkError:
            teadsErrorType = @"TeadsNetworkError";
            break;
        case TeadsNoAdsAvailable:
            teadsErrorType = @"TeadsNoAdsAvailable";
            break;
        case TeadsTimeoutError:
            teadsErrorType = @"TeadsTimeoutError";
            break;
        default:
            break;
    }
    
    NSString *data = [NSString stringWithFormat:@"{'code' : '%@', 'name' : '%@', 'message' : '%@'}", teadsErrorType, error.name, error.message];
    [self fireDocumentEvent:@"teadsNativeVideoDidFailLoading" withData:data];
}

/**
 * NativeVideo Will Load (loading)
 *
 * @param interstitial  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoWillLoad:(TeadsNativeVideo *)nativeVideo {
    [self fireDocumentEvent:@"teadsNativeVideoWillLoad" withData:@""];
}

/**
 * NativeVideo Did Load (loaded successfully)
 *
 * @param interstitial  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoDidLoad:(TeadsNativeVideo *)nativeVideo {
    //    [self triggerWebViewLoadEvents];
    [self.webView.delegate webViewDidFinishLoad:self.webView];
    [self fireDocumentEvent:@"teadsNativeVideoDidLoad" withData:@""];
}

/**
 * NativeVideo Will Start Playing (loading)
 *
 * @param nativeVideo  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoWillStart:(TeadsNativeVideo *)nativeVideo {
    [self fireDocumentEvent:@"teadsNativeVideoWillStart" withData:@""];
}

/**
 * NativeVideo Did Start Playing (playing)
 *
 * @param nativeVideo  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoDidStart:(TeadsNativeVideo *)nativeVideo {
    self.nativeVideoAdExperienceStarted = YES;
    [self fireDocumentEvent:@"teadsNativeVideoDidStart" withData:@""];
}

/**
 * NativeVideo Will Stop Playing (stopping)
 *
 * @param nativeVideo  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoWillStop:(TeadsNativeVideo *)nativeVideo {
    [self fireDocumentEvent:@"teadsNativeVideoWillStop" withData:@""];
}

/**
 * NativeVideo Did Stop Playing (stopped)
 *
 * @param nativeVideo  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoDidStop:(TeadsNativeVideo *)nativeVideo {
    self.nativeVideoAdExperienceStarted = NO;
    [self fireDocumentEvent:@"teadsNativeVideoDidStop" withData:@""];
}

/**
 * NativeVideo Did Pause (paused)
 *
 * @param nativeVideo  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoDidPause:(TeadsNativeVideo *)nativeVideo {
    [self fireDocumentEvent:@"teadsNativeVideoDidPause" withData:@""];
}

/**
 * NativeVideo Did Resume (playing)
 *
 * @param nativeVideo  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoDidResume:(TeadsNativeVideo *)nativeVideo {
    [self fireDocumentEvent:@"teadsNativeVideoDidResume" withData:@""];
}

/**
 * NativeVideo Did Mute Sound
 *
 * @param nativeVideo  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoDidMute:(TeadsNativeVideo *)nativeVideo {
    [self fireDocumentEvent:@"teadsNativeVideoDidMute" withData:@""];
}

/**
 * NativeVideo Did Unmute Sound
 *
 * @param nativeVideo  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoDidUnmute:(TeadsNativeVideo *)nativeVideo {
    [self fireDocumentEvent:@"teadsNativeVideoDidUnmute" withData:@""];
}

/**
 * NativeVideo Will expand
 *
 * @param nativeVideo  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoWillExpand:(TeadsNativeVideo *)nativeVideo {
    [self fireDocumentEvent:@"teadsNativeVideoWillExpand" withData:@""];
}

/**
 * NativeVideo Did expand
 *
 * @param nativeVideo  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoDidExpand:(TeadsNativeVideo *)nativeVideo {
    [self fireDocumentEvent:@"teadsNativeVideoDidExpand" withData:@""];
}

/**
 * NativeVideo Will collapse
 *
 * @param nativeVideo  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoWillCollapse:(TeadsNativeVideo *)nativeVideo {
    [self fireDocumentEvent:@"teadsNativeVideoWillCollapse" withData:@""];
}

/**
 * NativeVideo did collapse
 *
 * @param nativeVideo  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoDidCollapse:(TeadsNativeVideo *)nativeVideo {
    self.nativeVideoAdExperienceStarted = NO;
    [self fireDocumentEvent:@"teadsNativeVideoDidCollapse" withData:@""];
}

/**
 * NativeVideo was clicked
 *
 * @param nativeVideo  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoWasClicked:(TeadsNativeVideo *)nativeVideo {
    [self fireDocumentEvent:@"teadsNativeVideoWasClicked" withData:@""];
}

/**
 * NativeVideo Did Stop Playing (stopped)
 *
 * @param nativeVideo  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoDidClickBrowserClose:(TeadsNativeVideo *)nativeVideo {
    [self fireDocumentEvent:@"teadsNativeVideoDidClickBrowserClose" withData:@""];
}

/**
 * NativeVideo Will Take Over Fullscreen
 *
 * @param nativeVideo  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoWillTakeOverFullScreen:(TeadsNativeVideo *)nativeVideo {
    [self fireDocumentEvent:@"teadsNativeVideoWillTakeOverFullScreen" withData:@""];
}

/**
 * NativeVideo Did Take Over Fullscreen
 *
 * @param nativeVideo  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoDidTakeOverFullScreen:(TeadsNativeVideo *)nativeVideo {
    [self fireDocumentEvent:@"teadsNativeVideoDidTakeOverFullScreen" withData:@""];
}

/**
 * NativeVideo Will Dismiss Fullscreen
 *
 * @param nativeVideo  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoWillDismissFullscreen:(TeadsNativeVideo *)nativeVideo {
    [self fireDocumentEvent:@"teadsNativeVideoWillDismissFullscreen" withData:@""];
}

/**
 * NativeVideo Did Dismiss Fullscreen
 *
 * @param nativeVideo  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoDidDismissFullscreen:(TeadsNativeVideo *)nativeVideo {
    [self fireDocumentEvent:@"teadsNativeVideoDidDismissFullscreen" withData:@""];
}

/**
 * NativeVideo Skip Button Was Tapped (skip button pressed)
 *
 * @param nativeVideo  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoSkipButtonTapped:(TeadsNativeVideo *)nativeVideo {
    [self fireDocumentEvent:@"teadsNativeVideoSkipButtonTapped" withData:@""];
}

/**
 * NativeVideo Skip Button Did Show (skip button appeared)
 *
 * @param nativeVideo  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoSkipButtonDidShow:(TeadsNativeVideo *)nativeVideo {
    [self fireDocumentEvent:@"teadsNativeVideoSkipButtonDidShow" withData:@""];
}

/**
 * NativeVideo did clean (all related resoures have been removed)
 *
 * @param nativeVideo  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoDidClean:(TeadsNativeVideo *)nativeVideo {
    [self fireDocumentEvent:@"teadsNativeVideoDidClean" withData:@""];
}

@end
