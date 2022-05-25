package.path = (string.gsub(_addon.path, '[^\\]+\\?$', '')) .. 'giko-common\\' .. '?.lua;' .. package.path

_addon.author 	= 'giko'
_addon.name 	= 'giko-reaper'
_addon.version 	= '1.0.0'

watcher = require('core.watcher')

ashita.register_event('load', watcher.load)
ashita.register_event('render', watcher.watch)
ashita.register_event('incoming_packet', watcher.listen)