//
//  TeadsPlugin
//  TeadsSDK
//
//  Created by Nikolaï Roycourt on 2/16/15.
//  Copyright (c) 2015 Teads. All rights reserved.
//

package tv.teads.plugin;


import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaWebView;
import org.apache.cordova.PluginResult;
import org.apache.cordova.PluginResult.Status;

import android.app.Activity;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;


import tv.teads.sdk.publisher.TeadsConfiguration;
import tv.teads.sdk.publisher.TeadsError;
import tv.teads.sdk.publisher.TeadsInterstitial;
import tv.teads.sdk.publisher.TeadsInterstitialEventListener;
import tv.teads.sdk.publisher.TeadsLockableViewPager;
import tv.teads.sdk.publisher.TeadsNativeVideo;
import tv.teads.sdk.publisher.TeadsNativeVideoEventListener;
import tv.teads.sdk.publisher.TeadsObservableWebView;


import android.util.Log;

public class TeadsPlugin extends CordovaPlugin implements TeadsInterstitialEventListener, TeadsNativeVideoEventListener {
    
    /** Cordova Actions. */
    
    //TeadsAdFactory
    private static final String ACTION_ADFACTORY_LOAD_NATIVE        = "loadNativeVideoAdWithPidToAdFactory";
    private static final String ACTION_ADFACTORY_LOAD_INTERSTITIAL  = "loadInterstitialAdWithPidToAdFactory";
    
    //Teads fullscreen video
    private static final String ACTION_INFLOW_INIT              = "initInFlowWithPlacementId";
    private static final String ACTION_INFLOW_ISLOADED          = "getInFlowIsLoaded";
    private static final String ACTION_INFLOW_SET_PREDOWNLOAD   = "setPreDownloadInFlow";
    private static final String ACTION_INFLOW_LOAD              = "loadInFlow";
    private static final String ACTION_INFLOW_LOAD_FROM_ADFACTORY = "loadInFlowFromAdFactory";
    private static final String ACTION_INFLOW_SHOW              = "showInFlow";
    private static final String ACTION_INFLOW_CLEAN             = "cleanInFlow";
    private static final String ACTION_INFLOW_ONLAYOUTCHANGE    = "onLayoutChangeInFlow";
    
    //Teads native video (inRead & inBoard)
    //init inBoard
    private static final String ACTION_NATIVE_INIT_INBOARD  = "initInBoardWithPlacementId";
    //init inRead
    private static final String ACTION_NATIVE_INIT_INREAD   = "initinReadWithPlacementId";

    //Native video (inRead & inBoard) common methods
    private static final String ACTION_NATIVE_ISLOADED          = "getNativeVideoIsLoaded";
    private static final String ACTION_NATIVE_SET_PREDOWNLOAD   = "setPreDownLoadNativeVideo";
    private static final String ACTION_NATIVE_LOAD              = "loadNativeVideo";
    private static final String ACTION_NATIVE_LOAD_FROM_FACTORY = "loadNativeVideoFromAdFactory";
    private static final String ACTION_NATIVE_CLEAN             = "cleanNativeVideo";
    private static final String ACTION_NATIVE_REQUEST_PAUSE     = "requestPauseNativeVideo";
    private static final String ACTION_NATIVE_REQUEST_PLAY      = "requestPlayNativeVideo";
    private static final String ACTION_NATIVE_VIEW_DID_APPEAR   = "viewControllerAppearedForNativeVideo";
    private static final String ACTION_NATIVE_DID_DISAPPEAR     = "viewControllerDisappearedForNativeVideo";
    
    /* Parameters */
    private static final String OPT_PUBLISHER_ID = "publisherId";
    private static final String OPT_INTERSTITIAL_AD_ID = "interstitialAdId";
    private static final String OPT_AD_SIZE = "adSize";
    private static final String OPT_BANNER_AT_TOP = "bannerAtTop";
    private static final String OPT_OVERLAP = "overlap";
    private static final String OPT_OFFSET_TOPBAR = "offsetTopBar";
    private static final String OPT_IS_TESTING = "isTesting";
    private static final String OPT_AD_EXTRAS = "adExtras";
    private static final String OPT_AUTO_SHOW = "autoShow";
    
