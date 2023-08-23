-- reworked by scrxpted because yes

local ProtectedInstances = {}
local _getconnections = getconnections or get_connections
local _hookfunction = HookFunction or hookfunction or hook_function or detour_function
local _getnamecallmethod = getnamecallmethod or get_namecall_method
local _checkcaller = checkcaller or check_caller
local _getrawmetatable = get_raw_metatable or getrawmetatable or getraw_metatable

assert(_hookfunction  and _getnamecallmethod and _checkcaller and _getconnections, "Exploit is not supported")

local function HookMetaMethod(Object, MetaMethod, Function)
    return _hookfunction(assert(_getrawmetatable(Object)[MetaMethod], "Invalid Method"), Function)
end 

local TblDataCache = {}
local FindDataCache = {}
local PropertyChangedData = {}
local InstanceConnections = {}
local NameCall, NewIndex

local EventMethods = {
    "ChildAdded",
    "ChildRemoved",
    "DescendantRemoving",
    "DescendantAdded",
    "childAdded",
    "childRemoved",
    "descendantRemoving",
    "descendantAdded",
}
local TableInstanceMethods = {
    GetChildren = game.GetChildren,
    GetDescendants = game.GetDescendants,
    getChildren = game.getChildren,
    getDescendants = game.getDescendants,
    children = game.children,
}
local FindInstanceMethods = {
    FindFirstChild = game.FindFirstChild,
    FindFirstChildWhichIsA = game.FindFirstChildWhichIsA,
    FindFirstChildOfClass = game.FindFirstChildOfClass,
    findFirstChild = game.findFirstChild,
    findFirstChildWhichIsA = game.findFirstChildWhichIsA,
    findFirstChildOfClass = game.findFirstChildOfClass,
}
local NameCallMethods = {
    Remove = game.Remove,
    Destroy = game.Destroy,
    remove = game.remove,
    destroy = game.destroy,
}

local signals = {}
setmetatable(signals, { __mode = "k" })

local blankFunction = function(...) return ... end

local function disablesignal(signal)
    if signals[signal] == nil then
        signals[signal] = {}
    end
    for _, connection in next, _getconnections(signal) do
        if connection.Function and connection.Function ~= blankFunction then
            table.insert(signals[signal], {
                shell = connection.Function,
                root = hookfunction(connection.Function, blankFunction)
            })
        end
    end
    return signal
end

local function enablesignal(signal)
    if signals[signal] ~= nil then
        for _, object in next, signals[signal] do
            hookfunction(object.shell, object.root)
            table.clear(object)
            signals[signal][_] = nil
        end
    end
    return signal
end

for MethodName, MethodFunction in next, TableInstanceMethods do
    TblDataCache[MethodName] = _hookfunction(MethodFunction, function(...)
        if not _checkcaller() then
            local ReturnedTable = TblDataCache[MethodName](...)
            
            if ReturnedTable then
                for _, instance in next, ProtectedInstances do
                    while table.find(ReturnedTable, instance) do
                        table.remove(ReturnedTable, table.find(ReturnedTable, instance))
                    end
                end

                return ReturnedTable
            end
        end

        return TblDataCache[MethodName](...)
    end)
end

for MethodName, MethodFunction in next, FindInstanceMethods do
    FindDataCache[MethodName] = _hookfunction(MethodFunction, function(...)
        if not _checkcaller() then
            local FindResult = FindDataCache[MethodName](...)

            if table.find(ProtectedInstances, FindResult) then
                FindResult = nil
            end
        end
        return FindDataCache[MethodName](...)
    end)
end

local function GetParents(Object)
    local Parents = { Object.Parent }

    local CurrentParent = Object.Parent

    while CurrentParent ~= game and CurrentParent ~= nil do
        CurrentParent = CurrentParent.Parent
        table.insert(Parents, CurrentParent)
    end

    return Parents
end

