fs = require 'fs'

module.exports.save_dataURL_to_file = (dataURL, filename) ->
  data = dataURL.replace(/^data:image\/\w+;base64,/, "")
  buf = new Buffer data, 'base64'
  fs.writeFile filename, buf
