TOBBlaine = {}
TOBBlaine.ServerCallbacks = {}

RegisterServerEvent('TOBBlaine:triggerServerCallback')
AddEventHandler('TOBBlaine:triggerServerCallback', function(name, requestId, ...)
	local _source = source

	TOBBlaine.TriggerServerCallback(name, requestID, _source, function(...)
		TriggerClientEvent('TOBBlaine:serverCallback', _source, requestId, ...)
	end, ...)
end)

TOBBlaine.RegisterServerCallback = function(name, cb)
	TOBBlaine.ServerCallbacks[name] = cb
end

TOBBlaine.TriggerServerCallback = function(name, requestId, source, cb, ...)
	if TOBBlaine.ServerCallbacks[name] ~= nil then
		TOBBlaine.ServerCallbacks[name](source, cb, ...)
	else
		print('TOBBlaine.TriggerServerCallback => [' .. name .. '] does not exist')
	end
end