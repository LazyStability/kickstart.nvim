require('which-key').setup()

-- Document existing key chains
require('which-key').add {
  { '<leader>c', group = '[C]ode' },
  { '<leader>c_', hidden = true },
  { '<leader>d', group = '[D]ocument' },
  { '<leader>d_', hidden = true },
  { '<leader>h', group = 'git [h]ub' },
  { '<leader>h_', hidden = true },
  { '<leader>ht', group = '[t]oggle diff/blame line' },
  { '<leader>ht_', hidden = true },
  { '<leader>r', group = '[R]ename' },
  { '<leader>r_', hidden = true },
  { '<leader>s', group = '[S]earch' },
  { '<leader>s_', hidden = true },
  { '<leader>t', group = 'vim[t]ex' },
  { '<leader>t_', hidden = true },
  { '<leader>w', group = '[W]orkspace' },
  { '<leader>w_', hidden = true },
}
