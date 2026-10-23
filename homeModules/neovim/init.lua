vim.opt.expandtab = true
vim.opt.number = true
vim.opt.shiftwidth = 2

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

for _, c in ipairs({ 'h', 'j', 'k', 'l' }) do
  vim.keymap.set('n', '<C-' .. c .. '>', '<cmd>wincmd ' .. c .. '<CR>')
end


local lz = require('lz.n')


require('kanagawa').setup({
  transparent = true,
})
vim.cmd.colorscheme('kanagawa')


require 'mini.icons'.setup()
require('mini.icons').mock_nvim_web_devicons()


require('lualine').setup()


lz.load({
  'blink-cmp',
  after = function()
    require('blink.cmp').setup({
      keymap = { preset = 'super-tab' }
    })
  end,
  event = { 'InsertEnter', 'CmdlineEnter' }
})


lz.load({
  'gitsigns-nvim',
  after = function()
    require('gitsigns').setup()
  end,
  cmd = 'Gitsigns',
  event = { 'BufReadPost', 'BufNewFile' },
  keys = {
    {
      ']c',
      function()
        if vim.wo.diff then
          vim.cmd.normal({ ']c', bang = true })
        else
          require('gitsigns').nav_hunk('next')
        end
      end,
      desc = 'Next hunk'
    },
    {
      '[c',
      function()
        if vim.wo.diff then
          vim.cmd.normal({ ']c', bang = true })
        else
          require('gitsigns').nav_hunk('prev')
        end
      end,
      desc = 'Previous hunk'
    },
    { '<leader>hs', function() require('gitsigns').stage_hunk() end, desc = 'Stage hunk' },
    { '<leader>hr', function() require('gitsigns').reset_hunk() end, desc = 'Reset hunk' },
    {
      '<leader>hs',
      function() require('gitsigns').stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end,
      mode = 'v',
      desc = 'Stage hunk'
    },
    {
      '<leader>hr',
      function() require('gitsigns').reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end,
      mode = 'v',
      desc = 'Reset hunk'
    },
    { '<leader>hS', function() require('gitsigns').stage_buffer() end,             desc = 'Stage buffer' },
    { '<leader>hR', function() require('gitsigns').reset_buffer() end,             desc = 'Reset buffer' },
    { '<leader>hp', function() require('gitsigns').preview_hunk() end,             desc = 'Preview hunk' },
    { '<leader>hi', function() require('gitsigns').preview_hunk_inline() end,      desc = 'Preview hunk inline' },
    { '<leader>hb', function() require('gitsigns').blame_line { full = true } end, desc = 'Blame line' },
    { '<leader>hd', function() require('gitsigns').diffthis() end,                 desc = 'Diff this' },
  }
})


lz.load({
  'telescope',
  after = function() require('telescope').setup() end,
  cmd = 'Telescope',
  keys = {
    { '<leader>ff', '<cmd>Telescope find_files', desc = 'Telescope find files' },
    { '<leader>fg', '<cmd>Telescope live_grep',  desc = 'Telescope live grep' },
    { '<leader>fb', '<cmd>Telescope buffers',    desc = 'Telescope buffers' },
  }
})


lz.load({
  'which-key-nvim',
  after = function() require('which-key').setup() end,
  cmd = "WhichKey",
  event = "DeferredUIEnter"
})


vim.lsp.config('nixd', {
  settings = {
    nixd = {
      formatting = { command = { "alejandra" } },
      options = {
        nixos = {
          expr = "(builtins.getFlake (builtins.toString ./.)).nixosConfigurations.augustROG.options"
        },
        home_manager = {
          expr =
          "(builtins.getFlake (builtins.toString ./.)).nixosConfigurations.augustROG.options.home-manager.users.type.getSubOptions []"
        }
      }
    }
  }
})
vim.lsp.enable('nixd')

vim.lsp.enable('lua_ls')
