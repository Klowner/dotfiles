return {
  'tpope/vim-commentary',
  keys = {
    { '<leader>c', '<Plug>Commentary', mode = {'n','o','x'}, desc = "Toggle commented"},
    { '<leader>cc', '<Plug>CommentaryLine', mode = 'n', desc = "Toggle commented"},
  },
}
