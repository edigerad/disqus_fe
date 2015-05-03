'use strict';

# this script is used in background.html

chrome.runtime.onInstalled.addListener (details) ->
  console.log('previousVersion', details.previousVersion)

dannye =
  user_name:''
  user_email:''
  urls:
    [
      url:''
      comments:
        [
          name:''
          ava:''
          email:''
          comment:''
          date:''
        ]
    ]
                
                  
chrome.runtime.onInstalled.addListener (details) ->
  console.log('previousVersion', details.previousVersion)
  chrome.storage.local.set {'value': dannye}

update= =>
  chrome.storage.local.get 'value',(result)->
    result = result.value
    chrome.tabs.getSelected null,(tab)->
      
      [d, other] = (tab.url).split '://'
      [domain, oth] = other.split '/'
      urlN = d + '://' + domain
      console.log urlN
      
      flag = false
      urls = result.urls
      
      for val in urls
        if urlN == val.url
          chrome.browserAction.setBadgeText {text:val.comments.length.toString()}
          flag = true
          break
      if !flag
        chrome.browserAction.setBadgeText {text:'0'}

update()

chrome.tabs.onActivated.addListener (activeInfo)->
  update()