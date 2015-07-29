# Preface

This plugin is built upon the [VideoJS/VideoJS-SWF](https://github.com/videojs/video-js-swf) repo. It contains extra code allowing it to fetch VPAID information from a URL and load it over the VideoJS video wrap.
I decided to turn this into a VideoJS Plugin, rather than VideoJS Tech simply because it seemed the easiest to execute and remove once it is over.

Currently Working:
* LiveRail VPAID ad examples
* Brightroll VPAID ad example
* VPAID Debug Log

Working examples can be found within the /demo/ folder of this repo, and can be viewed locally within your browser. You can also enter your own VPAID URL and Parameters to test out
your own ads and ensure they work. This plugin currently uses VideoJS v4.11.4, it is not the most recent, but in my opinion seems the most stable and still flexible for other plugins, such as Closed Captioning and Resolution Switch to work.

The source code for the `videojs-vpaid.swf` file is available and can be editted to your liking, down the road I'll remove extra junk that doesn't need to be in there to trim
it down. For now, however, it works as it is. Feel free to submit any issues or ask any questions that arise, it should be faily straight forward as this has an easy setup.

I am available via Twitter for direct questions or feedback, my handle is [@Manbearpixel](https://twitter.com/manbearpixel). Thanks for checking this repo out! Please view the **What's New** section for most up-to-date additions to this plugin!

# Installation

1. Install Node Packages.
```bash
    npm install
```
   
2. Compile JS Library AND SWF Plugin
```bash
    grunt dist
```
   
3. Create the local server
```bash
    grunt connect:dev
```

4. Open your browser at [http://localhost:8888/demo/](http://localhost:8888/demo/) to view the VPAID Demo page. You can keep using grunt taks to rebuild the JS Library *(written in CoffeeScript)* and Flash SWF file without restarting the server.


# Getting Started
When setting up the plugin you will need to give `vjsVPAID` the following information:

#### vpaidSWF
Type: `string`

This is the path to the `videojs-vpaid.swf` file generated from `grunt mxmlc`.

#### vpaidUrl
Type: `string`

This is the path to the VPAID XML file. As of **v1.0.1** you can now add parameters within the `vpaidUrl`. Such as the following example: `http://adsite.com/vpaid-ad.xml?param1=foo&param2=bar&param3=meme`

#### debug
Type: `boolean`

Setting this flag to `true` will tell the VideoJS VPAID Plugin to emit information to the console.log, useful for testing out or debugging issues
that may arise.

### Example
```javascript
player = videojs("player", {
	controls: true,
	autoplay: false,
	...,
    plugins: {
        vjsVPAID : {
            vpaidSWF    : '/dist/videojs-vpaid.swf',
            vpaidUrl    : 'http://site.com/path-to-vpaid.xml?timestamp=12334824&ref=http://refsite.com/sitepath&foo=bar',
            debug       : false
        }
    }
});
```
### NOTE: Testing Flash Locally in Chrome

Chrome 21+ (as of 2013/01/01) doens't run Flash files that are local and loaded into a locally accessed page (file:///). To get around this you can do either of the following:

1. Do your development and testing using a local HTTP server.  See above for instructions on using simple-http-server for this purpose.
2. Disable the version of Flash included with Chrome and enable a system-wide version of Flash instead.Gruntfile.js
 
# What's New

## v1.0.2

##### New Plugin Option "timeout"

As noted, there is a current implementation to have the ad fail after a specified amount of time. Prior to this version it was hardcoded to 5 seconds, with this update you can now specify your own timeout *(in ms)*, or disable it all together. If it is not specified it will default to 5 seconds.

```javascript
vjsVpaid : {
	...
	timeout: 6000
}

```
```javascript
vjsVpaid : {
	...
	timeout: -1
}

```

##### New events

I have added new events to be triggered and available to be listened to by VideoJS. You can find the complete list of events in the working demo, but here is a quick list of all possible events. Please note that each will be prepended with `vpaid_` :

- AdStarted
- AdLoaded
- AdClickThru
- AdTimeoutError
- error
- AdVideoFirstQuartile
- AdVideoMidpoint
- AdVideoThirdQuartile
- AdComplete
- AdPlaying
- AdPaused

## v1.0.1

##### Important Notice

This plugin is written in **[CoffeeScript](http://coffeescript.org/)** and should be maintained in it. When building the JS library any changes written in the *.js* file **will** be overwritten, so be careful!

##### New functionality

VideoJS-VPAID plugin **no longer requires** the need to include both the *adUrl*, and *adParams* as two separate variables/options. I have configured a way to just pass a VPAID Url including any additional params to be successfully passed and used by the SWF.

#### Old Way
```javascript
player = videojs("player", {
	controls: true,
	autoplay: false,
	...,
    plugins: {
        vjsVPAID : {
            vpaidSWF    : '/dist/videojs-vpaid.swf',
            vpaidUrl    : 'http://site.com/path-to-vpaid.xml',
            vpaidParams : 'timestamp=123456789',
            debug       : false
        }
    }
});
```
#### New Way
```javascript
player = videojs("player", {
	controls: true,
	autoplay: false,
	...,
    plugins: {
        vjsVPAID : {
            vpaidSWF    : '/dist/videojs-vpaid.swf',
            vpaidUrl    : 'http://site.com/path-to-vpaid.xml?timestamp=12334824&ref=http://refsite.com/sitepath&foo=bar',
            debug       : false
        }
    }
});
```

##### New Grunt Tasks

Additionally, I have added new Grunt tasks for building the JS Library and SWF file to hopefully make things simpler. If you currently have this repo cloned, you will need to run `npm install` to download the additional Grunt Plugins the tasks now use.

#### Build JS Library
```bash
    grunt build-lib
```

#### Build JS Library & Move JS to /dist/
```bash
    grunt build-lib:1
	or
	grunt build-lib:true
```

#### Build SWF File
```bash
    grunt build-swf
```

#### Build /dist/ Folder

This basically combines both `build-lib:1` and `build-swf`.
```bash
    grunt dist
```

# Release History

 - 1.0.0: Initial release, stable
 - 1.0.1: Removed need to have params split from url, added new Grunt tasks
 - 1.0.2: Added support to configure ad timeout, Added new event triggers