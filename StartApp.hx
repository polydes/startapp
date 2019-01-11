package;

#if cpp
import cpp.Lib;
#elseif neko
import neko.Lib;
#else
import openfl.Lib;
#end

#if android
#if openfl_legacy
import openfl.utils.JNI;
#else
import lime.system.JNI;
#end
#end

import com.stencyl.Engine;
import com.stencyl.Input;
import openfl.events.MouseEvent;

import scripts.ByRobinAssets;

class StartApp {

	private static var initialized:Bool=false;
	private static var _bannerDidDisplay:Bool=false;
	private static var _bannerFailedToLoad:Bool=false;
	private static var _bannerIsClicked:Bool=false;
	private static var _interstitialDidLoad:Bool=false;
	private static var _interstitialFailedToLoad:Bool=false;
	private static var _interstitialDidShow:Bool=false;
	private static var _interstitialFailedToShow:Bool=false;
	private static var _interstitialDidClosed:Bool=false;
	private static var _interstitialIsClicked:Bool=false;
	private static var _rewardedFullyWatched:Bool=false;


	////////////////////////////////////////////////////////////////////////////
	#if ios
	private static var __init:String->String->Void = function(appId:String,gMode:String){};
	private static var __startapp_set_event_handle = Lib.load("startapp","startapp_set_event_handle", 1);
	#end
	#if android
	private static var __init:Dynamic;
	#end
	private static var __showBanner:Void->Void = function(){};
	private static var __hideBanner:Void->Void = function(){};
	private static var __setBannerPosition:String->Void = function(gMode:String){};

	private static var __loadInterstitial:Void->Void = function(){};
	private static var __showInterstitial:Void->Void = function(){};
	private static var __loadRewarded:Void->Void = function(){};
	private static var __setConsent:Bool->Void = function(isGranted:Bool){};
	private static var __getConsent:Void->Bool = function(){return false;};

	////////////////////////////////////////////////////////////////////////////

	public static function init(gMode:String){

		#if ios
		var appId:String = ByRobinAssets.SAIosAppID;
		#elseif android
		var appId:String = ByRobinAssets.SAAndroidAppID;
		#end

		#if ios
		if(initialized) return;
		initialized = true;
		try{
			// CPP METHOD LINKING
			__init = Lib.load("startapp","startapp_init",2);
			__showBanner = Lib.load("startapp","startapp_banner_show",0);
			__hideBanner = Lib.load("startapp","startapp_banner_hide",0);
			__setBannerPosition = Lib.load("startapp","startapp_banner_position",1);
			__loadInterstitial = Lib.load("startapp","startapp_interstitial_load",0);
			__showInterstitial = Lib.load("startapp","startapp_interstitial_show",0);
			__loadRewarded = Lib.load("startapp","startapp_rewarded_load",0);
			__setConsent = cpp.Lib.load("startapp","startapp_setconsent",1);
			__getConsent = cpp.Lib.load("startapp","startapp_getconsent",0);

			__init(appId,gMode);
			__startapp_set_event_handle(notifyListeners);
		}catch(e:Dynamic){
			trace("iOS INIT Exception: "+e);
		}
		#end

		#if android
		if(initialized) return;
		initialized = true;
		try{
			// JNI METHOD LINKING
			__showBanner = JNI.createStaticMethod("com/byrobin/startapp/StartAppEx", "showBanner", "()V");
			__hideBanner = JNI.createStaticMethod("com/byrobin/startapp/StartAppEx", "hideBanner", "()V");
			__setBannerPosition = JNI.createStaticMethod("com/byrobin/startapp/StartAppEx", "setBannerPosition", "(Ljava/lang/String;)V");
			__loadInterstitial = JNI.createStaticMethod("com/byrobin/startapp/StartAppEx", "loadInterstitial", "()V");
			__showInterstitial = JNI.createStaticMethod("com/byrobin/startapp/StartAppEx", "showInterstitial", "()V");
			__loadRewarded = JNI.createStaticMethod("com/byrobin/startapp/StartAppEx", "loadRewarded", "()V");
			__setConsent = JNI.createStaticMethod("com/byrobin/startapp/StartAppEx", "setUsersConsent", "(Z)V");
			__getConsent = JNI.createStaticMethod("com/byrobin/startapp/StartAppEx", "getUsersConsent", "()Z");

			if(__init == null)
			{
				__init = JNI.createStaticMethod("com/byrobin/startapp/StartAppEx", "init", "(Lorg/haxe/lime/HaxeObject;Ljava/lang/String;Ljava/lang/String;)V", true);
			}

			var args = new Array<Dynamic>();
			args.push(new StartApp());
			args.push(appId);
			args.push(gMode);
			__init(args);
		}catch(e:Dynamic){
			trace("Android INIT Exception: "+e);
		}
		#end
	}

	////Banner
	public static function showBanner() {
		try {
			__showBanner();
		} catch(e:Dynamic) {
			trace("Show Banner Exception: "+e);
		}
	}

