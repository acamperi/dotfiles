vim.filetype.add({
    extension = {
        tf = 'terraform',
        tftpl = 'terraform',
        zed = 'authzed',
    },
    pattern = {
        ['.*%.tf%.tpl'] = 'terraform',
    },
})
