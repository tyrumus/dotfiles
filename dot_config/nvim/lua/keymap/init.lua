local vimmap = vim.api.nvim_set_keymap

local function map(bind, cmd, mode)
    local mode = mode or "n"
    vimmap("n", bind, cmd, {noremap = true})
end

-- keep my sanity
map(";", ":")
map("<C-s>", "<cmd>w<CR>")

-- move lines up/down
map("<A-k>", "ddkP")
map("<A-j>", "ddp")

-- move characters left/right
map("<A-h>", "xhP")
map("<A-l>", "xp")

-- disable arrow keys
map("<Up>", "<Nop>", "i")
map("<Down>", "<Nop>", "i")
map("<Left>", "<Nop>", "i")
map("<Right>", "<Nop>", "i")

-- allow easier navigation on lines that are broken
map("j", "gj")
map("k", "gk")

-- clear search highlights
map("<C-c>", "<cmd>nohlsearch<CR>")

-- close the quickfix window
map("<leader>q", "<cmd>cclose<CR>")

-- source $MYVIMRC
map("<leader>sv", "<cmd>source $MYVIMRC<CR>")

-- window navigation
map("<C-J>", "<C-W><C-J>")
map("<C-K>", "<C-W><C-K>")
map("<C-L>", "<C-W><C-L>")
map("<C-H>", "<C-W><C-H>")
map("<C-Q>", "<C-W><C-Q>")
map("<C-W>t", "<cmd>tabnew<CR>")
map("<C-W><C-t>", "<cmd>tabnew<CR>")

-- Shift+L clears screen since Ctrl+L was remapped
map("L", "<cmd>mode<CR>")

-- tab navigation
map("<Tab>", "gt")
map("<S-Tab>", "gT")