	public static function hideBanner() {
		try {
			__hideBanner();
		} catch(e:Dynamic) {
			trace("Hide Banner Exception: "+e);
		}
	}

	public static function setBannerPosition(gMode:String) {
		try {
			__setBannerPosition(gMode);
		} catch(e:Dynamic) {
			trace("Set Banner Position Exception: "+e);
		}
	}

	public static function setConsent(isGranted:Bool) {
		try {
			__setConsent(isGranted);
		} catch(e:Dynamic) {
			trace("SetConsent Exception: "+e);
		}
	}

	public static function getConsent():Bool {

		return __getConsent();
	}

	////
	public static function bannerDidDisplay():Bool{

		if(_bannerDidDisplay){
			_bannerDidDisplay = false;
			return true;
		}

		return false;
	}

	public static function bannerFailedToLoad():Bool{

		if(_bannerFailedToLoad){
			_bannerFailedToLoad = false;
			return true;
		}

		return false;
	}

	public static function bannerIsClicked():Bool{

		if(_bannerIsClicked){
			_bannerIsClicked = false;
			return true;
		}

		return false;
	}

	/////Interstitial
	public static function loadInterstitial() {
		try {
			__loadInterstitial();
		} catch(e:Dynamic) {
			trace("Load Interstitial Exception: "+e);
		}
	}

	public static function loadRewarded() {
		try {
			__loadRewarded();
		} catch(e:Dynamic) {
			trace("Load Rewarded Exception: "+e);
		}
	}

	public static function showInterstitial() {
		try {
			__showInterstitial();
		} catch(e:Dynamic) {
			trace("Show Interstitial Exception: "+e);
		}
	}

	public static function interstitialDidLoad():Bool{

		if(_interstitialDidLoad){
			_interstitialDidLoad = false;
			return true;
		}

		return false;
	}

	public static function interstitialFailedToLoad():Bool{

		if(_interstitialFailedToLoad){
			_interstitialFailedToLoad = false;
			return true;
		}

		return false;
	}

	public static function interstitialDidShow():Bool{

		if(_interstitialDidShow){
			_interstitialDidShow = false;
			return true;
		}

		return false;
	}

	public static function interstitialFailedToShow():Bool{

		if(_interstitialFailedToShow){
			_interstitialFailedToShow = false;
			return true;
		}

		return false;
	}

	public static function interstitialDidClosed():Bool{

		if(_interstitialDidClosed){
			_interstitialDidClosed = false;
			return true;
		}

		return false;
	}

	public static function interstitialIsClicked():Bool{

		if(_interstitialIsClicked){
			_interstitialIsClicked = false;
			return true;
		}

		return false;
	}

	public static function rewardedFullyWatched():Bool{

		if(_rewardedFullyWatched){
			_rewardedFullyWatched = false;
			return true;
		}

		return false;
	}

	///////Events Callbacks/////////////

	#if ios
	//Ads Events only happen on iOS.
	private static function notifyListeners(inEvent:Dynamic)
	{
		var event:String = Std.string(Reflect.field(inEvent, "type"));

		if(event == "bannerdiddisplay")
		{
			_bannerDidDisplay = true;
		}
		if(event == "bannerfailedload")
		{
			_bannerFailedToLoad = true;
		}
		if(event == "bannerdidclicked")
		{
			_bannerIsClicked = true;
		}
		if(event == "interstitialdidload")
		{
			_interstitialDidLoad = true;
		}
		if(event == "interstitialfailedtoload")
		{
			_interstitialFailedToLoad = true;
		}
		if(event == "interstitialdidshow")
		{
			_interstitialDidShow = true;
		}
		if(event == "interstitialfailedtoshow")
		{
			_interstitialFailedToShow = true;
		}
		if(event == "interstitialdidclosed")
		{
			_interstitialDidClosed = true;
		}
		if(event == "interstitialisclicked")
		{
			_interstitialIsClicked = true;
		}
		if(event == "rewardedfullywatched")
		{
			_rewardedFullyWatched = true;
		}

	}
	#end

	#if android
	private function new() {}

	public function onBannerDidDisplay()
	{
		_bannerDidDisplay = true;
	}
	public function onBannerFailedToLoad()
	{
		_bannerFailedToLoad = true;
	}
	public function onBannerIsClicked()
	{
		_bannerIsClicked = true;
	}
	public function onInterstitialDidLoad()
	{
		_interstitialDidLoad = true;
	}
	public function onInterstitialFailedToLoad()
	{
		_interstitialFailedToLoad = true;
	}
	public function onInterstitialDidShow()
	{
		_interstitialDidShow = true;
	}
	public function onInterstitialFailedToShow()
	{
		_interstitialFailedToShow = true;
	}
	public function onInterstitialDidClosed()
	{
		_interstitialDidClosed = true;
	}
	public function onInterstitialIsClicked()
	{
		_interstitialIsClicked = true;
	}
	public function onRewardedFullyWatched()
	{
		_rewardedFullyWatched = true;
	}
	#end

}
