Jerk = require 'jerk'
StatusChecker = require 'status_cheker'

OPTIONS =
  development:
    server: 'irc.freenode.net'
    nick: 'herobotest'
    channels: ['#norbauer']
  production:
    server: 'irc.freenode.net'
    nick: 'herobot'
    channels: ['#heroku']

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
  through http://support.heroku.com. Please do not repeat/spam questions or the
  word 'heroku' in the channel.
  '''
    .replace(/\n/g, ' ')

module.exports = new class Herobot

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

      @status_checker = new StatusChecker()
        .on 'message', (message) ->
          @bot.say @options.channels[0], "STATUS UPDATE: #{message.title} - #{message.url}"
          message = if message.content.length > 420
            message.content[0...400] + " ... (continued, see link)"
          else
            message.content
          @boy.say @options.channels[0], message.content
        .on 'status', (status) ->
          msg = (for k, v of status
            k + ": " + v
          ).join(" - ")
          @bot.say @options.channels[0], "PLATFORM STATUS: #{msg}"

      return bot

  connect: (environment = 'development') ->
    @options = OPTIONS[environment]
    @bot.connect(@options)
    @status_checker.start_auto_update()
