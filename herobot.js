var options = {
  server: 'irc.freenode.net',
  nick: 'herobot',
  channels: ['#norbauer']
};

var jerk = require('jerk');

var bot = jerk(function(j) {
  j.watch_for(/^!say (.+)$/, function(message) {
    message.say(message.match_data[1]);
  });
}).connect(options);
