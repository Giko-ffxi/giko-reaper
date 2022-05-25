local config   = require('lib.giko.config')
local cache    = require('lib.giko.cache')
local common   = require('lib.giko.common')
local chat     = require('lib.giko.chat')
local monster  = require('lib.giko.monster')
local reaper   = { }

reaper.listen = function(id, size, packet, packet_modified, blocked)
    
    if (id == 0x38) then

        local index    = struct.unpack('H', packet, 0x10 + 1)
        local deceased = GetEntity(index)

        if (deceased ~= nil) then
            for key,mob in ipairs(monster.notorious) do
                for n,name in ipairs(common.flatten(mob.names)) do
                    if string.lower(deceased.Name) == string.lower(name) and deceased.SpawnFlags == 0x0010 then
                        chat.tell(config.broadcaster, string.format('@giko set-tod %s %s', string.lower(string.gsub(deceased.Name, ' ', '-')), os.date('%Y-%m-%d %H:%M:%S %z', os.time() + config.lag)))
                    end
                end
            end
        end       

    end

    return false

end

return reaper