local M = {}

function M.run()
	vim.ui.input({ prompt = "Enter the name of your Python file (e.g., Main.py): " }, function(input)
		if input == nil or input == "" then
			print("No file name provided.")
			return
		end

		local class_name = input:gsub("%.java$", "")
		local compile_cmd = "python " .. input
		local run_cmd = "python " .. class_name

		local compile_output = {}

		vim.fn.jobstart(compile_cmd, {
			stdout_buffered = true,
			stderr_buffered = true,

			on_stdout = function(_, data)
				if data then
					for _, line in ipairs(data) do
						if line ~= "" then
							table.insert(compile_output, line)
						end
					end
				end
			end,

			on_stderr = function(_, data)
				if data then
					for _, line in ipairs(data) do
						if line ~= "" then
							table.insert(compile_output, line)
						end
					end
				end
			end,

			on_exit = function(_, code)
				if code == 0 then
					-- Compilation succeeded → run in floating terminal
					local buf = vim.api.nvim_create_buf(false, true)
					local width = math.floor(vim.o.columns * 0.8)
					local height = math.floor(vim.o.lines * 0.8)
					local row = math.floor((vim.o.lines - height) / 2)
					local col = math.floor((vim.o.columns - width) / 2)

					local win = vim.api.nvim_open_win(buf, true, {
						relative = "editor",
						width = width,
						height = height,
						row = row,
						col = col,
						style = "minimal",
						border = "rounded",
					})

					vim.fn.termopen(run_cmd)
					vim.cmd("startinsert")
				else
					-- Compilation failed → show errors in floating terminal
					local buf = vim.api.nvim_create_buf(false, true)
					local width = math.floor(vim.o.columns * 0.8)
					local height = math.floor(vim.o.lines * 0.6)
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
					})

					-- Write compilation errors to buffer
					vim.api.nvim_buf_set_lines(buf, 0, -1, false, compile_output)
				end
			end,
		})
	end)
end

return M
