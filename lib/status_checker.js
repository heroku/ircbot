(function() {
  var Request, StatusChecker, Xml;
  Request = require('request');
  Xml = require('libxmljs');
  module.exports = StatusChecker = (function() {
    function StatusChecker() {
      this.status = null;
      this.last_message_at = null;
      this._timeout_id = null;
      this._ms_frequency = null;
    }
    StatusChecker.prototype.update = function() {
      this.update_status();
      return this.update_message();
    };
    StatusChecker.prototype.start_auto_update = function(frequency) {
      if (frequency == null) {
        frequency = 60;
      }
      this._ms_frequency = frequency * 1000;
      if (this._timeout_id == null) {
        return this._auto_update();
      }
    };
    StatusChecker.prototype.stop_auto_update = function() {
      if (this._timeout_id) {
        clearTimeout(this._timeout_id);
      }
      return this._timeout_id = null;
    };
    StatusChecker.prototype.update_status = function() {
      return this._request('http://status.heroku.com/status.json', function(body) {
        var changed, status;
        status = JSON.parse(body);
        changed = (this.status != null) && this.status !== status;
        this.status = status;
        if (changed) {
          return this.emit('status', this.status);
        }
      });
    };
    StatusChecker.prototype.update_message = function() {
      return this._request('http://status.heroku.com/feed', function(body) {
        var changed, updated_at, xml;
        xml = Xml.parseXmlString(body);
        updated_at = xml.get('/feed/updated');
        changed = (this.last_message_at != null) && this.last_message_at < updated_at;
        this.last_message_at = updated_at;
        if (changed || this.message === null) {
          this.message = {
            content: xml.get('/feed/entry[0]/content').text().replaceString(/<[^>]*>/g, '').replaceString(/\n/g, ' ').replaceString(/\s{2,}/g, ' '),
            title: xml.get('/feed/entry[0]/title').text(),
            url: xml.get('/feed/entry[0]/link').attr('href').value()
          };
        }
        if (changed) {
          return this.emit('message', this.message);
        }
      });
    };
    StatusChecker.prototype._auto_update = function() {
      this.update();
      return this._timeout_id = setTimeout(this._auto_update, this._ms_frequency);
    };
    StatusChecker.prototype._request = function(uri, on_success) {
      return Request({
        uri: uri
      }, function(error, response, body) {
        if (error != null) {
          if (error != null) {
            return console.log("Error: " + error);
          }
        } else if (response.statusCode !== 200) {
          return console.log("Response code: " + response.statusCode);
        } else {
          return on_success(body);
        }
      });
    };
    return StatusChecker;
  })();
}).call(this);
