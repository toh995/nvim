-- gitconfig accepts both `#` and `;` for comments; nvim's runtime ftplugin
-- defaults to `; %s`. Override to `#` as a matter of preference.
-- Must live in after/ftplugin to win over the runtime one.
vim.bo.commentstring = "# %s"
