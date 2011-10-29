# Generates help commands for Hubot.
#
# These commands are grabbed from comment blocks at the top of each file.
#
# help - Displays all of the help commands that Hubot knows about.

Throttler = require('../src/throttler')

module.exports = (robot) ->

  help_throttler = new Throttler(5 * 60)
    .on 'trigger', (msg) ->
      msg.send robot.helpCommands().join("\n")

  robot.respond /help(?: me)?$/i, (msg) ->
    help_throttler.trigger(msg)
