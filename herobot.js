(function() {
  module.exports = function() {
    var heroku_help_message, jerk, options, url_commands, _to_url;
    jerk = require('jerk');
    options = {
      server: 'irc.freenode.net',
      nick: 'herobot',
      channels: ['#heroku']
    };
    url_commands = {
      google: {
        url: 'http://www.google.com/search?q=',
        escape: '+'
      },
      article: {
        url: 'http://devcenter.heroku.com/articles/',
        escape: '-'
      },
      tag: {
        url: 'http://devcenter.heroku.com/tags/',
        escape: '-'
      },
      search: {
        url: 'http://devcenter.heroku.com/articles?q=',
        escape: '+'
      }
    };
    heroku_help_message = "Welcome to the Heroku community channel. Before asking a question, please search http://devcenter.heroku.com and Google. You can check platform status at http://status.heroku.com.  Note that official support is available only through http://support.heroku.com.  Please do not spam the channel with your question or the word 'heroku'.";
    _to_url = function(command, term) {
      if (command.escape != null) {
        return command.url + term.replace(/\s+/g, command.escape);
      } else {
        return command.url + term;
      }
    };
    return {
      bot: jerk(function(bot) {
        var command, metadata, regexp, _fn;
        bot.watch_for(/^\s*(?:heroku\s*)+$|^heroku:/, function(message) {
          return message.msg(heroku_help_message);
        });
        _fn = function(regexp, metadata) {
          return bot.watch_for(new RegExp(regexp), function(message) {
            var target, _ref;
            target = (_ref = message.match_data[1]) != null ? _ref : message.user;
            return message.say(target + ": " + _to_url(metadata, message.match_data[2]));
          });
        };
        for (command in url_commands) {
          metadata = url_commands[command];
          regexp = "^" + "(?:(\\w+):\\s*)?" + ("\\s*!" + command) + "\\s*(.*)";
          _fn(regexp, metadata);
        }
        return bot;
      }),
      connect: function() {
        return this.bot.connect(options);
      }
    };
  };
}).call(this);
