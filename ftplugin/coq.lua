-- Block comments, so built-in `gc` commenting and comment formatting work.
vim.bo.commentstring = "(* %s *)"
vim.bo.comments = "srn:(*,mb:*,ex:*)"

-- Coq identifiers routinely carry primes (e.g. `foo'`); keep them one word
-- for `w`/`*`/completion.
vim.opt_local.iskeyword:append("'")

-- `gf` / `:find` resolve bare module names to .v files.
vim.opt_local.suffixesadd:append(".v")