    private static final String TAG = "TeadsPluginLog";
    
    TeadsInterstitial mTeadsInterstitial;
    private CallbackContext callbackContextInFlow;

    TeadsNativeVideo mTeadsNativeVideo;
    TeadsConfiguration mTeadsConfiguration;
    private CallbackContext callbackContextInRead;
    
    @Override
    public boolean execute(String action, JSONArray data, CallbackContext callbackContext) throws JSONException {
        PluginResult result = null;
        
        Log.d(TAG, "mon log action = " + action);

        //TeadsAdFactory
        if (ACTION_ADFACTORY_LOAD_NATIVE.equals(action)) {
            result = executeLoadNativeVideoAdWithPidToAdFactory(data, callbackContext);

        } else if (ACTION_ADFACTORY_LOAD_INTERSTITIAL.equals(action)) {
            result = executeLoadInterstitialAdWithPidToAdFactory(data, callbackContext);

        }

        //Teads fullscreen video
        else if (ACTION_INFLOW_INIT.equals(action)) {
            result = executeInitInFlowWithPlacementId(data, callbackContext);

        } else if (ACTION_INFLOW_ISLOADED.equals(action)) {
            result = executeGetInFlowIsLoaded(data, callbackContext);

        } else if (ACTION_INFLOW_SET_PREDOWNLOAD.equals(action)) {
            result = executeSetPreDownloadInFlow(data, callbackContext);

        } else if (ACTION_INFLOW_LOAD.equals(action)) {
            result = executeLoadInFlow(data, callbackContext);

        } else if (ACTION_INFLOW_LOAD_FROM_ADFACTORY.equals(action)) {
            result = executeLoadInFlowFromAdFactory(data, callbackContext);

        } else if (ACTION_INFLOW_SHOW.equals(action)) {
            result = executeShowInFlow(data, callbackContext);

        } else if (ACTION_INFLOW_CLEAN.equals(action)) {
            result = executeCleanInFlow(data, callbackContext);

        } else if (ACTION_INFLOW_ONLAYOUTCHANGE.equals(action)) {
            result = executeonLayoutChangeInFlow(data, callbackContext);

        }

        //Teads native video (inRead & inBoard)
        else if (ACTION_NATIVE_INIT_INBOARD.equals(action)) {
            result = executeInitInBoardWithPlacementId(data, callbackContext);

        } else if (ACTION_NATIVE_INIT_INREAD.equals(action)) {
            result = executeInitinReadWithPlacementId(data, callbackContext);

        }
        //Native video (inRead & inBoard) common methods
        else if (ACTION_NATIVE_ISLOADED.equals(action)) {
            result = executeGetNativeVideoIsLoaded(data, callbackContext);

        } else if (ACTION_NATIVE_SET_PREDOWNLOAD.equals(action)) {
            result = executeSetPreDownLoadNativeVideo(data, callbackContext);

        } else if (ACTION_NATIVE_LOAD.equals(action)) {
            result = executeLoadNativeVideo(data, callbackContext);

        } else if (ACTION_NATIVE_LOAD_FROM_FACTORY.equals(action)) {
            result = executeLoadNativeVideoFromAdFactory(data, callbackContext);

        } else if (ACTION_NATIVE_CLEAN.equals(action)) {
            result = executeCleanNativeVideo(data, callbackContext);

        } else if (ACTION_NATIVE_REQUEST_PAUSE.equals(action)) {
            result = executeRequestPauseNativeVideo(data, callbackContext);

        } else if (ACTION_NATIVE_REQUEST_PLAY.equals(action)) {
            result = executeRequestPlayNativeVideo(data, callbackContext);

        } else if (ACTION_NATIVE_VIEW_DID_APPEAR.equals(action)) {
            result = executeViewControllerAppearedForNativeVideo(data, callbackContext);

        } else if (ACTION_NATIVE_DID_DISAPPEAR.equals(action)) {
            //result = executeiewControllerDisappearedForNativeVideo(data, callbackContext);

        } else {
            return false;
        }


        if (result != null) {
            callbackContext.sendPluginResult(result);
        }

        return true;
    }


