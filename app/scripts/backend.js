'use strict';

# this script is supposed to have backend related code

module = exports ? this
urlBackend = 'http://localhost:8000/api/v1/comment/'

$this =
  getComments: (url, callback, errback) ->
    comments = document.getElementById('comments')
    hr = new XMLHttpRequest
    hr.open 'GET', urlBackend, true
    hr.setRequestHeader 'Content-type', 'application/json', true

    hr.onreadystatechange = ->
      if hr.readyState == 4 and hr.status == 200
        data = JSON.parse(hr.responseText)
        for i in data.objects
          if i.url == url
            gravatar = '<img src = https://s.gravatar.com/avatar/' + hex_md5(i.email) + '?s=64 />'
            tableComment = '<table>
                              <tr><td>' + gravatar + '</td>
                        
                                <td><h4  style="margin-top:0px;">' + i.name + '</h4><h5>' + i.comment + '</h5></td>
                            
                              <td style="vertical-align:top; padding-left:120px;"><h6>' + (i.pub_date.substring 0, 10) + '</h6></td></tr></table>'
            # append this new image to some div, or whatever
                            
            $('#comments').append tableComment
      return

    hr.send null
    # callback();
    # errback();
  getCount: (url, callback, errback)->
    hr = new XMLHttpRequest
    hr.open 'GET', urlBackend, true
    hr.setRequestHeader 'Content-type', 'application/json', true
    total_count = 0
    hr.onreadystatechange = ->
      if hr.readyState == 4 and hr.status == 200
        data = JSON.parse(hr.responseText)
        for i in data.objects
          if i.url == url
            total_count++
            console.log total_count
      return 
    total_count

    # console.log total_count
    hr.send null
    
  newComment: (url, name, email, comment, callback, errback) ->
    # console.log('Popup 3')

module.Backend = $this