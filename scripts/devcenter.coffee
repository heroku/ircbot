# article me <name> - returns a link to the DevCenter article with <name>
# tag me <tag> - returns a link to all articles with tagged <tag>
# devcenter find me <query> - returns a link to a DevCenter search for <query>

module.exports = (robot) ->

  robot.respond /article( me)? (.*)/i, (msg) ->
    msg.send 'https://devcenter.heroku.com/articles/' + msg.match[2].replace(/\s+/g, '-')

  robot.respond /tag( me)? (.*)/i, (msg) ->
    msg.send 'https://devcenter.heroku.com/tags/' + msg.match[2].replace(/\s+/g, '-')

  robot.respond /devcenter find( me)? (.*)/i, (msg) ->
    msg.send 'https://devcenter.heroku.com/articles?q=' + msg.match[2].replace(/\s+/g, '+')
