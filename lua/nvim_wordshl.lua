local hlist = {}
local group_idx = 0
local group_num = 3
local word_idx = 0
local priority = 10

vim.cmd([[
    highlight whlgroup0 ctermbg=DarkRed guibg=DarkRed
    highlight whlgroup1 ctermbg=DarkMagenta guibg=DarkMagenta
    highlight whlgroup2 ctermbg=DarkBlue guibg=DarkBlue
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

local function whlToggle(word)
    local new_word = nil
    local cur_mode = vim.fn.mode()

    if word ~= nil then
        new_word = word
    elseif cur_mode == 'n' then
        -- new_word = "\b" .. vim.fn.expand("<cword>") .. "\b"
        new_word = vim.fn.expand("<cword>")
    elseif cur_mode == 'v' then
        print("visual mode is not support yet")
    else
        print("not supported mode: " .. cur_mode)
    end

    if hlist[new_word] == nil then
        hlist[new_word] = word_idx
        word_idx = word_idx + 1
    else
        hlist[new_word] = nil
    end

    whlUpdate()
end

local function whlDelete(idx)
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

local function keyRegister()
    require("which-key").register({
        ["<leader>h"] = {
            mode = { "n", "v" },
            name = "+highlight",
            t = { function() whlToggle() end, "toggle highlight" },
            d = { function() whlClear() end, "clear all highlight" },
            S = { function() whlShow() end, "show all highlight" },
        },
    })
end

-- vim.defer_fn(keyRegister, 5000)

vim.api.nvim_create_user_command("WHLToggle", function() whlToggle() end, {})
vim.api.nvim_create_user_command("WHLDelete", function() whlDelete() end, {})
vim.api.nvim_create_user_command("WHLClear", function() whlClear() end, {})
vim.api.nvim_create_user_command("WHLShow", function() whlShow() end, {})
