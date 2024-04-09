describe("keyoverloader", function()
	local keyoverloader = require("keyoverloader")

	it("sets two global keymaps and executes them in order", function()
		local events = {}
		keyoverloader.set("n", "foo", function()
			table.insert(events, "a")
		end, { priority = 0 })
		keyoverloader.set("n", "foo", function()
			table.insert(events, "b")
		end, { priority = 1 })

		vim.api.nvim_feedkeys("foo", "x", false)

		assert.are.same({ "b", "a" }, events)
	end)
end)
