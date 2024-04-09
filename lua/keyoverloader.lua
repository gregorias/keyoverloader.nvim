local M = {}

local global_keymaps = {}

---@class KeyOverloaderOptions
---@field buffer? boolean|number
---@field priority? integer (default=0) The priority of the keymap. Keymaps are executed in the order of descending
---                         priority.

--- Set an overloaded keymap.
--
---@param mode string|string[]
---@param lhs string
---@param callback function():boolean?
---@param opts KeyOverloaderOptions
M.set = function(mode, lhs, callback, opts)
	if type(mode) == "table" then
		-- Return an error that this is not supported yet.
		error("Setting keymaps for multiple modes is not supported yet.", 2)
	end

	if opts.buffer ~= nil then
		error("Buffer keymaps are not supported yet.", 2)
	end

	if global_keymaps[lhs] == nil then
		global_keymaps[lhs] = {}
		vim.keymap.set(mode, lhs, function()
			for _, km in ipairs(global_keymaps[lhs]) do
				if km.cb() then
					break
				end
			end
		end, { noremap = true })
	end

	table.insert(global_keymaps[lhs], { cb = callback, priority = opts.priority or 0 })
	table.sort(global_keymaps[lhs], function(a, b)
		return a.priority > b.priority
	end)
end

return M
