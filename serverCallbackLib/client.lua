TOBBlaine = {}
TOBBlaine.CurrentRequestId          = 0
TOBBlaine.ServerCallbacks           = {}

TOBBlaine.TriggerServerCallback = function(name, cb, ...)
	TOBBlaine.ServerCallbacks[TOBBlaine.CurrentRequestId] = cb

	TriggerServerEvent('TOBBlaine:triggerServerCallback', name, TOBBlaine.CurrentRequestId, ...)

	if TOBBlaine.CurrentRequestId < 65535 then
		TOBBlaine.CurrentRequestId = TOBBlaine.CurrentRequestId + 1
	else
		TOBBlaine.CurrentRequestId = 0
	end
end

RegisterNetEvent('TOBBlaine:serverCallback')
AddEventHandler('TOBBlaine:serverCallback', function(requestId, ...)
	TOBBlaine.ServerCallbacks[requestId](...)
	TOBBlaine.ServerCallbacks[requestId] = nil
end)