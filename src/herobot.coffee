module.exports = ->

  jerk = require 'jerk'

  options =
    server: 'irc.freenode.net',
    nick: 'herobot',
    channels: ['#heroku']

  url_commands =
    google:
      url: 'http://www.google.com/search?q='
      escape: '+'
    article:
      url: 'http://devcenter.heroku.com/articles/'
      escape: '-'
    tag:
      url: 'http://devcenter.heroku.com/tags/'
      escape: '-'
    search:
      url: 'http://devcenter.heroku.com/articles?q='
      escape: '+'

  heroku_help_message = "Welcome to the Heroku community channel. Before asking a
 question, please search http://devcenter.heroku.com and Google. You can check
 platform status at http://status.heroku.com.  Note that official support is
 available only through http://support.heroku.com.  Please do not spam the
 channel with your question or the word 'heroku'."

  to_url = (command, term) ->
    if command.escape?
      command.url + term.replace(/\s+/g, command.escape)
    else
      command.url + term

  return {
    bot:
      jerk (bot) ->
        bot.watch_for /^\s*(?:heroku\s*)+$|^heroku:/, (message) ->
          message.msg heroku_help_message
        for command, metadata of url_commands
          regexp =
            "^" +                # beginning of line
            "(?:(\\w+):\\s*)?" + # username target
            "\\s*!#{command}" +  # command
            "\\s*(.*)"           # search term
          do (regexp, metadata) ->
            bot.watch_for new RegExp(regexp), (message) ->
              target = message.match_data[1] ? message.user
              message.say target + ": " +  to_url(metadata, message.match_data[2])
        bot

    connect: ->
      @bot.connect(options)
  }
