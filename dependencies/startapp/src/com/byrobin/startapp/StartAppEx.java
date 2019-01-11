/*
 *
 * Created by Robin Schaafsma
 * www.byrobingames.com
 * copyright
 */

package com.byrobin.startapp;

import android.app.Activity;
import android.content.Context;
import android.content.SharedPreferences;
import android.content.Intent;
import android.os.*;
import android.util.Log;
import android.content.ActivityNotFoundException;
import android.widget.LinearLayout;
import android.view.ViewGroup;
import android.view.Gravity;
import android.view.animation.Animation;
import android.view.animation.AlphaAnimation;
import android.view.View;
import android.view.ViewGroup.LayoutParams;
import android.view.Window;
import android.view.WindowManager;

import org.haxe.extension.Extension;
import org.haxe.lime.HaxeObject;

import com.startapp.android.publish.ads.banner.Banner;
import com.startapp.android.publish.ads.banner.BannerListener;
import com.startapp.android.publish.adsCommon.Ad;
import com.startapp.android.publish.adsCommon.StartAppAd;
import com.startapp.android.publish.adsCommon.StartAppAd.AdMode;
import com.startapp.android.publish.adsCommon.StartAppSDK;
import com.startapp.android.publish.adsCommon.VideoListener;
import com.startapp.android.publish.adsCommon.adListeners.AdDisplayListener;
import com.startapp.android.publish.adsCommon.adListeners.AdEventListener;


public class StartAppEx extends Extension {

    private StartAppAd startAppAd = new StartAppAd(mainActivity);
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//////////////////////////////////////////////////////////////////////////////////////////////////
    private static StartAppEx _self = null;
    protected static HaxeObject startappCallback;
    private static Banner startAppBanner = null;
    private static LinearLayout layout;
    
    //////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////////
    private static String appId = null;
    private static String gMode = null;
    private static int gravity=Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL;
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//////////////////////////////////////////////////////////////////////////////////////////////////

	static public void init(HaxeObject cb, final String appId, final String gMode){
        
        startappCallback = cb;
        StartAppEx.appId= appId;
        StartAppEx.gMode= gMode;
        
		Extension.mainActivity.runOnUiThread(new Runnable() {
            public void run() 
			{
                Log.d("StartAppEx","Init StartApp appId:" + appId);
                StartAppSDK.init(Extension.mainActivity, appId, true);
                
                if(!gMode.equals("NONE")){
                    setBannerPosition(gMode);
                    initStartAppBanner();
                }
			}
		});	
	}

    /////////////////////////////////////Banner///////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////////

    
    static public void showBanner() {
        Log.d("StartAppEx","Show Banner");
        
        mainActivity.runOnUiThread(new Runnable() {
            public void run() {
                
                startAppBanner.showBanner();
                
                Animation animation1 = new AlphaAnimation(0.0f, 1.0f);
                animation1.setDuration(1000);
                layout.startAnimation(animation1);
            }
        });
    }
    
    
    static public void hideBanner() {
        
        Log.d("StartAppEx","Hide Banner");
        
        mainActivity.runOnUiThread(new Runnable() {
            public void run() {
                
                Animation animation1 = new AlphaAnimation(1.0f, 0.0f);
                animation1.setDuration(1000);
                layout.startAnimation(animation1);
                
                final Handler handler = new Handler();
                handler.postDelayed(new Runnable() {
                    @Override
                    public void run() {
                        startAppBanner.hideBanner();
                    }
                }, 1000);
                
            }
        });
    }
    
    static public void setBannerPosition(final String gravityMode)
    {
        mainActivity.runOnUiThread(new Runnable()
                                   {
            public void run()
            {
                
                if(gravityMode.equals("TOP"))
                {
                    if(startAppBanner==null)
                    {
                        StartAppEx.gravity=Gravity.TOP | Gravity.CENTER_HORIZONTAL;
                    }else
                    {
                        StartAppEx.gravity=Gravity.TOP | Gravity.CENTER_HORIZONTAL;
                        layout.setGravity(gravity);
                    }
                }else
                {
                    if(startAppBanner==null)
                    {
                        StartAppEx.gravity=Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL;
                    }else
                    {
                        StartAppEx.gravity=Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL;
                        layout.setGravity(gravity);
                    }
                }
            }
        });
    }
    
