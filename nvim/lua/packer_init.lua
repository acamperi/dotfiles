local ensure_packer = function()
    local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
        vim.fn.system({
            'git',
            'clone',
            '--depth',
            '1',
            'https://github.com/wbthomason/packer.nvim',
            install_path,
        })
        vim.cmd.packadd('packer.nvim')
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'

    use 'FooSoft/vim-argwrap'
    use 'airblade/vim-gitgutter'
    use 'dag/vim-fish'
    use { 'fatih/vim-go', run = ':GoUpdateBinaries' }
    use 'hashivim/vim-terraform'
    use 'jiangmiao/auto-pairs'
    use '/usr/local/opt/fzf'
    use 'junegunn/fzf.vim'
    use 'neovim/nvim-lspconfig'
    use {
        'nvim-tree/nvim-tree.lua',
        requires = {
            'nvim-tree/nvim-web-devicons',
        },
    }
    use 'rust-lang/rust.vim'
    use 'ryanoasis/vim-devicons'
    use 'srcery-colors/srcery-vim'
    use 'tpope/vim-commentary'
    use 'tpope/vim-fugitive'
    use 'tpope/vim-repeat'
    use 'tpope/vim-surround'
    use 'uarun/vim-protobuf'
    use 'vim-airline/vim-airline'
    use 'vim-airline/vim-airline-themes'

    if packer_bootstrap then
        require('packer').sync()
    end
end)
