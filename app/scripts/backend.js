(function() {
  'use strict';
  var $this, module;

  module = typeof exports !== "undefined" && exports !== null ? exports : this;

  $this = {
    getComments: function(url, callback, errback) {
      $.getJSON('http://127.0.0.1:8000/api/v1/comment', function(data) {
        var div, gravatar, html1, html2, html3, k, _i, _len, _ref, _results;
        _ref = data.objects;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          k = _ref[_i];
          if (url === k.link) {
            div = document.createElement('div');
            gravatar = '<img src = https://s.gravatar.com/avatar/' + hex_md5(k.email) + '?s=28 />';
            html1 = '<p>' + gravatar + " " + '<strong>' + k.author + '</strong></p>';
            html2 = '<font>' + k.text + '</font>';
            html3 = '<p class="text-right">' + k.pub_date + '</p>';
            console.log(html1);
            div.className = "comment-border";
            div.innerHTML += html1;
            div.innerHTML += html2;
            div.innerHTML += html3;
            _results.push(document.getElementById('comments').appendChild(div));
          } else {
            _results.push(void 0);
          }
        }
        return _results;
      });
    },
    getCount: function(url, callback, errback) {
      $.getJSON('http://127.0.0.1:8000/api/v1/comment', function(data) {
        var k, q, _i, _len, _ref;
        q = 0;
        _ref = data.objects;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          k = _ref[_i];
          if (url === k.link) {
            q = q + 1;
          }
        }
        return chrome.browserAction.setBadgeText({
          text: q + ""
        });
      });
    },
    newComment: function(url, author, comment, email, callback, errback) {
      var json, xhr;
      xhr = new XMLHttpRequest();
      json = JSON.stringify({
        text: comment,
        author: author,
        link: url,
        email: email
      });
      xhr.open("POST", 'http://127.0.0.1:8000/api/v1/comment/', true);
      xhr.setRequestHeader('Content-type', 'application/json;');
      return xhr.send(json);
    }
  };

  module.Backend = $this;

}).call(this);
