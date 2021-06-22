require "format".setup {
    go = {
        {
            cmd = {"gofmt -w", "goimports -w"},
            tempfile_postfix = ".tmp"
        }
    },
    javascript = {
        {cmd = {"prettier -w", "./node_modules/.bin/eslint --fix"}}
    },
    markdown = {
        {cmd = {"prettier -w"}},
        {
            cmd = {"black -l 120"},
            start_pattern = "^```python$",
            end_pattern = "^```$",
            target = "current"
        }
    },
    python = {
        {cmd = {"black -l 120", "isort"}}
    },
    rust = {
        {cmd = {"rustfmt --emit=stdout"}}
    }
}
