# Generates help commands for Hubot.
#
# These commands are grabbed from comment blocks at the top of each file.
#
# help - responds with all of the commands that Hubot knows about.

module.exports = (robot) ->

  robot.respond /help\s*(.*)?$/i, (msg) ->
    cmds = robot.helpCommands()
    if msg.match[1]
      cmds = cmds.filter (cmd) -> cmd.match(new RegExp(msg.match[1], 'i'))
      return if cmds.size == 0
    emit = cmds.join("\n")
    unless robot.name is 'Hubot'
      emit = emit.replace(/(H|h)ubot/g, robot.name)

    msg.send emit
