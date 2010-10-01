AFKLoadManager
==============

AFKLoadManager helps you manage an arbitrary number of downloading operations via HTTP[S] asynchronously from your iOS app by:

* Limiting the maximum number of downloads so as not to overload the connection
* Performing all downloads asynchronously, without blocking your app, while managing errors for you
* Calling an arbitrary selector when a download completes (successfully or not)
* Passing along arbitrary HTTP parameters to the server (e.g.: Referer, etc.)

The idea behind AFKLoadManager is to provide a little more functionality than the built in -xxxWithURL: methods. It's simple and easy to use, uses only two classes and can be used on any iOS device.

Additionally, AFKLoadManager places all the downloads requested of it in a queue, allowing only a given number of them to occur at any given time (the default is five).

Usage
-----

The usage is very simple:

* Import AFKLoadManager.h
* Call +queueDownloadFromURL:withHTTPParameters:target:selector:atTopOfQueue
* Await a call to your callback method when the download is complete

Calling +queueDownloadFromURL:withHTTPParameters:target:selector:atTopOfQueue
-----------------------------------------------------------------------------

The parameters of +queueDownloadFromURL:withHTTPParameters:target:selector:atTopOfQueue are as follows:

```objc
+ (void) queueDownloadFromURL:(NSURL *) url 
           withHTTPParameters:(NSDictionary *) parameters 
                       target:(id) target 
                     selector:(SEL) selector 
                 atTopOfQueue:(BOOL) atTopOfQueue;
```

The parameters are as follows:

* **url** - The URL to download from. HTTP and HTTPS should both work fine. FTP is untested (but should work)
* **parameters** - A NSDictionary instance that contains any additional HTTP parameters to pass (with the key being the parameter name and the value its value)
* **target** - The target object that should be notified when a download is completed
* **selector** - The selector that should be called when a download is completed
* **atTopOfQueue** - Whether the download should be placed at the beginning of the download queue (in which case it's loaded before anything else) or not

The callback method
-------------------

The callback method receives a pointer to an NSData object that contains the information downloaded from the web:

http://gist.github.com/605607

The demo
--------

This project contains a (Universal) demo that displays a simple timed slideshow using ten images taken from my [Flickr photostream](http://www.flickr.com/photos/mtabini/). It delegates loading to the load manager and then displays them as they become available—as you will see if you try it out, the loading operation does not interfere with the smooth functioning of the app.

Requirements
------------

The demo is built to run against the 4.2ß1 SDK, but both it and the library should work fine against any iOS version starting from 3.2.

Limitations
-----------

The library loads every piece of data in memory. Therefore, a large download may (and probably will) result in unwanted low-memory conditions. Fixing this by using a file-based cache is on my to-do list, at which point the current method will be deprecated.