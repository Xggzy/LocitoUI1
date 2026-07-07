-- LocitoUI Config System
-- Version 0.2.0
-- This is intentionally storage-agnostic. It does not use exploit-only filesystem APIs.

local Config = {}
Config.Store = {}

function Config:Save(Name, Data)
	self.Store[Name] = Data
	return true
end

function Config:Load(Name)
	return self.Store[Name]
end

function Config:Delete(Name)
	self.Store[Name] = nil
	return true
end

function Config:List()
	local Names = {}
	for Name in pairs(self.Store) do
		table.insert(Names, Name)
	end
	table.sort(Names)
	return Names
end

return Config
