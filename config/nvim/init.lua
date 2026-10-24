-- SECTION 1: Options
vim.o.breakindent = true
vim.o.confirm = true
vim.o.expandtab = true
vim.o.mouse = 'a'
vim.o.number = true
vim.o.relativenumber = true
vim.o.shiftwidth = 2
vim.o.showmode = false -- Already in statusline
vim.o.undofile = true

vim.api.nvim_create_autocmd({ 'TextYankPost' }, { callback = function() vim.hl.on_yank { higroup = 'Visual' } end })

-- SECTION 2: Keymaps
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

for c, desc in pairs({ h = 'left', j = 'down', k = 'up', l = 'right' }) do
  vim.keymap.set('n', '<C-' .. c .. '>', '<C-w>' .. c, { desc = 'Go to the ' .. desc .. 'window' })
  vim.keymap.set('n', '<C-S-' .. c .. '>', '<C-w>' .. string.upper(c), { desc = 'Move window to the far ' .. desc })
end

vim.keymap.set({ 'n', 'v' }, '<leader>la', vim.lsp.buf.code_action, { desc = "Code action" })
vim.keymap.set('n', '<leader>ld', vim.diagnostic.open_float, { desc = "Display diagnostics" })
vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format, { desc = "Format buffer" })
vim.keymap.set('n', '<leader>li', vim.lsp.buf.implementation, { desc = "Show implementation" })
vim.keymap.set('n', '<leader>ln', vim.lsp.buf.rename, { desc = "Rename symbol" })


require('mini.pick').setup()
vim.keymap.set('n', '<leader>fb', '<cmd>Pick buffers<CR>', { desc = 'Buffers' })
vim.keymap.set('n', '<leader>ff', '<cmd>Pick files<CR>', { desc = 'Files' })
vim.keymap.set('n', '<leader>fg', '<cmd>Pick grep_live<CR>', { desc = 'Grep live' })
vim.keymap.set('n', '<leader>fh', '<cmd>Pick help<CR>', { desc = 'Help tags' })


-- SECTION 3: Plugins
local lz = require('lz.n')


require('kanagawa').setup({
  transparent = true,
})
vim.cmd.colorscheme('kanagawa')


require('mini.icons').setup()
MiniIcons.mock_nvim_web_devicons()


require('mini.pairs').setup()


require('lualine').setup {}


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
  'which-key-nvim',
  after = function()
    require('which-key').add({
      { '<leader>f', group = 'Find' },
      { '<leader>h', group = 'Hunk' },
      { '<leader>l', group = 'LSP' },
    })
  end,
  cmd = "WhichKey",
  event = "DeferredUIEnter"
})



-- SECTION 4: LSP Config

vim.diagnostic.config {
  virtual_text = true
}

vim.lsp.config('nixd', {
  settings = {
    nixd = {
      formatting = { command = { "nixfmt" } },
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
