local status, telescope = pcall(require, 'telescope')
if (not status) then return end
local actions = require('telescope.actions')

local function telescope_buffer_dir()
	return vim.fn.expand('%:p:h')
end

local fb_actions = require 'telescope'.extensions.file_browser.actions

telescope.setup {
	defaults = {
		mappings = {
			n = {
				['q'] = actions.close
			}
		}
	},
	extensions = {
		file_browser = {
			theme = 'ivy',
			hijack_netrw = true,
			mappings = {
				['n'] = {
					['N'] = fb_actions.create,
					['h'] = fb_actions.goto_parent_dir,
					['/'] = function()
						vim.cmd('startinsert')
					end
				}
			}
		}
	}
}

telescope.load_extension('file_browser')

local opts = { noremap = true, silent = true }
vim.keymap.set('n', ';f', '<cmd>lua require("telescope.builtin").find_files({ no_ignore = false, hidden = true })<cr>', opts)
