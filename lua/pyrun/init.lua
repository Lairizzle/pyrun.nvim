local M = {}

function M.run()
	vim.ui.input({ prompt = "Enter the name of your Python file (e.g., main.py): " }, function(input)
		if input == nil or input == "" then
			print("No file name provided.")
			return
		end

		-- Create floating window
		local buf = vim.api.nvim_create_buf(false, true)
		local width = math.floor(vim.o.columns * 0.8)
		local height = math.floor(vim.o.lines * 0.8)
		local row = math.floor((vim.o.lines - height) / 2)
		local col = math.floor((vim.o.columns - width) / 2)

		vim.api.nvim_open_win(buf, true, {
			relative = "editor",
			width = width,
			height = height,
			row = row,
			col = col,
			style = "minimal",
			border = "rounded",
			title = " Pyrun Output ",
			title_pos = "center",
		})

		-- Run the script in a terminal (supports input())
		vim.fn.termopen({ "python", input })
		vim.cmd("startinsert")
	end)
end

return M
