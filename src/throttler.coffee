EventEmitter = require('events').EventEmitter

class Throttler extends EventEmitter

  constructor: (delay) ->
    @delay = delay * 1000

   trigger: (args...) ->
     unless @timeout?
       @timeout = setTimeout =>
         @timeout = null
         @emit('timeout', this)
       , @delay
       @emit('trigger', args...)

module.exports = Throttler
