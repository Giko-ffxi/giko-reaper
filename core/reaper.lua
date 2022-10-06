local config   = require('lib.giko.config')
local cache    = require('lib.giko.cache')
local common   = require('lib.giko.common')
local chat     = require('lib.giko.chat')
local death    = require('lib.giko.death')
local monster  = require('lib.giko.monster')
local reaper   = { }

reaper.listen = function(id, size, packet, packet_modified, blocked)
    
    if (id == 0x38) then

        local index    = struct.unpack('H', packet, 0x10 + 1)
        local zone     = AshitaCore:GetResourceManager():GetString('areas', AshitaCore:GetDataManager():GetParty():GetMemberZone(0));
        local deceased = GetEntity(index)

        if deceased ~= nil and string.find(string.lower(zone), "nyzul") == nil and string.find(string.lower(zone), "riverne") == nil and string.find(string.lower(zone), "eldieme") == nil then
            for key,mob in ipairs(monster.notorious) do
                for n,name in ipairs(common.flatten(mob.names)) do
                    if string.lower(deceased.Name) == string.lower(name) and deceased.SpawnFlags == 0x0010 then
                        if config.monsters[mob.names.nq[1]] ~= nil and config.monsters[mob.names.nq[1]].broadcast == false then
                            death.set_tod(mob.names.nq[1], os.date('%Y-%m-%d %H:%M:%S', os.time() - common.offset_to_seconds(os.date('%z', os.time()))))                          
                        else
                            ashita.timer.create(string.format('reaper-%s', string.lower(name)), config.delay or 3, 1, function() chat.tell(config.broadcaster, string.format('@giko set-tod %s now', string.lower(string.gsub(deceased.Name, ' ', '-')))) end)
                        end
                    end
                end
            end
        end       

    end

    return false

end

return reaper