NameCall = HookMetaMethod(game, "__namecall", function(...)
    if not _checkcaller() then
        local ReturnedData = NameCall(...)
        local NCMethod = _getnamecallmethod()
        local self, Args = ...

        if typeof(self) ~= "Instance" then return ReturnedData end
        if not ReturnedData then return nil end

        if TableInstanceMethods[NCMethod] then
            if typeof(ReturnedData) ~= "table" then return ReturnedData end

            for _, instance in next, ProtectedInstances do
                while table.find(ReturnedData, instance) do
                    table.remove(ReturnedData, table.find(ReturnedData, instance))
                end
            end

            return ReturnedData
        end
        
        if FindInstanceMethods[NCMethod] then
            if typeof(ReturnedData) ~= "Instance" then return ReturnedData end
            
            if table.find(ProtectedInstances, ReturnedData) then
                return nil
            end
        end
    elseif _checkcaller() then
        local self, Args = ...
        local Method = _getnamecallmethod()

        if NameCallMethods[Method] then
            if typeof(self) ~= "Instance" then return NewIndex(...) end

            if table.find(ProtectedInstances, self) and not PropertyChangedData[self] then
                local Parent = self.Parent
                local disabled = {}

                if tostring(Parent) ~= "nil" then
                    for _, ConnectionType in next, EventMethods do
                        table.insert(disabled, disablesignal(Parent[ConnectionType]))
                    end
                end
                table.insert(disabled, disablesignal(game.ItemChanged))
                table.insert(disabled, disablesignal(game.itemChanged))

                for _, ParentObject in next, GetParents(self) do
                    if tostring(ParentObject) ~= "nil" then
                        for _, ConnectionType in next, EventMethods do
                            table.insert(disabled, disablesignal(ParentObject[ConnectionType]))
                        end
                    end
                end

                PropertyChangedData[self] = true
                self[Method](self)
                PropertyChangedData[self] = false

                for _, signal in next, disabled do
                    enablesignal(signal)
                end
                table.clear(disabled)
            end
        end
    end
    return NameCall(...)
end)
NewIndex = HookMetaMethod(game , "__newindex", function(...)
    if _checkcaller() then
        local self, Property, Value, UselessArgs = ...
        
        if typeof(self) ~= "Instance" then return NewIndex(...) end

        if table.find(ProtectedInstances, self) and not PropertyChangedData[self] then
            if rawequal(Property, "Parent") then
                local NewParent = Value
                local OldParent = self.Parent
                local disabled = {}

                for _, ConnectionType in next, EventMethods do
                    if NewParent and NewParent.Parent ~= nil then
                        table.insert(disabled, disablesignal(NewParent[ConnectionType]))
                    end
                    if OldParent and OldParent ~= nil then
                        table.insert(disabled, disablesignal(OldParent[ConnectionType]))
                    end
                end

                for _, ParentObject in next, GetParents(self) do
                    if ParentObject and ParentObject.Parent ~= nil then
                        for _, ConnectionType in next, EventMethods do
                            table.insert(disabled, disablesignal(ParentObject[ConnectionType]))
                        end
                    end
                end

                for _, ParentObject in next, GetParents(NewParent) do
                    if ParentObject and ParentObject.Parent ~= nil then
                        for _, ConnectionType in next, EventMethods do
                            table.insert(disabled, disablesignal(ParentObject[ConnectionType]))
                        end
                    end
                end

                table.insert(disabled, disablesignal(game.ItemChanged))
                table.insert(disabled, disablesignal(game.itemChanged))

                PropertyChangedData[self] = true
                self.Parent = NewParent
                PropertyChangedData[self] = false

                for _, signal in next, disabled do
                    enablesignal(signal)
                end
                table.clear(disabled)
            end
        end
    end
    return NewIndex(...)
end)

getgenv().protect_instance = function(NewInstance)
    table.insert(ProtectedInstances, NewInstance)
end
getgenv().unprotect_instance = function(NewInstance)
    local found = table.find(ProtectedInstances, NewInstance)
    if found then
        table.remove(ProtectedInstances, found)
    end
end