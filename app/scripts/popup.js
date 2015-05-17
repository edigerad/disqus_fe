(function() {
  'use strict';
  var Stat, add, currentUrl, parseUrl, saveInfo, validateEmail;

  currentUrl = "";

  Stat = {
    data: {},
    cur: null
  };

  chrome.storage.sync.get('disqus.data', function(item) {
    if (item['disqus.data']) {
      return Stat.data = JSON.parse(item['disqus.data']);
    }
  });

  saveInfo = function(url) {
    var email, lst, name;
    if (Stat.cur) {
      lst = Stat.data[Stat.cur];
    }
    Stat.cur = url;
    lst = Stat.data[url] || [];
    name = document.getElementById('name').value;
    email = document.getElementById('email').value;
    lst.push(name);
    lst.push(email);
    Stat.data[url] = lst;
    return chrome.storage.sync.set({
      'disqus.data': JSON.stringify(Stat.data)
    });
  };

  validateEmail = function(email) {
    var re;
    re = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/i;
    return re.test(email);
  };

  add = function() {
    var dd, div, email, gravatar, html1, html2, html3, mm, name, new_comment, today, yyyy;
    console.log('\'Allo \'Allo! Popup');
    new_comment = document.getElementById('comment').value;
    name = document.getElementById('name').value;
    email = document.getElementById('email').value;
    if (new_comment !== "") {
      if (name === "" || name === null || email === null || email === "" || !validateEmail(email)) {
        return alert("Please Fill Credentials");
      } else {
        saveInfo(currentUrl.hostname);
        today = new Date();
        dd = today.getDate() - 1;
        mm = today.getMonth() + 1;
        yyyy = today.getFullYear();
        if (dd < 10) {
          dd = '0' + dd;
        }
        if (mm < 10) {
          mm = '0' + mm;
        }
        today = yyyy + '-' + mm + '-' + dd;
        div = document.createElement('div');
        gravatar = '<img src = https://s.gravatar.com/avatar/' + hex_md5(email) + '?s=28 />';
        html1 = '<p>' + gravatar + '<strong>' + name + '</strong></p>';
        html2 = '<font>' + new_comment + '</font>';
        html3 = '<p class="text-right">' + today + '</p>';
        console.log(html1);
        div.className = "comment-border";
        div.innerHTML += html1;
        div.innerHTML += html2;
        div.innerHTML += html3;
        document.getElementById('comments').appendChild(div);
        return Backend.newComment(currentUrl.hostname, name, new_comment, email);
      }
    } else {
      return alert('Please Fill Comment');
    }
  };

  console.log('Popup');

  parseUrl = function(url) {
    var l;
    if (url == null) {
      url = location.href;
    }
    l = document.createElement("a");
    l.href = url;
    return l;
  };

  window.onload = function() {
    return document.getElementById('add').onclick = add;
  };

  chrome.tabs.query({
    active: true,
    windowId: window.id
  }, function(tab) {
    var lst;
    currentUrl = parseUrl(tab[0].url);
    console.log("Query = " + currentUrl.hostname);
    lst = Stat.data[currentUrl.hostname];
    if (lst) {
      document.getElementById('name').value = lst[lst.length - 2];
      document.getElementById('email').value = lst[lst.length - 1];
    }
    return Backend.getComments(currentUrl.hostname);
  });

}).call(this);
