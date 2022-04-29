local config   = require('lib.giko.config')
local cache    = require('lib.giko.cache')
local common   = require('lib.giko.common')
local chat     = require('lib.giko.chat')
local monster  = require('lib.giko.monster')
local watcher  = { cache = string.format('%s\\..\\giko-cache\\cache\\giko.monster.id.csv', _addon.path) }
local ids      = {}

watcher.load  = function()
    ids = cache.get_all(watcher.cache)
end

watcher.watch = function(mode, input, m_mode, m_message, blocked)
    
    local target = GetEntity(AshitaCore:GetDataManager():GetTarget():GetTargetIndex())

    if (target ~= nil) then
        for key,mob in ipairs(monster.notorious) do
            for n,name in ipairs(common.flatten(mob.names)) do  
                if string.lower(target.Name) == string.lower(name) and target.SpawnFlags == 0x0010 and not common.in_array_key(ids, string.lower(target.Name)) then
                    ids[string.lower(target.Name)] = target.ServerId
                    cache.set(watcher.cache, k, i)
                end
            end
        end
    end

end

watcher.listen = function(id, size, packet, packet_modified, blocked)
    
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

return watcher