    public static void initStartAppBanner(){
        if(startAppBanner==null){ // if this is the first time we call this function
            layout = new LinearLayout(mainActivity);
            layout.setGravity(gravity);
        } else {
            ViewGroup parent = (ViewGroup) layout.getParent();
            parent.removeView(layout);
            layout.removeView(startAppBanner);
        }
        
        
        startAppBanner = new Banner(mainActivity, new BannerListener() {
            @Override
            public void onReceiveAd(View banner) {
                startappCallback.call("onBannerDidDisplay", new Object[] {});
            }
            @Override
            public void onFailedToReceiveAd(View banner) {
                startappCallback.call("onBannerFailedToLoad", new Object[] {});
            }
            @Override
            public void onClick(View banner) {
                startappCallback.call("onBannerIsClicked", new Object[] {});
            }
        });
        
        mainActivity.addContentView(layout, new LayoutParams(LayoutParams.FILL_PARENT, LayoutParams.FILL_PARENT));
        layout.addView(startAppBanner);
        layout.bringToFront();
    }
    
    /////////////////////////////////////Interstitial/////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////////
    
    static public void loadInterstitial(){
        
        mainActivity.runOnUiThread(new Runnable() {
            public void run() {
                
                _self.startAppAd.loadAd (AdMode.AUTOMATIC,new AdEventListener() {
                    @Override
                    public void onReceiveAd(Ad ad) {
                        startappCallback.call("onInterstitialDidLoad", new Object[] {});
                    }
                    @Override
                    public void onFailedToReceiveAd(Ad ad) {
                        startappCallback.call("onInterstitialFailedToLoad", new Object[] {});
                    }
                });
                
            }
        });
    }
    
    static public void showInterstitial(){
        
        mainActivity.runOnUiThread(new Runnable() {
            public void run() {
                
                _self.startAppAd.showAd(new AdDisplayListener() {
                    @Override
                    public void adHidden(Ad ad) {
                        startappCallback.call("onInterstitialDidClosed", new Object[] {});
                    }
                    @Override
                    public void adDisplayed(Ad ad) {
                        startappCallback.call("onInterstitialDidShow", new Object[] {});
                    }
                    @Override
                    public void adNotDisplayed(Ad ad) {
                        startappCallback.call("onInterstitialFailedToShow", new Object[] {});
                    }
                    @Override
                    public void adClicked(Ad ad) {
                        startappCallback.call("onInterstitialIsClicked", new Object[] {});
                    }
                });
                
            }
        });
    }
    
    static public void loadRewarded(){
        
        mainActivity.runOnUiThread(new Runnable() {
            public void run() {
                
                _self.startAppAd.loadAd (AdMode.REWARDED_VIDEO,new AdEventListener() {
                    @Override
                    public void onReceiveAd(Ad ad) {
                        startappCallback.call("onInterstitialDidLoad", new Object[] {});
                    }
                    @Override
                    public void onFailedToReceiveAd(Ad ad) {
                        startappCallback.call("onInterstitialFailedToLoad", new Object[] {});
                    }
                });
                
                _self.startAppAd.setVideoListener(new VideoListener() {
                    @Override
                    public void onVideoCompleted() {
                        startappCallback.call("onRewardedFullyWatched", new Object[] {});
                    }
                });
                
            }
        });
    }

static public void setUsersConsent(final boolean isGranted){

    StartAppSDK.setUserConsent (mainActivity,
                                "pas",
                                System.currentTimeMillis(),
                                isGranted);

    SharedPreferences.Editor editor = mainActivity.getPreferences(Context.MODE_PRIVATE).edit();
    if(editor == null) {
            Log.d("StartAppEx", "StartAppEx Failed to write user consent to preferences");
            return;
    }

    editor.putBoolean("gdpr_consent_startapp", isGranted);
    boolean committed = editor.commit();

    if(!committed) {
            Log.d("StartAppEx", "StartAppEx Failed to write user consent to preferences");
    }
}

    public static boolean getUsersConsent(){

    SharedPreferences prefs = mainActivity.getPreferences(Context.MODE_PRIVATE);
    if(prefs == null) {
            Log.i("StartAppEx", "StartAppEx Failed to read user conent preference data");
    }

    final Boolean isGranted = prefs.getBoolean("gdpr_consent_startapp", false);

    Log.d("StartAppEx","StartAppEx get userConsent is: " + isGranted);

    return isGranted;
}

	//////////////////////////////////////////////////////////////////////////////////////////////////
	//////////////////////////////////////////////////////////////////////////////////////////////////
    

    public void onCreate ( Bundle savedInstanceState )
    {
        super.onCreate(savedInstanceState);
        _self = this;
    }
    
    public void onResume () {
        super.onResume();
        startAppAd.onResume();
        
    }
    
    @Override
    public void onPause() {
        super.onPause();
        startAppAd.onPause();
    }

}
