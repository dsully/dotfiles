vim.api.nvim_create_autocmd("BufWritePost", {
    callback = function(args)
        -- ignore files starting with `.`
        if vim.fn.fnamemodify(args.file, ":."):match("^%.") then
            return
        end

        local target = vim.system({ "chezmoi", "target-path", args.file }, { text = true }):wait()

        vim.system({ "chezmoi", "apply", "--force", vim.trim(target.stdout) }):wait()
    end,
})
