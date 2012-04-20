# Generates help commands for Hubot.
#
# These commands are grabbed from comment blocks at the top of each file.
#
# help - responds by private message with all of the commands that Hubot knows about.

Throttler = require('../src/throttler')

module.exports = (robot) ->

  robot.respond /help(?: me)?$/i, (msg) ->
    msg.send "Dispatching help by private message."
    msg.reply robot.helpCommands().join("\n")
