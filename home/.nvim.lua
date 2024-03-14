vim.api.nvim_create_autocmd("BufWritePost", {
    callback = function(args)
        -- ignore files starting with `.`
        if vim.fn.fnamemodify(args.file, ":."):match("^%.") then
            return
        end

        local chezmoi_apply_cmd = {
            "chezmoi",
            "apply",
            vim.fn.systemlist({ "chezmoi", "target-path", args.file })[1],
        }

        vim.system(chezmoi_apply_cmd, { text = true }):wait()
    end,
})