    private PluginResult executeLoadNativeVideoAdWithPidToAdFactory(JSONArray data, final CallbackContext callbackContext) {


        return null;
    }

    private PluginResult executeLoadInterstitialAdWithPidToAdFactory(JSONArray data, final CallbackContext callbackContext) {


        return null;
    }
    
    private PluginResult executeInitInFlowWithPlacementId(JSONArray data, final CallbackContext callbackContext) {
        callbackContextInFlow = callbackContext;
        //String pid = data.getString(0);
        Log.d(TAG, "InitInterstitial");
        
        //cordova.getActivity().runOnUiThread(new Runnable() {
        //    @Override
        //    public void run() {
        try {
            mTeadsInterstitial = new TeadsInterstitial(cordova.getActivity(), "27695", this);
        } catch (Exception e) {
            Log.d(TAG, "error executeInitInterstitial = " + e.getMessage());
        } finally {
             Log.d(TAG, "fin init inter");
        }
        
        callbackContext.success();
        //    }
        //});
        
        /*
         cordova.getActivity().runOnUiThread(new Runnable() {
         @Override
         public void run() {
         Context context = cordova.getActivity().getApplicationContext();
         Intent intent = new Intent(context, MyNewActivityGap.class);
         cordova.getActivity().startActivity(intent);
         }
         });
         */
        
        return null;
    }

    private PluginResult executeGetInFlowIsLoaded(JSONArray data, final CallbackContext callbackContext) {


        return null;
    }

    private PluginResult executeSetPreDownloadInFlow(JSONArray data, final CallbackContext callbackContext) {


        return null;
    }
    
    private PluginResult executeLoadInFlow(JSONArray data, final CallbackContext callbackContext) {
        Log.d(TAG, "LoadInterstitial");
        

        try {

            mTeadsInterstitial.load();
        } catch (Exception e) {
            Log.d(TAG, "error LoadInterstitial = " + e.getMessage());
        } finally {
             Log.d(TAG, "fin LoadInterstitial");
        }

        Log.d(TAG, "load done");
        if (callbackContext != null) {
            Log.d(TAG, "callbackContext != null");
            callbackContext.success();
        }
        
        return null;
    }

    private PluginResult executeLoadInFlowFromAdFactory(JSONArray data, final CallbackContext callbackContext) {


        return null;
    }
    
    private PluginResult executeShowInFlow(JSONArray data, final CallbackContext callbackContext) {
        Log.d(TAG, "ShowInterstitial");
        if(mTeadsInterstitial.isLoaded()){
            Log.d(TAG, "isLoaded");
            
            try {

            mTeadsInterstitial.show();
        } catch (Exception e) {
            Log.d(TAG, "error ShowInterstitial = " + e.getMessage());
        } finally {
             Log.d(TAG, "fin ShowInterstitial");
        }
            
            if (callbackContext != null) {
                Log.d(TAG, "callbackContext != null");
                callbackContext.success();
            }
        } else {
            callbackContext.error("Teads Interstitial is not loaded");
        }
        
        return null;
    }

    private PluginResult executeCleanInFlow(JSONArray data, final CallbackContext callbackContext) {


        return null;
    }

    private PluginResult executeonLayoutChangeInFlow(JSONArray data, final CallbackContext callbackContext) {


        return null;
    }

    //Teads native video (inRead & inBoard)

    private PluginResult executeInitInBoardWithPlacementId(JSONArray data, final CallbackContext callbackContext) {
        mTeadsConfiguration = new TeadsConfiguration();


        mTeadsNativeVideo = new TeadsNativeVideo(
                cordova.getActivity(),
                webView.getView(),
                "27695",
                TeadsNativeVideo.NativeVideoContainerType.inBoard,
                this
        );

        return null;
    }

    private PluginResult executeInitinReadWithPlacementId(JSONArray data, final CallbackContext callbackContext) {


        return null;
    }

    //Native video (inRead & inBoard) common methods
    private PluginResult executeGetNativeVideoIsLoaded(JSONArray data, final CallbackContext callbackContext) {


        return null;
    }

    private PluginResult executeSetPreDownLoadNativeVideo(JSONArray data, final CallbackContext callbackContext) {
        mTeadsNativeVideo.load();

        return null;
    }

