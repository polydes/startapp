#ifndef STARTAPPEX_H
#define STARTAPPEX_H


namespace startapp {
	
	
	void init(const char *__appID, const char *__GMode);
	void showBanner();
    void hideBanner();
    void setBannerPosition(const char *__GMode);
    
    void loadInterstitial();
    void showInterstitial();
    void loadRewarded();
}


#endif