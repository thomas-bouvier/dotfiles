local status, tree = pcall(require, 'nvim-tree')
if (not status) then return end

tree.setup {
    sort_by = "case_sensitive",
    open_on_setup = true,
    open_on_setup_file = true,
    view = {
        adaptive_size = true,
        mappings = {
            list = {
                { key = "u", action = "dir_up" },
            },
        },
    },
    renderer = {
        group_empty = true,
    },
    filters = {
        dotfiles = true,
    },
}
