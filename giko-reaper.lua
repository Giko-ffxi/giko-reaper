package.path = (string.gsub(_addon.path, '[^\\]+\\?$', '')) .. 'giko-common\\' .. '?.lua;' .. package.path

_addon.author 	= 'giko'
_addon.name 	= 'giko-reaper'
_addon.version 	= '1.0.5'

reaper = require('core.reaper')

ashita.register_event('incoming_packet', reaper.listen)

