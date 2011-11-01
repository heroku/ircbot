# Find a rubygem from rubygems.org
#
# there's a gem for <that>, gem me <that> - Returns a link to a gem on rubygems.org
#

module.exports = (robot) ->
  responder = (msg) ->
    search = escape(msg.match[1])
    msg.http('https://rubygems.org/api/v1/search.json')
      .query(query: search)
      .get() (err, res, body) ->
        results = JSON.parse(body)
        result = results[0]
        msg.send "https://rubygems.org/gems/#{result.name}"

  robot.respond /there's a gem for (.*)/i, responder
  robot.respond /gem(?: me) (.*)/i, responder
