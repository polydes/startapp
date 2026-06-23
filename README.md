## Stencyl Startapp ads iOS/Android Extension (OpenFL)

For Stencyl 3.4 9280 and above

Stencyl extension for “StartApp” (http://www.startapp.com) for iOS and Android. This extension allows you to easily integrate StartApp on your Stencyl game / application. (http://www.stencyl.com)

![startapptoolset](https://byrobingames.github.io/img/startapp/startapptoolset.png)

## Main Features

  * Banner Support.
  * Interstitial Support.
  * Rewarded Video Support.

## Documentation and Block Examples

If you don’t have an account, create one on http://www.startapp.com and get your “AppId”.<br/>
Fill in your “AppId” in the Toolset Manager<br/>
![startappappid](https://byrobingames.github.io/img/startapp/startappappid.png)<br/>

Load an Interstitial of Rewarded Video first before you can show. Interstitial and Rewarded cannot load at the same time. Load next after the first one has showed.

### Blocks

**Initialize StartApp**<br/>
![startappinitialize](https://byrobingames.github.io/img/startapp/startappinitialize.png)<br/>
Use this block to initialize StartApp. Use this block once per user session (from the moment the user starts to play until the user quits the game). For example in a loading scene.<br/>

<hr/>

**Hide/Show Banner**<br/>
![startappshowhidebanner](https://byrobingames.github.io/img/startapp/startappshowhidebanner.png)<br/>
Use this block to hide or show banner ad.<br/>

<hr/>

**Move Banner to**<br/>
![startappmovebanner](https://byrobingames.github.io/img/startapp/startappmovebanner.png)<br/>
Use this block to move a banner ad to bottom or top.<br/>

<hr/>

**Load Interstitial or Rewarded Video**<br/>
![startapploadads](https://byrobingames.github.io/img/startapp/startapploadads.png)<br/>
Use this block to load Interstitial or Rewarded Video ads.<br/>

<hr/>

**Show Interstitial of Rewarded Video**<br/>
![startappshowads](https://byrobingames.github.io/img/startapp/startappshowads.png)<br/>
Use this block to show Interstitial or Rewarded Video ads. (load first before calling show)<br/>

<hr/>

**Callback for Interstitial/ Rewarded Video**<br/>
![startappcallbacks](https://byrobingames.github.io/img/startapp/startappcallbacks.png)<br/>
Use this block to get callbacks.

<hr/>

**Set Consent**<br/>
![startappsetconsent](https://byrobingames.github.io/img/startapp/startappsetconsent.png)<br/>
Sets consent for user (for Europe only).

<hr/>

**Get Consent**<br/>
![startappgetconsent](https://byrobingames.github.io/img/startapp/startappgetconsent.png)<br/>
Gets consent for user (for Europe only).

## Privacy Policy

http://www.startapp.com

## License

Author: Robin Schaafsma

The MIT License (MIT)

Copyright (c) 2014 byRobinGames [http://www.byrobin.nl](http://www.byrobin.nl)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
