'use strict';

# this script is used in background.html

chrome.runtime.onInstalled.addListener (details) ->
  console.log('previousVersion', details.previousVersion)

#Parsing Url to get hostname of url
parseUrl = ( url = location.href ) ->
  l = document.createElement "a"
  l.href = url
  return l

#If tab is changed we will need to know number of comments to new url and show it
chrome.tabs.onActivated.addListener (activeInfo)->
  chrome.tabs.get activeInfo.tabId, (tab) ->
    k = parseUrl tab.url 
    console.log "ONLy #{k.hostname}"
    Backend.getCount(k.hostname) 