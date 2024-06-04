require('which-key').setup()

-- Document existing key chains
require('which-key').register {
  ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
  ['<leader>d'] = { name = '[D]ocument', _ = 'which_key_ignore' },
  ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
  ['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
  ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
  ['<leader>t'] = { name = 'vim[t]ex', _ = 'which_key_ignore' },
  ['<leader>ht'] = { name = '[t]oggle diff/blame line', _ = 'which_key_ignore' },
  ['<leader>h'] = { name = 'git [h]ub', _ = 'which_key_ignore' },
}
