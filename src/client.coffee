debug = require('debug') 'freemobile:client'
Fantomo = require 'fantomo'
Inject = require './inject'
require './patch'


class module.exports extends Fantomo
  init: (@options = {}) =>
    @options.browser.urlPrefix = 'https://mobile.free.fr/'

  on_open: (path) =>
    @inject 'utils'
    routing =
      'moncompte/': @on_open_moncompte
    do routing[path] if routing[path]?

  on_open_moncompte: =>
    #@inject 'getConnectedUrl', (url) =>
    #  debug 'connected url', url

    #@inject 'getIdentDiv', (obj) =>
    #  debug 'ident_div', obj?

    #@inject 'getSmallImages', (images) =>
    #  debug 'images', images

    #@inject 'enterCredentials', @options.login, @options.password, (result) =>
    #  debug 'credentials entered', result

    #@inject 'getImagesData', (images) =>
    #  debug 'images', images

    @inject 'getImagesHash', (images) =>
      debug 'images', images

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
