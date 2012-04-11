Throttler = require('../src/throttler')

module.exports = (robot) ->

  generic_help_message =
    '''
    For urgent help, please visit https://support.heroku.com; for platform
    status: https://status.heroku.com; for docs: https://devcenter.heroku.com.
    Say 'herobot help me' to learn more about me.
    '''
      .replace(/\n/g, ' ')

  heroku_help_message = "It looks like you need help! " + generic_help_message

  herobot_message = "I'm herobot! " + generic_help_message

  heroku_throttler = new Throttler(10 * 60).on 'trigger', (message) ->
    message.send(heroku_help_message)

  robot.hear /^(?:heroku\W*)+$|^heroku:/i, (message) ->
    heroku_throttler.trigger(message)
