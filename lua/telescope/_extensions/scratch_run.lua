local finders = require('telescope.finders')
local pickers = require('telescope.pickers')
local entry_display = require('telescope.pickers.entry_display')
local conf = require('telescope.config').values

local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

local function make_repl()
    local repl = {
        pyton = {
            name = "python",
            cmd = ":w !python"
        },
        node = {
            name = "node",
            cmd = ":w !node"
        },
        java = {
            name = "java",
            cmd = ":w !javac"
        },
        golang = {
            name = "golang",
            cmd = ":w !go run"
        },
        rustlang = {
            name = "rustlang",
            cmd = ":w !rustc "
        },
    }

    local languagesPicker = {}
    local count = 0

    for _,val in pairs(repl) do
        count = count + 1
        table.insert(languagesPicker, {
            lang = val.name,
            cmd = val.cmd,
        })
    end

    return languagesPicker
end

local function make_entry()
    local displayer = entry_display.create {
        separator = "",
        items = {
            { width = 15 },
            { remaining = true }
        }
    }

    local make_display = function(entry)
        return displayer {
            entry.lang,
            entry.cmd,
        }
    end

    return function(entry)
        return {
            -- valid = true,
            value = entry,
            ordinal = entry.cmd,
            display = make_display,
            lang = entry.lang,
            -- col = 1,
            cmd = entry.cmd,
        }
    end
end

local make_finder = function()
    return finders.new_table {
        results = make_repl(),
        entry_maker = make_entry(),
    }
end

local function make_picker()
    pickers.new({}, {
        prompt_title = "REPL Language",
        finder = make_finder(),
        sorter = conf.generic_sorter({}),
        attach_mappings = function(prompt_bufnr)
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                vim.cmd(action_state.get_selected_entry().cmd)
            end)
            return true
        end,
    }):find()
end

return require('telescope').register_extension {
    exports = {
        scratch_run = make_picker,
    }
}
