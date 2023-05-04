cmp_ok, cmp = pcall(require, 'cmp')
if not cmp_ok then
    return {}
end

luasnip_ok, luasnip = pcall(require, 'luasnip')
if not luasnip_ok, luasnip then
    return {}
end

cmp.setup({

})
