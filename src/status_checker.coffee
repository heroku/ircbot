Request = require('request')
Xml = require('libxmljs')

module.exports = class StatusChecker

  constructor: ->
    @status = null
    @last_message_at = null
    @_timeout_id = null
    @_ms_frequency = null

  update: ->
    @update_status()
    @update_message()

  start_auto_update: (frequency = 60) ->
    @_ms_frequency = frequency * 1000
    @_auto_update() unless @_timeout_id?

  stop_auto_update: ->
    clearTimeout(@_timeout_id) if @_timeout_id
    @_timeout_id = null

  update_status: ->
    @_request 'http://status.heroku.com/status.json', (body) ->
      status = JSON.parse(body)
      changed = @status? and @status isnt status
      @status = status
      this.emit('status', @status) if changed

  update_message: ->
    @_request 'http://status.heroku.com/feed', (body) ->
      xml = Xml.parseXmlString(body)
      updated_at = xml.get('/feed/updated')
      changed = @last_message_at? and @last_message_at < updated_at
      @last_message_at = updated_at
      if changed or @message is null
        @message =
          content: xml.get('/feed/entry[0]/content').text().
            replaceString(/<[^>]*>/g, '').
            replaceString(/\n/g, ' ').
            replaceString(/\s{2,}/g, ' ')
          title: xml.get('/feed/entry[0]/title').text()
          url: xml.get('/feed/entry[0]/link').attr('href').value()
      this.emit('message', @message) if changed

  _auto_update: ->
    @update()
    @_timeout_id = setTimeout @_auto_update, @_ms_frequency

  _request: (uri, on_success) ->
    Request { uri: uri }, (error, response, body) ->
      if error?
        console.log("Error: #{error}") if error?
      else if response.statusCode isnt 200
        console.log("Response code: #{response.statusCode}")
      else
        on_success body
