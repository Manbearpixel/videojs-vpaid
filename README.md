## Preface

This plugin is built upon the [VideoJS/VideoJS-SWF](https://github.com/videojs/video-js-swf) repo. It contains extra code allowing it to fetch VPAID information from a URL and load it over the VideoJS video wrap.
I decided to turn this into a VideoJS Plugin, rather than VideoJS Tech simply because it seemed the easiest to execute and remove once it is over.

Currently Working:
* LiveRail VPAID ad example
* Brightroll VPAID ad example
* VPAID Debug Log

Working examples can be found within the /demo/ folder of this repo, and can be viewed locally within your browser. You can also enter your own VPAID URL and Parameters to test out
your own ads and ensure they work. This plugin currently uses VideoJS v4.11.4, it is not the most recent, but in my opinion seems the most stable and still flexible for other plugins to work.

The source code for the `videojs-vpaid.swf` file is available and can be editted to your liking, down the road I'll remove extra junk that doesn't need to be in there to trim
it down. For now, however, it works as it is. Feel free to submit any issues or ask any questions that arise, it should be faily straight forward as this has an easy setup.

I am available via Twitter for direct questions or feedback, my handle is [@Manbearpixel](https://twitter.com/manbearpixel). Thanks for checking this repo out!

## Installation

1. Install Node Packages.
```bash
    npm install
   ```
2. Compile SWF.
Development (places new VPAID SWF in /dist/):
```bash
    grunt mxmlc
   ```
3. Create the local server
```bash
    grunt connect:dev
```
4. Open your browser at [http://localhost:8888/demo/](http://localhost:8888/demo/) to view the VPAID Demo page. You can keep using grunt to rebuild the Flash code without restarting the server.


## Getting Started
When setting up the plugin you will need to give `vjsVPAID` the following information:
#### vpaidSWF
Type: `string`

This is the path to the `videojs-vpaid.swf` file generated from `grunt mxmlc`.

#### vpaidUrl
Type: `string`

This is the path to the VPAID XML file.

#### vpaidParams
Type: `string`

These are the params you would like appended to the vpaidUrl when requested from the SWF file. This is separated to ensure it is decoded and encoded properly when added
to the Flash Object.

#### debug
Type: `boolean`

Setting this flag to `true` will tell the VideoJS VPAID Plugin to emit information to the console.log, useful for testing out or debugging issues
that may arise.

### Example
```javascript
player = videojs("player", {
    plugins: {
        vjsVPAID : {
            vpaidSWF    : '/dist/videojs-vpaid.swf',
            vpaidUrl    : 'http://site.com/path-to-vpaid.xml',
            vpaidParams : 'timestamp=123456789',
            debug       : false
        }
    }
```
#### NOTE: Testing Flash Locally in Chrome

Chrome 21+ (as of 2013/01/01) doens't run Flash files that are local and loaded into a locally accessed page (file:///). To get around this you can do either of the following:

1. Do your development and testing using a local HTTP server.  See above for instructions on using simple-http-server for this purpose.
2. Disable the version of Flash included with Chrome and enable a system-wide version of Flash instead.Gruntfile.js

### Release History

 - 1.0.0: Initial release, stable