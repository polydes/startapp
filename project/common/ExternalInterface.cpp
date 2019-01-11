#ifndef STATIC_LINK
#define IMPLEMENT_API
#endif

#if defined(HX_WINDOWS) || defined(HX_MACOS) || defined(HX_LINUX)
#define NEKO_COMPATIBLE
#endif


#include <hx/CFFI.h>
#include "StartAppEx.h"
#include <stdio.h>

using namespace startapp;

AutoGCRoot* startAppEventHandle = 0;

#ifdef IPHONE

static void startapp_set_event_handle(value onEvent)
{
    startAppEventHandle = new AutoGCRoot(onEvent);
}
DEFINE_PRIM(startapp_set_event_handle, 1);

static value startapp_init(value app_id, value gmode){
	init(val_string(app_id),val_string(gmode));
	return alloc_null();
}
DEFINE_PRIM(startapp_init,2);

//Banner
static value startapp_banner_show(){
	showBanner();
	return alloc_null();
}
DEFINE_PRIM(startapp_banner_show,0);

static value startapp_banner_hide(){
    hideBanner();
    return alloc_null();
}
DEFINE_PRIM(startapp_banner_hide,0);

static value startapp_banner_position(value gmode){
   setBannerPosition(val_string(gmode));
    return alloc_null();
}
DEFINE_PRIM(startapp_banner_position,1);

///interstitial
static value startapp_interstitial_load(){
    loadInterstitial();
    return alloc_null();
}
DEFINE_PRIM(startapp_interstitial_load,0);

static value startapp_interstitial_show(){
    showInterstitial();
    return alloc_null();
}
DEFINE_PRIM(startapp_interstitial_show,0);

static value startapp_rewarded_load(){
    loadRewarded();
    return alloc_null();
}
DEFINE_PRIM(startapp_rewarded_load,0);

static value startapp_setconsent(value isGranted){
    setStartAppConsent(val_bool(isGranted));
    return alloc_null();
}
DEFINE_PRIM(startapp_setconsent,1);

static value startapp_getconsent(){
    return alloc_bool(getStartAppConsent());
}
DEFINE_PRIM(startapp_getconsent,0);

#endif

extern "C" void startapp_main () {
	val_int(0); // Fix Neko init
	
}
DEFINE_ENTRY_POINT (startapp_main);

extern "C" int startapp_register_prims () { return 0; }

extern "C" void sendStartAppEvent(const char* type)
{
    printf("Send Event: %s\n", type);
    value o = alloc_empty_object();
    alloc_field(o,val_id("type"),alloc_string(type));
    val_call1(startAppEventHandle->get(), o);
}
