var options = {
  server: 'irc.freenode.net',
  nick: 'herobot',
  channels: ['#norbauer']
};

var jerk = require('jerk');

var bot = jerk(function(j) {
  j.watch_for(/^\s*(?:heroku\s*)+$|^heroku:/, function(message) {
    message.msg(
      "Welcome to the Heroku community channel. Before asking a question, " +
      "please search http://devcenter.heroku.com and Google. " +
      "You can check platform status at http://status.heroku.com. " +
      "Note that official support is available only through http://support.heroku.com. " +
      "Please do not spam the channel with your question or the word 'heroku'.");
  });
  j.watch_for(/^(?:(\w+): )?!google (.*)/, function(message) {
    var target = message.match_data[1] || message.user;
    message.say(target + ': http://www.google.com/search?q=' +
      message.match_data[2].replace(/\s+/g, '+'));
  });
  j.watch_for(/^(?:(\w+): )?!article (.*)/, function(message) {
    var target = message.match_data[1] || message.user;
    message.say(target + ': http://devcenter.heroku.com/articles/' +
      message.match_data[2].replace(/\s+/g, '-'));
  });
  j.watch_for(/^(?:(\w+): )?!tag (.*)/, function(message) {
    var target = message.match_data[1] || message.user;
    message.say(target + ': http://devcenter.heroku.com/tags/' +
      message.match_data[2]);
  });
  j.watch_for(/^(?:(\w+): )?!search (.*)/, function(message) {
    var target = message.match_data[1] || message.user;
    message.say(target + ': http://devcenter.heroku.com/articles?q=' +
      message.match_data[2].replace(/\s+/g, '+'));
  });
}).connect(options);
