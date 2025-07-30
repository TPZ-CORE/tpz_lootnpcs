Citizen.CreateThread(function()

    while true do

        local sleep = 0

        local size = GetNumberOfEvents(0)

        if size > 0 then
	
            for index = 0, size - 1 do

                local event = GetEventAtIndex(0, index)

                if event == 1376140891 then -- EVENT_LOOT_COMPLETE

                    local eventDataSize   = 3 -- for EVENT_LOOT_COMPLETE data size is 3
                    local eventDataStruct = DataView.ArrayBuffer(8 * eventDataSize) -- buffer must be 8*eventDataSize or bigger

                    eventDataStruct:SetInt32(8 * 0, 0) -- 8*0 offset for 0 element of eventData
                    eventDataStruct:SetInt32(8 * 1, 0) -- 8*0 offset for 0 element of eventData
                    eventDataStruct:SetInt32(8 * 2, 0) -- 8*0 offset for 0 element of eventData

                    local is_data_exists = Citizen.InvokeNative(0x57EC5FA4D4D6AFCA,0, index, eventDataStruct:Buffer(), eventDataSize)	-- GET_EVENT_DATA

					if is_data_exists then

                        local looterId          = eventDataStruct:GetInt32(8 * 0)
                        local LootedEntityModel = eventDataStruct:GetInt32(8 * 1)
                        local IsLootSuccess     = eventDataStruct:GetInt32(8 * 2)

                        if (PlayerPedId() == looterId) and (not Citizen.InvokeNative(0x964000D355219FC0, LootedEntityModel)) then -- We make sure the looterId is our PlayerId.

                            local type = GetPedType(LootedEntityModel)

                            if type == 4 then

                                if Citizen.InvokeNative(0x8DE41E9902E85756, LootedEntityModel) then -- _IS_ENTITY_FULLY_LOOTED
                                
                                    local closestEntityPedsList = exports.tpz_core:getCoreAPI().getClosestPedsNearbyTargetPed(PlayerPedId(), 5.0)
                                    TriggerServerEvent("tpz_lootnpcs:server:reward", closestEntityPedsList, LootedEntityModel)
                                end

                            end

                        end

                    end

                end
            
            end

        end

        Wait(sleep)
    end
end)
