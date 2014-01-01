debug = require('debug') 'FreeMobile:patch'

originalLog = console.log

# Disable CoreText performance debug
console.warn = console.warning = (args...) ->
  if -1 is args[0].indexOf 'CoreText performance note:', 0
    originalLog args...
