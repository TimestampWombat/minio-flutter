-- print(vim.api.nvim_eval("1 + 1"))
-- print(vim.inspect(vim.api.nvim_eval("[1, 2, 3]")))
-- print(vim.inspect(vim.api.nvim_eval("{'a': 1, 'b': 2}")))
-- print(vim.api.nvim_eval("v:true"))
-- print(vim.api.nvim_eval("v:null"))
--
-- local result = vim.api.nvim_exec(
-- 	[[
--   let s:mytext = 'hello world'
--   function! s:MyFunction(text)
--     echo a:text
--   endfunction
--
--   call s:MyFunction(s:mytext)
-- ]],
-- 	true
-- )
--
-- print(result)
--
-- -- vim.api.nvim_command("echo 'hello world'")
-- -- vim.api.nvim_command("new")
-- -- vim.api.nvim_command("wincmd H")
-- -- vim.api.nvim_command("set nonumber")
-- --
-- -- foo1
-- -- foo2
-- -- foo3
--
-- -- local result2 = vim.api.nvim_exec("buffers", true)
-- -- print(result2)
--
-- -- local result3 = vim.api.nvim_command("buffers")
-- -- print(result3)
--
-- local result4 = vim.cmd("buffers")
-- print(result3)
--

-- local function t(str)
-- 	return vim.api.nvim_replace_termcodes(str, true, true, true)
-- end
--
-- print(t("<Tab>what are you doing?"))
-- print("22what are you doing?")

-- function _G.smart_tab()
-- 	return vim.fn.pumvisible() == 1 and t("<C-N>") or t("<Tab>")
-- end
--
-- vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.smart_tab()", { expr = true, noremap = true })

-- print(vim.fn.printf("Hello from %s", "Wombat"))
--
-- local reversed_list = vim.fn.reverse({ "a", "b", "c" })
-- print(vim.inspect(reversed_list))
--
-- local function print_stdout(chan_id, data, name)
-- 	print(data[1])
-- end
--
-- vim.fn.jobstart("ls", { on_stdout = print_stdout })

-- vim.api.nvim_open_win(0, true, { relative = "win", row = 0, col = 0, width = 26, height = 20 })
vim.api.nvim_open_win(0, true, { relative = "cursor", width = 26, height = 20, bufpos = { 0, 0 } })
