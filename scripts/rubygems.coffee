# Find a rubygem from rubygems.org
#
# there's a gem for <that>, gem me <that> - Returns a link to a gem on rubygems.org
#

_ = require('underscore')

module.exports = (robot) ->
  responder = (msg) ->
    search = escape(msg.match[1])
    msg.http("https://rubygems.org/api/v1/gems/#{search}.json")
      .get() (err, res, body) ->
        if res.statusCode == 200
          results = JSON.parse(body)
          info = results['info'].replace("\n", " ").replace(/\s+/, ' ')
          if info.length > 100
            info = info[0..100] + "..."
          response = "Exact match: https://rubygems.org/gems/#{search} - #{info} - latest version: #{results['version']}"
          if results['dependencies']['runtime'].length > 0
            response += " - dependencies: #{_.map(results['dependencies']['runtime'], (e) -> e['name']).join(', ')}"
          else
            response += " - no dependencies"
          response += " - source: #{results['source_code_uri']}" if results['source_code_uri']?
          msg.send response
        else
          msg.http('https://rubygems.org/api/v1/search.json')
            .query(query: search)
            .get() (err, res, body) ->
              results = JSON.parse(body)
              result = results[0]
              if result?
                msg.send "First search result: https://rubygems.org/gems/#{result.name}"
              else
                msg.send "I couldn't find a gem for that. :("

  robot.respond /there's a gem for (.*)/i, responder
  robot.respond /gem(?: me) (.*)/i, responder
