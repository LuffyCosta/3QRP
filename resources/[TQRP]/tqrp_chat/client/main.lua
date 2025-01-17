function Print3DText(coords, text)
  local onScreen, _x, _y = World3dToScreen2d(coords.x, coords.y, coords.z)

  if onScreen then
      local px, py, pz = table.unpack(GetGameplayCamCoords())
      local dist = #(vector3(px, py, pz) - vector3(coords.x, coords.y, coords.z))    
      local scale = (1 / dist) * 20
      local fov = (1 / GetGameplayCamFov()) * 100
      local scale = scale * fov   
      SetTextScale(0.35, 0.35)
      SetTextFont(6)
      SetTextProportional(1)
      SetTextColour(250, 250, 250, 255)		-- You can change the text color here
      SetTextDropshadow(1, 1, 1, 1, 255)
      SetTextEdge(2, 0, 0, 0, 150)
      SetTextDropShadow()
      SetTextOutline()
      SetTextEntry("STRING")
      SetTextCentre(1)
      AddTextComponentString(text)
      SetDrawOrigin(coords.x, coords.y, coords.z, 0)
      DrawText(0.0, 0.0)
      ClearDrawOrigin()
  end
end

RegisterCommand('editorstopsave', function()
  if(IsRecording()) then
    StopRecordingAndSaveClip()
  end   
end, false)

RegisterCommand('editorstopdiscard', function()
  if(IsRecording()) then
    StopRecordingAndDiscardClip()
  end   
end, false)

RegisterCommand('editorstartrecord', function()
  if( not IsRecording()) then
    StartRecording(1)
  end   
end, false)

RegisterCommand('editorenter', function()
  if( not IsRecording()) then
    NetworkSessionLeaveSinglePlayer()
    ActivateRockstarEditor()
  end   
end, false)

--[[ RegisterCommand("blueFlare", function()

  SetPedWeaponTintIndex(PlayerPedId(), GetHashKey("WEAPON_FLAREGUN"), 5)

end, false) ]]





local mes = {}
RegisterNetEvent('fu_chat:client:ReceiveMe')
AddEventHandler('fu_chat:client:ReceiveMe', function(sender, message)
  local senderClient = GetPlayerFromServerId(sender)
  local senderPos = GetEntityCoords(GetPlayerPed(senderClient))
  local dist = #(vector3(senderPos.x, senderPos.y, senderPos.z) - GetEntityCoords(PlayerId()))

  if dist < 20.0 then
    local timer = 500
    mes[sender] = message
    Citizen.CreateThread(function()
      while dist < 20.0 and mes[sender] == message and timer > 0 do
        senderPos = GetEntityCoords(GetPlayerPed(senderClient))
        Print3DText(senderPos, message)
        dist = #(vector3(senderPos.x, senderPos.y, senderPos.z) - GetEntityCoords(PlayerId()))
        timer = timer - 1
        Citizen.Wait(1)
      end
    end)
  end
end)

RegisterNetEvent('sendProximityMessage')
AddEventHandler('sendProximityMessage', function(id, name, message)
  local myId = PlayerId()
  local pid = GetPlayerFromServerId(id)
  if pid == myId then
    TriggerEvent('chatMessage', "^4" .. name .. "", {0, 153, 204}, "^7 " .. message)
  elseif #(vector3(GetEntityCoords(GetPlayerPed(myId))) - GetEntityCoords(GetPlayerPed(pid))) < 19.999 then
    TriggerEvent('chatMessage', "^4" .. name .. "", {0, 153, 204}, "^7 " .. message)
  end
end)

RegisterNetEvent('sendProximityMessageMe')
AddEventHandler('sendProximityMessageMe', function(id, name, message)
  local myId = PlayerId()
  local pid = GetPlayerFromServerId(id)
  if pid == myId then
    TriggerEvent('chatMessage', "", {255, 0, 0}, " ^6 " .. name .." ".."^6 " .. message)
  elseif #(vector3(GetEntityCoords(GetPlayerPed(myId))) - GetEntityCoords(GetPlayerPed(pid))) < 19.999 then
    TriggerEvent('chatMessage', "", {255, 0, 0}, " ^6 " .. name .." ".."^6 " .. message)
  end
end)

RegisterNetEvent('sendProximityMessageDo')
AddEventHandler('sendProximityMessageDo', function(id, name, message)
  local myId = PlayerId()
  local pid = GetPlayerFromServerId(id)
  if pid == myId then
    TriggerEvent('chatMessage', "", {255, 0, 0}, " ^0* " .. name .."  ".."^0  " .. message)
  elseif #(vector3(GetEntityCoords(GetPlayerPed(myId))) - GetEntityCoords(GetPlayerPed(pid))) < 19.999 then
    TriggerEvent('chatMessage', "", {255, 0, 0}, " ^0* " .. name .."  ".."^0  " .. message)
  end
end)