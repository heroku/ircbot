(function() {
  var HEROKU_HELP_MESSAGE, Herobot, Jerk, OPTIONS, StatusChecker, URL_COMMANDS;
  Jerk = require('jerk');
  StatusChecker = require('status_checker');
  OPTIONS = {
    development: {
      server: 'irc.freenode.net',
      nick: 'herobotest',
      channels: ['#norbauer']
    },
    production: {
      server: 'irc.freenode.net',
      nick: 'herobot',
      channels: ['#heroku']
    }
  };
  URL_COMMANDS = {
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
  HEROKU_HELP_MESSAGE = 'Welcome to the Heroku community channel. Before asking a question, please\nsearch http://devcenter.heroku.com and Google. You can check platform status\nat http://status.heroku.com. Note that official support is available only\nthrough http://support.heroku.com. Please do not spam the channel with your\nquestion or the word \'heroku\'.'.replace(/\n/g, ' ');
  module.exports = new (Herobot = (function() {
    function Herobot() {
      var to_url;
      to_url = function(command, term) {
        if (command.escape != null) {
          return command.url + term.replace(/\s+/g, command.escape);
        } else {
          return command.url + term;
        }
      };
      this.bot = Jerk(function(bot) {
        var command, metadata, _fn;
        bot.watch_for(/^\s*(?:heroku\s*)+$|^heroku:/, function(message) {
          return message.msg(HEROKU_HELP_MESSAGE);
        });
        _fn = function(metadata) {
          var regexp;
          regexp = new RegExp("^" + "(?:(\\w+):\\s*)?" + ("\\s*!" + command) + "\\s*(.*)");
          return bot.watch_for(regexp, function(message) {
            var target, _ref;
            target = (_ref = message.match_data[1]) != null ? _ref : message.user;
            return message.say(target + ": " + to_url(metadata, message.match_data[2]));
          });
        };
        for (command in URL_COMMANDS) {
          metadata = URL_COMMANDS[command];
          _fn(metadata);
        }
        return bot;
      });
      this.status_checker = new StatusChecker().on('message', function(message) {
        this.bot.say(this.options.channels[0], "STATUS UPDATE: " + message.title + " - " + message.url);
        message = message.content.length > 420 ? message.content.slice(0, 400) + " ... (continued, see link)" : message.content;
        return this.boy.say(this.options.channels[0], message.content);
      }).on('status', function(status) {
        var k, msg, v;
        msg = ((function() {
          var _results;
          _results = [];
          for (k in status) {
            v = status[k];
            _results.push(k + ": " + v);
          }
          return _results;
        })()).join(" - ");
        return this.bot.say(this.options.channels[0], "PLATFORM STATUS: " + msg);
      });
    }
    Herobot.prototype.connect = function(environment) {
      if (environment == null) {
        environment = 'development';
      }
      this.options = OPTIONS[environment];
      this.bot.connect(this.options);
      return this.status_checker.start_auto_update();
    };
    return Herobot;
  })());
}).call(this);
