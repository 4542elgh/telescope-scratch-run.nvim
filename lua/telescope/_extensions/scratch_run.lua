-- Check telescope is installed
local ok, telescope = pcall(require, 'telescope')

if not ok then
    error 'Install nvim-telescope/telescope.nvim to use 4542elgh/telescope-scratch-run.nvim.'
end

-- Telescope utils
local finders = require('telescope.finders')
local pickers = require('telescope.pickers')
local entry_display = require('telescope.pickers.entry_display')
local conf = require('telescope.config').values

local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

-- Predefined list
local compilers = {
    python = { name = "python", cmd = ":w !python" },
    node = { name = "node", cmd = ":w !node" },
    java = { name = "java", cmd = ":w !javac" },
    golang = { name = "golang", cmd = ":w !go run" },
    rustlang = { name = "rustlang", cmd = ":w !rustc " },
}

-- Make format better
local function make_compiler()
    local languagesPicker = {}
    for _, val in pairs(compilers) do
        table.insert(languagesPicker, {
            lang = val.name,
            cmd = val.cmd,
        })
    end
    return languagesPicker
end

-- This is what will be showing in Telescope
local function make_entry()
 
    -- Spacing
    local displayer = entry_display.create {
        separator = "",
        items = {
            { width = 15 },
            { remaining = true }
        }
    }

    -- What content is displaying
    local make_display = function(entry)
        return displayer {
            entry.lang,
            entry.cmd,
        }
    end

    -- Internal sorting
    return function(entry)
        return {
            value = entry,
            ordinal = entry.cmd,
            display = make_display,
            lang = entry.lang,
            cmd = entry.cmd,
        }
    end
end

-- Finder will fill picker with items
local make_finder = function()
    return finders.new_table {
        results = make_compiler(),
        entry_maker = make_entry(),
    }
end

-- Displaying module, putting everything together
local function make_picker()
    pickers.new({}, {
        prompt_title = "Complier Language",
        finder = make_finder(),
        sorter = conf.generic_sorter({}),

        -- What to do with selected item
        attach_mappings = function(prompt_bufnr)
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                vim.cmd(action_state.get_selected_entry().cmd)
            end)
            return true
        end,
    }):find()
end

return require("telescope").register_extension {
    setup = function(user_opts, _)
        if next(user_opts) ~= nil then
            compilers = vim.tbl_extend('force', compilers, user_opts.custom_compilers)
        end
    end,
    exports = {
        scratch_run = make_picker,
        all = make_picker
    }
}
