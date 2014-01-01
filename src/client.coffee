debug = require('debug') 'freemobile:client'
Fantomo = require 'fantomo'
Inject = require './inject'
require './patch'


class module.exports extends Fantomo
  init: (@options = {}) =>
    @options.browser.urlPrefix = 'https://mobile.free.fr/'

  on_open: (path) =>
    routing =
      'moncompte/': @on_open_moncompte
    do routing[path] if routing[path]?

  on_open_moncompte: =>
    @inject 'get_connected_url', (url) =>
      debug 'connected url', url

    @inject 'get_ident_div', (obj) =>
      debug 'ident_div', obj?

    @inject 'enter_credentials', @options.login, @options.password, (result) =>
      debug 'credentials entered', result

  inject: (key, args...) =>
    if Inject.prototype[key]?
      if args.length > 1
        args = args[-1...].concat(args[...-1])
      @browser.evaluate Inject.prototype[key], args...
    else
      throw "Inject #{key} does not exist"

  login: (fn = null) =>
    throw "Browser is not yet ready" unless @browser.ready
    @browser.open 'moncompte/'
    debug "login=#{@options.login}, password=#{@options.password}"
    do fn if fn
