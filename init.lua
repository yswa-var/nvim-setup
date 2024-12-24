-- Lazy.nvim setup (plugin manager)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Enable line numbers and relative line numbers
vim.opt.number = true         -- Absolute line numbers
vim.opt.relativenumber = true -- Relative line numbers

-- Plugin Setup
require("lazy").setup({
    -- LeetCode plugin (preserved from original config)
    {
        "kawre/leetcode.nvim",
        dependencies = {
            "nvim-telescope/telescope.nvim",
            "MunifTanjim/nui.nvim",
        },
        config = function()
            require("leetcode").setup({
                language = "python3", -- Default language for solutions
                url = "leetcode.com", -- Change to "leetcode-cn.com" for China
                username = "yswa.var@gmail.com",
                password = "9stfF9qZjvayKo",
            })
        end,
    },
    -- Telescope for better UI (preserved)
    { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
    -- NumberToggle (preserved)
    {
        "sitiom/nvim-numbertoggle",
        config = function()
            -- No configuration required; it works out of the box
        end,
    },

    -- Additional Python development plugins
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        },
    },
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "rafamadriz/friendly-snippets",
        },
    },
    {
        "jose-elias-alvarez/null-ls.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
    },
})

-- Treesitter Configuration (preserved and enhanced)
require("nvim-treesitter.configs").setup({
    ensure_installed = { "python" },
    highlight = {
        enable = true,
    },
    indent = { enable = true },
})

-- LSP Setup
require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = { "pyright" }
})

-- Completion Setup
local cmp = require("cmp")
cmp.setup({
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
    }),
    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
    }),
})

-- Null-ls for formatting
local null_ls = require("null-ls")
null_ls.setup({
    sources = {
        null_ls.builtins.formatting.black, -- Python formatter
        null_ls.builtins.formatting.isort, -- Python import sorter
        null_ls.builtins.diagnostics.flake8, -- Python linter
    },
})

-- Format on save
vim.cmd [[autocmd BufWritePre *.py lua vim.lsp.buf.format()]]

-- Python LSP configuration
require("lspconfig").pyright.setup({
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
    settings = {
        python = {
            analysis = {
                typeCheckingMode = "basic",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
            },
        },
    },
})

-- Key mappings for Python development
vim.keymap.set("n", "<leader>df", ":lua vim.lsp.buf.format()<CR>")
vim.keymap.set("n", "<leader>ca", ":lua vim.lsp.buf.code_action()<CR>")
vim.keymap.set("n", "<leader>rn", ":lua vim.lsp.buf.rename()<CR>")
vim.keymap.set("n", "gd", ":lua vim.lsp.buf.definition()<CR>")
vim.keymap.set("n", "K", ":lua vim.lsp.buf.hover()<CR>")
