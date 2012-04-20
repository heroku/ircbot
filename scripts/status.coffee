# Show current Heroku status
#
# status - Returns the current Heroku status for app operations and tools

module.exports = (robot) ->
  robot.respond /status/, (msg) ->
    msg.http("https://status.heroku.com/status.json")
      .get() (err, res, body) ->
        try
          json = JSON.parse(body)
          msg.send "App Operations: #{json['App Operations']} | Tools: #{json['Tools']}"
        catch error
          msg.send "Uh oh, I had trouble figuring out what the Heroku cloud is up to."
