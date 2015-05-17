'use strict';

# this script is used in popup.html
currentUrl = ""

Stat =
	data: {}
	cur: null

# If we have data in local Storage we will take it
chrome.storage.sync.get 'disqus.data', (item) ->
	if item['disqus.data']
		Stat.data = JSON.parse(item['disqus.data'])
	
# Save Information in local storage
saveInfo = (url) ->
	if Stat.cur
		lst = Stat.data[Stat.cur]
	Stat.cur = url
	lst = Stat.data[url] or []
	name = document.getElementById('name').value
	email = document.getElementById('email').value		
	lst.push(name)
	lst.push(email)
	Stat.data[url] = lst
	chrome.storage.sync.set {'disqus.data': JSON.stringify(Stat.data)}

#There we check is email validated
validateEmail = (email) ->
	re = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/i
	re.test email

#There we add new comment, and using post method send query to backend
add = () ->
	console.log('\'Allo \'Allo! Popup')
	new_comment = document.getElementById('comment').value
	name = document.getElementById('name').value
	email = document.getElementById('email').value
	if (new_comment != "")
		if (name == "" || name == null || email == null || email == "" || !validateEmail(email))
			alert("Please Fill Credentials")
		else		
			saveInfo(currentUrl.hostname)
			today = new Date()
			dd = today.getDate() - 1
			mm = today.getMonth() + 1
			yyyy = today.getFullYear()

			if(dd<10) 
			    dd='0'+dd
			if(mm<10)
			    mm='0'+mm
			today = yyyy + '-' + mm + '-' + dd
			
			div = document.createElement('div')
			gravatar = '<img src = https://s.gravatar.com/avatar/' + hex_md5(email) + '?s=28 />'		
			html1 = '<p>' + gravatar + '<strong>' + name + '</strong></p>'
			html2 = '<font>' + new_comment + '</font>'
			html3 = '<p class="text-right">' + today + '</p>'					
			console.log(html1)
			div.className="comment-border"				
			div.innerHTML += html1
			div.innerHTML += html2
			div.innerHTML += html3								
			document.getElementById('comments').appendChild(div)								
			Backend.newComment(currentUrl.hostname, name, new_comment,email)
	else
		alert('Please Fill Comment')


console.log('Popup');

#Parsing Url to get hostname of url
parseUrl = ( url = location.href ) ->
  l = document.createElement "a"
  l.href = url
  return l

#Listen when Send Button pressed
window.onload = () ->
	document.getElementById('add').onclick = add

#There I take url of current tab and if value in db is exists put it into my variable
chrome.tabs.query({active: true, windowId: window.id},(tab)->
	currentUrl = parseUrl(tab[0].url)
	console.log("Query = " + currentUrl.hostname)
	lst = Stat.data[currentUrl.hostname]
	if(lst)
		document.getElementById('name').value = lst[lst.length - 2]
		document.getElementById('email').value = lst[lst.length - 1]		
	Backend.getComments(currentUrl.hostname)
)



