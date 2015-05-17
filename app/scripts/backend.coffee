'use strict';

# this script is supposed to have backend related code

module = exports ? this

#getComments method takes all comments,names,avatar and email from backend related to this url using method getJson to show it
#getCount just shows the number of comments to current url
#newComment sends json to backend using method post.
$this =
	getComments: (url, callback, errback) ->
		$.getJSON('http://127.0.0.1:8000/api/v1/comment', (data) ->
			for k in data.objects
				if url == k.link
					div = document.createElement('div')
					gravatar = '<img src = https://s.gravatar.com/avatar/' + hex_md5(k.email) + '?s=28 />'	
					html1 = '<p>' + gravatar + " " + '<strong>' + k.author + '</strong></p>'
					html2 = '<font>' + k.text + '</font>'
					html3 = '<p class="text-right">' + k.pub_date + '</p>'	
					console.log(html1)
					div.innerHTML += html1
					div.innerHTML += html2
					div.innerHTML += html3
					document.getElementById('comments').appendChild(div)
		)
		return

	getCount: (url, callback, errback)->
		$.getJSON('http://127.0.0.1:8000/api/v1/comment', (data) ->
			q = 0
			for k in data.objects
				if url == k.link
					q = q + 1
			chrome.browserAction.setBadgeText({text:q + ""})					
		)
		return

	newComment: (url, author, comment,email, callback, errback) ->
		xhr = new XMLHttpRequest();

		json = JSON.stringify({
			text: comment,
			author: author,
			link: url,
			email: email
		})

		xhr.open("POST", 'http://127.0.0.1:8000/api/v1/comment/', true)
		xhr.setRequestHeader('Content-type', 'application/json;')

		xhr.send(json)


module.Backend = $this