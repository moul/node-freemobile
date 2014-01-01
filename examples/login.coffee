#!/usr/bin/env coffee

# clear terminal
process.stdout.write '\u001B[2J\u001B[0;0f'

debug = require('debug') 'freemobile:examples:login'

FreeMobile = require '..'

client = new FreeMobile
  verbose: true
  browser:
    verbose: true
  login: process.argv[2]
  password: process.argv[3]

client.on 'ready', ->
  debug 'ready OK'

  client.login ->
    debug 'login OK'

client.on 'logged', ->
  debug 'logged'
