//
//  TeadsPlugin.h
//  TeadsSDK
//
//  Created by Nikolaï Roycourt on 2/16/15.
//  Copyright (c) 2015 Teads. All rights reserved.
//
#import <Cordova/CDV.h>
#import <Cordova/CDVViewController.h>
#import <Cordova/CDVWebViewDelegate.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import <TeadsSDK/TeadsSDK.h>



@interface TeadsPlugin : CDVPlugin <UIWebViewDelegate, TeadsAdFactoryDelegate, TeadsInterstitialDelegate, TeadsNativeVideoDelegate>

//TeadsAdFactory

- (void)loadNativeVideoAdWithPidToAdFactory:(CDVInvokedUrlCommand*)command;
- (void)loadInterstitialAdWithPidToAdFactory:(CDVInvokedUrlCommand*)command;

//Teads fullscreen video
- (void)initInFlowWithPlacementId:(CDVInvokedUrlCommand*)command;
- (void)getInFlowIsLoaded:(CDVInvokedUrlCommand*)command;
- (void)setPreDownloadInFlow:(CDVInvokedUrlCommand*)command;
- (void)loadInFlow:(CDVInvokedUrlCommand*)command;
- (void)loadInFlowFromAdFactory:(CDVInvokedUrlCommand*)command;
- (void)showInFlow:(CDVInvokedUrlCommand*)command;
- (void)cleanInFlow:(CDVInvokedUrlCommand*)command;
- (void)setRewardEnabledInFlow:(CDVInvokedUrlCommand*)command;
- (void)isRewardEnabledInFlow:(CDVInvokedUrlCommand*)command;
- (void)setRewardInfoInFlow:(CDVInvokedUrlCommand*)command;
- (void)onLayoutChangeInFlow:(CDVInvokedUrlCommand*)command;


//Teads native video (inRead & inBoard)
//init inBoard
- (void)initInBoardWithPlacementId:(CDVInvokedUrlCommand*)command;
//init inRead
- (void)initinReadWithPlacementId:(CDVInvokedUrlCommand*)command;

//Native video (inRead & inBoard) common methods
- (void)getNativeVideoIsLoaded:(CDVInvokedUrlCommand*)command;
- (void)setPreDownLoadNativeVideo:(CDVInvokedUrlCommand*)command;
- (void)loadNativeVideo:(CDVInvokedUrlCommand*)command;
- (void)loadNativeVideoFromAdFactory:(CDVInvokedUrlCommand*)command;
- (void)cleanNativeVideo:(CDVInvokedUrlCommand*)command;
- (void)requestPauseNativeVideo:(CDVInvokedUrlCommand*)command;
- (void)requestPlayNativeVideo:(CDVInvokedUrlCommand*)command;
- (void)viewControllerAppearedForNativeVideo:(CDVInvokedUrlCommand*)command;
- (void)viewControllerDisappearedForNativeVideo:(CDVInvokedUrlCommand*)command;

@end
