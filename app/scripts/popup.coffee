'use strict';

# this script is used in popup.html

comments = []

ractive = new Ractive
     el : '#result'
     template : '#ractive_id'
     data :
         user_name: ''
         user_email: ''
         comments:comments

ractive.set 'array_length',0
document.getElementById('pager').style.display = 'none'

ractive.on 'ok', =>
  ractive.set 'user_name',ractive.get 'user_name'
  ractive.set 'user_email',ractive.get 'user_email'

  chrome.storage.local.get 'value',(result) ->
    result = result.value
    result.user_name = ractive.get 'user_name'
    result.user_email = ractive.get 'user_email'
    chrome.storage.local.set {'value':result}

ractive.on 'add_comment', =>
  date = new Date()
  
  day = date.getDay()
  day = '0' + day if day <= 9
  
  month = date.getMonth()
  month = '0' + month if month <=9

  if (ractive.get 'user_name') == '' || (ractive.get 'email') == ''
  	alert('enter name and surname to add comment')
  	return

  ractive.set 'ava',(md5 (ractive.get 'user_email'))
  comments = ractive.get 'comments'
  comments.push({
           name:ractive.get 'user_name'
           ava:ractive.get 'ava'
           email:ractive.get 'user_email'
           comment:ractive.get 'comment'
           date:day+'.'+month+'.'+date.getFullYear()
       })
  ractive.set 'comments',comments
  ractive.set 'array_length',comments.length
  ractive.set 'comment',''
  chrome.browserAction.setBadgeText {text: comments.length.toString()}
  document.getElementById('pager').style.display = 'block' if comments.length > 1

  chrome.storage.local.get 'value',(result) ->
    result = result.value
    chrome.tabs.getSelected null,(tab)->
      


      [d, other] = (tab.url).split '://'
      [domain, oth] = other.split '/'
      urlN = d + '://' + domain
      
      flag = false
      urls = result.urls
      for val in urls
        if urlN == val.url
          result.urls[_i].comments = ractive.get 'comments'
          chrome.storage.local.set {'value':result}
          chrome.browserAction.setBadgeText {text: val.comments.length.toString()}
          ractive.set 'array_length',val.comments.length.toString()
          flag = true
          break
      if !flag
        urls.push({
              url:urlN
              comments:comments
          });
        dannye =
          user_name:ractive.get 'user_name'
          user_email:ractive.get 'user_email'
          urls:urls
            
        chrome.storage.local.set {'value':dannye}


chrome.storage.local.get 'value',(result) ->
  result = result.value
  ractive.set 'user_name',result.user_name
  ractive.set 'user_email',result.user_email
  ractive.set 'array_length',(ractive.get 'comments').length
  
  chrome.tabs.getSelected null,(tab)->
    [d, other] = (tab.url).split '://'
    [domain, oth] = other.split '/'
    urlN = d + '://' + domain
    
    flag = false
    urls = result.urls

    for val in urls
      if urlN == val.url
        ractive.set 'comments',result.urls[_i].comments
        chrome.browserAction.setBadgeText {text:val.comments.length.toString()}
        ractive.set 'array_length',(result.urls[_i].comments).length
        flag = true
        break
    if !flag
      chrome.browserAction.setBadgeText {text:'0'}