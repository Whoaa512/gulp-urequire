path = require 'path'
gutil = require 'gulp-util'

urequire = require 'urequire'

class GulpURequire extends require('stream').Transform
  constructor: (options={}) ->
    super {objectMode: true}
    @files = []

  _transform: (file, encoding, callback) -> @files.push(file); callback()

  _flush: (callback) ->
    builder = new urequire.BundleBuilder(options)
    builder.compile @files, (err, result) =>
      return callback(err) if err

      @push(new gutil.File({
        base: options.project_name,
        path: process.cwd(),
        contents: new Buffer(result)
      }))
      callback()

module.exports = (options) -> return new GulpURequire(options)
