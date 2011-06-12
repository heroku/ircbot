Jerk = require 'jerk'

OPTIONS =
  development:
    server: 'irc.freenode.net'
    nick: 'herobotest'
    channels: ['#norbauer']
  production:
    server: 'irc.freenode.net'
    nick: 'herobot'
    channels: ['heroku']

URL_COMMANDS =
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

HEROKU_HELP_MESSAGE =
  '''
  Welcome to the Heroku community channel. Before asking a question, please
  search http://devcenter.heroku.com and Google. You can check platform status
  at http://status.heroku.com. Note that official support is available only
  through http://support.heroku.com. Please do not spam the channel with your
  question or the word 'heroku'.
  '''
    .replace(/\n/g, ' ')

class Herobot

  constructor: ->

    to_url = (command, term) ->
      if command.escape?
        command.url + term.replace(/\s+/g, command.escape)
      else
        command.url + term

    @bot = Jerk (bot) ->

      bot.watch_for /^\s*(?:heroku\s*)+$|^heroku:/, (message) ->
        message.msg HEROKU_HELP_MESSAGE

      for command, metadata of URL_COMMANDS
        do (metadata) ->
          regexp = new RegExp(
            "^" +                # beginning of line
            "(?:(\\w+):\\s*)?" + # optional username target
            "\\s*!#{command}" +  # command
            "\\s*(.*)"           # search term
          )
          bot.watch_for regexp, (message) ->
            target = message.match_data[1] ? message.user
            message.say target + ": " +  to_url(metadata, message.match_data[2])

      return bot

  connect: (environment = 'development') ->
    @bot.connect(OPTIONS[environment])

module.exports = new Herobot()
