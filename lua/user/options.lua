local default_options = {
  backup = false, -- creates a backup file
  clipboard = "", -- allows neovim to access the system clipboard
  cmdheight = 1, -- more space in the neovim command line for displaying messages
  completeopt = { "menuone", "noselect" },
  conceallevel = 0, -- so that `` is visible in markdown files
  fileencoding = "utf-8", -- the encoding written to a file
  foldmethod = "manual", -- folding, set to "expr" for treesitter based folding
  foldexpr = "", -- set to "nvim_treesitter#foldexpr()" for treesitter based folding
  hidden = true, -- required to keep multiple buffers and open multiple buffers
  hlsearch = true, -- highlight all matches on previous search pattern
  ignorecase = true, -- ignore case in search patterns
  mouse = "", -- allow the mouse to be used in neovim
  pumheight = 10, -- pop up menu height
  showmode = false, -- we don't need to see things like -- INSERT -- anymore
  smartcase = true, -- smart case
  splitbelow = true, -- force all horizontal splits to go below current window
  splitright = true, -- force all vertical splits to go to the right of current window
  swapfile = false, -- creates a swapfile
  termguicolors = true, -- set term gui colors (most terminals support this)
  timeoutlen = 1000, -- time to wait for a mapped sequence to complete (in milliseconds)
  title = true, -- set the title of window to the value of the titlestring
  -- opt.titlestring = "%<%F%=%l/%L - nvim" -- what the title of the window will be set to
  undodir = undodir, -- set an undo directory
  undofile = true, -- enable persistent undo
  updatetime = 100, -- faster completion
  writebackup = false, -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
  expandtab = true, -- convert tabs to spaces
  shiftwidth = 2, -- the number of spaces inserted for each indentation
  tabstop = 2, -- insert 2 spaces for a tab
  cursorline = true, -- highlight the current line
  number = true, -- set numbered lines
  relativenumber = true,
  numberwidth = 4, -- set number column width to 2 {default 4}
  signcolumn = "yes", -- always show the sign column, otherwise it would shift the text each time
  wrap = false, -- display lines as one long line
  scrolloff = 4, -- minimal number of screen lines to keep above and below the cursor.
  sidescrolloff = 8, -- minimal number of screen lines to keep left and right of the cursor.
  showcmd = false,
  ruler = false,
  laststatus = 3,
  list = true,
  listchars = {
    tab = '▷⋅',
    trail = '·',
  },
}

---  SETTINGS  ---
vim.opt.spelllang:append "cjk" -- disable spellchecking for asian characters (VIM algorithm does not support it)
vim.opt.shortmess:append "c" -- don't show redundant messages from ins-completion-menu
vim.opt.shortmess:append "I" -- don't show the default intro message
vim.opt.whichwrap:append "<,>,[,],h,l"

for k, v in pairs(default_options) do
  vim.opt[k] = v
end

-- Table to store the saved views for each buffer
local saved_views = {}
-- Function to save the current view of the current buffer
local function save_view()
  saved_views[vim.api.nvim_get_current_buf()] = vim.fn.winsaveview()
end
-- Function to restore the view of the buffer when switching back to it
local function restore_view()
  local bufnr = vim.api.nvim_get_current_buf()
  if saved_views[bufnr] then
    vim.fn.winrestview(saved_views[bufnr])
  end
end
vim.api.nvim_create_autocmd('BufWinEnter', {
  pattern = '*',
  callback = function ()
    restore_view()
  end
})
vim.api.nvim_create_autocmd('BufLeave', {
  pattern = '*',
  callback = function ()
    save_view()
  end
})

