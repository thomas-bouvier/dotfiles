local status, gitsigns = pcall(require, 'gitsigns')
if (not status) then return end

gitsigns.setup {
    on_attach = function(bufnr)
        local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
        end

        -- Actions
        map({'n', 'v'}, 'gs', ':Gitsigns stage_hunk<CR>')
        map({'n', 'v'}, 'gr', ':Gitsigns reset_hunk<CR>')
        map('n', 'gS', gitsigns.stage_buffer)
        map('n', 'gu', gitsigns.undo_stage_hunk)
        map('n', 'gR', gitsigns.reset_buffer)
        map('n', 'gp', gitsigns.preview_hunk)
        map('n', 'gb', function() gitsigns.blame_line{full=true} end)
        map('n', 'gB', gitsigns.toggle_current_line_blame)
        map('n', 'gd', gitsigns.diffthis)
        map('n', 'gD', function() gitsigns.diffthis('~') end)
    end
}
