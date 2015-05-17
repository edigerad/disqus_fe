(function() {
  'use strict';
  var parseUrl;

  chrome.runtime.onInstalled.addListener(function(details) {
    return console.log('previousVersion', details.previousVersion);
  });

  parseUrl = function(url) {
    var l;
    if (url == null) {
      url = location.href;
    }
    l = document.createElement("a");
    l.href = url;
    return l;
  };

  chrome.tabs.onActivated.addListener(function(activeInfo) {
    return chrome.tabs.get(activeInfo.tabId, function(tab) {
      var k;
      k = parseUrl(tab.url);
      console.log("ONLy " + k.hostname);
      return Backend.getCount(k.hostname);
    });
  });

}).call(this);
