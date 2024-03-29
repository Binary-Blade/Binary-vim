local M = {}
local set = vim.keymap.set
local opts = { noremap = true, silent = true }

-- TODO: TO REFACTORING LATER : REORGANIZE IT FOR SEPARATE CONCERNS

set('n', '<Esc>', '<cmd>nohlsearch<CR>')
set('t', '<leader>q', '<C-\\><C-n>', opts)

-- -- Debugger
-- set('n', '<leader>db', '<Cmd>DapToggleBreakPoint<CR>', { desc = '[D]ebugger Add [B]reakpoint' }, opts)
-- set('n', '<leader>dc', '<Cmd>DapContinue<CR>', { desc = '[D]ebugger Start or [C]ontinue' }, opts)

-- Quick keymaps
set('n', '<leader>ql', ':wqa<CR>', { desc = '[Q]uick [L]eft Neovim' }, opts)
set('n', '<leader>qp', 'vi)', { desc = '[Q]uick Inside [P]arentheses [(]' }, opts)
set('n', '<leader>qc', 'vi}', { desc = '[Q]uick Inside [C]urly [}]' }, opts)
set('n', '<leader>qb', 'vi]', { desc = '[Q]uick Inside [B]racket [[]' }, opts)
set('n', '<leader>qq', "vi'", { desc = "[Q]uick Inside [Q]uote[']" }, opts)

-- Diagnostic keymaps
set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
set('n', '<leader>ce', vim.diagnostic.open_float, { desc = 'Show [C]ode [E]error Diagnostic ' })
set('n', '<leader>cq', vim.diagnostic.setloclist, { desc = 'Open [C]ode [Q]uick Diagnostic list' })

-- TIP: Disable arrow keys in normal mode
set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Buffer key
set('n', '<S-Tab>', '<Cmd>BufferPrevious<CR>', opts)
set('n', '<Tab>', '<Cmd>BufferNext<CR>', opts)
set('n', '<A-1>', '<Cmd>BufferGoto 1<CR>', opts)
set('n', '<A-2>', '<Cmd>BufferGoto 2<CR>', opts)
set('n', '<A-3>', '<Cmd>BufferGoto 3<CR>', opts)
set('n', '<A-4>', '<Cmd>BufferGoto 4<CR>', opts)
set('n', '<leader>x', ':BufferClose<CR>', opts)
set('n', '<C-p>', '<Cmd>BufferPick<CR>', opts)

-- TodoComment
set('n', '<leader>ft', '<CMD>TodoTelescope keywords=TODO,FIX,WARNING<CR>', vim.tbl_extend('force', opts, { desc = '[F]ind Todo: TODO, FIX, WARNING' }))
set('n', '<leader>fn', '<CMD>TodoTelescope keywords=NOTE<CR>', vim.tbl_extend('force', opts, { desc = '[F]ind Todo: NOTE' }))
set('n', '<leader>fh', '<CMD>TodoTelescope keywords=HACK<CR>', vim.tbl_extend('force', opts, { desc = '[F]ind Todo: Hack' }))

-- TODO: Add command to use neotree for the buffer instead tab
-- Neotree
set('n', '<leader>e', '<CMD>Neotree toggle left<CR>', { desc = 'Open Neotre[E]' }, opts)

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Telescope keymap
function M.telescope_keymaps()
  -- See `:help telescope.builtin`
  local builtin = require 'telescope.builtin'

  -- Search
  set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
  set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
  set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
  set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
  set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
  set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })

  -- Find
  set('n', '<leader>fb', builtin.buffers, { desc = '[F]ind existing [B]uffers' })
  set('n', '<leader>fg', builtin.live_grep, { desc = '[F]ind by [G]rep' })
  set('n', '<leader>ff', builtin.find_files, { desc = '[F]find [F]iles' })
  set('n', '<leader>fr', builtin.oldfiles, { desc = '[F]ind Recent Files ("." for repeat)' })
  set('n', '<leader>fc', function()
    builtin.find_files { cwd = vim.fn.stdpath 'config' }
  end, { desc = '[F]ind [C]onfig files' })

  set('n', '<leader>/', function()
    builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
      winblend = 0,
      previewer = false,
    })
  end, { desc = '[/] Fuzzily search in current buffer' })

  --  See `:help telescope.builtin.live_grep()` for information about particular keys
  set('n', '<leader>so', function()
    builtin.live_grep {
      grep_open_files = true,
      prompt_title = 'Live Grep in Open Files',
    }
  end, { desc = '[S]earch in [O]pen Files' })
end

return M
