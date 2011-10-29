# Returns the URL of the first google hit for a query
#
# google me <query> - Googles <query> & returns 1st result's URL
# results page me <query> - Returns a link to a Google search for <query>

module.exports = (robot) ->

  googleMe = (msg, query, cb) ->
    msg.http('http://www.google.com/search')
      .query(q: query)
      .get() (err, res, body) ->
        cb body.match(/<a href="([^"]*)" class=l>/)?[1] || "Sorry, Google had zero results for '#{query}'"

  robot.respond /google( me)? (.*)/i, (msg) ->
    googleMe msg, msg.match[2], (url) ->
      msg.send url

  robot.respond /(google )?results page( me)? (.*)/i, (msg) ->
    msg.send 'http://www.google.com/search?q=' + msg.match[3].replace(/\s+/g, '+')
