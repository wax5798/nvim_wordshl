local hlist = {}
local group_idx = 0
local group_num = 8
local word_idx = 0
local priority = 10

vim.cmd([[
    highlight whlgroup0 guibg=#a4a55b
    highlight whlgroup1 guibg=#4da538
    highlight whlgroup2 guibg=#7b12b2
    highlight whlgroup3 guibg=#12b28b
    highlight whlgroup4 guibg=#129bb2
    highlight whlgroup5 guibg=#b32aba
    highlight whlgroup6 guibg=#1266b2
    highlight whlgroup7 guibg=#8e0e5e
]])

local function whlUpdate()
    local win_list = vim.api.nvim_list_wins()

    for i = 1, #win_list do
        vim.fn.clearmatches(win_list[i])

        for key in pairs(hlist) do
            -- vim.fn.matchadd("whlgroup" .. hlist[key] % group_num, key, {window = win_list[i]})
            vim.fn.matchadd("whlgroup" .. hlist[key] % group_num, key, priority, -1, {window = win_list[i]})
        end
    end
end

local function whlToggle(param)
    local new_word = nil

    if param["args"] ~= "" then
        new_word = param["args"]
    else
        new_word = "\\<" .. vim.fn.expand("<cword>") .. "\\>"
    end

    if hlist[new_word] == nil then
        hlist[new_word] = word_idx
        word_idx = word_idx + 1
    else
        hlist[new_word] = nil
    end

    whlUpdate()
end

local function whlDelete(param)
    local idx = tonumber(param["args"])

    for key in pairs(hlist) do
        if hlist[key] == idx then
            hlist[key] = nil
            whlUpdate()
            return
        end
    end
end

local function whlClear(idx)
    hlist = {}
    whlUpdate()
end

local function whlShow()
    for key in pairs(hlist) do
        print("[" .. hlist[key] .. "]" .. key)
    end
end

vim.api.nvim_command("autocmd WinNew * :WHLUpdate")

vim.api.nvim_create_user_command("WHLToggle", function(param) whlToggle(param) end, { nargs = "*" })
vim.api.nvim_create_user_command("WHLDelete", function(param) whlDelete(param) end, { nargs = 1 })
vim.api.nvim_create_user_command("WHLUpdate", function() whlUpdate() end, {})
vim.api.nvim_create_user_command("WHLClear", function() whlClear() end, {})
vim.api.nvim_create_user_command("WHLShow", function() whlShow() end, {})