    private PluginResult executeLoadNativeVideo(JSONArray data, final CallbackContext callbackContext) {


        return null;
    }

    private PluginResult executeLoadNativeVideoFromAdFactory(JSONArray data, final CallbackContext callbackContext) {


        return null;
    }

    private PluginResult executeCleanNativeVideo(JSONArray data, final CallbackContext callbackContext) {


        return null;
    }

    private PluginResult executeRequestPauseNativeVideo(JSONArray data, final CallbackContext callbackContext) {


        return null;
    }

    private PluginResult executeRequestPlayNativeVideo(JSONArray data, final CallbackContext callbackContext) {


        return null;
    }

    private PluginResult executeViewControllerAppearedForNativeVideo(JSONArray data, final CallbackContext callbackContext) {


        return null;
    }

    private PluginResult executeViewControllerDisappearedForNativeVideo(JSONArray data, final CallbackContext callbackContext) {


        return null;
    }
    
    
    /**
     *  TeadsInterstitial Event Listener
     */
    
    @Override
    public void teadsInterstitialDidFailLoading(TeadsError error) {
        Log.d(TAG, "teadsInterstitialDidFailLoading");

        PluginResult dataResult = new PluginResult(PluginResult.Status.OK, "teadsInterstitialDidFailLoading");
        dataResult.setKeepCallback(true);
        callbackContextInFlow.sendPluginResult(dataResult);
    }
    
    @Override
    public void teadsInterstitialWillLoad() {
        Log.d(TAG, "teadsInterstitialWillLoad");
    }
    
    @Override
    public void teadsInterstitialDidLoad() {
        Log.d(TAG, "teadsInterstitialDidLoad");
        PluginResult dataResult = new PluginResult(PluginResult.Status.OK, "teadsInterstitialDidLoad");
        dataResult.setKeepCallback(true);
        callbackContextInFlow.sendPluginResult(dataResult);

    }
    
    @Override
    public void teadsInterstitialWillTakeOverFullScreen() {
        
    }
    
    @Override
    public void teadsInterstitialDidTakeOverFullScreen() {
        
    }
    
    @Override
    public void teadsInterstitialWillDismissFullScreen() {
        
    }
    
    @Override
    public void teadsInterstitialDidDismissFullScreen() {
        
    }
    
    @Override
    public void teadsInterstitialRewardUnlocked() {
        
    }
    
    /**
     * Teads Native Video Listener
     */

     @Override
     public void didFailLoading(TeadsError error) {
     
     }
     
     @Override
     public void nativeVideoWillLoad() {
     
     }
     
     @Override
     public void nativeVideoDidLoad() {
     
     }
     
     @Override
     public void nativeVideoWillStart() {
     
     }
     
     @Override
     public void nativeVideoDidStart() {
     
     }
     
     @Override
     public void nativeVideoWillStop() {
     
     }
     
     @Override
     public void nativeVideoDidStop() {
     
     }
     
     @Override
     public void nativeVideoDidResume() {
     
     }
     
     @Override
     public void nativeVideoDidPause() {
     
     }
     
     @Override
     public void nativeVideoDidMute() {
     
     }
     
     @Override
     public void nativeVideoDidUnmute() {
     
     }
     
     @Override
     public void nativeVideoDidOpenInternalBrowser() {
     
     }
     
     @Override
     public void nativeVideoDidClickBrowserClosed() {
     
     }
     
     @Override
     public void nativeVideoWillTakerOverFullScreen() {
     
     }
     
     @Override
     public void nativeVideoDidTakeOverFullScreen() {
     
     }
     
     @Override
     public void nativeVideoWillDismiss() {
     
     }
     
     @Override
     public void nativeVideoDidDismiss() {
     
     }
     
     @Override
     public void nativeVideoSkipButtonTapped() {
     
     }
     
     @Override
     public void nativeVideoSkipButtonDidShow() {
     
     }
     
     @Override
     public void nativeVideoWillExpand() {
     
     }
     
     @Override
     public void nativeVideoDidExpand() {
     
     }
     
     @Override
     public void nativeVideoWillCollapse() {
     
     }
     
     @Override
     public void nativeVideoDidCollapse() {
     
     }
}
